#!/usr/bin/env bash
JOB=$(basename "$0")

# Load target
source /etc/restic/targets/includes/pre.sh

# Topics
RESTORE_SIZE_TOPIC="homeassistant/sensor/restic-stats-$TARGET-restore-size"
RAW_DATA_TOPIC="homeassistant/sensor/restic-stats-$TARGET-raw-data"

# Create restore size sensor
$MOSQUITTO_PUB -r -t "$RESTORE_SIZE_TOPIC/config" -m "{ \"name\": \"restic stats $TARGET restore size\", \"state_topic\": \"$RESTORE_SIZE_TOPIC/state\", \"value_template\": \"{{ value | filesizeformat() }}\", \"unit_of_measurement\": \"B\", \"json_attributes_topic\": \"$RESTORE_SIZE_TOPIC/attributes\"}"
# Create raw data sensor
$MOSQUITTO_PUB -r -t "$RAW_DATA_TOPIC/config" -m "{ \"name\": \"restic stats $TARGET raw data\", \"state_topic\": \"$RAW_DATA_TOPIC/state\", \"value_template\": \"{{ value | filesizeformat() }}\", \"unit_of_measurement\": \"B\", \"json_attributes_topic\": \"$RAW_DATA_TOPIC/attributes\"}"

# Send attributes
RESTORE_SIZE=$(restic stats --json)
RAW_DATA=$(restic stats --json --mode raw-data)
TOTAL_RESTORE_SIZE=$(echo $RESTORE_SIZE | jq ".total_size")
TOTAL_RAW_DATA=$(echo $RAW_DATA | jq ".total_size")

$MOSQUITTO_PUB -r -t "$RESTORE_SIZE_TOPIC/attributes" -m $RESTORE_SIZE
$MOSQUITTO_PUB -r -t "$RAW_DATA_TOPIC/attributes" -m $RAW_DATA
$MOSQUITTO_PUB -r -t "$RESTORE_SIZE_TOPIC/state" -m $TOTAL_RESTORE_SIZE
$MOSQUITTO_PUB -r -t "$RAW_DATA_TOPIC/state" -m $TOTAL_RAW_DATA

#source /etc/restic/targets/includes/post.sh
