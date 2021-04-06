RESTIC_RETURN=$?

# Common 
source /etc/restic/targets/includes/common.sh

# Create sensor
JOB_TOPIC="homeassistant/sensor/restic-$TAG-$TARGET"
$MOSQUITTO_PUB -r -t "$JOB_TOPIC/config" -m "{ \"name\": \"restic $TAG $TARGET backup status\", \"state_topic\": \"$JOB_TOPIC/state\", \"value_template\": \"{{ value }}\", \"json_attributes_topic\": \"$JOB_TOPIC/attributes\"}"

# Notify Home Assistant
$MOSQUITTO_PUB -t /restic/backup -m $JOB,$TARGET,finished,$RESTIC_RETURN
if [ $RESTIC_RETURN -ne 0 ]; then
	$MOSQUITTO_PUB -t "$JOB_TOPIC/state" -m "Failure"
else 
	$MOSQUITTO_PUB -t "$JOB_TOPIC/state" -m "Success"
fi
