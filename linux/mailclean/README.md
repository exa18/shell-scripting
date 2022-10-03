#### LINUX
## MailClean

This script is for cleaning ./imap folder from growing files.
Can be set as cron job.
Also works on directory structure for **hekko/cyberfolks** or similar ->
```<home>/imap/domain/*Maildir/cur```

```
<home>
    /imap
        /domain
            /*  <- all boxes/users
            /user1
            /user2
            /...
                /Maildir/cur
```

### Args

Cleaning works for one domain not for "*".
Starting domain with -- will show verbose.

clean domain (days) (size)
Remove/archive files older than (days)
-- and for less than (size) MB make .zip and remove
-- and greater than (size) MB just remove
-- .zip stored at (archive-dir)

scan (domain)
-- checks how many GB saved with given days and size

help (domain or "*") (days > 6) (size > 1)
-- show help

### Cron entry

```
/usr/bin/bash ~/mailclean.sh clean domain >/dev/null 2>&1
```