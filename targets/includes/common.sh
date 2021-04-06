source /etc/restic/targets/passwords/mqtt.sh
MOSQUITTO_PUB="/usr/bin/mosquitto_pub -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASSWORD"
