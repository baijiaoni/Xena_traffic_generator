#!/bin/bash 
source xena_config.sh

# Define chassis, port, password and owner
MACHINE=140.181.139.228
PORT=22611
PASSWORD='"xena"'  # Must be in double quotes
OWNER='"Timing"' # Must be in double quotes

# Open file handle 3 as TCP connection to chassis:port
exec 3<> /dev/tcp/${MACHINE}/${PORT}
if [ $? -eq 0 ]
then
  echo "Telnet accepting connections"
else
  echo "Telnet connections not possible"
  exit 1
fi

# Send commands with echo command to file handle 3
echo -en "C_LOGON ${PASSWORD}\r\n" >&3
# Read answers from file handle 3, (one line a time)
read  <&3 
# Answers are put in $REPLY variable 
echo $REPLY

# Here are some examples
echo -en "C_OWNER ${OWNER}\r\n"  >&3
read  <&3 
echo $REPLY
echo -en "C_TIMEOUT 99999\r\n" >&3
read  <&3 
echo $REPLY

chassis_config_info

#NO vlan please set protNo=4/4, VLAN please set =4/5
# VLAN ID 1-7, corresponding priority 0-6
protNo=4/4

port_release 4/1 
port_release ${protNo}


port_reserve 4/1
port_reserve ${protNo}

traffic_stop ${protNo}
capture_stop ${protNo}

#Please choose a function

Novlan_random_bandwidth200M_1G 
#Vlan_random_bandwidth200M_1G  

traffic_stop ${protNo}
capture_stop ${protNo}

port_release 4/1
port_release ${protNo}
			
# Close file handle 3
exec 3>&-
if [ $? -eq 0 ]
then
    echo "Telnet accepting close"
else
    echo "Telnet close not possible"
fi
