#!/usr/bin/env bash

declare_variables() {
  username=$(id -u -n 1000)
  readarray -t folders <<<"$(find . -maxdepth 1 -type d -not -path '*/.*' | tr -d './' | awk 'NF')"
}

print_menu() {
  echo "Choose some options to symlink into your .config folder"

  for item in "${!folders[@]}"; do
    echo "[$item] ${folders[item]}"
  done

  read -r -p "(1,2,..)> "  answer

  IFS="," read -ra array_answers <<< "$answer"
}

apply_symlink() {
  echo ""
  for i in "${array_answers[@]}"; do
    echo "symlink $(pwd)/${folders[i]} -> /home/$username/.config/${folders[i]}"
    ln -s "$(pwd)/${folders[i]}" "/home/$username/.config/${folders[i]}"
  done

  echo "done"
}

main() {
  declare_variables
  print_menu
  apply_symlink
}

main
