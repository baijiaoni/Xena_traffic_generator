function chassis_init ()
{
	if [ "$#" -ne "3" ]
	then
		echo "chassis_init <IP> <OWNER> <PASSWORD>"
	fi
	# Define chassis, port, password and owner
	MACHINE=$1
	PORT=22611
	PASSWORD=$3  
	OWNER=$2 
	
	# Send commands with echo command to file handle 3
	echo -en "C_OWNER $PASSWORD\r\n"  >&3
	read  <&3 
	echo $REPLY
	echo -en "C_LOGON $OWNER\r\n" >&3
	# Read answers from file handle 3, (one line a time)
	read  <&3 
	# Answers are put in $REPLY variable 
	echo $REPLY

	echo -en "C_TIMEOUT 20\r\n" >&3
	read  <&3 
	echo $REPLY
}

function chassis_config_info ()
{
	echo -en "C_CONFIG ?\r\n" >&3  # Will create 5 lines of answer
	read  <&3 # will only read one line of answer
	echo $REPLY 
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
}

function port_reserve ()
{
	echo -en "$1 P_INTERFACE ?\r\n" >&3 
	read  <&3
	echo $REPLY
	echo -en "$1 P_RESERVATION RESERVE\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
	then
		echo "Error: P_RESERVED:$REPLY"
	fi
}

function port_release ()
{
	echo -en "$1 P_INTERFACE ?\r\n" >&3 
	read  <&3
	echo $REPLY
	echo -en "$1 P_RESERVATION RELEASE\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
	then
		echo "Error: P_RELEASED:$REPLY"
	fi
}

function traffic_stop ()
{
  echo -en "$1 P_TRAFFIC OFF\r\n" >&3 
	read  <&3
	echo $REPLY
#	echo -en "$1 P_TRAFFIC ?\r\n" >&3 
#	read  <&3
#	echo $REPLY
}

function traffic_start ()
{
  echo -en "$1 P_TRAFFIC ON\r\n" >&3 
	read  <&3
	echo $REPLY
#	echo -en "$1 P_TRAFFIC ?\r\n" >&3 
#	read  <&3
#	echo $REPLY
}

function capture_stop ()
{
  echo -en "$1 P_CAPTURE OFF\r\n" >&3 
	read  <&3
	echo $REPLY
#	echo -en "$1 P_CAPTURE ?\r\n" >&3 
#	read  <&3
#	echo $REPLY
}

function capture_start ()
{
  echo -en "$1 P_CAPTURE ON\r\n" >&3 
	read  <&3
	echo $REPLY
#	echo -en "$1 P_CAPTURE ?\r\n" >&3 
#	read  <&3
#	echo $REPLY
}
function PR_counter_clear ()
{
	echo -en "$1 PR_CLEAR\r\n" >&3 
	read  <&3
	echo "$1 PR_COUNTER_CLEAR:$REPLY"
}
function PT_counter_clear ()
{

	echo -en "$1 PT_CLEAR\r\n" >&3 
	read  <&3
	echo "$1 PT_COUNTER_CLEAR:$REPLY"
}
function PT_info ()
{
	echo -en "$1 PT_ALL ?\r\n" >&3 
	read  <&3 # will only read one line of answer
	echo $REPLY 
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY 
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
}	
function PR_info ()
{
	echo -en "$1 PR_ALL ?\r\n" >&3 
	read  <&3 # will only read one line of answer
	echo $REPLY 
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
	read  <&3 # will only read one line of answer
	echo $REPLY
}
#stream_config parameters : port, stream, payload (Fixed), Bandwidth
function stream_config ()
{ 
	if [ "$#" -ne "5" ]
	then
		echo "Stream_config <port> <stream ID> <FIXED/RANDOM> <payload_length> <bandwidth>"
	fi
	# Xena ports configuration 
	echo -en "$1 P_LOOPBACK NONE\r\n" >&3 
	read  <&3
	echo $REPLY
	echo -en "$1 P_LATENCYMODE LAST2LAST\r\n" >&3 
	read  <&3
	echo $REPLY
        # Please modify the latency offset introduced by optical fiber
	echo -en "$1 P_LATENCYOFFSET 20\r\n" >&3 
	read  <&3
	echo $REPLY

	#Stream configuration
	echo -en "$1 PS_CREATE [$2]\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
	then
		echo "Error: PS_CREATE:$REPLY"
	fi	
	echo -en "$1 PS_PACKETLIMIT [$2] -1\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
	then
		echo "Error: PACKETLIMIT:$REPLY"
	fi
	#echo -en '$1 PS_COMMENT [$2] "Stream number $2"\r\n' >&3
	#read  <&3
	#if [ "$REPLY" != "<OK>" ]
	#then
	#	echo "Error: COMMENT:$REPLY" 
	#fi	
#	ratepps=`expr$5 / $4`
#	echo -en "$1 PS_RATEPPS [$2] $ratepps\r\n" >&3 
#	read  <&3
#	if [ "$REPLY" != "<OK>" ]
#	then
#	echo "Error: PS_RATEPPS:$REPLY" 
#	fi	
	echo -en "$1 PS_RATEL2BPS [$2] $5\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_RATEL2BPS:$REPLY"
	fi

	echo -en "$1 PS_BURST [$2] -1 100\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_BURST:$REPLY" 
	fi	
	echo -en "$1 PS_HEADERPROTOCOL [$2] ETHERNET IP\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
	then
			echo "Error: PS_HEADERPROTOCOL:$REPLY"
	fi			
	echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E410800002E000000007FFF3AD20000000000000000\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
	fi	
	if [ "$3" == "FIXED" ]	
  then 
  	echo -en "$1 PS_PACKETLENGTH [$2] FIXED $4 1500\r\n" >&3 
  else
  	echo -en "$1 PS_PACKETLENGTH [$2] $3 200 800\r\n" >&3
  	#echo -en "$1 PS_PACKETLENGTH [$2] $3 64 1500\r\n" >&3
	fi
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETLENGTH:$REPLY"
	fi				
	echo -en "$1 PS_PAYLOAD [$2] PATTERN 0xAABB00FFEE\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PAYLOAD:$REPLY"
	fi			
	echo -en "$1 PS_TPLDID [$2] $2\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_TPLDID:$REPLY"
	fi		
	echo -en "$1 PS_INSERTFCS  [$2]  ON\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_INSERTFCS:$REPLY"
	fi
	echo -en "$1 PS_ENABLE [$2] ON\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_ENABLE:$REPLY"
	fi	
	echo -en "SYNC\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: SYNC:$REPLY"
	fi	

#	echo -en "$1 PS_CONFIG [$2] ?\r\n" >&3  # Will create 5 lines of answer
#	read  <&3 # will only read one line of answer
#	echo $REPLY 
#	read  <&3 # will only read one line of answer
#	echo $REPLY
#	read  <&3 # will only read one line of answer
#	echo $REPLY
#	read  <&3 # will only read one line of answer
#	echo $REPLY
#	read  <&3 # will only read one line of answer
#	echo $REPLY
#	echo "Payload:$4  Bandwidth:$5"
}
#stream_update is used to change payload length and bandwidth
function stream_update ()
{
	if [ "$#" -ne "5" ]
	then
		echo "Stream_update <port> <stream ID> <FIXED/Other type> <payload> <bandwidth> "
	fi
	if [ "$3" == "FIXED" ]	
  then 
  	echo -en "$1 PS_PACKETLENGTH [$2] FIXED $4 1500\r\n" >&3 
  else
  	echo -en "$1 PS_PACKETLENGTH [$2] $3 64 1516\r\n" >&3
	fi
	echo -en "$1 PS_PACKETLENGTH [$2] ?\r\n" >&3
	read  <&3
	echo $REPLY
	echo -en "$1 PS_RATEL2BPS [$2] $5\r\n" >&3 
	read  <&3
#	if [ "$REPLY" != "<OK>" ]
#		then
#			echo "Error: PS_RATEL2BPS:$REPLY"
#	fi
	echo -en "$1 PS_RATEL2BPS [$2] ?\r\n" >&3
	read  <&3
	echo $REPLY
}
function stream_vlan ()
{
	if [ "$#" -ne "4" ]
	then
		echo "Stream_vlan <port> <stream ID> <VLAN ID> <VLAN Priority>"
	fi
	echo -en "$1 PS_HEADERPROTOCOL [$2] ETHERNET VLAN IP\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
	then
		echo "Error: PS_HEADERPROTOCOL:$REPLY"
	fi		
	#VLAN 1 Priority 0
	if [ "$3" == "1" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E4810000010800450002F8000000007FFF38080000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 01 PRIORITY 0"
	fi
	
	#VLAN 2 Priority 1
	if [ "$3" == "2" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E4810020020800450002F8000000007FFF38080000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 02 PRIORITY 1"
	fi

	#VLAN 3 Priority 2
	if [ "$3" == "3" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E4810040030800450002F8000000007FFF38080000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 03 PRIORITY 2"
	fi
	
	#VLAN 4 Priority 3
	if [ "$3" == "4" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E4810060040800450002F8000000007FFF38080000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 04 PRIORITY 3"
	fi
	
	#VLAN 5 Priority 4
	if [ "$3" == "5" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E4810080050800450002F8000000007FFF38080000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 05 PRIORITY 4"
	fi	

	#VLAN 6 Priority 5
	if [ "$3" == "6" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E48100a0060800450002F8000000007FFF38080000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 06 PRIORITY 5"
	fi

	#VLAN 7 Priority 6
	if [ "$3" == "7" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x01aabbccddee4F4BC3B27E48100c0070800450002F8000000007FFF38080000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 07 PRIORITY 6"
	fi	
	

}

function stream_bandwidth ()
{
	if [ "$#" -ne "3" ]
	then
		echo "stream_bandwidth <port> <stream ID> <bandwidth>"
	fi
	
	echo -en "$1 PS_RATEL2BPS [$2] $3\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_RATEL2BPS:$REPLY"
	fi
	echo -en "$1 PS_RATEL2BPS [$2] ?\r\n" >&3 
	read  <&3 # will only read one line of answer
	echo $REPLY 
}

# No vlan, random payload, bandwidth from 20% to 90% at the step of 10%, each step is 20 minutes
 
function Novlan_random_bandwidth200M_1G ()
{

	stream_config 4/4 01 RANDOM 64 100000000 
	    
	for (( bandwidth = 200000000; bandwidth < 900000000; bandwidth =`expr $bandwidth + 100000000` ))
	do
			sleep 2
			PT_counter_clear 4/4		
			PR_counter_clear 4/1		
						
			sleep 2
			echo "---------------------Test with bandwith $bandwidth---------------------------------"

	    stream_bandwidth 4/4 01 $bandwidth
	    
	    sleep 2    
			traffic_start 4/4
 			capture_start 4/4 

			# s/m/h/d, defalut second
			sleep 5m
	
			traffic_stop 4/4
			capture_stop 4/4 
			
			sleep 7
			#PT_info 4/4
			#PR_info 4/1
				
	done
 			
	for (( bandwidth = 900000000; bandwidth <= 1000000000; bandwidth =`expr $bandwidth + 10000000` ))
	do
			sleep 2
			PR_counter_clear 4/1		
						
			sleep 2
	    stream_bandwidth 4/4 01 $bandwidth
	    
	    sleep 2    
			traffic_start 4/4
 			capture_start 4/4 

			# s/m/h/d, defalut second
			sleep 5m
	
			traffic_stop 4/4
			capture_stop 4/4 
			
			sleep 7
			#PT_info 4/4
			#PR_info 4/1
			
	done				

}

function Vlan_random_bandwidth200M_1G ()
{

	    stream_config 4/5 00 RANDOM 64 10000000
	    stream_config 4/5 01 RANDOM 64 10000000 
	    stream_config 4/5 02 RANDOM 64 10000000
	    stream_config 4/5 03 RANDOM 64 10000000
	    stream_config 4/5 04 RANDOM 64 10000000
	    stream_config 4/5 05 RANDOM 64 10000000
	    stream_config 4/5 06 RANDOM 64 10000000
	    
      sleep 2    
	    #Stream_vlan <port> <stream ID> <VLAN ID> <VLAN Priority>
			stream_vlan 4/5 00 1 0
			stream_vlan 4/5 01 2 1
			stream_vlan 4/5 02 3 2
			stream_vlan 4/5 03 4 3
			stream_vlan 4/5 04 5 4
			stream_vlan 4/5 05 6 5
			stream_vlan 4/5 06 7 6	
	    
	    sleep 20m

	for (( bandwidth = 200000000; bandwidth < 900000000; bandwidth =`expr $bandwidth + 100000000` ))
	do
			sleep 2
			PR_counter_clear 4/1		
			PT_counter_clear 4/5	
			echo "---------------------Test with bandwith $bandwidth---------------------------------"
			
			band=`expr $bandwidth / 7`
			echo $band
						
			sleep 2
	    stream_bandwidth 4/5 00 $band	
	    stream_bandwidth 4/5 01 $band	
	    stream_bandwidth 4/5 02 $band
	    stream_bandwidth 4/5 03 $band
	    stream_bandwidth 4/5 04 $band
	    stream_bandwidth 4/5 05 $band
	    stream_bandwidth 4/5 06 $band 	

	    sleep 2    
			traffic_start 4/5
 			capture_start 4/5 

			# s/m/h/d, defalut second
			sleep 20m
	
			traffic_stop 4/5
			capture_stop 4/5 
			
			sleep 2
			#PT_info 4/5
			#PR_info 4/1
				
	done
 			
	for (( bandwidth = 900000000; bandwidth <= 1000000000; bandwidth =`expr $bandwidth + 10000000` ))
	do
			sleep 2
			PR_counter_clear 4/1		
						
			sleep 2
			band=`expr $bandwidth / 7`
						
			sleep 2
	    stream_bandwidth 4/5 00 $band	
	    stream_bandwidth 4/5 01 $band	
	    stream_bandwidth 4/5 02 $band
	    stream_bandwidth 4/5 03 $band
	    stream_bandwidth 4/5 04 $band
	    stream_bandwidth 4/5 05 $band
	    stream_bandwidth 4/5 06 $band 
	    
	    sleep 2    
			traffic_start 4/5
 			capture_start 4/5 

			# s/m/h/d, defalut second
			sleep 10
	
			traffic_stop 4/5
			capture_stop 4/5 
			
			sleep 2
			#PT_info 4/5
			#PR_info 4/1
			
	done				

}