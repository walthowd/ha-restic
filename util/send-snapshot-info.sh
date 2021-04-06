#!/usr/bin/env bash
JOB=`basename "$0"`

# Load target
source /etc/restic/targets/includes/pre.sh

# Snapshots
for TAG in `/etc/restic/util/list-tags.sh $TARGET`; do

	# Get latest snapshot ID
	SNAPSHOT_ID=$(restic snapshots --last --tag $TAG --json | jq '.[].short_id' | sed -e 's/\"//g')

	RESTORE_SIZE=$(restic stats $SNAPSHOT_ID --json | jq '.["total_restore_size"] = .total_size | .["total_retore_file_count"] = .total_file_count | del(.total_size, .total_file_count)')
	RAW_DATA=$(restic stats $SNAPSHOT_ID --json --mode raw-data | jq '.["total_raw_data"] = .total_size | del(.total_size, .total_file_count)')

	# Create sensor
	$MOSQUITTO_PUB -r -t "homeassistant/sensor/restic-$TAG-$TARGET/config" -m "{ \"name\": \"restic $TAG $TARGET backup status\", \"state_topic\": \"homeassistant/sensor/restic-$TAG-$TARGET/state\", \"value_template\": \"{{ value }}\", \"json_attributes_topic\": \"homeassistant/sensor/restic-$TAG-$TARGET/attributes\"}"

	# Send attributes
	SNAPSHOT_INFO=$(restic snapshots --last --tag $TAG --json | jq -c 'add')

	# Merge
	SNAPSHOT_MERGE=$(echo $SNAPSHOT_INFO $RESTORE_SIZE $RAW_DATA | jq -c -s 'add')

	$MOSQUITTO_PUB -r -t "homeassistant/sensor/restic-$TAG-$TARGET/attributes" -m "$SNAPSHOT_MERGE"
done

#source /etc/restic/targets/includes/post.sh
