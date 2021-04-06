# Common 
source /etc/restic/targets/includes/common.sh

# Choose target
if [ -f "/etc/restic/targets/$1_env.sh" ]; then
	source "/etc/restic/targets/$1_env.sh"
	export TARGET=$1
else 
	echo "$1 backup target not found"
	exit 1
fi

# Notify Home Assistant
$MOSQUITTO_PUB -t /restic/backup -m $JOB,$TARGET,starting
