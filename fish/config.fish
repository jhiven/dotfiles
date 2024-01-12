if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
set fish_greeting ""

# Created by `pipx` on 2023-10-29 06:12:13
set PATH $PATH /home/jhivens/.local/bin
set PATH $PATH /home/jhivens/development/flutter/bin

fish_add_path /home/jhivens/.spicetify
set PATH $HOME/.cargo/bin $PATH
set -gx CHROME_EXECUTABLE /var/lib/flatpak/app/com.github.Eloston.UngoogledChromium/x86_64/stable/active/export/bin/com.github.Eloston.UngoogledChromium

alias :q "exit"
alias emulator "~/Android/Sdk/emulator/emulator"
