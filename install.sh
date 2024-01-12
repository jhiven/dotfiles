#!/usr/bin/env bash

username=$(id -u -n 1000)

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
          echo "$filename exist in .config, deleting /home/$username/.config/$filename"
          rm -r "/home/$username/.config/$filename"
        fi

        echo "Symlink $absolute_path -> /home/$username/.config/$filename"
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
      echo "debian installer not found"
    fi
  fi

  if ask "Install dotfiles?"; then
    install_dotfiles
  fi
}

main
