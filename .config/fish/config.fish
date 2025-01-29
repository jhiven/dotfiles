export (envsubst < $HOME/.env)

fish_vi_key_bindings

# Enable jj to enter normal mode
set fish_key_bindings fish_user_key_bindings

# alias
alias mirrorupdate "echo 'updating mirrorlist' && sudo reflector --latest 5 --country 'sg,id,Australia' --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist && sudo cat /etc/pacman.d/mirrorlist"
alias dotfiles "/usr/bin/git --git-dir='$HOME/.dotfiles/' --work-tree='$HOME'"

complete -f -c dotnet -a "(dotnet complete (commandline -cp))"

starship init fish | source

source "$HOME/.cargo/env.fish"
