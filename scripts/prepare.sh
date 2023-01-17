BLOCK_DEVICE="/dev/nvme0n1"

# Prepare the drive by writing random data to it
# See https://wiki.archlinux.org/title/Dm-crypt/Drive_preparation
# TODO: Figure out how to spot check the device for being properly prepared and wiped
dd if=/dev/zero of="$BLOCK_DEVICE" status=progress bs=1M
cryptsetup open --type plain --key-file /dev/urandom "$BLOCK_DEVICE" to_be_wiped
dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress bs=1M
cryptsetup close to_be_wiped

# Partition (GPT/UEFI). We create the primary partition first so it becomes
# partition #1, causing the device name to be something like /dev/sda1
parted "$BLOCK_DEVICE" -- mklabel gpt
parted "$BLOCK_DEVICE" -- mkpart primary 512MiB 100%
parted "$BLOCK_DEVICE" -- mkpart esp fat32 1MiB 512MiB
parted "$BLOCK_DEVICE" -- set 2 esp on

# Format the partitions
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/esp
cryptsetup luksFormat --label root /dev/disk/by-partlabel/primary
cryptsetup open /dev/disk/by-partlabel/primary root

# Format the dm-crypt container and create the btrfs subvolumes
mkfs.btrfs -L nixos /dev/mapper/root
mount /dev/mapper/root /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
mkdir /mnt/snapshots
umount /mnt

# Mount the root filesystem
mount -o subvol=root,noatime /dev/disk/by-label/nixos /mnt
mkidr /mnt/home /mnt/nix
mount -o subvol=home,noatime /dev/disk/by-label/nixos /mnt/home
mount -o subvol=nix,noatime /dev/disk/by-label/nixos /mnt/nix
mkidr /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
