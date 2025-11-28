from flask import Flask, session
import os
from flask_session import Session
from extensions import mail
from helpers.template_filters import register_template_filters

def str_to_bool(value: str, default: bool = True) -> bool:
    if value is None:
        return default
    return value.lower() in {'1', 'true', 't', 'yes', 'y'}


def create_app():
    app = Flask(__name__, template_folder='../template', static_folder='../static')
    
    # Core security config
    app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'change-me-in-prod')
    app.config['SESSION_TYPE'] = 'filesystem'  # Options: 'redis', 'filesystem', 'mongodb', etc.

    # Mail configuration (defaults to Gmail SMTP)
    app.config['MAIL_SERVER'] = os.environ.get('MAIL_SERVER', 'smtp.gmail.com')
    app.config['MAIL_PORT'] = int(os.environ.get('MAIL_PORT', 587))
    app.config['MAIL_USE_TLS'] = str_to_bool(os.environ.get('MAIL_USE_TLS', 'true'))
    app.config['MAIL_USERNAME'] = os.environ.get('MAIL_USERNAME')
    app.config['MAIL_PASSWORD'] = os.environ.get('MAIL_PASSWORD')
    app.config['MAIL_DEFAULT_SENDER'] = (
    os.environ.get('MAIL_DEFAULT_SENDER') 
    or os.environ.get('MAIL_USERNAME')
    or "serisuaruse@gmail.com"
)

    # Verification + OTP controls
    app.config['SECURITY_EMAIL_SALT'] = os.environ.get('SECURITY_EMAIL_SALT', 'email-confirm')
    app.config['EMAIL_TOKEN_MAX_AGE'] = int(os.environ.get('EMAIL_TOKEN_MAX_AGE', 3600))
    app.config['OTP_TTL_MINUTES'] = int(os.environ.get('OTP_TTL_MINUTES', 5))
    app.config['OTP_MAX_ATTEMPTS'] = int(os.environ.get('OTP_MAX_ATTEMPTS', 3))
    app.config['OTP_RESEND_COOLDOWN_SECONDS'] = int(os.environ.get('OTP_RESEND_COOLDOWN_SECONDS', 60))
    app.config['TWILIO_ACCOUNT_SID'] = os.environ.get('TWILIO_ACCOUNT_SID')
    app.config['TWILIO_AUTH_TOKEN'] = os.environ.get('TWILIO_AUTH_TOKEN')
    app.config['TWILIO_FROM_NUMBER'] = os.environ.get('TWILIO_FROM_NUMBER')

    Session(app)
    mail.init_app(app)

    @app.context_processor
    def inject_user():
        authenticated = session.get('authenticated', None)
        return dict(auth_user=authenticated)

    # Import the routes and register them with the app
    from routes import setup_routes
    setup_routes(app)
    
    # Register template filters
    register_template_filters(app)
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)  # Allow automatic reloading of changes

