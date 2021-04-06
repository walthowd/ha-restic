#!/usr/bin/env bash
JOB=`basename "$0"`
TAG=`echo $JOB | sed -e "s/.sh//"`;

# Load target 
source /etc/restic/targets/includes/pre.sh

# Example job 
restic $EXCLUDES --tag $TAG backup /specify/directory/here

source /etc/restic/targets/includes/post.sh
