#!/bin/bash

# Sciript tested on LAPN600 but may work on other versions.
# This script will automatically reboot the Access Points provided in the SYSTEMURLS_LIST Variable.
# Primarily this script can be scheduled using CRON or other systems to reboot the Access Points automatically.

USERID="admin"
PASSWORD=""
SYSTEMURLS_LIST=("https://192.168.0.101" "https://192.168.0.106")

for SYSTEMURL in "${SYSTEMURLS_LIST[@]}"
do
	echo "Rebooting $SYSTEMURL"
  curl -k --cookie-jar linksys -d "login_name=$USERID&login_pwd=%2$PASSWORD&todo=login&h_lang=en&r_id=&this_file=login.htm&next_file=Menu_Status.htm" $SYSTEMURL/login.cgi

  REBOOT_SESS_ID="$(curl -k -L -b linksys -s "$SYSTEMURL/Reboot.htm" | grep session_id | cut -c47-54)"

  curl -k -L -b linksys -d "DeviceReboot=1&session_id=$REBOOT_SESS_ID&todo=restart&this_file=Reboot.htm&next_file=Reboot.htm&message=" $SYSTEMURL/setup.cgi?next_file=Reboot.htm

  echo "Waiting for reboot of system @ $SYSTEMURL"
  sleep 200
done
