import random
import smtplib, ssl

SMTP_SSL_PORT=465 
SMTP_SERVER="smtp.gmail.com"

SENDER_EMAIL="gmlcjf0419@gmail.com"
SENDER_PASSWORD="uuzd kouw mcsa gmer"

check_num = {}

def get_certification_number():
    number = ""

    for _ in range(6):
        number += str(random.randint(0, 9))
    
    check_num["number"] = number
    return number


def send_message(receiver_email):
    context = ssl.create_default_context()

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