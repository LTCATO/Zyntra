import random
from datetime import datetime, timedelta
from typing import Optional

from flask import current_app, url_for
from flask_mail import Message
from itsdangerous import BadSignature, URLSafeTimedSerializer
from itsdangerous.exc import BadTimeSignature, SignatureExpired
from twilio.base.exceptions import TwilioException
from twilio.rest import Client

from extensions import mail
from helpers.HelperFunction import hashing


def _get_serializer() -> URLSafeTimedSerializer:
    secret_key = current_app.config['SECRET_KEY']
    salt = current_app.config['SECURITY_EMAIL_SALT']
    return URLSafeTimedSerializer(secret_key, salt=salt)


def generate_email_token(email: str) -> str:
    serializer = _get_serializer()
    return serializer.dumps(email)


def confirm_email_token(token: str) -> str:
    serializer = _get_serializer()
    max_age = current_app.config['EMAIL_TOKEN_MAX_AGE']
    return serializer.loads(token, max_age=max_age)


def send_verification_email(email: str, token: str) -> None:
    verify_url = url_for('verify_email', token=token, _external=True)
    subject = 'Verify your Zyntra account'
    body = (
        'Hi! Please confirm your Zyntra account by clicking the link below.\n\n'
        f'{verify_url}\n\n'
        'This link expires in one hour. If you did not create an account, you can ignore this email.'
    )
    message = Message(subject=subject, recipients=[email], body=body)
    mail.send(message)


def generate_otp() -> str:
    return f"{random.randint(100000, 999999)}"


def hash_otp(otp: str) -> str:
    return hashing(otp)


def get_otp_expiry() -> datetime:
    ttl_minutes = current_app.config['OTP_TTL_MINUTES']
    return datetime.utcnow() + timedelta(minutes=ttl_minutes)


def _format_phone_number(phone: str) -> str:
    phone = phone.strip()
    if phone.startswith('+'):
        return phone
    if phone.startswith('0'):
        return f"+63{phone[1:]}"
    if phone.startswith('63'):
        return f"+{phone}"
    return phone


def _get_twilio_client() -> Optional[Client]:
    account_sid = current_app.config.get('TWILIO_ACCOUNT_SID')
    auth_token = current_app.config.get('TWILIO_AUTH_TOKEN')
    if not account_sid or not auth_token:
        return None
    return Client(account_sid, auth_token)


def send_sms_otp(phone: str, otp: str) -> bool:
    client = _get_twilio_client()
    sender = current_app.config.get('TWILIO_FROM_NUMBER')
    if not client or not sender:
        return False
    try:
        client.messages.create(
            body=f"Your Zyntra verification code is {otp}. It expires in {current_app.config['OTP_TTL_MINUTES']} minutes.",
            from_=sender,
            to=_format_phone_number(phone)
        )
        return True
    except TwilioException:
        return False


def seconds_until_resend(last_sent_at: Optional[datetime]) -> int:
    if not last_sent_at:
        return 0
    cooldown = current_app.config['OTP_RESEND_COOLDOWN_SECONDS']
    now = datetime.utcnow()
    delta = last_sent_at + timedelta(seconds=cooldown) - now
    return max(int(delta.total_seconds()), 0)
