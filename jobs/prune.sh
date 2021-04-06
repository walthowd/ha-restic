#!/usr/bin/env bash
JOB=`basename "$0"`

# Load target 
source /etc/restic/targets/includes/pre.sh

# Prune
restic forget $RETENTION --prune

source /etc/restic/targets/includes/post.sh
