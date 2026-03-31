#! /usr/bin/env sh

BACKUP_BUCKET="backup-hades-storage"
SRC="/data/chroot_sshfs/nas"
DEST="b2:${BACKUP_BUCKET}/current"
RCLONE_CONFIG_B2_TYPE="b2"
RCLONE_CONFIG_B2_ACCOUNT="$(systemd-creds cat b2_application_key_id)"
RCLONE_CONFIG_B2_KEY="$(systemd-creds cat b2_application_key)"
RCLONE_CONFIG_CRYPT_TYPE="crypt"
RCLONE_CONFIG_CRYPT_REMOTE="$DEST"
RCLONE_CONFIG_CRYPT_PASSWORD="$(systemd-creds cat b2_encryption_password_obscured)"

# check if $SRC exists
if ! [ -d "$SRC" ]; then
    printf "%s\n" \
           "\$SRC does not exist" \
           "exiting..."
    exit 1
fi

# check if $SRC is empty
if [ -z "$(ls -A "$SRC")" ]; then
    printf "%s\n" \
           "\$SRC is empty" \
           "exiting..."
    exit 1
fi

# check if $SRC is a mountpoint
if ! mountpoint "$SRC" > /dev/null; then
    printf "%s\n" \
           "\$SRC is not a mountpoint" \
           "exiting..."
    exit 1
fi

if [ -z "$RCLONE_CONFIG_B2_ACCOUNT" ]; then
    printf "%s\n" \
           "\$RCLONE_B2_ACCOUNT is empty" \
           "exiting..."
    exit 1
fi
if [ -z "$RCLONE_CONFIG_B2_KEY" ]; then
    printf "%s\n" \
           "\$RCLONE_B2_KEY is empty" \
           "exiting..."
fi
