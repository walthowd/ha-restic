export RESTIC_REPOSITORY="rclone:restic:backup"
export RESTIC_PASSWORD_FILE="/etc/restic/targets/passwords/gdrive_pw.txt"
export JOBS_DIR="/etc/restic/jobs"
export EXCLUDE_FILE="$JOBS_DIR/excludes/$JOB.excludes"
export RETENTION="--keep-daily 30 --keep-weekly 12 --keep-monthly 18 --keep-yearly 5"
if [ -f $EXCLUDE_FILE ]; then
	export EXCLUDES="--exclude-file $EXCLUDE_FILE"
else 
	export EXCLUDES=""
fi
