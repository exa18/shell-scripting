#### LINUX
## BASH

This is setting for bash. Copy to your HOME.

### Bashupdate.sh

Updates all profiles with this set. Copies files with dot thru all users includes root.

### Aliases

##### NO args

- dff :: shows all SD* usage
- dus :: shows usage for all directories on actual level
- psd2jpg :: convert all .psd to .jpg in current folder
- psk :: shows collected wifi passwords
- u :: execute full update

##### with args

- l. :: list hidden (begins with dot)
- l :: list entires as columns and with indicator
- ll :: same as above but as expanded
- i :: install package with yes agree on
- I :: reinstall package
- s :: list repos
- S :: show given package
- r :: remove package with yes agree on
- e :: empty will shows all executables, or execute with bash
- cp :: uses rsync for copy
- hist :: use grep phrase on .bash_history
- m :: tizonia play content of folder given as arg // no args list entries // arg '--' list entries of folder given as second arg
- ms :: tizonia audio search
- ml :: tizonia audio playlist
- sc :: shellcheck on bash with warrnings and errors only
- jpgre :: resize all .jpg which was not scaled to given number of % width/higth // arg with number change % of resize
- nmap :: with prepend sudo
- kc :: sync Keepass file local-remote with autochange detection (separate project)

##### Variables

- SH_MSX :: sets working directory for **m**
- SH_JPGRE :: sets default % of resize for **jpgre**
- SH_SPIN :: sets spin sequence for progress **jpgre** and **psd2jpg**

### Convert and problem with cache
> Source from [HERE](https://stackoverflow.com/questions/31407010/cache-resources-exhausted-imagemagick#62512452)

The error probably occurs because you run out of memory. You can check for the resources using the following command:
**convert -list resource**

The output will be somewhat like this:
```
Resource limits:
  Width: 16KP   
  Height: 16KP   
  Area: 128MP   
  Memory: 256MiB   
  Map: 512MiB   
  Disk: 1GiB   
  File: 768   
  Thread: 8   
  Throttle: 0   
  Time: unlimited
```
Here, you can see that the assigned amounts of disk space and memory are very small. So, in order to modify it you need to change the policy.xml file located somewhere in /etc/ImageMagick-6 directory. Use command **find / -name "policy.xml"** to locate.

Change in the **policy.xml** file.
```
<policy domain="resource" name="disk" value="1GiB"/>
```
to
```
<policy domain="resource" name="disk" value="4GiB"/>
```

## BASH.TERMUX

Copy to your HOME under Termux on your Android device.

### Installation

1. download files to device
2. run Termux
3. execute commands (first command only once):
    ```
    termux-setup-storage
    ```
4. download file and copy
    ```
    cp ./storage/downloads/bashrc_termux ./.bashrc
    ```
    OR
    ```
    curl https://github.com/exa18/shell-scripting/raw/main/linux/bash/termux/bashrc_termux > .bashrc
    ```
5. restart shell: **exec bash**
