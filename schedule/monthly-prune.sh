#!/usr/bin/env bash
/etc/restic/jobs/prune.sh local
/etc/restic/jobs/prune.sh gdrive

# Update HA 
/etc/restic/util/send-snapshot-info.sh local
/etc/restic/util/send-stats-info.sh local
/etc/restic/util/send-snapshot-info.sh gdrive
/etc/restic/util/send-stats-info.sh gdrive
