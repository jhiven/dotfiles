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

        if [ -e "/home/$username/.config/$filename" ]; then
          text_info "$filename exist in .config, deleting /home/$username/.config/$filename"
          rm -r "/home/$username/.config/$filename"
        fi

        text_info "Symlink $absolute_path -> /home/$username/.config/$filename"
        ln -s "$absolute_path" "/home/$username/.config/$filename"
      fi
    fi
  done
}

main() {
  if ask "Start debian installer?"; then
    if [ -e ./docs/debian_installation/install.sh ]; then
      ./docs/debian_installation/install.sh
    else
      text_error "debian installer not found"
    fi
  fi

  if ask "Install dotfiles?"; then
    install_dotfiles
  fi
}

main
