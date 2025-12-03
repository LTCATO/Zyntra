from flask import render_template, request, g
from helpers.QueryHelpers import executeGet, executePost
from helpers.HelperFunction import responseData


def _ensure_rider_auth():
    if not g.authenticated or g.authenticated.get('role_id') != 4:
        return None, responseData("error", "Rider access required.", "", 401)
    return g.authenticated, None


def riderPickupDashboard():
    rider, error = _ensure_rider_auth()
    if error:
        return error
    return render_template('views/dashboard/rider-pickups.html', menu=['rider', 'assigned-deliveries'])


def _pickup_query(scope):
    base_query = """
        SELECT
            os.suborder_id,
            os.order_id,
            os.reference AS sub_reference,
            os.status,
            os.pickup_status,
            os.pickup_rider_id,
            os.pickup_claimed_at,
            os.pickup_completed_at,
            os.updated_at,
            o.reference AS order_reference,
            o.created_at AS order_created_at,
            buyer.firstname AS buyer_firstname,
            buyer.lastname AS buyer_lastname,
            buyer.phone AS buyer_phone,
            seller.firstname AS seller_firstname,
            seller.lastname AS seller_lastname,
            sd.store_name,
            sd.city AS seller_city,
            sd.province AS seller_province,
            sd.street AS seller_street
        FROM order_suborders os
        INNER JOIN orders o ON os.order_id = o.order_id
        LEFT JOIN users buyer ON o.user_id = buyer.user_id
        INNER JOIN users seller ON os.seller_id = seller.user_id
        LEFT JOIN seller_details sd ON sd.user_id = seller.user_id
    """

    conditions = []
    if scope == 'mine':
        conditions.append("os.pickup_rider_id = %s")
        conditions.append("os.pickup_status IN (2,3,4)")
    else:
        conditions.append("os.pickup_status = 1")
        conditions.append("os.pickup_rider_id IS NULL")

    where_clause = " WHERE " + " AND ".join(conditions)
    order_clause = " ORDER BY os.updated_at DESC"
    return base_query + where_clause + order_clause


def _serialize_pickup(row):
    seller_name = f"{row.get('seller_firstname', '')} {row.get('seller_lastname', '')}".strip()
    buyer_name = f"{row.get('buyer_firstname', '')} {row.get('buyer_lastname', '')}".strip()
    pickup_state = row.get('pickup_status') or 0
    return {
        "suborder_id": row.get('suborder_id'),
        "order_reference": row.get('order_reference'),
        "sub_reference": row.get('sub_reference'),
        "order_created_at": row.get('order_created_at'),
        "status": row.get('status'),
        "pickup_status": pickup_state,
        "pickup_rider_id": row.get('pickup_rider_id'),
        "pickup_claimed_at": row.get('pickup_claimed_at'),
        "pickup_completed_at": row.get('pickup_completed_at'),
        "seller_name": seller_name or row.get('store_name') or 'Seller',
        "seller_store": row.get('store_name') or seller_name or 'Seller',
        "seller_location": ", ".join(filter(None, [row.get('seller_street'), row.get('seller_city'), row.get('seller_province')])),
        "buyer_name": buyer_name or 'Buyer',
        "buyer_phone": row.get('buyer_phone'),
    }


def getRiderPickups():
    rider, error = _ensure_rider_auth()
    if error:
        return error

    scope = request.args.get('scope', 'available').lower()
    if scope not in ('available', 'mine'):
        scope = 'available'

    query = _pickup_query(scope)
    params = (rider['user_id'],) if scope == 'mine' else ()
    rows = executeGet(query, params)
    if isinstance(rows, tuple):
        return rows

    pickups = [_serialize_pickup(row) for row in rows]
    return responseData("success", "Pickups fetched.", pickups, 200)


def claimPickupAssignment(suborder_id):
    rider, error = _ensure_rider_auth()
    if error:
        return error

    claim_query = """
        UPDATE order_suborders
        SET pickup_rider_id = %s,
            pickup_status = 2,
            pickup_claimed_at = NOW(),
            updated_at = NOW()
        WHERE suborder_id = %s
          AND pickup_status = 1
          AND (pickup_rider_id IS NULL)
    """

    result = executePost(claim_query, (rider['user_id'], suborder_id))
    if isinstance(result, tuple):
        return result

    if (result or {}).get('rowcount', 0) == 0:
        return responseData("error", "This pickup has already been claimed.", "", 409)

    detail = _fetch_pickup_detail(suborder_id)
    return responseData("success", "Pickup assigned to you.", detail, 200)


def updatePickupStatus(suborder_id):
    rider, error = _ensure_rider_auth()
    if error:
        return error

    new_status = request.form.get('status', type=int)
    if new_status not in (3, 4):
        return responseData("error", "Invalid status.", "", 400)

    detail = _fetch_pickup_detail(suborder_id)
    if not detail:
        return responseData("error", "Pickup not found.", "", 404)

    if detail.get('pickup_rider_id') != rider['user_id']:
        return responseData("error", "You are not assigned to this pickup.", "", 403)

    current_status = detail.get('pickup_status', 0)
    allowed_previous = {3: (2, 3), 4: (2, 3, 4)}
    if current_status not in allowed_previous.get(new_status, ()): 
        return responseData("error", "Invalid pickup status transition.", "", 409)

    set_clauses = ["pickup_status = %s", "updated_at = NOW()"]
    params = [new_status]

    if new_status == 4:
        set_clauses.append("pickup_completed_at = NOW()")
        set_clauses.append("status = 4")
    elif new_status == 3:
        set_clauses.append("status = CASE WHEN status < 3 THEN 3 ELSE status END")

    update_query = f"""
        UPDATE order_suborders
        SET {', '.join(set_clauses)}
        WHERE suborder_id = %s AND pickup_rider_id = %s
    """

    params.extend([suborder_id, rider['user_id']])
    update_result = executePost(update_query, tuple(params))
    if isinstance(update_result, tuple):
        return update_result

    # Keep item-level status aligned with the suborder status so buyer views reflect rider actions.
    if new_status == 3:
        # Move items to at least "Out for Delivery" (3), but do not downgrade items already further along.
        item_update_query = """
            UPDATE order_items
            SET status = CASE WHEN status < 3 THEN 3 ELSE status END
            WHERE suborder_id = %s
        """
        executePost(item_update_query, (suborder_id,))
    elif new_status == 4:
        # Mark all items in this suborder as Delivered (4) if not cancelled.
        item_update_query = """
            UPDATE order_items
            SET status = 4
            WHERE suborder_id = %s AND status <> 5
        """
        executePost(item_update_query, (suborder_id,))

    detail = _fetch_pickup_detail(suborder_id)
    return responseData("success", "Pickup status updated.", detail, 200)


def _fetch_pickup_detail(suborder_id):
    detail_query = """
        SELECT
            os.suborder_id,
            os.order_id,
            os.reference AS sub_reference,
            os.status,
            os.pickup_status,
            os.pickup_rider_id,
            os.pickup_claimed_at,
            os.pickup_completed_at,
            os.updated_at,
            o.reference AS order_reference,
            o.created_at AS order_created_at,
            buyer.firstname AS buyer_firstname,
            buyer.lastname AS buyer_lastname,
            buyer.phone AS buyer_phone,
            seller.firstname AS seller_firstname,
            seller.lastname AS seller_lastname,
            sd.store_name,
            sd.city AS seller_city,
            sd.province AS seller_province,
            sd.street AS seller_street
        FROM order_suborders os
        INNER JOIN orders o ON os.order_id = o.order_id
        LEFT JOIN users buyer ON o.user_id = buyer.user_id
        INNER JOIN users seller ON os.seller_id = seller.user_id
        LEFT JOIN seller_details sd ON sd.user_id = seller.user_id
        WHERE os.suborder_id = %s
    """

    rows = executeGet(detail_query, (suborder_id,))
    if isinstance(rows, tuple) or not rows:
        return None

    return _serialize_pickup(rows[0])
