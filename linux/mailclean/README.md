#### LINUX
## MailClean

This script is for cleaning ./imap folder from growing files.
Can be set as cron job.
Also works on directory structure for **hekko/cyberfolks** or similar ->
```<home>/imap/<domain>/*/Maildir/```

```
<home>
    /imap
        /domain
            /*  <- all boxes/users
            /user1
            /user2
            /...
                /Maildir
                    /*/cur
                    /*/new
```

### Args

Cleaning works for one domain not for "*".
Starting domain with -- will turn on making zip.

**clean** domain (days) (size)
Remove/archive files older than (days)
-- and less than (size) MB make .zip if domain prefixed and do remove
-- and greater than (size) MB do remove
-- .zip stored at (archive-dir)

**scan** (domain) (days) (size)
-- checks how many GB saved with given days and size

**datefix** (domain)
-- fix modification date to inside delivery instead current which was taken after copy

**help** (domain or "*") (days > 6) (size > 1)
-- show help and check settings

### Cron entry

```
/usr/bin/bash ~/mailclean.sh clean domain >/dev/null 2>&1
```
