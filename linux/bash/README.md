#### LINUX
## BASH

This is setting for bash. Copy to your HOME.

---

## Prompt

Here are choices which you enable in **.bashrc** inside set_prompt().

- `PROMPT_STYLE` :: select prompt: simple, oneline, twoline

![Bash Prompts preview](bash_prompts.png "Bash Prompts preview")

## 

### Bashupdate.sh

Updates all profiles with this set. Copies files with dot thru all users includes root.

## Aliases

### Bash completion

Execute **_install** to copy completions at **/usr/share/bash-completion/completions/**. This path could be found inside **/etc/bash_completion**.
- APT :: ```i, I, S, r```

#### Variables

- `SH_MSX` :: sets working directory for **m**
- `SH_MSXPLAYER` :: choose wich player to use **tizonia|mocp**
- `SH_JPGRE` :: sets default % of resize for **jpgre**
- `SH_SPIN` :: sets spin sequence for progress **jpgre** and **psd2jpg**
- `SH_IM` :: selects which ImageMagick version, IM7 uses **magick** but IM6 **convert**
- `TIME_STYLE` :: sets date format used by **ls** and **exa**

#### COMMON
- `l` :: list entires as columns and with indicator
- `ll` :: same as above but as expanded
- `la` :: list all (with hidden)
- `l.` :: list only hidden (begins with dot)
- `ip` :: just add colors
  > install :: net-tools
- `dff` :: shows all /dev/sd* usage
- `dus` :: shows usage for all directories on actual level
- `cp` :: uses rsync for copy
  > install :: rsync
- `hist` :: use grep phrase on .bash_history

#### APT
- `i` :: install package with yes agree on
- `I` :: reinstall package
- `s` :: list repos
- `S` :: show given package
- `r` :: remove package with yes agree on
- `U` :: execute dry update and list which waiting for update
- `u` :: execute full update (but no distro and holded), regular update with simulate update to check if needed timeshift snapshot and update then cleaning

##### GFX
- `psd2jpg` :: convert all .psd to .jpg in current folder
- `jpgre` :: resize all .jpg which was not scaled to given number of % width/higth // arg with number change % of resize
- `gfx2jpg` :: convert one or more images to JPG with 100% quality
  > install :: imagemagick
- `pdf2pdf` :: separate multi page PDF to single pages (numbered 0000, 0001 ...)
  > install :: pdfarranger
- `doc2pdf` :: convert to PDF any document openable by LibreOffice (version is checked >= 5.2.6.2)
  > install :: libreoffice
- `pdfnopass` :: rewrite encrypted PDF to no password if you know it, args: /file.pdf/ /pass/
  > install :: ghostscript
  >> equivalent to :: qpdf --password=PDF-PASSWORD --decrypt input_pdf output_pdf

##### VIDEO
- `ffavi` :: convert any video to H.264/mkv crf/20 and audio mp3/48000Mhz/128k
- `ffmp3` :: extract mp3 with 192k (default) from mp4 bitrate from video // args: /videofile or empty/ /bitrate/
  > install :: ffmpeg

#### MSX
- `m` :: play content of folder given as arg // no args list entries // arg '--' list entries of folder given as second arg
1. TIZONIA
- `ms` :: tizonia audio search
- `ml` :: tizonia audio playlist
  > install :: tizonia
2. MOCP (in case config set on file **chmod g-r,o-r**)
- `ms` :: toggle PAUSE
- `mS` :: toggle PLAY/STOP
- `mx` :: start mocp server, if stoped and playlist then playit, enter GUI
- `mX` :: shutdown mocp server
- `mn`/`mp` :: next/previous track
  > install :: moc

##### TOOLS
- `sc` :: shellcheck on bash with warrnings and errors only
  > install :: shellcheck
- `nmap` :: with prepend sudo
  > install :: nmap
- `e` :: empty will shows all executables scripts invoked SheBang (#!), or execute
- `tm` :: change access and modification datetime with arg YYYYMMDDhhmm. Changes with only provided part of arg.
- `kc` :: sync Keepass file local-remote with autochange detection (separate project)
  > install :: keepassrc rclone
- `psk` :: shows collected wifi passwords
- `findusb` :: determine usb port of device
- `version` :: get version for .bash_aliases and .bashrc
- `ddw` :: write IMG to (USB) drive, exp. ddw sde raspberry.img
- `ddc` :: clear (USB) drive, exp. ddc sde

#### EDITOR
- `vi` :: neovim
- `na` :: nano
- `mi` :: micro

## Unbundled
Contains full and prettified some scripts of above aliases.
- `e`
- `findusb` :: findusbports
- `jpgre`
- `tm`
- `u` : update
- `update_ubuntu` :: for ubuntu full update
- `update_ubuntu_non` :: sme but without update kept back and nvidia
- `swap.sh`\* :: for creating and/or changing /swapfile
  > argument as number to change amount in gigs (default: total ram +2) \
  > if "--" then just remove and disable swap
- `nvidia_hold.sh`\* :: mark all nvidia dependencies as hold to prevent updates

  \* not aliased


## XFCE4 Genmon
Install: **xfce4-genmon-plugin**

Source: [Xtonousou/xfce4-genmon-scripts](https://github.com/xtonousou/xfce4-genmon-scripts/blob/master/memory-panel.sh)
- memory-panel.sh : show ram used / total and icon if valid file which could be added as arg
  and also show running tasks afer click over if installed **xfce4-taskmanager** or if not and xfce4-terminal and **htop**

## Configs / dot folder
Just copy to home
- .config -> xfce4 : panel, terminal, keyboard shortcuts
- .config -> thunar
- .gnupg
- .moc : default config template for MOCP

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
    pkg update && pkg install python git rclone zip unzip wget
    ```
4. download file and copy
    ```
    cp ./storage/downloads/bashrc_termux ./.bashrc
    ```
    OR
    ```
    curl -L https://github.com/exa18/shell-scripting/raw/main/linux/bash/termux/bashrc_termux > .bashrc
    ```
    OR
    ```
    wget https://github.com/exa18/shell-scripting/raw/main/linux/bash/termux/bashrc_termux
    mv bashrc_termux .bashrc
    ``` 
5. restart shell: **exec bash**

### Aliases

#### Variables

- `SH_MSX`
- `SH_IM`
- `TIME_STYLE`
- `USER` :: sets env which is missing

#### Common

- `l`
- `l.`
- `ll`
- `la`
- `ip`
- `dus`
- `hist`

#### Install & update (PKG)

- `i`
- `I`
- `s`
- `S`
- `r`
- `u` :: update repos
- `U` :: update and upgrade all and then clean

#### Tools

- `e`
- `sc`
- `kc`
- `list` :: convert text comma separated to EOL which could be pasted and remade as checklist
  > use default list name "_list" or provided arg
  > outputs to console

#### Msx & Gfx

- `jpgre` :: resize all .jpg from current folder to 50% and outputs to **resized** folder
- `pdfnopass`

#### Editor

- `vi`
- `mi`
- `na`
