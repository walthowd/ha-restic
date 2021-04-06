# ha-restic
Restic backup scripts with Home Assistant MQTT integration. It will auto create sensor entities that track the state of your backups, show the backup size, last status, etc. 

This is a set of scripts that allow you to define backups, targets and schedules in a Linux style. It also includes integration into Home Assistant via MQTT discovery. It allows you to define single backup jobs that can go automatically to multiple targets (for example onsite and offsite)

### Requirements
* Home Assistant
* MQTT Server 
* Mosquitto clients - /usr/bin/mosquitto_pub
* jq

## Installing

Clone this repository into `/etc/restic`. 

`sudo git clone https://github.com/walthowd/ha-restic.git /etc/restic`

Install JQ and mosquitto_pub if not already installed.

`sudo apt-get update && sudo apt-get install jq mosquitto-clients`

Edit your MQTT credentials in `/etc/restic/targets/passwords/mqtt.sh`

Add a Home Assistant MQTT sensor (sensors.yaml)

```
- platform: mqtt
  name: 'restic backup'
  state_topic: '/restic/backup'
  value_template: "{{ value }}"
```

### Setup your restic repositories into targets

Now add any of your restic repositories into `/etc/restic/targets`. This includes an example local and gdrive reposistory. At the very least you need to edit the `RESTIC_REPOSITORY` path and the `RESTIC_PASSWORD_FILE` with the password to your repository. 

Source this file to test and restic init the repository (if you haven't done so already)

```
source /etc/restic/targets/your-target.sh
restic init
```

### Setup your restic backup jobs

Now set up your restic backup jobs. This system assumes that each backup job will have a matching tag name. For example, `home-dir.sh` backup job will have by default a `home-dir` restic tag. 

Create a `/etc/restic/jobs/JOBNAME.sh` for each backup job. You can copy `example.sh` to get started. Edit the `restic $EXCLUDES --tag $TAG backup /specify/directory/here` and change the `/specify/directory/here` to what you want to back up. You can specify multiple directories here for a single job if needed. For example `/etc/restic /opt/homeassistant` etc. 

For example in my setup I have:

```
/etc/restic/jobs$ ls -1 /etc/restic/jobs/
docker-stack-opt.sh
letsencrypt-cron-restic.sh
prune.sh
```

Optionally add any files you want excluded from backups to `/etc/restic/job/excludes/JOBNAME.excludes` where JOBNAME matches the `/etc/restic/job/JOBNAME.sh` job. 

### Setup your schedule

Finally, set up your schedule for backups. Edit `/etc/restic/schedule` files. Two examples are included. Each schedule file should contain:

```
/etc/restic/jobs/JOBNAME.sh TARGET
```

Where JOBNAME.sh matches your defined jobs and TARGET matches your defined targets.  You can now have these schedule scripts run via a systemd timer or a cronjob.

### Home Assistant backup monitoring

You can install the flex-table addon from HACS to display a lovelace overview of your backups. Create a card with the following

```
columns:
  - attr: time
    name: Time
  - attr: tags
    name: Tags
  - attr: paths
    name: Paths
  - attr: friendly_name
    name: Name
  - attr: total_restore_size
    name: Total restore size
  - attr: total_raw_data
    name: Total raw data
entities:
  exclude:
    - sensor.restic_stat*
    - sensor.restic_backup
  include: sensor.restic*
title: restic backups
type: 'custom:flex-table-card'
```
