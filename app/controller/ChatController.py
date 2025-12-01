from flask import request, g
from helpers.QueryHelpers import executeGet, executePost
from helpers.HelperFunction import responseData


def _parse_int(value):
    try:
        return int(value)
    except (TypeError, ValueError):
        return None


def _get_payload():
    return request.get_json(silent=True) or request.form


def _ensure_authenticated_user():
    if not g.authenticated:
        return None, responseData("error", "Authentication required.", "", 401)
    return g.authenticated, None


def _get_conversation(conversation_id):
    query = "SELECT * FROM conversations WHERE conversation_id = %s"
    result = executeGet(query, (conversation_id,))
    if isinstance(result, tuple):
        return None, result
    if not result:
        return None, responseData("error", "Conversation not found.", "", 404)
    return result[0], None


def _validate_membership(conversation, user_id):
    return user_id in (conversation['buyer_id'], conversation['seller_id'])


def _build_counterpart(conversation_row, viewer_role):
    counterpart = {}
    if viewer_role == 2:  # buyer viewing seller info
        counterpart = {
            "user_id": conversation_row['seller_id'],
            "firstname": conversation_row.get('seller_firstname'),
            "lastname": conversation_row.get('seller_lastname'),
            "email": conversation_row.get('seller_email'),
            "store_name": conversation_row.get('seller_store_name'),
            "role_id": 3,
        }
    elif viewer_role == 3:  # seller viewing buyer info
        counterpart = {
            "user_id": conversation_row['buyer_id'],
            "firstname": conversation_row.get('buyer_firstname'),
            "lastname": conversation_row.get('buyer_lastname'),
            "email": conversation_row.get('buyer_email'),
            "role_id": 2,
        }
    else:
        counterpart = {
            "user_id": conversation_row['buyer_id'],
            "firstname": conversation_row.get('buyer_firstname'),
            "lastname": conversation_row.get('buyer_lastname'),
            "email": conversation_row.get('buyer_email'),
            "role_id": conversation_row.get('buyer_role_id', 2),
        }
    return counterpart


def ensureConversation():
    current_user, error = _ensure_authenticated_user()
    if error:
        return error

    payload = _get_payload()
    buyer_id = _parse_int(payload.get('buyer_id'))
    seller_id = _parse_int(payload.get('seller_id'))
    order_id = _parse_int(payload.get('order_id'))

    role_id = current_user.get('role_id')
    user_id = current_user.get('user_id')

    if role_id == 2 and not buyer_id:
        buyer_id = user_id
    if role_id == 3 and not seller_id:
        seller_id = user_id

    if not buyer_id or not seller_id:
        return responseData("error", "Buyer and seller must be specified.", "", 400)

    if user_id not in (buyer_id, seller_id):
        return responseData("error", "You are not allowed to start this conversation.", "", 403)

    select_query = """
        SELECT *
        FROM conversations
        WHERE buyer_id = %s AND seller_id = %s
        LIMIT 1
    """
    existing = executeGet(select_query, (buyer_id, seller_id))
    if isinstance(existing, tuple):
        return existing

    if existing:
        conversation = existing[0]
    else:
        insert_query = """
            INSERT INTO conversations (buyer_id, seller_id, order_id)
            VALUES (%s, %s, %s)
        """
        insert_result = executePost(insert_query, (buyer_id, seller_id, order_id))
        if isinstance(insert_result, tuple):
            return insert_result

        conversation_id = insert_result.get('last_inserted_id')
        fetch_new = executeGet("SELECT * FROM conversations WHERE conversation_id = %s", (conversation_id,))
        if isinstance(fetch_new, tuple):
            return fetch_new
        conversation = fetch_new[0]

    return responseData("success", "Conversation ready.", conversation, 200)


def getConversationMessages(conversation_id):
    current_user, error = _ensure_authenticated_user()
    if error:
        return error

    conversation, conv_error = _get_conversation(conversation_id)
    if conv_error:
        return conv_error

    if not _validate_membership(conversation, current_user.get('user_id')):
        return responseData("error", "You are not part of this conversation.", "", 403)

    limit = _parse_int(request.args.get('limit')) or 50
    limit = min(max(limit, 1), 100)
    before_id = _parse_int(request.args.get('before_id'))

    query = """
        SELECT 
            cm.message_id,
            cm.conversation_id,
            cm.sender_id,
            u.firstname,
            u.lastname,
            u.role_id,
            cm.message_text,
            cm.is_read,
            cm.read_at,
            cm.created_at
        FROM conversation_messages cm
        JOIN users u ON cm.sender_id = u.user_id
        WHERE cm.conversation_id = %s
    """
    params = [conversation_id]

    if before_id:
        query += " AND cm.message_id < %s"
        params.append(before_id)

    query += " ORDER BY cm.message_id DESC LIMIT %s"
    params.append(limit)

    messages = executeGet(query, tuple(params))
    if isinstance(messages, tuple):
        return messages

    messages.reverse()

    return responseData("success", "Messages fetched.", messages, 200)


def postConversationMessage(conversation_id):
    current_user, error = _ensure_authenticated_user()
    if error:
        return error

    conversation, conv_error = _get_conversation(conversation_id)
    if conv_error:
        return conv_error

    user_id = current_user.get('user_id')
    if not _validate_membership(conversation, user_id):
        return responseData("error", "You are not part of this conversation.", "", 403)

    payload = _get_payload()
    message_text = (payload.get('message_text') or '').strip()

    if not message_text:
        return responseData("error", "Message cannot be empty.", "", 400)

    insert_query = """
        INSERT INTO conversation_messages (conversation_id, sender_id, message_text)
        VALUES (%s, %s, %s)
    """
    insert_result = executePost(insert_query, (conversation_id, user_id, message_text))
    if isinstance(insert_result, tuple):
        return insert_result

    executePost("UPDATE conversations SET updated_at = NOW() WHERE conversation_id = %s", (conversation_id,))

    message_id = insert_result.get('last_inserted_id')
    fetch_query = """
        SELECT 
            cm.message_id,
            cm.conversation_id,
            cm.sender_id,
            u.firstname,
            u.lastname,
            u.role_id,
            cm.message_text,
            cm.is_read,
            cm.read_at,
            cm.created_at
        FROM conversation_messages cm
        JOIN users u ON cm.sender_id = u.user_id
        WHERE cm.message_id = %s
    """
    new_message = executeGet(fetch_query, (message_id,))
    if isinstance(new_message, tuple):
        return new_message

    return responseData("success", "Message sent.", new_message[0], 201)


def getUserConversations():
    current_user, error = _ensure_authenticated_user()
    if error:
        return error

    user_id = current_user.get('user_id')
    role_id = current_user.get('role_id')

    query = """
        SELECT 
            c.conversation_id,
            c.buyer_id,
            c.seller_id,
            c.order_id,
            c.updated_at,
            buyer.firstname AS buyer_firstname,
            buyer.lastname AS buyer_lastname,
            buyer.email AS buyer_email,
            buyer.role_id AS buyer_role_id,
            seller.firstname AS seller_firstname,
            seller.lastname AS seller_lastname,
            seller.email AS seller_email,
            sd.store_name AS seller_store_name,
            last_msg.message_text AS last_message,
            last_msg.created_at AS last_message_at
        FROM conversations c
        JOIN users buyer ON buyer.user_id = c.buyer_id
        JOIN users seller ON seller.user_id = c.seller_id
        LEFT JOIN seller_details sd ON sd.user_id = seller.user_id
        LEFT JOIN (
            SELECT cm1.*
            FROM conversation_messages cm1
            INNER JOIN (
                SELECT conversation_id, MAX(message_id) AS max_id
                FROM conversation_messages
                GROUP BY conversation_id
            ) latest ON latest.conversation_id = cm1.conversation_id AND latest.max_id = cm1.message_id
        ) last_msg ON last_msg.conversation_id = c.conversation_id
        WHERE c.buyer_id = %s OR c.seller_id = %s
        ORDER BY COALESCE(last_msg.created_at, c.updated_at) DESC
    """

    rows = executeGet(query, (user_id, user_id))
    if isinstance(rows, tuple):
        return rows

    conversations = []
    for row in rows:
        counterpart = _build_counterpart(row, role_id)
        conversations.append({
            "conversation_id": row['conversation_id'],
            "buyer_id": row['buyer_id'],
            "seller_id": row['seller_id'],
            "order_id": row['order_id'],
            "updated_at": row['updated_at'],
            "last_message": row.get('last_message'),
            "last_message_at": row.get('last_message_at'),
            "counterpart": counterpart,
        })

    return responseData("success", "Conversations fetched.", conversations, 200)


def getChatCounterparts():
    current_user, error = _ensure_authenticated_user()
    if error:
        return error

    role_id = current_user.get('role_id')

    if role_id == 2:  # Buyer fetching sellers
        query = """
            SELECT u.user_id, u.firstname, u.lastname, u.email, sd.store_name
            FROM seller_details sd
            JOIN users u ON u.user_id = sd.user_id
            WHERE sd.status = 1 AND u.status = 1
            ORDER BY sd.updated_at DESC
            LIMIT 50
        """
    elif role_id == 3:  # Seller fetching buyers
        query = """
            SELECT u.user_id, u.firstname, u.lastname, u.email
            FROM users u
            WHERE u.role_id = 2 AND u.status = 1
            ORDER BY u.updated_at DESC
            LIMIT 50
        """
    else:
        return responseData("error", "Chat counterparts available only for buyers and sellers.", "", 403)

    results = executeGet(query)
    if isinstance(results, tuple):
        return results

    return responseData("success", "Counterparts fetched.", results, 200)
