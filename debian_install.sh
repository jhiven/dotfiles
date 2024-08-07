#!/usr/bin/env bash
# shellcheck disable=2015

username=$(id -u -n 1000)
current_path=$(pwd)
RED='\033[0;31m'    
GREEN='\033[0;32m'    
YELLOW='\033[1;33m'
SET='\033[0m'
log_path="$current_path/log"

text_info(){
  echo -e "${YELLOW}[INFO]${SET} $1" 2>&1 | tee -a "$LOG"
}

text_error(){
  echo -e "${RED}[ERROR]${SET} $1" 2>&1 | tee -a "$LOG"
  return 1
}

text_success(){
  echo -e "${GREEN}[SUCCESS]${SET} $1" 2>&1 | tee -a "$LOG"
}

ask() {
  read -r -p "$1 (Y/n): " answer

  [ "$answer" = "y" ]
}

check_success(){
  if [ $? -eq 0 ]; then
    text_success "$1"
  else
    text_error "$2"
  fi
}

check_installed(){
  sudo dpkg -l | grep -q -w "$1"
  check_success "$1 already installed on your system" "$1 is not installed on your system"
}

check_nala(){
  LOG="$log_path/check_nala.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
  fi

  if ! check_installed "nala"; then
    sudo apt install nala -y 2>&1 | tee -a "$LOG"
    if command -v nala > /dev/null; then
      sudo nala update && sudo nala upgrade 2>&1 | tee -a "$LOG"
      text_success "nala installed successfully"
    else
      text_error "failed to install nala"
    fi
  fi
}

nala_install(){
  text_info "installing $1"
  # shellcheck disable=2086
  sudo nala install $1 -y
  check_success "$1 installed successfully"  "failed to install $1"
}

install_gnome() {
  LOG="$log_path/gnome_install.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
    nala_install "gnome-core"
  else
    text_info "it seems 'install gnome' opertion has been done before"
    text_info "skipping this operation"
  fi

}

install_gui() {
  LOG="$log_path/install_gui.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
  fi

  nala_install "kitty gnome-tweaks dconf-editor qdirstat grub-customizer"
  
  if ask "Install flatpak?"; then
    nala_install "flatpak"

    text_info "adding flathub repo"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    check_success "flathub added to repo" "failed to add flathub into repo"
text_info "installing brave, webcord, and zoom with flatpak"
    flatpak install flathub com.brave.Browser -y 2>&1 | tee -a "$LOG"
    flatpak install flathub io.github.spacingbat3.webcord -y 2>&1 | tee -a "$LOG"
    flatpak install flathub us.zoom.Zoom -y 2>&1 | tee -a "$LOG"
    text_success "brave, webcord, and zoom with flatpak installed successfuly"
  fi

  if ask "Install VScode?"; then
    cd "$current_path" || exit
    nala_install "wget gpg"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg 2>&1 | tee -a "$LOG"
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg 2>&1 | tee -a "$LOG"
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' 2>&1 | tee -a "$LOG"
    rm -f packages.microsoft.gpg
    nala_install "apt-transport-https"
    sudo nala update 2>&1 | tee -a "$LOG"
    nala_install "code"

    text_info "installing 2 vscode extensions"
    code --install-extension Catppuccin.catppuccin-vsc 2>&1 | tee -a "$LOG"
    check_success "catpuccin vscode installed successfully" "failed to install catppuccin vscode"
    code --install-extension PKief.material-icon-theme 2>&1 | tee -a "$LOG"
    check_success "material icon vscode installed successfully" "failed to install material icon vscode"
    code --install-extension vscodevim.vim 2>&1 | tee -a "$LOG"
    check_success "vscode vim installed successfully" "failed to install material icon vscode"

    if [ ! -e  "/home/$username/.config/Code/User" ]; then
      text_info "/home/$username/.config/Code/User not found, creating new directory"
      mkdir -p "/home/$username/.config/Code/User"
    fi

    ln -sf "$current_path/vscode/settings.json"  "/home/$username/.config/Code/User/settings.json" && text_info "Symlink ./vscode/settings.json -> /home/$username/.config/Code/User/settings.json"
    ln -sf "$current_path/vscode/keybindings.json"  "/home/$username/.config/Code/User/keybindings.json" && text_info "Symlink ./vscode/keybindings.json -> /home/$username/.config/Code/User/keybindings.json"

  fi

  if ask "Install spotify?"; then
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg 2>&1 | tee -a "$LOG"
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list 2>&1 | tee -a "$LOG"
    sudo nala update && nala_install "spotify-client"
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh 2>&1 | tee -a "$LOG"
    sudo chmod a+wr /usr/share/spotify
    sudo chmod a+wr /usr/share/spotify/Apps -R

    fish

    text_info "Please login your spotify account"; spotify && curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh && spicetify backup apply
    check_success "spotify patched successfully" "spicetify can't patch spotify, you need to run it manully"
  fi

  # text_info "enable wayland firefox"
  # # enable wayland firefox
  # echo "MOZ_ENABLE_WAYLAND=1" | sudo tee -a /etc/environment
  # check_success "wayland firefox enabled" "failed to enable wayland firefox"
}

install_ctf_tools(){
  nala_install "exiftool binwalk steghide default-jre checksec ltrace strace testdisk foremost python3-pwntools git"

  # install stegsolve
  text_info "downloading stegsolve"
  text_info "creating new directory at /home/$username/tools/stegsolve"
  mkdir -p "/home/$username/tools/stegsolve"
  cd "/home/$username/tools/stegsolve" || exit
  wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar 2>&1 | tee -a "$LOG"
  check_success "stegsolve downloaded successfully" "failed to download stegsolve"
  text_success
  cd .. || exit

  # install ida
  text_info "downloading ida"
  text_info "creating new directory at $(pwd)/ida"
  mkdir ida
  cd ida || exit
  wget https://out7.hex-rays.com/files/idafree83_linux.run 2>&1 | tee -a "$LOG"
  check_success "ida downloaded successfully. However, you need to run it manually" "failed to download ida"

  # install pwndbg
  text_info "installing pwndbg"
  cd "/home/$username/tools" || exit
  git clone https://github.com/pwndbg/pwndbg 2>&1 | tee -a "$LOG"
  cd pwndbg/ || exit
  ./setup.sh 2>&1 | tee -a "$LOG"
  check_success "pwndbg installed successfully" "failed to install pwndbg"
  cd "$current_path" || exit

  text_info "installing zsteg"
  gem install zsteg 2>&1 | tee -a "$LOG"
  check_success "zsteg installed successfuly" "failed to install zsteg"
}

install_cli(){
  LOG="$log_path/install_cli.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
  fi

  nala_install "libcurl4 curl git neofetch btop duf lsd tldr fzf tree rubygems pipx npm ripgrep"

  if ask "Install ctf tools?"; then
    install_ctf_tools
  fi
}

install_nvim(){
  LOG="$log_path/install_nvim.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
  fi

  mkdir -p "/home/$username/tools"
  text_info "installing neovim from source since debian repository have very old version"

  nala_install "ninja-build gettext cmake unzip curl git"
  cd "/home/$username/tools" || exit
  git clone https://github.com/neovim/neovim 2>&1 | tee -a "$LOG"
  cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo 2>&1 | tee -a "$LOG"
  check_success "nvim build successfull" "failed to build nvim"
  cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb 2>&1 | tee -a "$LOG"
  check_success "nvim installed successfully" "failed to install nvim"
  cd "$current_path" || exit
}

install_fish(){
  LOG="$log_path/install_fish.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
  fi

  text_info "downloading fish"

  cd "$current_path" || exit
  nala_install "curl"
  echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
  curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
  sudo nala update
  nala_install "fish"
  check_success "download success" "failed to download fish"

  text_info "set fish to default shell"
  sudo echo "$(which fish)" | sudo tee -a /etc/shells
  chsh -s "$(which fish)"
  check_success "fish has been set to default shell" "can not set fish to default shell"
  text_info "removing fish_3.7.0-1_amd64.deb file since the fish is installed"
  rm fish_3.7.0-1_amd64.deb

  # install starship
  text_info "downloading starship"
  curl -sS https://starship.rs/install.sh | sh 2>&1 | tee -a "$LOG"
  check_success  "starship installed successfully" "failed to download starship"
  starship init fish | source

  fish_path=$(realpath ./fish)
  if [ -e "/home/$username/.config/fish" ]; then
    text_info "fish exist in .config, deleting /home/$username/.config/fish"
    rm -r "/home/$username/.config/fish"
  fi

  ln -s "$fish_path" "/home/$username/.config/fish"
  check_success "Symlink /home/$username/.config/fish -> /home/$username/.config/fish" "failed to symlink fish into config"
}

install_flutter(){
  LOG="$log_path/install_flutter.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
  fi

  wget "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.8-stable.tar.xz" 2>&1 | tee -a "$LOG"
  check_success  "flutter downloaded successfully" "failed to download flutter"

  text_info "installing flutter"
  mkdir -p "/home/$username/development"
  tar xvf flutter_linux_3.16.8-stable.tar.xz --directory="/home/$username/development" 2>&1 | tee -a "$LOG"
  check_success "flutter installed successfully" "failed to download flutter"
  text_info "removing flutter_linux_3.16.8-stable.tar.xz"
  rm flutter_linux_3.16.8-stable.tar.xz

  text_info "installing android studio"
  nala_install "libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386"
  wget "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.27/android-studio-2023.1.1.27-linux.tar.gz" 2>&1 | tee -a "$LOG"
  check_success "android studio downloaded successfully" "failed to download android studio"
  sudo tar xvf android-studio-2023.1.1.27-linux.tar.gz --directory=/usr/local/ 2>&1 | tee -a "$LOG"
  check_success "android studio installed successfully, you have to run /usr/local/studio.sh manually" "failed to install android studio"
  text_info "removing flutter_linux_3.16.8-stable.tar.xz"
  rm flutter_linux_3.16.8-stable.tar.xz
  cd "$current_path" || exit
}

install_theme(){
  LOG="$log_path/install_theme.log"

  if [ ! -e "$LOG" ]; then
    touch  "$LOG"
  fi

  # installing font
  text_info "installing gnome theme"

  text_info "downloading JerBrainsMono Nerd Font"
  mkdir "/home/$username/.fonts"
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip 2>&1 | tee -a "$LOG"
  check_success "fonts download success" "failed to download fonts"
  unzip JetBrainsMono.zip -d "/home/$username/.fonts" 2>&1 | tee -a "$LOG"
  check_success "font installed successfully" "failed to install font"
  rm JetBrainsMono.zip

  # Gnome Tweaks
  nala_install "gnome-shell-extensions"
  mkdir "/home/$username/.themes"

  # install catppuccin theme
  text_info "downloading catppuccin mocha lavender gtk-theme"
  wget https://github.com/catppuccin/gtk/releases/download/v0.7.0/Catppuccin-Mocha-Standard-Lavender-Dark.zip 2>&1 | tee -a "$LOG"
  check_success "theme download success" "failed to download theme"
  text_info "installing gtk-theme"
  unzip Catppuccin-Mocha-Standard-Lavender-Dark.zip -d "/home/$username/.themes" 2>&1 | tee -a "$LOG"
  rm Catppuccin-Mocha-Standard-Lavender-Dark.zip 
  mkdir -p "/home/$username/.config/gtk-4.0"
  ln -sf "/home/$username/.themes/Catppuccin-Mocha-Standard-Lavender-Dark/gtk-4.0/assets" "/home/$username/.config/gtk-4.0/assets"
  ln -sf "/home/$username/.themes/Catppuccin-Mocha-Standard-Lavender-Dark/gtk-4.0/gtk.css" "/home/$username/.config/gtk-4.0/gtk.css"
  ln -sf "/home/$username/.themes/Catppuccin-Mocha-Standard-Lavender-Dark/gtk-4.0/gtk-dark.css" "/home/$username/.config/gtk-4.0/gtk-dark.css"
  check_success "gtk-theme installed successfully" "gtk-theme installation failed"
  cd "$current_path" || exit

  # apply the settings
  text_info "applying gnome settings"
  gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
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
  gsettings set org.gnome.settings-daemon.plugins.power power-button-action "nothing"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$(realpath hypr/bg/neon-cat.jpg)"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>h']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>l']"
  gsettings set org.gnome.desktop.interface enable-hot-corners false
  text_success "gnome settings has been applied"

  text_info "disable sleep key(F1) and power button"
  sudo sed -e '/I150/ s/^\/*/\/\//' -i /usr/share/X11/xkb/keycodes/evdev 
  check_success "the operation successful" "can't disable the key"
}

main(){
  mkdir -p "$log_path"
  check_nala

  if ask "Install gnome?"; then
    install_gnome
  fi

  if ask "Install some cli tools?"; then
    install_cli
  fi

  if ask "Install nvim?"; then
    install_nvim
  fi

  if ask "Install fish shell?"; then
    install_fish
  fi

  if ask "Install some gui applications?"; then
    install_gui
  fi

  if ask "Install theme?"; then
    install_theme
  fi

  if ask "Install flutter?"; then
    install_flutter
  fi
}

main

# might be useful
# sudo nala purge ifupdown -y 
# sudo sed -i "s/managed=false/managed=true/g" /etc/NetworkManager/NetworkManager.conf
#
# sudo su - <<EOF
#   apt update
#   apt upgrade -y 
#
#   adduser $username sudo
# EOF
