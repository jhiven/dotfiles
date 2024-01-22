#!/usr/bin/env bash

username=$(id -u -n 1000)

RED='\033[0;31m'    
GREEN='\033[0;32m'    
YELLOW='\033[1;33m'
SET='\033[0m'

text_info(){
  echo -e "${YELLOW}[INFO]${SET} $1"
}

text_error(){
  echo -e "${RED}[ERROR]${SET} $1"
}

text_success(){
  echo -e "${GREEN}[SUCCESS]${SET} $1"
}

check_success(){
  if [ $? -eq 0 ]; then
    text_success "$1"
  else
    text_error "$2"
  fi
}

ask() {
  read -r -p "$1 (Y/n): " answer

  [ "$answer" = "y" ]
}

install_dotfiles() {
  for file in ./*; do
    if [ -d "$(realpath "$file")" ]; then
      filename=$(basename "$file")


      if ask "Link $filename into .config?"; then
        absolute_path=$(realpath "$filename")

        if [ "$filename" = "vscode" ]; then
          if [ ! -e  "/home/$username/.config/Code/User" ]; then
            text_info "/home/$username/.config/Code/User not found, creating new directory"
            mkdir -p "/home/$username/.config/Code/User"
          fi

          ln -sf "$(realpath "$absolute_path/settings.json" )"  "/home/$username/.config/Code/User/settings.json" && text_success "Symlink ./vscode/settings.json -> /home/$username/.config/Code/User/settings.json"
          ln -sf "$(realpath "$absolute_path/keybindings.json" )"  "/home/$username/.config/Code/User/keybindings.json" && text_success "Symlink ./vscode/keybindings.json -> /home/$username/.config/Code/User/keybindings.json"
          continue
        fi

        if [ -e "/home/$username/.config/$filename" ]; then
          text_info "$filename exist in .config, deleting /home/$username/.config/$filename"
          rm -r "/home/$username/.config/$filename" || rm "/home/$username/.config/$filename" || text_error "can't remove $filename in .config"
        fi

        ln -s "$absolute_path" "/home/$username/.config/$filename"
        check_success "Symlink $absolute_path -> /home/$username/.config/$filename" "can't link $filename into .config"
      fi
    fi
  done
}

main() {
  if ask "Start debian installer?"; then
    if [ -e ./debian_install.sh ]; then
      ./debian_install.sh
    else
      text_error "debian installer not found"
    fi
  fi

  if ask "Install dotfiles?"; then
    install_dotfiles
  fi
}

main
