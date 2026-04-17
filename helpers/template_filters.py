def format_currency(value):
    """Format number with comma as thousand separator and 2 decimal places"""
    try:
        # Convert to float first to handle string inputs
        num = float(value)
        # Format with comma as thousand separator and 2 decimal places
        return "₱{:,.2f}".format(num)
    except (ValueError, TypeError):
        # Return original value if conversion fails
        return value

def register_template_filters(app):
    """Register all template filters"""
    app.jinja_env.filters['currency'] = format_currency
