fish_vi_key_bindings
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# if status is-interactive
# and not set -q TMUX
#     exec tmux new -A -s agnar
# end


# starship init fish | source
set fish_greeting ""

set -gx CHROME_EXECUTABLE /var/lib/flatpak/app/com.brave.Browser/x86_64/stable/active/export/bin/com.brave.Browser
set -gx BORG_REPO ssh://v6n779gs@v6n779gs.repo.borgbase.com/./repo

set -gx XCURSOR_SIZE $(gsettings get org.gnome.desktop.interface cursor-size)
set -x -U GOPATH $HOME/go

set fish_key_bindings fish_user_key_bindings

alias emulator "~/Android/Sdk/emulator/emulator"
set -Ux PYENV_ROOT $HOME/.pyenv
# set -gx JAVA_HOME /usr/local/jdk-21

fish_add_path /home/jhivens/.spicetify
fish_add_path $PYENV_ROOT/bin
fish_add_path $GOPATH/bin
# Created by `pipx` on 2023-10-29 06:12:13
fish_add_path $HOME/.local/bin
fish_add_path -g -p /usr/bin/flutter/bin

fish_add_path $HOME/.spicetify
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/go/bin
# fish_add_path $JAVA_HOME/bin

pyenv init - | source
# pnpm
set -gx PNPM_HOME "/home/jhivens/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
