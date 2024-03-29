if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
set fish_greeting ""

# Created by `pipx` on 2023-10-29 06:12:13
fish_add_path $HOME/.local/bin
fish_add_path $HOME/development/flutter/bin

fish_add_path $HOME/.spicetify
fish_add_path $HOME/.cargo/bin
set -gx CHROME_EXECUTABLE /var/lib/flatpak/app/com.github.Eloston.UngoogledChromium/x86_64/stable/active/export/bin/com.github.Eloston.UngoogledChromium

fish_vi_key_bindings
set fish_key_bindings fish_user_key_bindings

alias emulator "~/Android/Sdk/emulator/emulator"
