#### LINUX
## SpeedTest

This script is for network speed test and logging results to logs in .TXT and .CSV (excel format).
It runs speedtest command which need to be installed. 
You can download it from [here](https://github.com/sivel/speedtest-cli) or install from repo 'speedtest-cli'.

### Options
    -r - remove old entries from log files (default: 61 days)
    -r 10 - like above but remove older than 10 days

    cronjob entry exp.
    (run test every 15 minutes and run cleanup at 0:00 everyday)
    */15 * * * * bash /home/user/sp.sh
    0 0 * * * bash /home/user/sp.sh -r


### Termux

Follow instructions from [this](https://github.com/thelearn-tech/speedtest-cli). Before need to do:
```
    pkg update
    pkg install python git
```
then
```
    git clone https://github.com/thelearn-tech/speedtest-cli
    cd speedtest-cli
    chmod +x termux-install.sh
    ./termux-install.sh
```
