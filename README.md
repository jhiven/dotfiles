
# Jhiven's Dotfiles

This repository contains my personal dotfiles for ArchLinux. These files are used to configure various applications and tools on my ArchLinux system. Here is my personal configuration for Hyprland on my system. 


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
vim /etc/locale.gen
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
open the sudoers file and comment out `wheel`.
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

## Base Install Hyprland

```bash
  yay -S \
  hyprland-git \
  xdg-desktop-portal-hyprland-git \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk \
  thunar \
  firefox \
  kitty \
  sddm-git \
  pipewire \
  pipewire-alsa \
  pipewire-jack \
  pipewire-pulse \
  pipewire-zeroconf \
  bluez \
  bluez-utils \
  polkit-gnome \
  qt5-wayland \
  qt6-wayland \
  intel-ucode \
  xf86-video-intel \
```

## After Installation
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