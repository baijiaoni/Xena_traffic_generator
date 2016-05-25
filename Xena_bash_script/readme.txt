Bash script for the traffic generator

Steps:
	1. 	Install "Cygwin" linux Gun on Windows
	2. 	Start Cygwin bash shell
	3. 	Run ./xena_main.sh > log
	4. 	Select the conntend you need
	./Result_selection.sh log selected_log
	
Tips:
	1. 	Ports of the traffic generator could not be reserved by other softwares.
	2. 	Xena manager is used to stop the bit stream.
		2.1 Xena manager reserves the ports, and stop the traffic.
		2.2 Xena manager must relinquish the port before the bash script starts.