#### LINUX
## SmartMon

This script test and count if where errors on disks and if so throw with mail and sms. Sms is send 1 per 24h unless have paid plan.

### Config
Config is inside **Set** section:

netip : first two numbers of network ip
tempalert : above given value
testperiod : perform short test once per given days

#### MAIL

mailsend : send mail once per given hours
mailssl : if send mail thru SSL just type any value
mailsmtp : mail server / smtp  ( port: noSSL=587, SSL=485 )
mailfrom : address @ from who
mailpass : password for mailform login
mailto : to who send

#### SMS

smssend : send sms once per day, unless paid plan available
smsnumber : phone to which send ( +00111222333 )
smsuserid : user id as @ if paid plan
smskey : otg-key if paid plan


### Cron

Just set script to run from root. 
