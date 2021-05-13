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
- u :: execute update.sh which updates system

##### with args

- l :: list entires as columns and with indicator
- ll :: same as above but as expanded
- i :: install package with yes agree on
- s :: list repos
- S :: show given package
- r :: remove package with yes agree on
- e :: empty will shows all executables, or execute with bash
- cp :: uses rsync for copy
- hist :: use grep phrase on .bash_history
- ms :: tizonia audio search
- ml :: tizonia audio playlist
- m :: tizonia plays from set folder // arg '--' list directories which contain audio files, arg with folder name play its content
- sc :: spellcheck on bash with warrnings and errors only
- jpgre :: resize all .jpg which was not scaled to given number of % width/higth // arg with number change % of resize
- nmap :: with prepend sudo
- kc :: sync Keepass file local-remote with autochange detection (separate project)

##### Variables

- shMSX :: sets working directory for **m**
- shJPGRE :: sets default % of resize for **jpgre**