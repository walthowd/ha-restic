#!/usr/bin/env bash
JOB=`basename "$0"`

# Load target
source /etc/restic/targets/includes/pre.sh

# Return snapshots
restic snapshots --last --json | jq '.[].tags | add' | sort | uniq | sed -e 's/\"//g'

#source /etc/restic/targets/includes/post.sh
