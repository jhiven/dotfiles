#!/usr/bin/env bash

username=$(id -u -n 1000)

ask() {
  read -r -p "$1 (Y/n): " answer

  [ "$answer" = "y" ]
}

install_dotfiles() {
  for file in $(find . -maxdepth 1 -type d -not -path '*/.*' | tr -d './' | awk 'NF'); do
    if ask "Link $file into .config?"; then
      absolute_path=$(realpath "$file")

      if [ -e "/home/$username/.config/$file" ]; then
        echo "$file exist in .config, deleting /home/$username/.config/$file"
        rm -r "/home/$username/.config/$file"
      fi

      echo "Symlink $absolute_path -> /home/$username/.config/$file"
      ln -s "$absolute_path" "/home/$username/.config/$file"
    fi
  done
}

main() {
  if ask "Start debian installer?"; then
    if [ -e ./docs/debian_installation/install.sh ]; then
      ./docs/debian_installation/install.sh
    else
      echo "debian installer not found"
    fi
  fi

  if ask "Install dotfiles?"; then
    install_dotfiles
  fi
}

main
