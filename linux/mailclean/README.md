#### LINUX
## MailClean

This script arhive and then removes old mail entries. Can be set as cron job.

### Arg

If provided run for given domain name, if not run for all domains.
Arg starting with -- will show verbosing.

### Cron entry

'''
/usr/bin/bash ~/mailclean.sh domain >/dev/null 2>&1
'''