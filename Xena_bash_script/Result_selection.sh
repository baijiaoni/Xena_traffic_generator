# Selection the desired content from the script result log file to other file
# .\Result_selection.sh original_log.file selected_log.file
if [ "$#" -ne "2" ]
then
	echo "Result_selection <source_file_name> <target_file_name>"
fi
awk '$2=="PS_PACKETLENGTH" || $2=="PS_RATEL2BPS" || $2=="PR_TPLDLATENCY" || $2=="PR_TPLDJITTER" || $2=="PT_STREAM" || $2=="PR_TPLDTRAFFIC" || $3=="PR_TPLDTRAFFIC" || $3=="PR_TPLDLATENCY" || $3=="PR_TPLDJITTER" ' "$1" > "$2"


