#### LINUX
# Keepass SYNC

## This script is for synchronize keepass database file with set cloud/server.
And it is compliant with POSIX Shell so it can be executed on Termux.
  > install :: keepassxc rclone

---

### Config

This is filename for database without extension 
> kdbx='KEEPASSDATABASE'

First need install RCLONE, then **rclone config** and create new remote

> remote='REMOTE:'\
> remotepath='FOLDER/SUBFOLDER'

This define local folder in HOME which store backups

> bak='/Backup_XC'

This on or off showing more output (default is empty)

> verbose=

### Arguments

If first argument is **--** then show more output unless **verbose** is set then opposite.

First/second arg change **kdbx** database filename.