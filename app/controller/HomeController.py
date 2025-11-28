from datetime import datetime, timedelta
from flask import render_template, request, session, g, url_for, redirect
from helpers.QueryHelpers import executeGet, executePost, changeStatus
from helpers.HelperFunction import responseData, allowed_image_file, generate_random_filename, generate_random_string
from controller.UserController import getSellers
import json
import locale
import os

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
PH_JSON_DIR = os.path.join(BASE_DIR, 'static', 'ph-json')
LOCATION_CACHE = {}


def load_location_cache(filename, code_key, name_key):
    cache_key = filename
    if cache_key not in LOCATION_CACHE:
        file_path = os.path.join(PH_JSON_DIR, filename)
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                data = json.load(file)
                LOCATION_CACHE[cache_key] = {
                    str(entry.get(code_key)): entry.get(name_key)
                    for entry in data
                    if entry.get(code_key) and entry.get(name_key)
                }
        except Exception as e:
            print(f"Unable to load {filename}: {e}")
            LOCATION_CACHE[cache_key] = {}
    return LOCATION_CACHE[cache_key]


def resolve_location_name(value, filename, code_key, name_key):
    if not value:
        return value
    cache = load_location_cache(filename, code_key, name_key)
    return cache.get(str(value), value)


def get_user_address_details(user_id):
    address_query = """
        SELECT floor_unit_number, region, province, city_municipality, barangay, street, other_notes
        FROM addresses
        WHERE user_id = %s
        ORDER BY updated_at DESC
        LIMIT 1
    """
    address_result = executeGet(address_query, (user_id,))
    user_address = address_result[0] if address_result else None
    formatted_address = None
    address_texts = {}

    if user_address:
        region_display = resolve_location_name(user_address.get('region'), 'region.json', 'region_code', 'region_name') or user_address.get('region')
        province_display = resolve_location_name(user_address.get('province'), 'province.json', 'province_code', 'province_name') or user_address.get('province')
        city_display = resolve_location_name(user_address.get('city_municipality'), 'city.json', 'city_code', 'city_name') or user_address.get('city_municipality')
        barangay_display = resolve_location_name(user_address.get('barangay'), 'barangay.json', 'brgy_code', 'brgy_name') or user_address.get('barangay')

        address_components = [
            user_address.get('floor_unit_number'),
            user_address.get('street'),
            barangay_display,
            city_display,
            province_display,
            region_display
        ]
        formatted_address = ", ".join([component for component in address_components if component])
        address_texts = {
            'region': region_display,
            'province': province_display,
            'city': city_display,
            'barangay': barangay_display
        }

    return user_address, formatted_address, address_texts


def calculate_order_totals(cart_items):
    subtotal = 0
    for item in cart_items:
        price = float(item.get('price', 0) or 0)
        quantity = float(item.get('quantity', 0) or 0)
        subtotal += price * quantity

    shipping_fee = 0 if subtotal >= 2000 or subtotal == 0 else 79
    taxable_amount = subtotal + shipping_fee
    tax_amount = taxable_amount * 0.01
    total_amount = taxable_amount + tax_amount

    return subtotal, shipping_fee, tax_amount, total_amount


def build_product_image_url(attachment):
    if not attachment or attachment in ('no-image.jpg', ''):
        return '/static/images/no-image.jpg'

    clean_path = attachment.replace('\\', '/').lstrip('/')

    if clean_path.startswith('static/'):
        return '/' + clean_path if not clean_path.startswith('/') else clean_path

    if clean_path.startswith('images/'):
        return f"/static/{clean_path}"

    if clean_path.startswith('uploads/'):
        return f"/static/{clean_path}"

    if clean_path.startswith('products/'):
        return f"/static/uploads/{clean_path}"

    return f"/static/uploads/products/{clean_path}"


def get_order_items_by_reference(reference):
    items_query = """
        SELECT 
            oi.product_id,
            oi.suborder_id,
            p.product_name,
            SUM(oi.quantity) AS total_quantity,
            p.price,
            os.shipping_fee AS sub_shipping_fee,
            sd.store_name,
            seller.firstname AS seller_firstname,
            seller.lastname AS seller_lastname,
            (SELECT pa.attachment FROM product_attachments pa WHERE pa.product_id = p.product_id LIMIT 1) AS attachment
        FROM order_items oi
        LEFT JOIN products p ON oi.product_id = p.product_id
        LEFT JOIN order_suborders os ON oi.suborder_id = os.suborder_id
        LEFT JOIN users seller ON os.seller_id = seller.user_id
        LEFT JOIN seller_details sd ON sd.user_id = seller.user_id
        WHERE oi.reference = %s
        GROUP BY oi.product_id, oi.suborder_id, p.product_name, p.price, os.shipping_fee, sd.store_name, seller.firstname, seller.lastname
    """
    order_items = executeGet(items_query, (reference,)) or []

    for item in order_items:
        price = float(item.get('price', 0) or 0)
        quantity = float(item.get('total_quantity', item.get('quantity', 0) or 0))
        item['quantity'] = int(quantity)
        item['formatted_price'] = locale.format_string("%0.2f", price, grouping=True)
        total_price = price * quantity
        item['line_total_raw'] = total_price
        item['formatted_total'] = locale.format_string("%0.2f", total_price, grouping=True)
        shipping_fee = float(item.get('sub_shipping_fee', 0) or 0)
        item['shipping_fee_raw'] = shipping_fee
        item['shipping_fee_formatted'] = locale.format_string("%0.2f", shipping_fee, grouping=True)
        seller_name = item.get('store_name') or f"{item.get('seller_firstname', '')} {item.get('seller_lastname', '')}".strip()
        item['store_name'] = seller_name or 'Seller'
        attachment = item.get('attachment')
        if attachment:
            item['attachment'] = attachment.lstrip('/\\')

    return order_items


def build_order_summary(order_row):
    shipping_fee_raw = float(order_row.get('shipping_fee', 0) or 0)
    subtotal_value = float(order_row.get('subtotal', 0) or 0)
    tax_value = float(order_row.get('tax_amount', 0) or 0)
    total_value = float(order_row.get('total_amount', 0) or 0)
    status = order_row.get('status', 1) or 1
    status_labels = ['', 'Order Placed', 'Shipped', 'Out for Delivery', 'Delivered']
    status_text = status_labels[status] if status < len(status_labels) else 'Processing'

    created_at = order_row.get('created_at')
    try:
        if isinstance(created_at, str):
            created_at_dt = datetime.strptime(created_at.split('.')[0], "%Y-%m-%d %H:%M:%S")
        else:
            created_at_dt = created_at or datetime.utcnow()
    except Exception:
        created_at_dt = datetime.utcnow()

    estimated_delivery = (created_at_dt + timedelta(days=5)).strftime("%B %d, %Y")

    return {
        'reference': order_row.get('reference'),
        'subtotal': locale.format_string("%0.2f", subtotal_value, grouping=True),
        'shipping_fee': locale.format_string("%0.2f", shipping_fee_raw, grouping=True),
        'shipping_fee_raw': shipping_fee_raw,
        'tax_amount': locale.format_string("%0.2f", tax_value, grouping=True),
        'tax_amount_raw': tax_value,
        'total_amount': locale.format_string("%0.2f", total_value, grouping=True),
        'payment_method': order_row.get('cash_type', '').upper(),
        'status': status,
        'status_text': status_text,
        'created_at': order_row.get('created_at'),
        'estimated_delivery': estimated_delivery
    }


def get_cart_items_for_user(user_id):
    query = """
        SELECT
            oi.order_items_id,
            oi.product_id,
            oi.user_id,
            oi.quantity,
            oi.reference,
            oi.status,
            p.product_name,
            p.price,
            sd.store_name,
            (
                SELECT pa.attachment
                FROM product_attachments pa
                WHERE pa.product_id = p.product_id AND pa.status = 1
                ORDER BY pa.updated_at DESC, pa.product_attachment_id DESC
                LIMIT 1
            ) AS attachment,
            p.user_id AS seller_id
        FROM order_items oi
        LEFT JOIN products p ON oi.product_id = p.product_id
        LEFT JOIN seller_details sd ON sd.user_id = p.user_id
        WHERE oi.user_id = %s AND oi.status = 1
    """
    return executeGet(query, (user_id,)) or []


def group_cart_items_by_seller(cart_items):
    grouped = {}
    for item in cart_items or []:
        seller_id = item.get('seller_id')
        if not seller_id:
            continue
        grouped.setdefault(seller_id, []).append(item)
    return grouped


def create_order_notifications(order_id, reference, buyer_name, suborders_payload):
    if not suborders_payload or not order_id:
        return 0

    notifications_created = 0
    for entry in suborders_payload:
        seller_id = entry.get('seller_id')
        item_names = entry.get('item_names', [])
        sub_reference = entry.get('sub_reference') or reference
        if not seller_id:
            continue

        preview_names = ", ".join(item_names[:3])
        if len(item_names) > 3:
            preview_names += "…"

        message = (
            f"{buyer_name} placed order {reference} (Sub-order {sub_reference}) "
            f"containing {len(item_names)} item(s): {preview_names}"
        )

        insert_query = """
            INSERT INTO notifications (user_id, order_id, title, message, notification_type)
            VALUES (%s, %s, %s, %s, %s)
        """

        executePost(
            insert_query,
            (
                seller_id,
                order_id,
                "New order placed",
                message,
                'order'
            )
        )
        notifications_created += 1

    return notifications_created


def get_user_notifications(user_id, limit=10):
    if not user_id:
        return []

    query = """
        SELECT n.notification_id,
               n.title,
               n.message,
               n.is_read,
               n.created_at,
               n.order_id,
               o.reference AS order_reference
        FROM notifications n
        LEFT JOIN orders o ON n.order_id = o.order_id
        WHERE n.user_id = %s
        ORDER BY n.created_at DESC
        LIMIT %s
    """

    notifications = executeGet(query, (user_id, limit)) or []

    for notif in notifications:
        created_at = notif.get('created_at')
        try:
            if isinstance(created_at, str):
                created_dt = datetime.strptime(created_at.split('.')[0], "%Y-%m-%d %H:%M:%S")
            else:
                created_dt = created_at
            notif['created_at_display'] = created_dt.strftime("%b %d, %Y %I:%M %p") if created_dt else ''
            if created_dt:
                notif['created_at'] = created_dt.strftime("%Y-%m-%d %H:%M:%S")
        except Exception:
            notif['created_at_display'] = created_at

        notif['reference'] = notif.get('order_reference')

    return notifications


def markNotificationRead(notification_id):
    user_id = g.authenticated.get('user_id') if g.authenticated else None

    if not user_id:
        return responseData("error", "Unauthorized", "", 401)

    update_query = """
        UPDATE notifications
        SET is_read = 1, read_at = NOW()
        WHERE notification_id = %s AND user_id = %s
    """

    update_result = executePost(update_query, (notification_id, user_id))

    if not update_result or update_result.get('rowcount', 0) == 0:
        return responseData("error", "Notification not found.", "", 404)

    return responseData("success", "Notification marked as read.", {"notification_id": notification_id}, 200)


def markAllNotificationsRead():
    user_id = g.authenticated.get('user_id') if g.authenticated else None

    if not user_id:
        return responseData("error", "Unauthorized", "", 401)

    update_query = """
        UPDATE notifications
        SET is_read = 1,
            read_at = IF(read_at IS NULL, NOW(), read_at)
        WHERE user_id = %s AND is_read = 0
    """

    update_result = executePost(update_query, (user_id,))

    return responseData(
        "success",
        "All notifications marked as read.",
        {"updated": update_result.get('rowcount', 0) if update_result else 0},
        200
    )


def getNotifications():
    user_id = g.authenticated.get('user_id') if g.authenticated else None

    if not user_id:
        return responseData("error", "Unauthorized", "", 401)

    notifications = get_user_notifications(user_id, limit=10)
    unread_count = sum(1 for notif in notifications if not notif.get('is_read'))

    payload = {
        "items": notifications,
        "unread_count": unread_count
    }

    return responseData("success", "Notifications loaded.", payload, 200)


def home():
    query = request.args.get('query', '')
    page = request.args.get('page', 1, type=int)
    categories = getCategoriesInHome("WHERE status = 1")
    
    if query:  # Check if there is a search query
        products = getProductsBySearch(query)  # Call the search function
    else:
        products = getProductsInHome("WHERE p.status = 1", page=page)  # Default products

    cart_items = session.get('cart', {})
    return render_template('views/home.html', cat_data=categories, prod_data=products, page=page, per_page=10, cart_items=cart_items)

def shop():
    # Get all products with pagination
    page = request.args.get('page', 1, type=int)
    per_page = 12  # 12 products per page for the shop grid
    
    # Get filter parameters
    category_id = request.args.get('category', None)
    search_query = request.args.get('q', '')
    min_price = request.args.get('min_price', 0, type=float)
    max_price = request.args.get('max_price', 100000, type=float)
    
    # Base query
    condition = "WHERE p.status = 1"
    params = []
    
    # Add category filter if specified
    if category_id and category_id != 'all':
        condition += " AND p.category_id = %s"
        params.append(category_id)
    
    # Add search query filter
    if search_query:
        condition += " AND (p.product_name LIKE %s OR p.description LIKE %s)"
        search_term = f"%{search_query}%"
        params.extend([search_term, search_term])
    
    # Add price range filter
    condition += " AND p.price BETWEEN %s AND %s"
    params.extend([min_price, max_price])
    
    # Get products with filters
    products = getProductsInHome(condition, page, per_page, params)
    
    # Get all categories for the sidebar
    categories = getCategoriesInHome("WHERE status = 1")
    
    # Get cart items
    cart_items = session.get('cart', {})
    
    return render_template('buyer/shop.html', 
                         products=products, 
                         categories=categories, 
                         current_category=category_id,
                         search_query=search_query,
                         min_price=min_price,
                         max_price=max_price,
                         page=page,
                         per_page=per_page,
                         cart_items=cart_items)

def getProductsBySearch(query):
    query = f"%{query}%"
    sql_query = "SELECT p.product_id, p.category_id, p.product_name, c.category_name, pa.attachment, p.description, p.price, p.qty, p.created_at, p.status FROM products p LEFT JOIN categories c ON p.category_id = c.category_id LEFT JOIN product_attachments pa ON p.product_id = pa.product_id WHERE p.product_name LIKE %s AND p.status = 1"
    results = executeGet(sql_query, (query,))
    return results

def getCategoriesInHome(condition=""):
    query = f"SELECT * FROM `categories` {condition}"
    results = executeGet(query)
    return results

def getProductsInHome(condition="", page=1, per_page=10, params=None):
    offset = (page - 1) * per_page
    
    # Base query with proper parameterization
    base_query = """
    SELECT p.product_id, p.category_id, p.product_name, c.category_name, 
           pa.attachment, p.description, p.price, p.qty, p.created_at, p.status 
    FROM products p 
    LEFT JOIN categories c ON p.category_id = c.category_id 
    LEFT JOIN product_attachments pa ON p.product_id = pa.product_id 
    {condition} 
    AND c.status != 2 
    GROUP BY p.product_id, p.category_id, p.product_name, c.category_name, 
             p.price, p.qty, p.created_at, p.status 
    LIMIT %s, %s
    """
    
    # Format the condition (remove WHERE if it's empty to avoid SQL syntax error)
    if not condition.strip():
        condition = "WHERE 1=1"
    
    # Add LIMIT parameters to params if they exist, otherwise create new params
    if params is None:
        params = []
    
    # Execute the query with parameters
    query = base_query.format(condition=condition)
    results = executeGet(query, params + [offset, per_page])
    
    if not results:  # Check if results is empty
        return []

    # Format the results
    for product in results:
        product['formatted_price'] = locale.format_string("%0.2f", float(product['price']), grouping=True)
        if product['attachment'] is not None:
            # Remove any leading slashes or backslashes from the attachment path
            attachment_path = product['attachment'].lstrip('/\\')
            product['attachment'] = url_for('static', filename=attachment_path)
        else:
            product['attachment'] = None
    return results

def loadMoreProducts():
    page = request.args.get('page', 1, type=int)
    products = getProductsInHome("WHERE p.status = 1", page=page)
    
    if products is None or products == "":
        return responseData("error", "No more products found.", [], 200)

    return responseData("success", "Products loaded successfully.", products, 200)

def categoryPage(category_id):
    products = getProductsInCategoryGrouped(category_id)
    categories = getCategoriesInHome("WHERE status = 1")

    # Check if products list is empty
    if not products:
        return render_template('views/category.html', data=[], cat_data=categories)  # Pass an empty list

    return render_template('views/category.html', data=products, cat_data=categories)

def getProductsInCategoryGrouped(category_id, page=1, per_page=10):
    offset = (page - 1) * per_page
    query = f"SELECT p.product_id, p.user_id, p.product_name, p.price, p.status AS product_status, pa.product_attachment_id, pa.product_id AS attachment_product_id, pa.attachment, pa.status AS attachment_status, c.category_id, c.category_name, c.status AS category_status FROM products p LEFT JOIN product_attachments pa ON p.product_id = pa.product_id LEFT JOIN categories c ON p.category_id = c.category_id WHERE c.category_id = {category_id} AND c.status = 1 GROUP BY p.product_id LIMIT {offset}, {per_page};"
    results = executeGet(query)
    
    if not results:  # Check if results is empty
        return []  # Return an empty list or handle as needed

    for product in results:
        product['formatted_price'] = locale.format_string("%0.2f", product['price'], grouping=True)
        if 'attachment' in product and product['attachment'] is not None:
            # Remove any leading slashes or backslashes from the attachment path
            attachment_path = product['attachment'].lstrip('/\\')
            product['attachment'] = url_for('static', filename=attachment_path)
            print(f"Image URL for {product['product_name']}: {product['attachment']}")
        else:
            product['attachment'] = None
            print(f"No image for {product['product_name']}")
    
    return results
    return results

def cart():
    categories = getCategoriesInHome("WHERE status = 1")
    user_id = g.authenticated.get('user_id')  # Get the logged-in user's ID
    if not user_id:
        return redirect(url_for('login_page'))  # Redirect to login if not authenticated

    cart_items = get_cart_items_for_user(user_id)
    user_address, formatted_address, address_texts = get_user_address_details(user_id)

    order_totals = None
    total_sum = 0
    random_order_reference = None
    seller_shipping_breakdown = []

    if cart_items:
        seller_groups = group_cart_items_by_seller(cart_items)
        for seller_id, items in seller_groups.items():
            seller_name = items[0].get('store_name') or 'Seller'
            group_subtotal = 0
            for item in items:
                price = float(item.get('price', 0) or 0)
                quantity = int(item.get('quantity', 0) or 0)
                group_subtotal += price * quantity

            shipping_fee = 0 if group_subtotal >= 2000 or group_subtotal == 0 else 79
            seller_shipping_breakdown.append({
                'seller_id': seller_id,
                'store_name': seller_name,
                'shipping_fee': shipping_fee
            })

        for item in cart_items:
            price = item.get('price', 0) or 0
            quantity = item.get('quantity', 0) or 0
            total_price = quantity * price

            item['formatted_price'] = locale.format_string("%0.2f", price, grouping=True)
            item['total_price'] = locale.format_string("%0.2f", total_price, grouping=True)

            attachment = item.get('attachment')
            if attachment:
                cleaned_attachment = attachment.lstrip('/\\')
                item['attachment'] = cleaned_attachment

        subtotal, shipping_fee, tax_amount, total_amount = calculate_order_totals(cart_items)
        if seller_shipping_breakdown:
            shipping_fee = sum(entry.get('shipping_fee', 0) for entry in seller_shipping_breakdown)
            taxable_amount = subtotal + shipping_fee
            tax_amount = taxable_amount * 0.01
            total_amount = taxable_amount + tax_amount
        total_sum = total_amount
        order_totals = {
            'subtotal': subtotal,
            'shipping_fee': shipping_fee,
            'tax_amount': tax_amount,
            'total_amount': total_amount,
            'formatted_subtotal': locale.format_string("%0.2f", subtotal, grouping=True),
            'formatted_shipping': locale.format_string("%0.2f", shipping_fee, grouping=True),
            'formatted_tax': locale.format_string("%0.2f", tax_amount, grouping=True),
            'formatted_total': locale.format_string("%0.2f", total_amount, grouping=True),
            'is_shipping_free': shipping_fee == 0
        }
        order_totals['shipping_breakdown'] = seller_shipping_breakdown
        random_order_reference = generate_random_string(10)

    return render_template(
        'views/cart.html',
        cat_data=categories,
        cart_items=cart_items,
        total_sum=total_sum,
        user_address=user_address,
        address_display=formatted_address,
        address_texts=address_texts,
        order_totals=order_totals,
        random_order_reference=random_order_reference
    )

def checkout():
    user_id = g.authenticated.get('user_id')
    
    if not user_id:
        return responseData("error", "User not authenticated.", [], 401)

    # Update the status of order items to 2 for the logged-in user
    query = "UPDATE order_items SET status = 2 WHERE user_id = %s AND status = 1"
    results = executeGet(query, (user_id,))

    if results:
        return responseData("success", "Checkout successful", results, 200)
    else:
        return responseData("error", "No items to checkout or update failed.", [], 400)


def submitCheckout(): 
    user_id = g.authenticated.get('user_id')
    if not user_id:
        return responseData("error", "User not authenticated.", "", 401)

    payment_method = request.form.get('payment-method')
    if not payment_method:
        return responseData("error", "Please select a payment method.", "", 200)

    cart_items = get_cart_items_for_user(user_id)
    if not cart_items:
        return responseData("error", "Your cart is empty.", "", 200)

    subtotal, shipping_fee, tax_amount, total_amount = calculate_order_totals(cart_items)
    provided_reference = request.form.get('reference')
    reference = provided_reference if provided_reference else generate_random_string(12)
    estimated_delivery = (datetime.utcnow() + timedelta(days=5)).strftime("%B %d, %Y")

    insert_query = """
        INSERT INTO orders (user_id, reference, subtotal, shipping_fee, tax_amount, total_amount, cash_type)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    insert_result = executePost(
        insert_query,
        (
            user_id,
            reference,
            subtotal,
            shipping_fee,
            tax_amount,
            f"{total_amount:.2f}",
            payment_method
        )
    )

    if not insert_result or not insert_result.get('last_inserted_id'):
        return responseData("error", "Unable to create order. Please try again.", "", 200)

    order_id = insert_result.get('last_inserted_id')

    seller_groups = group_cart_items_by_seller(cart_items)
    if not seller_groups:
        return responseData("error", "Unable to allocate items to sellers.", "", 200)

    suborders_payload = []
    for index, (seller_id, items) in enumerate(seller_groups.items(), start=1):
        if not seller_id or not items:
            continue

        group_subtotal = 0
        for cart_item in items:
            price = float(cart_item.get('price', 0) or 0)
            quantity = int(cart_item.get('quantity', 0) or 0)
            group_subtotal += price * quantity

        group_shipping_fee = 0 if group_subtotal >= 2000 or group_subtotal == 0 else 79
        group_tax_amount = (group_subtotal + group_shipping_fee) * 0.01
        group_total_amount = group_subtotal + group_shipping_fee + group_tax_amount

        sub_reference = f"{reference}-{index:02d}"
        insert_suborder_query = """
            INSERT INTO order_suborders
                (order_id, seller_id, reference, status, subtotal, shipping_fee, tax_amount, total_amount)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        suborder_result = executePost(
            insert_suborder_query,
            (
                order_id,
                seller_id,
                sub_reference,
                1,
                f"{group_subtotal:.2f}",
                f"{group_shipping_fee:.2f}",
                f"{group_tax_amount:.2f}",
                f"{group_total_amount:.2f}"
            )
        )

        if not suborder_result or not suborder_result.get('last_inserted_id'):
            return responseData("error", "Unable to create seller sub-orders.", "", 200)

        suborder_id = suborder_result.get('last_inserted_id')
        item_names = []
        for cart_item in items:
            update_item_query = """
                UPDATE order_items
                SET status = 1, reference = %s, suborder_id = %s
                WHERE order_items_id = %s
            """
            executePost(update_item_query, (reference, suborder_id, cart_item.get('order_items_id')))
            item_names.append(cart_item.get('product_name') or 'Product')

        suborders_payload.append({
            'seller_id': seller_id,
            'sub_reference': sub_reference,
            'item_names': item_names
        })

    buyer_first = g.authenticated.get('firstname', '') if g.authenticated else ''
    buyer_last = g.authenticated.get('lastname', '') if g.authenticated else ''
    buyer_name = f"{buyer_first} {buyer_last}".strip() or "A buyer"
    create_order_notifications(order_id, reference, buyer_name, suborders_payload)

    response_payload = {
        "reference": reference,
        "total_amount": f"{total_amount:,.2f}",
        "estimated_delivery": estimated_delivery,
        "payment_method": payment_method
    }

    return responseData("success", "Checkout successful", response_payload, 200)


def build_timeline_steps(order_status):
    steps = [
        {"title": "Order Placed", "description": "We received your order."},
        {"title": "Shipped", "description": "Your items left our facility."},
        {"title": "Out for Delivery", "description": "Courier is on the way."},
        {"title": "Delivered", "description": "Package delivered."},
    ]

    current_status = order_status or 1
    for index, step in enumerate(steps, start=1):
        step['completed'] = current_status >= index
        step['active'] = current_status == index
        step['step_number'] = index
    return steps


def orderTrackingHub():
    user_id = g.authenticated.get('user_id')
    if not user_id:
        return redirect(url_for('login_page'))

    orders_query = """
        SELECT o.*, u.firstname, u.lastname
        FROM orders o
        LEFT JOIN users u ON o.user_id = u.user_id
        WHERE o.user_id = %s
        ORDER BY o.created_at DESC
    """
    orders_result = executeGet(orders_query, (user_id,)) or []

    categories = getCategoriesInHome("WHERE status = 1")
    user_address, formatted_address, address_texts = get_user_address_details(user_id)

    incoming_orders = []
    received_orders = []

    for order in orders_result:
        summary = build_order_summary(order)
        items = get_order_items_by_reference(summary['reference'])
        shipments = get_suborders_for_order(order.get('order_id'))
        if isinstance(shipments, tuple):
            shipments = []
        shipping_total = sum(sub.get('shipping_fee', 0) for sub in shipments)
        card_payload = {
            'summary': summary,
            'order_items': items,
            'primary_item': items[0] if items else None,
            'shipments': shipments,
            'shipping_total': shipping_total
        }

        if summary['status'] >= 4:
            received_orders.append(card_payload)
        else:
            incoming_orders.append(card_payload)

    return render_template(
        'views/order-tracking-hub.html',
        cat_data=categories,
        incoming_orders=incoming_orders,
        received_orders=received_orders,
        shipping_address=formatted_address,
        user_address=user_address,
        address_texts=address_texts
    )


def orderList():
    if not g.authenticated:
        return redirect(url_for('login_page'))

    seller_id = g.authenticated.get('user_id')
    if not seller_id:
        return redirect(url_for('login_page'))

    orders_query = """
        SELECT o.order_id,
               o.reference,
               o.created_at,
               o.status,
               o.subtotal,
               o.shipping_fee,
               o.tax_amount,
               o.total_amount,
               buyer.firstname AS buyer_firstname,
               buyer.lastname AS buyer_lastname,
               buyer.email AS buyer_email,
               buyer.phone AS buyer_phone,
               COUNT(oi.order_items_id) AS item_count
        FROM orders o
        INNER JOIN order_items oi ON oi.reference = o.reference
        INNER JOIN products p ON oi.product_id = p.product_id
        LEFT JOIN users buyer ON o.user_id = buyer.user_id
        WHERE p.user_id = %s
        GROUP BY o.order_id, o.reference, o.created_at, o.status,
                 o.subtotal, o.shipping_fee, o.tax_amount, o.total_amount,
                 buyer.firstname, buyer.lastname, buyer.email, buyer.phone
        ORDER BY o.created_at DESC
    """

    orders_result = executeGet(orders_query, (seller_id,)) or []

    status_labels = {
        1: 'Order Placed',
        2: 'Shipped',
        3: 'Out for Delivery',
        4: 'Delivered',
        5: 'Cancelled'
    }

    formatted_orders = []
    for order in orders_result:
        total_amount = order.get('total_amount')
        try:
            total_amount = float(total_amount)
        except (TypeError, ValueError):
            total_amount = 0.0

        item = {
            'order_id': order.get('order_id'),
            'reference': order.get('reference'),
            'created_at': order.get('created_at'),
            'status': order.get('status') or 1,
            'status_label': status_labels.get(order.get('status') or 1, 'Processing'),
            'subtotal': order.get('subtotal') or 0,
            'shipping_fee': order.get('shipping_fee') or 0,
            'tax_amount': order.get('tax_amount') or 0,
            'total_amount': total_amount,
            'item_count': order.get('item_count') or 0,
            'buyer_name': f"{order.get('buyer_firstname', '')} {order.get('buyer_lastname', '')}".strip() or 'N/A',
            'buyer_email': order.get('buyer_email'),
            'buyer_phone': order.get('buyer_phone')
        }
        formatted_orders.append(item)

    return render_template('views/orders/order-list.html', orders=formatted_orders, menu=['orders', 'order-list'])


def getSellerOrderItems(seller_id):
    order_items_query = """
        SELECT
            os.suborder_id,
            os.reference AS sub_reference,
            os.status AS sub_status,
            os.shipping_fee AS sub_shipping_fee,
            os.updated_at AS sub_updated_at,
            os.created_at AS sub_created_at,
            o.reference AS order_reference,
            o.created_at AS order_created_at,
            buyer.user_id AS buyer_id,
            buyer.firstname AS buyer_firstname,
            buyer.lastname AS buyer_lastname,
            buyer.email AS buyer_email,
            oi.order_items_id,
            oi.quantity,
            oi.status AS item_status,
            oi.reference,
            p.product_name,
            p.price AS unit_price,
            (
                SELECT pa.attachment
                FROM product_attachments pa
                WHERE pa.product_id = p.product_id AND pa.status = 1
                ORDER BY pa.updated_at DESC, pa.product_attachment_id DESC
                LIMIT 1
            ) AS product_image
        FROM order_suborders os
        INNER JOIN orders o ON os.order_id = o.order_id
        INNER JOIN order_items oi ON oi.suborder_id = os.suborder_id
        INNER JOIN products p ON oi.product_id = p.product_id
        LEFT JOIN users buyer ON o.user_id = buyer.user_id
        WHERE os.seller_id = %s
        ORDER BY os.updated_at DESC, oi.order_items_id DESC
    """

    rows = executeGet(order_items_query, (seller_id,))
    if not isinstance(rows, list):
        return rows

    rows = rows or []

    grouped_orders = {}
    for row in rows:
        suborder_id = row.get('suborder_id')
        if not suborder_id:
            continue

        if suborder_id not in grouped_orders:
            grouped_orders[suborder_id] = {
                'suborder_id': suborder_id,
                'sub_reference': row.get('sub_reference'),
                'reference': row.get('order_reference') or row.get('reference'),
                'buyer_id': row.get('buyer_id'),
                'buyer_name': f"{row.get('buyer_firstname', '')} {row.get('buyer_lastname', '')}".strip() or 'N/A',
                'buyer_email': row.get('buyer_email') or '',
                'updated_at': row.get('sub_updated_at') or row.get('sub_created_at'),
                'item_list': [],
                'group_status': row.get('sub_status') or 1,
                'shipping_fee': float(row.get('sub_shipping_fee') or 0)
            }

        item_payload = {
            'order_items_id': row.get('order_items_id'),
            'product_name': row.get('product_name'),
            'quantity': row.get('quantity'),
            'status': row.get('item_status') or 1,
            'unit_price': row.get('unit_price') or 0,
            'product_image': build_product_image_url(row.get('product_image') or ''),
            'reference': row.get('order_reference'),
            'updated_at': row.get('sub_updated_at') or row.get('order_created_at')
        }
        grouped_orders[suborder_id]['item_list'].append(item_payload)

        if (row.get('item_status') or 1) > grouped_orders[suborder_id]['group_status']:
            grouped_orders[suborder_id]['group_status'] = row.get('item_status') or 1

    ordered_groups = sorted(grouped_orders.values(), key=lambda entry: entry.get('updated_at') or datetime.utcnow(), reverse=True)
    return ordered_groups


def get_suborders_for_order(order_id):
    suborders_query = """
        SELECT
            os.suborder_id,
            os.reference AS sub_reference,
            os.status AS sub_status,
            os.shipping_fee AS sub_shipping_fee,
            os.updated_at,
            os.created_at,
            os.seller_id,
            seller.firstname AS seller_firstname,
            seller.lastname AS seller_lastname,
            sd.store_name,
            oi.order_items_id,
            oi.quantity,
            p.product_name,
            p.price,
            (
                SELECT pa.attachment
                FROM product_attachments pa
                WHERE pa.product_id = p.product_id AND pa.status = 1
                ORDER BY pa.updated_at DESC, pa.product_attachment_id DESC
                LIMIT 1
            ) AS product_image
        FROM order_suborders os
        INNER JOIN users seller ON os.seller_id = seller.user_id
        LEFT JOIN seller_details sd ON sd.user_id = seller.user_id
        INNER JOIN order_items oi ON oi.suborder_id = os.suborder_id
        INNER JOIN products p ON oi.product_id = p.product_id
        WHERE os.order_id = %s
        ORDER BY os.created_at ASC, os.suborder_id ASC, oi.order_items_id ASC
    """

    rows = executeGet(suborders_query, (order_id,))
    if not isinstance(rows, list):
        return rows

    rows = rows or []
    grouped = {}
    for row in rows:
        suborder_id = row.get('suborder_id')
        if not suborder_id:
            continue

        if suborder_id not in grouped:
            seller_name = f"{row.get('seller_firstname', '')} {row.get('seller_lastname', '')}".strip()
            store_name = row.get('store_name') or seller_name or 'Seller'
            grouped[suborder_id] = {
                'suborder_id': suborder_id,
                'sub_reference': row.get('sub_reference'),
                'status': row.get('sub_status') or 1,
                'updated_at': row.get('updated_at') or row.get('created_at'),
                'seller_name': seller_name or 'Seller',
                'store_name': store_name,
                'items': [],
                'shipping_fee': float(row.get('sub_shipping_fee') or 0)
            }

        price = float(row.get('price', 0) or 0)
        quantity = int(row.get('quantity', 0) or 0)
        item_payload = {
            'order_items_id': row.get('order_items_id'),
            'product_name': row.get('product_name'),
            'quantity': quantity,
            'unit_price': price,
            'line_total': price * quantity,
            'product_image': build_product_image_url(row.get('product_image') or '')
        }
        grouped[suborder_id]['items'].append(item_payload)

    ordered = sorted(grouped.values(), key=lambda entry: entry.get('updated_at') or datetime.utcnow())
    return ordered


def orderManagement():
    if not g.authenticated or g.authenticated.get('role_id') != 3:
        return redirect(url_for('login_page'))

    seller_id = g.authenticated.get('user_id')
    order_groups = getSellerOrderItems(seller_id)

    if not isinstance(order_groups, list):
        return order_groups

    return render_template('views/orders/order-management.html', order_groups=order_groups, menu=['orders', 'order-management'])


def updateSuborderStatus():
    if not g.authenticated or g.authenticated.get('role_id') != 3:
        return responseData("error", "Unauthorized", "", 401)

    seller_id = g.authenticated.get('user_id')
    suborder_id = request.form.get('suborder_id', type=int)
    status = request.form.get('status', type=int)

    if not suborder_id or status not in (2, 3, 4):
        return responseData("error", "Invalid request payload", "", 400)

    ownership_query = """
        SELECT suborder_id
        FROM order_suborders
        WHERE suborder_id = %s AND seller_id = %s
    """
    ownership = executeGet(ownership_query, (suborder_id, seller_id))
    if not ownership:
        return responseData("error", "Sub-order not found or you do not have permission to update it.", "", 404)

    update_suborder_query = """
        UPDATE order_suborders
        SET status = %s, updated_at = NOW()
        WHERE suborder_id = %s
    """
    suborder_result = executePost(update_suborder_query, (status, suborder_id))
    if isinstance(suborder_result, tuple):
        return suborder_result

    update_items_query = """
        UPDATE order_items
        SET status = %s
        WHERE suborder_id = %s
    """
    executePost(update_items_query, (status, suborder_id))

    status_labels = {
        2: 'Shipped',
        3: 'Out for Delivery',
        4: 'Delivered'
    }

    return responseData("success", f"Sub-order marked as {status_labels.get(status, 'updated')}.", "", 200)


def orderTracking(reference):
    user_id = g.authenticated.get('user_id')
    if not user_id:
        return redirect(url_for('login_page'))

    orders_query = """
        SELECT o.*, u.firstname, u.lastname
        FROM orders o
        LEFT JOIN users u ON o.user_id = u.user_id
        WHERE o.user_id = %s AND o.reference = %s
        LIMIT 1
    """
    order_row = executeGet(orders_query, (user_id, reference))
    if not order_row:
        return redirect(url_for('order_tracking_hub'))

    order_data = order_row[0]
    summary = build_order_summary(order_data)
    items = get_order_items_by_reference(summary['reference'])
    timeline_steps = build_timeline_steps(summary['status'])
    suborders = get_suborders_for_order(order_data.get('order_id'))
    if isinstance(suborders, tuple):
        suborders = []

    user_address, formatted_address, _ = get_user_address_details(user_id)
    categories = getCategoriesInHome("WHERE status = 1")

    return render_template(
        'views/order-tracking.html',
        cat_data=categories,
        order_summary=summary,
        order_items=items,
        suborders=suborders,
        timeline_steps=timeline_steps,
        shipping_address=formatted_address,
        user_address=user_address,
        can_cancel=summary['status'] == 1
    )


def orderTrackingLatest():
    user_id = g.authenticated.get('user_id') if g.authenticated else None
    if not user_id:
        return redirect(url_for('login_page'))

    latest_order_query = """
        SELECT reference
        FROM orders
        WHERE user_id = %s
        ORDER BY created_at DESC
        LIMIT 1
    """
    latest_order = executeGet(latest_order_query, (user_id,))

    if not latest_order:
        return redirect(url_for('cart_page'))

    latest_reference = latest_order[0].get('reference')
    if not latest_reference:
        return redirect(url_for('cart_page'))

    return redirect(url_for('order_tracking', reference=latest_reference))


def cancelOrder(reference):
    user_id = g.authenticated.get('user_id') if g.authenticated else None
    if not user_id:
        return responseData("error", "User not authenticated.", "", 401)

    order_query = """
        SELECT order_id, status
        FROM orders
        WHERE reference = %s AND user_id = %s
        LIMIT 1
    """
    order_result = executeGet(order_query, (reference, user_id))

    if not order_result:
        return responseData("error", "Order not found.", "", 404)

    status = order_result[0].get('status', 1)
    if status != 1:
        return responseData("error", "This order can no longer be canceled.", "", 200)

    executePost("DELETE FROM order_items WHERE reference = %s", (reference,))
    executePost("DELETE FROM orders WHERE reference = %s AND user_id = %s", (reference, user_id))

    return responseData("success", "Order removed successfully.", {"reference": reference}, 200)