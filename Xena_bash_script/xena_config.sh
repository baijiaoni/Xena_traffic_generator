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
#stram_config parameters : port, stream, payload (Fixed), Bandwidth
function stream_config ()
{ 
	if [ "$#" -ne "5" ]
	then
		echo "Stream_config <port> <stream ID> <FIXED/RANDOM> <payload_length> <bandwidth> "
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
	echo -en "$1 PS_PACKETHEADER [$2] 0xFFFFFFFFFFFF$2F4BC3B27E1080$2500002E000000007FFF3AD20000000000000000\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
	fi	
	if [ "$3" == "FIXED" ]	
  then 
  	echo -en "$1 PS_PACKETLENGTH [$2] FIXED $4 1500\r\n" >&3 
  else
  	echo -en "$1 PS_PACKETLENGTH [$2] $3 64 1516\r\n" >&3
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
	if [ "$#" -ne "5" ]
	then
		echo "Stream_vlan <port> <stream ID> <VLAN ID> <VLAN Priority> <FFFFFFFFFFFF/MAC ADDRESS> "
	fi
	echo -en "$1 PS_HEADERPROTOCOL [$2] ETHERNET VLAN IP\r\n" >&3 
	read  <&3
	if [ "$REPLY" != "<OK>" ]
	then
		echo "Error: PS_HEADERPROTOCOL:$REPLY"
	fi		
	#VLAN 5 Priority 7
	if [ "$3" == "5" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x$52F4BC3B27E108100E00508004500002A000000007FFF3AD60000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 05 PRIORITY 7"
	fi
	if [ "$3" == "6" ]	
	then
		echo -en "$1 PS_PACKETHEADER [$2] 0x$52F4BC3B27E108100000608004500002A000000007FFF3AD60000000000000000\r\n" >&3 
		read  <&3
		if [ "$REPLY" != "<OK>" ]
		then
			echo "Error: PS_PACKETHEADER:$REPLY"
		fi	
		echo "Port:$1 Stream:$2 PACKET VLAN 06 PRIORITY 0"
	fi	
}

# Only one port produce traffic with bandwidth from 100Mbps to 1Gbps. with each bandwidth, the payload length varies from 64 byte to 1024 byte
function p2p ()
{
  stream_config 4/4 04 FIXED 64 100000000

	for (( bandwidth = 1000000000; bandwidth <= 10000000000; bandwidth =`expr $bandwidth + 1000000000` ))
	do
		for (( payload = 64; payload <= 1516 ; payload=`expr $payload \* 2` ))
		do		
			PR_counter_clear 4/1
			PT_counter_clear 4/4
						
			stream_update 4/4 04 FIXED $payload $bandwidth
		    
  			traffic_start 4/4
  			capture_start 4/4 

			# s/m/h/d, defalut second
			sleep 10
			traffic_stop 4/4
			capture_stop 4/4
		        PT_info 4/4
			PR_info 4/1
		done
	done
}
# One Port produces noise from 100Mbps to 1Gbps with random payload length. Other port produce tested packets with 100 Mbps and varied payload length from 64 to 1024 byte
function p2p_noise ()
{
	stream_config 4/4 04 FIXED 64 100000000
	stream_config 4/5 05 FIXED 64 100000000
	for (( bandwidth = 100000000; bandwidth <= 1000000000; bandwidth =`expr $bandwidth + 100000000` ))
	do
		stream_update 4/4 04 RANDOM 64 $bandwidth
		for (( payload = 64; payload <= 1516 ; payload=`expr $payload \* 2` ))
		do
	
			PR_counter_clear 4/1
			PT_counter_clear 4/4
			PT_counter_clear 4/5
			
			stream_update 4/5 05 FIXED $payload 100000000
    
			traffic_start 4/4
  			capture_start 4/4 
  			traffic_start 4/5
  			capture_start 4/5
			# s/m/h/d, defalut second
			sleep 10
	
			traffic_stop 4/4
			capture_stop 4/4 
			traffic_stop 4/5
  			capture_stop 4/5
			PT_info 4/4
			PT_info 4/5
			PR_info 4/1
		done
	done
}
#VLAN
#Port 4 produces packets with VLAN 5 Priority 7 with bandwidth from 100Mbps to 500Mbps
#Port 5 produces packets with VLAN 6 Priority 0 with bandwidth from 100Mbps to 500Mbps
function VLAN_test ()
{
	stream_config 4/4 04 FIXED 110 300000000
	stream_config 4/5 05 FIXED 64 300000000
	
	stream_vlan 4/4 04 5 7
	stream_vlan 4/5 05 6 0

	for (( bandwidth = 100000000; bandwidth <= 500000000; bandwidth =`expr $bandwidth + 100000000` ))
	do
		for (( payload = 64; payload <= 1516 ; payload=`expr $payload \* 2` ))
		do
	
			PR_counter_clear 4/1
			PT_counter_clear 4/4
			PT_counter_clear 4/5			
						
			sleep 5
			stream_update 4/4 04 FIXED $payload $bandwidth
			stream_update 4/5 05 FIXED $payload $bandwidth
			sleep 5
    
			traffic_start 4/4
 			capture_start 4/4 
 			traffic_start 4/5
 			capture_start 4/5
			# s/m/h/d, defalut second
			sleep 15
	
			traffic_stop 4/4
			capture_stop 4/4 
			traffic_stop 4/5
 			capture_stop 4/5
			PT_info 4/4
			PT_info 4/5
			PR_info 4/1
  		sleep 5
		done
	sleep 5
	done
}
#When the output could not properly display, try to send one simple traffic to get result
function Timing_MSG_test ()
{
	stream_config 4/4 04 FIXED 110 300000000
	stream_config 4/5 05 FIXED 64 300000000
	
	stream_vlan 4/4 04 5 7
	stream_vlan 4/5 05 6 0

	for (( bandwidth_4 = 100000000; bandwidth_4 <= 1100000000; bandwidth_4 =`expr $bandwidth_4 + 200000000` ))
	do
		for (( bandwidth_5 = 100000000; bandwidth_5 <= 1100000000; bandwidth_5 =`expr $bandwidth_5 + 200000000` ))
		do
			PR_counter_clear 4/1
			PT_counter_clear 4/4
			PT_counter_clear 4/5			
						
			sleep 5
			stream_update 4/4 04 FIXED 110 $bandwidth_4
			stream_update 4/5 05 RANDOM 64 $bandwidth_5
			sleep 5
    
			traffic_start 4/4
 			capture_start 4/4 
 			traffic_start 4/5
 			capture_start 4/5
			# s/m/h/d, defalut second
			sleep 1h
	
			traffic_stop 4/4
			capture_stop 4/4 
			traffic_stop 4/5
 			capture_stop 4/5
			sleep 2
			# PR_TPLDTRAFFIC 0 0 . last 1 second there is no traffic
			#PR_TPLDERROR & & & -
			PT_info 4/4
			PT_info 4/5
			PR_info 4/1
 		sleep 5
		done
	sleep 5
	done

}

function B2B_MSG_test_idea ()
{
	# Port 4 produce packets with Payload 110 bytes  VLAN5 Priority 7 Broadcast (DM 7.B) 
	stream_config 4/4 04 FIXED 110 100000000 FFFFFFFFFFFF
	# Port 4 produce packets with Payload 110 bytes VLAN5 Priority 7 Unicast (DM 7.A) E.g. SIS18 to SIS100 6 packets per second, 5300bps
	#stream_config 4/4 04 FIXED 110 5300
	# Port 5 produce packets with  Payload 110 bytes VLAN5 Priority 7 Unicast (B2B 6.B) E.g. SIS18 to SIS100 28 packets per second,  24600bps
	stream_config 4/5 05 FIXED 110 24600 FFFFFFFFFFF
	
	stream_vlan 4/4 04 5 7
	stream_vlan 4/5 05 6 0

	#for (( bandwidth_4 = 100000000; bandwidth_4 <= 1100000000; bandwidth_4 =`expr $bandwidth_4 + 200000000` ))
	#do
		PR_counter_clear 4/1
		PT_counter_clear 4/4
		PT_counter_clear 4/5			
						
		sleep 2
		stream_update 4/4 04 FIXED 110 100000000 FFFFFFFFFFFF
		stream_update 4/5 05 FIXED 110 24600 FFFFFFFFFFFF
		sleep 5
    
		traffic_start 4/4
 		capture_start 4/4 
 		traffic_start 4/5
 		capture_start 4/5
		# s/m/h/d, defalut second
		sleep 20
	
		traffic_stop 4/4
		capture_stop 4/4 
		traffic_stop 4/5
 		capture_stop 4/5
		sleep 5
		# PR_TPLDTRAFFIC 0 0 . last 1 second there is no traffic
		# PR_TPLDERROR & & & -
		PT_info 4/4
		PT_info 4/5
		PR_info 4/1
 				
	sleep 5
	#done
}

function B2B_MSG_test_idea_2layter ()
{
	# Port 4 produce packets with Payload 110 bytes  VLAN5 Priority 7 Broadcast (DM 7.B) 
	stream_config 4/4 04 FIXED 110 100000000 
	# Port 4 produce packets with Payload 110 bytes VLAN5 Priority 7 Unicast (DM 7.A) E.g. SIS18 to SIS100 6 packets per second, 5300bps
	#stream_config 4/4 04 FIXED 110 5300
	# Port 5 produce packets with  Payload 110 bytes VLAN5 Priority 7 Unicast (B2B 6.B) E.g. SIS18 to SIS100 28 packets per second,  24600bps
	stream_config 4/5 05 FIXED 110 24600 
	stream_config 4/5 06 FIXED 110 5280 
	
	stream_vlan 4/4 04 5 7 FFFFFFFFFFFF
	stream_vlan 4/5 05 6 0 FFFFFFFFFFFF
	stream_vlan 4/5 06 5 7 04F4BC3B27E4


	for (( bandwidth_4 = 100000000; bandwidth_4 <= 1100000000; bandwidth_4 =`expr $bandwidth_4 + 200000000` ))
	do
		PR_counter_clear 4/1
		PT_counter_clear 4/4
		PT_counter_clear 4/5			
						
		sleep 2
		stream_update 4/4 04 FIXED 110 $bandwidth_4
		stream_update 4/5 05 FIXED 110 24600
		stream_update 4/5 06 FIXED 110 5280 
		sleep 5
    
		traffic_start 4/4
 		capture_start 4/4 
 		traffic_start 4/5
 		capture_start 4/5
		# s/m/h/d, defalut second
		sleep 2m
	
		traffic_stop 4/4
		capture_stop 4/4 
		traffic_stop 4/5
 		capture_stop 4/5
		sleep 10
		# PR_TPLDTRAFFIC 0 0 . last 1 second there is no traffic
		# PR_TPLDERROR & & & -
		PT_info 4/4
		PT_info 4/5
		PR_info 4/1
		PR_info 4/4
 				
	sleep 5
	done
}
