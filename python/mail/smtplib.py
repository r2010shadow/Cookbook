#encoding:utf-8
import smtplib
import email.mime.multipart
import email.mime.text

msg = email.mime.multipart.MIMEMultipart()
msg['from'] = 'r2010shadow@163.com'
msg['to'] = 'yyn_ga@163.com'
msg['subject'] = '这是邮件主题'
content = '''
    Hi will,
           This is an test email.
'''
txt = email.mime.text.MIMEText(content)
msg.attach(txt)

smtp = smtplib
smtp = smtplib.SMTP()
smtp.connect('smtp.163.com')
smtp.login('r2010shadow','password')
smtp.sendmail('r2010shadow@163.com', 'yyn_ga@163.com', str(msg))
smtp.quit()


Python 发送带附件的邮件  HTML
http://www.runoob.com/python/python-email.html



