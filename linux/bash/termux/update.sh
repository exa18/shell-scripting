#!/bin/bash
echo Performing UPDATE...
echo 
echo ... Update
apt update -y
echo ... Upgrade
apt upgrade -y
echo ... Autoremove
apt autoremove -y
echo 
echo ... Purge residual configs
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r dpkg --purge

echo DONE.

