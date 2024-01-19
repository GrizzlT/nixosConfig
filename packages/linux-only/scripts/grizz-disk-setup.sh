#!/usr/bin/env bash

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# Check for env GRIZZ_DISK
if [[ -z "${GRIZZ_DISK}" ]]; then
  echo "No Nvme GRIZZ_DISK env set - exiting program"
  exit 0
else
  disk="${GRIZZ_DISK}"
fi

# Create the partitions
echo "Creating parittions..."
parted "${disk}" -- mklabel gpt
parted "${disk}" -- mkpart ESP fat32 0% 1024MiB
parted "${disk}" -- set 1 esp on
parted "${disk}" -- mkpart 'luksKey' 1024MiB 1056MiB
parted "${disk}" -- mkpart swap linux-swap 1056MiB 1072MiB
parted "${disk}" -- mkpart primary 1072Mib 100%

# Format the partitions
echo "Formatting parittions..."
mkfs.fat -F 32 -n BOOT "${disk}p1"
mkswap -L swap "${disk}p3"
swapon "${disk}p3"

# create luks keyfile
# Use a *day-to-day* password that's strong!
echo "Creating LUKS devices..."
echo "Enter a strong day to day password!!"
cryptsetup luksFormat --type luks2 --label CRYPTKEY "${disk}p2"
cryptsetup open --type luks2 "${disk}p2" cryptkey
# Fill the (decrypted) cryptkey partition full of random data
# This invocation will fail with a "device out of space" error which is expected
dd if=/dev/urandom of=/dev/mapper/cryptkey bs=1024 status=progress || true

# create and mount the data partition
# Use a strong backup unlock phrase (e.g. dice ware) and write this down someplace safe!
echo "Enter a very high entropy backup passphrase, store this safely!!!!"
cryptsetup luksFormat --type luks2 --label CRYPTROOT "${disk}p4"
echo "Enter backup passphrase once more:"
cryptsetup luksAddKey --new-keyfile-size 8192 "${disk}p4" /dev/mapper/cryptkey
cryptsetup open --type luks2 --keyfile-size 8192 --key-file /dev/mapper/cryptkey --allow-discards "${disk}p4" cryptroot

echo "Setting up ZFS pool and datasets..."
# Note: when creating the pool, lower case `-o` is used to configure properties at
# the _pool_ level, while upper case `-O` is used to configure properties at the
# _dataset_ level
#
# Note: ashift MUST BE SET or there will be horrible horrible write performance
# using the default value ZFS selects. If you aren't sure what to pick and
# have a modern drive, just take my word for it and set it to 13. -> 12 = 4KB
# https://web.archive.org/web/20230219020744/https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
zpool create -o ashift=12 \
  -o autotrim=on \
  -O acltype=posixacl \
  -O atime=off \
  -O canmount=off \
  -O compression=lz4 \
  -O xattr=sa \
  -m legacy storage /dev/mapper/cryptroot
# Reserve (i.e. overprovision) ~10% of the disk (assuming 1TB disk)
zfs create \
    -o reservation=100G \
    -o quota=100G \
    -o canmount=off \
    storage/reserved

zfs create -p storage/local/root
zfs create -p storage/local/nix
zfs snapshot storage/local/root@blank
zfs create -p storage/safe/lib
zfs create storage/safe/journal
zfs create storage/safe/home
zfs create storage/safe/persist

mount -t zfs storage/local/root /mnt
mkdir -p /mnt/{boot,home,nix,persist,var/{lib,log/journal}}
mount "${disk}p1" /mnt/boot
mount -t zfs storage/local/nix /mnt/nix
mount -t zfs storage/safe/home /mnt/home
mount -t zfs storage/safe/persist /mnt/persist
mount -t zfs storage/safe/lib /mnt/var/lib
mount -t zfs storage/safe/journal /mnt/var/log/journal

