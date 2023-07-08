# Assumptions
The following assumptions are made for this setup

- You have a UEFI system
- You have a NVME SSD (at /dev/nvme0n1)
- You want an encrypted (dm-crypt) btrfs partiton as your primary device
- You want to configure you swap as a file on your btrfs patition rather than as a separate partition

# Preparing the drive

First we zero out the drive.

    dd if=/dev/zero of=/dev/nvme0n1 status=progress bs=1M

Check that the end of the drive is zeroed.

    tail -c -1K /dev/nvme0n1 | od

Mount a plain encrypted LUKS container to the device and zero it out. This
writes random data to the drive.

    cryptsetup open --type plain --key-file /dev/urandom /dev/nvme0n1 to_be_wiped
    dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress bs=1M
    cryptsetup close to_be_wiped

Check that the zeroes were overwritten with random data.

    tail -c -1K /dev/nvme0n1 | od

# Partition the drives
We will partition the drive using parted.

    parted /dev/nvme0n1

Create a GPT parition table.

    > mklabel gpt

Create your primary patition as the first partition /dev/nvme0n1p1.

    > mkpart primary 512MiB 100%

Create an EFI system partition (ESP) as the second partition /dev/nvme0n1p2.

    > mkpart esp 1MiB 512MiB

Set the ESP flag on this partition and exit.

    > set 2 esp on
    > quit

# Format the drives and mount your encrypted partition
Format the boot partition.

    mkfs.fat -F 32 -n boot /dev/nvme0n1p2

Format your LUKS parition with the default options. You'll be asked to provide
a password. Use a strong random password and store it in your password manager.
If you forget this you'll lose access to all your data.

    cryptsetup luksFormat --label root /dev/nvme0n1p1

Now mount the container. You'll be asked to enter the password you just set.

    cryptsetup open /dev/nvme0n1p1 root

# Formatting the encrypted partition
Format the encrypted partition and mount it.

    mkfs.btrfs /dev/mapper/root
    mount /dev/mapper/root /mnt

Create your subvolumes layout and unmount the disk. We're creating three
subvolumes here: the root subvolume, one for /home and then a final one for
your Nix store at /nix.

    btrfs subvolume create /mnt/root
    btrfs subvolume create /mnt/home
    btrfs subvolume create /mnt/nix
    mkdir /mnt/snapshots
    umount /mnt

TODO: Swap file in btrfs

Mount your subvolumes. We will also mount the boot partition at /boot.

    mount -o subvol=root,noatime /dev/mapper/root /mnt
    mkdir /mnt/{home,nix,boot}
    mount -o subvol=home,noatime /dev/mapper/root /mnt/home
    mount -o subvol=nix,noatime /dev/mapper/root /mnt/nix
    mount /dev/nvme0n1p2 /mnt/boot

# Configure and Install NixOS
Generate your Nix config at /mnt/etc/nixos/configuration.nix

    nixos-generate-config --root /mnt

Edit your configuration, and then install NixOS. You can just use a minimal
NixOS configuration, we'll convert it to a Flake setup later.

TODO: Prepare a minimal configuration for Desktop (x11, user with initial
password) and Server (openssh, initail password + keys). We can then wget that
and install.

    nixos-install

Reboot your system and test.

    reboot
