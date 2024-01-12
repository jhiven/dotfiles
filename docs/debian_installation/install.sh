#!/usr/bin/env bash

username=$(id -u -n 1000)
current_path=$(pwd)

ask() {
  read -r -p "$1 (Y/n): " answer

  [ "$answer" = "y" ]
}

install_gnome() {
  sudo apt install nala
  sudo su - <<EOF
  apt update
  apt upgrade -y 

  apt install sudo nala -y
  adduser $username sudo
EOF
  
  sudo nala install gnome-core -y
}

install_gui() {
  sudo nala install kitty gnome-tweaks dconf-editor qdirstat grub-customizer -y
  
  if ask "Install spotify?"; then
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install spotify-client
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
    # curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
    sudo chmod a+wr /usr/share/spotify
    sudo chmod a+wr /usr/share/spotify/Apps -R
    # spicetify backup apply
  fi

  if ask "Install flatpak?"; then
    sudo nala install flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.brave.Browser -y
    flatpak install flathub io.github.spacingbat3.webcord -y
    flatpak install flathub us.zoom.Zoom -y
  fi

  if ask "Install VScode?"; then
    sudo nala install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo nala install apt-transport-https -y
    sudo nala update -y
    sudo nala install code -y
  fi

  # enable wayland firefox
  echo "MOZ_ENABLE_WAYLAND=1" | sudo tee -a /etc/environment
}

install_ctf_tools(){
  sudo nala install exiftool binwalk steghide default-jre checksec ltrace strace testdisk foremost python3-pwntools -y

  # install stegsolve
  mkdir -p "/home/$username/tools/stegsolve"
  cd "/home/$username/tools/stegsolve" || exit
  wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar
  cd .. || exit
  mkdir ida
  cd ida || exit
  wget https://out7.hex-rays.com/files/idafree83_linux.run
  cd "$current_path" || exit

  # install pwndbg
  cd "/home/$username/tools" || exit
  git clone https://github.com/pwndbg/pwndbg
  cd pwndbg/ || exit
  ./setup.sh
  cd "$current_path" || exit

  gem install zsteg
}

install_cli(){
  sudo nala install libcurl4 curl git neofetch btop duf lsd tldr fzf tree rubygems pipx npm -y

  if ask "Install ctf tools?"; then
    install_ctf_tools
  fi
}

install_nvim(){
  sudo nala install ninja-build gettext cmake unzip curl-y
  cd "/home/$username/tools" || exit
  git clone https://github.com/neovim/neovim
  cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
  cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
  cd "$current_path" || exit
}

install_fish(){
  cd "$current_path" || exit
  wget https://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/amd64/fish_3.7.0-1_amd64.deb
  sudo nala install fish_3.7.0-1_amd64.deb -y
  sudo echo "$(which fish)" | sudo tee -a /etc/shells
  chsh -s "$(which fish)"
  rm fish_3.7.0-1_amd64.deb

  # install starship
  curl -sS https://starship.rs/install.sh | sh
  starship init fish | source
}

install_theme(){
  # installing font
  mkdir "/home/$username/.fonts"
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d "/home/$username/.fonts"
  rm JetBrainsMono.zip

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

  # apply the settings
  gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
  gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
  gsettings set org.gnome.desktop.interface gtk-theme Catppuccin-Mocha-Standard-Lavender-Dark
  gsettings set org.gnome.desktop.wm.preferences theme Catppuccin-Mocha-Standard-Lavender-Dark
  gsettings set org.gnome.shell.extensions.user-theme name Catppuccin-Mocha-Standard-Lavender-Dark
  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"
  gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
  gsettings set org.gnome.shell.keybindings screenshot "['<Super>Print']"
  gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>s']"
  gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 12"
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Open Terminal'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>q'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'/usr/bin/kitty'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Open File Explorer'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'<Super>e'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'/usr/bin/nautilus'"
  gsettings set org.gnome.shell favorite-apps "['firefox-esr.desktop', 'code.desktop', 'spotify.desktop']"
}

main(){
  if ask "Install gnome?"; then
    install_gnome
  fi

  if ask "Install some gui applications?"; then
    install_gui
  fi

  if ask "Install some cli tools?"; then
    install_cli
  fi

  if ask "Install ctf tools?"; then
    install_cli
  fi

  if ask "Install nvim?"; then
    install_nvim
  fi

  if ask "Install fish?"; then
    install_fish
  fi

  if ask "Install theme?"; then
    install_theme
  fi
}

main

# might be useful
# sudo nala purge ifupdown -y 
# sudo sed -i "s/managed=false/managed=true/g" /etc/NetworkManager/NetworkManager.conf
# sudo shutdown -r now
