# Arch Install Instructions

## From Live boot

- Set console keyboard layout to UK

`loadkeys uk`

- Check internet connection

`ping -c 5 archlinux.org`

- Make sure clock is correctly synchronised

`timedatectl`

- If not, run either of these commands

```bash
timedatectl set-ntp true

# Or this
systemctl enable systemd-timesyncd.service
```

- Identify the block device to partition

```bash
lsblk

# Or
fdisk -l
```

- Partition the block device using

```bash

fdisk /dev/your_device

# Or
cfdisk /dev/your_device
```

- Format the root partition for the BTRFS file system

`mkfs.btrfs /dev/root_partition`

- Mount the root volume

`mount /dev/root_partition /mnt`

- Create subvolumes for `/`, `/home` and `/.snapshots`

```bash
btrfs subvolume create /mnt/@       # Root subvolume
btrfs subvolume create /mnt/@home   # Home subvolume
btrfs subvolume create /mnt/@snapshots  # Snapshots subvolume
```

- Unmount the Temporary Mount

`umount /mnt`

- Mount each subvolume individually

```bash
# Mount root
mount -o compress=zstd,subvol=@ /dev/root_partition /mnt

# Mount home
mkdir -p /mnt/home
mount -o compress=zstd,subvol=@home /dev/root_partition /mnt/home

# Mount snapshots
mkdir -p /mnt/.snapshots
mount -o compress=zstd,subvol=@snapshots /dev/root_partition /mnt/.snapshots

# Mount EFI system partition
mkdir -p /mnt/efi
mount /dev/efi_partition /mnt/efi
```

- Check `/etc/pacman.d/mirrorlist` to ensure that geographically closer mirrors are closer to the top of the list. If not, edit it.

- Bootstrap the arch system

```bash
pacstrap -K /mnt base linux-zen linux-firmware git vim btrfs-progs grub efibootmgr grub-btrfs inotify-tools timeshift amd-ucode sudo networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
```

- Generate an fstab file

`genfstab -U /mnt >> /mnt/etc/fstab`

- Change root into the new system

`arch-chroot /mnt`

- Find timezone in `/usr/share/zoneinfo`

- Set timezone

```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
```

- Uncomment "en_GB.UTF-8" in `/etc/locale.gen`

- Generate locale

`locale-gen`

- Create locale config in `/etc/locale.conf` and add

`LANG=en_GB.UTF-8`

- Make keyboard layout change permanent by adding to `/etc/vconsole.conf`

`KEYMAP=uk`

- Add hostname to `/etc/hostname`

`your_hostname`

- Add hostname pairs to `/etc/hosts`

```bash
127.0.0.1 localhost
::1 localhost
127.0.1.1 Arch
```

- Create root password

`passwd`

- Add new user

```bash
useradd -mG wheel azazel
passwd azazel
```

- Grant superuser privileges to new user by uncommenting the line below "Uncomment to let members of group wheel execute any action" in /etc/sudoers

`EDITOR=vim visudo`

- Deploy grub

`grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB`

- Generate grub config

`grub-mkconfig -o /boot/grub/grub.cfg`

- Enable network manager

`systemctl enable NetworkManager`

- Exit, unmount and reboot

```bash
exit
umount -R /mnt
reboot
```

- Enable time synchronisation on startup

`timedatectl set-ntp true`

- Edit the `grub-btrfsd` service to automatically update the grub boot entries with snapshots taken with `timeshift`. Add `ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto`

`sudo systemctl edit --full grub-btrfsd`

- Enable grub-btrfsd service to run on boot

`sudo systemctl enable grub-btrfsd`
