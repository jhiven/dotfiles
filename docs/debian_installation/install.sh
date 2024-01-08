#!/usr/bin/env bash

username=$(id -u -n 1000)
current_path=$(pwd)

# sudo apt install nala
# sudo su - <<EOF
# apt update
# apt upgrade -y 
#
# apt install sudo nala -y
# adduser $username sudo
# EOF

sudo nala reinstall firmware-iwlwifi -y

# gnome install
sudo nala install gdm3 gnome-core ffmpegthumbnailer -y

# gui application install
sudo nala install firefox-esr nautilus kitty gnome-tweaks dconf-editor qdirstat audacity grub-customizer -y

# cli tools install 
sudo nala install libcurl4 curl git neofetch btop duf lsd tldr fzf tree rubygems pipx npm -y

# ctf tools
sudo nala install exiftool binwalk steghide default-jre checksec ltrace strace testdisk foremost python3-pwntools -y

mkdir -p "/home/$username/tools/stegsolve"
cd "/home/$username/tools/stegsolve" || exit
wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar
cd .. || exit
mkdir ida
cd ida || exit
wget https://out7.hex-rays.com/files/idafree83_linux.run
cd "$current_path" || exit

# installing font
mkdir "/home/$username/.fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d "/home/$username/.fonts"
rm JetBrainMono.zip

# Gnome Tweaks
sudo nala install gnome-shell-extensions
mkdir "/home/$username/.themes"
wget https://github.com/catppuccin/gtk/releases/download/v0.7.0/Catppuccin-Mocha-Standard-Lavender-Dark.zip
unzip Catppuccin-Mocha-Standard-Lavender-Dark.zip -d "/home/$username/.themes"
rm Catppuccin-Mocha-Standard-Lavender-Dark.zip 
mkdir -p "/home/$username/.config/gtk-4.0"
ln -sf "/home/$username/.themes/Catppuccin-Mocha-Standard-Lavender-Dark/gtk-4.0/assets" "/home/$username/.config/gtk-4.0/assets"
ln -sf "/home/$username/.themes/Catppuccin-Mocha-Standard-Lavender-Dark/gtk-4.0/gtk.css" "/home/$username/.config/gtk-4.0/gtk.css"
ln -sf "/home/$username/.themes/Catppuccin-Mocha-Standard-Lavender-Dark/gtk-4.0/gtk-dark.css" "/home/$username/.config/gtk-4.0/gtk-dark.css"

gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface gtk-theme Catppuccin-Mocha-Standard-Lavender-Dark
gsettings set org.gnome.desktop.wm.preferences theme Catppuccin-Mocha-Standard-Lavender-Dark
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Mono 12"

# install spotify & spicetify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
sudo chmod a+wr /usr/share/spotify
sudo chmod a+wr /usr/share/spotify/Apps -R
spicetify backup apply

# install neovim from source
sudo nala install ninja-build gettext cmake unzip curl
cd "/home/$username/tools" || exit
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb

# install fish shell
cd "$current_path" || exit
wget https://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/amd64/fish_3.6.1-1_amd64.deb
sudo nala install fish_3.6.1-1_amd64.deb
sudo echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
rm fish_3.6.1-1_amd64.deb

# install starship
curl -sS https://starship.rs/install.sh | sh
starship init fish | source

# enable wayland firefox
echo "MOZ_ENABLE_WAYLAND=1" | sudo tee -a /etc/environment
