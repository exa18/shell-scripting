#### WINDOWS 7 and greater
## Sync with remote
### Schedule backup local to remote

This script creates file to perform scheduled synchronization task with remote dir. 
It requires RCLONE and TAR installed.
In default it compress AppData folder and sync all user profile directory to remote.

### Before execute

- install RCLONE [here](https://rclone.org/downloads/)
- install TAR if you running Windows 7 [here](http://gnuwin32.sourceforge.net/packages/gtar.htm)
- configure RCLONE remote
- edit script and change
```
	set dest=yourRemote
```
- run script as admin

### After

- input time for run planned task in format HHMM (hours and minutes) or if leave empty then current time is set
- input home directory at remote
- answer if add another source and destination directory
	- if YES, input and if source exists add entry

