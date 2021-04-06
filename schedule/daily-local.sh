#!/usr/bin/env bash
/etc/restic/jobs/example.sh local
/etc/restic/util/send-snapshot-info.sh local
/etc/restic/util/send-stats-info.sh local
