import smtplib
from email.mime.text import MIMEText

s = smtplib.SMTP('smtp.utah.edu')
s.set_debuglevel(1)
msg = MIMEText("""This is a  Body message from karthi""")
sender = 'karthi.jeyabalan@hsc.utah.edu'
recipients = ['karthi.jeyabalan@hsc.utah.edu', 'karthi.jeyabalan@gmail.com']
msg['Subject'] = "From Work Laptop Karthii"
msg['From'] = sender
msg['To'] = ", ".join(recipients)
s.sendmail(sender, recipients, msg.as_string())