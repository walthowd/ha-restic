#!/usr/bin/env bash
/etc/restic/jobs/example.sh gdrive
/etc/restic/util/send-snapshot-info.sh gdrive 
/etc/restic/util/send-stats-info.sh gdrive 
