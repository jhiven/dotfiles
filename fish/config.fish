if status is-interactive
    # Commands to run in interactive sessions can go here
end

# starship init fish | source
set fish_greeting ""

# Created by `pipx` on 2023-10-29 06:12:13
fish_add_path $HOME/.local/bin
fish_add_path $HOME/development/flutter/bin

fish_add_path $HOME/.spicetify
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/go/bin
set -gx CHROME_EXECUTABLE /var/lib/flatpak/app/com.brave.Browser/x86_64/stable/active/export/bin/com.brave.Browser
set -gx BORG_REPO ssh://v6n779gs@v6n779gs.repo.borgbase.com/./repo

set -gx XCURSOR_SIZE $(gsettings get org.gnome.desktop.interface cursor-size)
set -x -U GOPATH $HOME/go

fish_vi_key_bindings
set fish_key_bindings fish_user_key_bindings

alias emulator "~/Android/Sdk/emulator/emulator"

fish_add_path /home/jhivens/.spicetify
