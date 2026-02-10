## How to config connection

1. Install urbackup_client [HERE](https://www.urbackup.org/download.html)
2. Allow IN traffic (ufw): **55415/tcp, 35621/tcp, 35622/tcp, 35623/udp**
3. Check your **hostname**
4. Login to your urbackup_server web **urbackup.server.domain**
5. There, go buttom and add new client
6. Copy line with fingerprint and add it to **/usr/local/var/urbackup/server_idents.txt**
7. Next on site in field "Add new internet/active client" put your **hostname** or whatever you like, this is be your **computername**
8. Add client and from next site copy your **AUTHKEY**
9. Edit **/usr/local/var/urbackup/data/settings.cfg** and add lines
   ```
   internet_server=<urbackup.server.domain>
   internet_server_port=55415
   internet_authkey=<AUTHKEY>
   ```
   and if you did choose other computername than your hostname, add also line with this new name
   ```
   computername=<NEW_NAME>
   ```
   and check if this is set
   ```
   internet_mode_enabled=true
   ```
   OR do with sudo
   ```
   urbackupclientctl set-settings -k internet_mode_enabled -v true 
   urbackupclientctl set-settings -k internet_server -v urbackup.server.domain
   urbackupclientctl set-settings -k internet_server_port -v 55415
   urbackupclientctl set-settings -k internet_authkey -v AUTHKEY // urbackupclientctl set-settings --authkey "AUTHKEY"
   # urbackupclientctl set-settings -k computername -v COMPUTERNAME // urbackupclientctl set-settings --name "COMPUTERNAME"
   systemctl restart urbackupclient
   ```
   
11. Add what you want to backup, exp. **sudo urbackupclientctl add-backupdir -d $HOME -n HOME**
12. Check status with **urbackupclientctl status** and wait, if all configured also with server you should see status connected soon.
13. You can push backup with **urbackupclientctl start --full --file**

Good luck !
