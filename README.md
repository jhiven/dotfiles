## Install Arch Linux

### Connect Wifi

```
iwctl

# device list
# device wlan0 set-property Powered on  //if the device is turned off
# station wlan0 scan
# station wlan0 get-networks
# station wlan0 connect SSID

ping 1.1.1.1 //test if wifi is connected
```

Make sure you already download the latest archlinux-keyring.

```
pacman -Syy archlinux-keyring
```

### BTRFS Partitioning

#### Partition the disk

```
cfdisk
```

for me it looks like this \
`Note: it already use BTRFS partitioning`

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
zram0       254:0    0   7,7G  0 disk [SWAP]
nvme0n1     259:0    0 476,9G  0 disk
├─nvme0n1p1 259:1    0    16M  0 part                   #windows partition
├─nvme0n1p2 259:2    0 251,2G  0 part                   #windows partition
├─nvme0n1p3 259:3    0   477M  0 part                   #windows partition
├─nvme0n1p4 259:4    0 124,1G  0 part                   #windows partition
├─nvme0n1p5 259:5    0   512M  0 part /boot/efi
├─nvme0n1p6 259:6    0     1G  0 part                   #windows partition
└─nvme0n1p7 259:7    0  99,5G  0 part /var
                                      /home
                                      /.snapshots
                                      /
```

#### Format the partitions

```
mkfs.fat -F 32 /dev/nvme0n1p6
mkfs.btrfs /dev/nvme0n1p7
```

#### Mount the root BTRFS volume and create subvolume

```
mount /dev/nvme0n1p7 /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
```

#### Unmount root BTRFS volume and mount subvolume

```
umount /mnt
mount -o noatime,compress=zstd,space_cache=v2,subvol=@root /dev/nvme0n1p7 /mnt
mkdir /mnt/{boot,var,home,.snapshots}
mount -o noatime,compress=zstd,space_cache=v2,subvol=@var /dev/nvme0n1p7 /mnt/var
mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/nvme0n1p7 /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/nvme0n1p7 /mnt/.snapshots
mount /dev/nvme0n1p6 /mnt/boot/efi
```

### Install base system

```
pacstrap -K /mnt base base-devel linux-lts linux-firmware network-manager nano
```

### Configure the system

#### Fstab

```
genfstab -U /mnt >> /mnt/etc/fstab
```

#### Chroot

```
arch-chroot /mnt
```

#### Timezone

```
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
hwclock --systohc
```

#### Localization

Comment out `en_US.UTF-8` in `/etc/locale.gen`

```
nano /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

### Network Configuration

#### Create the hostname

```
echo "archSwift" >> /etc/hostname
```

#### Edit hosts

Fill `/etc/hosts` with this

```
127.0.0.1        localhost
::1              localhost
127.0.1.1        archSwift.localdomain archSwift
```

### User configuration

#### Set root password

```
passwd
```

#### Add new user

```
useradd -m -G wheel,audio,network,video,storage,input,users jhivens
passwd jhivens
```

#### Configure sudo user

open the sudoers file and comment out `wheel` to be like this `%wheel ALL=(ALL:ALL) ALL`.

```
EDITOR=nano visudo
```

### Installing Important Package

```
pacman -S grub efibootemgr os-prober ntfs-3g git network-manager-applet wireless_tools wpa_supplicant git openssh
```

#### Install AUR helper

```
mkdir gitfiles && cd gitfiles
git clone https://aur.archlinux.org/yay-bin.git
cd yay
makepkg -si
```

### Configure BootLoader (GRUB)

#### Mount windows bootloader

```
mkdir /mnt2
mount /dev/nvme0n1p3 /mnt2
```

#### Install GRUB

```
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

#### mkinitcpio configuration

add `BINARIES=(btrfs)` in `/etc/mkinitcpio.conf`

```
nano /etc/mkinitcpio.conf
mkinitcpio -p linux-lts
```

### Snapper Configuration

#### Install snapper package

```
yay -S snapper-support
```

#### Recreate snapshots subvolume

Delete the snapshots subvolume that already create before.

```
cd /
umount /.snapshots
rm -r /.snapshots
```

Recreate `@snapshots` with snapper

```
snapper -c root create-config /
btrfs subvol list /
btrfs subvol delete /.snapshots
mkdir /.snapshots
mount -a
```

#### Change default subvolume

Get the default subvolume currently use and id for `@` subvolume.

```
btrfs subvol get-default /
btrfs subvol list /
```

Set default to `@` subvolume.

```
btrfs subvol set-default 256 /
```

#### Change the root configs file

```
nano /etc/snapper/configs/root
```

to something like this

```
# subvolume to snapshot
SUBVOLUME="/"

# filesystem type
FSTYPE="btrfs"


# btrfs qgroup for space aware cleanup algorithms
QGROUP=""


# fraction or absolute size of the filesystems space the snapshots may use
SPACE_LIMIT="0.5"

# fraction or absolute size of the filesystems space that should be free
FREE_LIMIT="0.2"


# users and groups allowed to work with config
ALLOW_USERS=""
ALLOW_GROUPS="wheel"

# sync users and groups from ALLOW_USERS and ALLOW_GROUPS to .snapshots
# directory
SYNC_ACL="no"


# start comparing pre- and post-snapshot in background after creating
# post-snapshot
BACKGROUND_COMPARISON="yes"


# run daily number cleanup
NUMBER_CLEANUP="yes"

# limit for number cleanup
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="50"
NUMBER_LIMIT_IMPORTANT="10"


# create hourly snapshots
TIMELINE_CREATE="yes"

# cleanup hourly snapshots after some time
TIMELINE_CLEANUP="yes"

# limits for timeline cleanup
TIMELINE_MIN_AGE="1000"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="5"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"


# cleanup empty pre-post-pairs
EMPTY_PRE_POST_CLEANUP="yes"

# limits for empty pre-post-pair cleanup
EMPTY_PRE_POST_MIN_AGE="1800"
```

#### Change group owner for `/.snapshots`

```
chown -R :wheel /.snapshots
```

#### Create fresh install snapshots

```
snapper -c root create -d "***Fresh Installation***"
```

And finally `reboot`.

## After Installation

#### Installing Hyprland

```bash
yay -S \
  hyprland \
  xdg-desktop-portal-hyprland-git \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk \
  kitty \
  sddm-git \
  polkit-gnome \
  qt5-wayland \
  qt6-wayland

```

#### Installing necessary package for system

```
yay -S \
  intel-ucode \
  xf86-video-intel\
  pipewire \
  pipewire-alsa \
  pipewire-jack \
  pipewire-pulse \
  pipewire-zeroconf \
  bluez \
  bluez-utils \
  thunar \
  firefox
```

#### Enable services

```
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable sshd
systemctl --user enable pipewire
sudo systemctl enable --now sddm
```

#### Installing some packages that i use

```bash
yay -S \
  waybar-hyprland-git \
  nwg-look \
  mako \
  polkit-gnome \
  rofi \
  cava \
  swayidle \
  swaylock-effects-git \
  swaybg \
  cronie \
  tty-clock \
  light \
  acpi \
  auto-cpufreq \
  hyprpicker-git \
  ntfs-3g \
  pavucontrol \
  playerctl \
  zram-generator \
  zsh \
  zsh-completions \
  zsh-syntax-highlighting \
  grim \
  slurp \
  wl-clipboard \
  pamixer \
  brightnessctl \
  sddm-theme-corners-git
```

And for the last step, you can clone this repository to your config files.
