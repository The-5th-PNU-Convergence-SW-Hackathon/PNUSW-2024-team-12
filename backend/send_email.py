import random
import smtplib, ssl

from dotenv import load_dotenv
import os
load_dotenv()

SMTP_SERVER = os.environ.get("SMTP_SERVER")
SMTP_SSL_PORT = os.environ.get("SMTP_SSL_PORT")
SENDER_EMAIL = os.environ.get("SENDER_EMAIL")
SENDER_PASSWORD = os.environ.get("SENDER_PASSWORD")

check_num = {}

def get_certification_number():
    number = ""

    for _ in range(6):
        number += str(random.randint(0, 9))
    
    check_num["number"] = number
    return number


def send_message(receiver_email):
    context = ssl.create_default_context()

    try:
        with smtplib.SMTP_SSL(SMTP_SERVER, SMTP_SSL_PORT, context=context) as server:
            certification_number = get_certification_number()
            print(certification_number)
            
            # Constructing the email message
            subject = "Your Certification Number"
            body = f"Your certification number is: {certification_number}"
            message = f"Subject: {subject}\n\n{body}"
            print(message)
            # Sending the email
            server.login(SENDER_EMAIL, SENDER_PASSWORD)
            server.sendmail(SENDER_EMAIL, receiver_email, message)
        return certification_number
    except Exception as e:
        print("error :", e)