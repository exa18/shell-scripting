#### LINUX
## PowerOn

This script count how long computer was turned on in given time from command `last -x runlevel --time-format iso`. If leave empty shows current month.

### Log config
Config file for logs is in '/etc/logrotate.conf' and usually includes all files from '/etc/logrotate.d'.
For longer keeping logs need to be change **rotate** value. Also recomended to change is period from monthly to **yearly**.
file '/etc/logrotate.d/wtmp', exp.
```
/var/log/wtmp {
    missingok
    yearly
    create 0664 root utmp
    minsize 1M
    rotate 3
}
```

### Options

    NaN

### Wishes (cron)

Adapt w/o zenity and work from cron to push data to txt/csv for future analyze possible.
