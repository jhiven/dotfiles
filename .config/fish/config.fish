export (envsubst < $HOME/.env)

fish_vi_key_bindings

# Enable jj to enter normal mode
set fish_key_bindings fish_user_key_bindings

# alias
alias mirrorupdate "echo 'updating mirrorlist' && sudo reflector --latest 5 --country 'sg,id,Australia' --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist && sudo cat /etc/pacman.d/mirrorlist"
alias dotfiles "/usr/bin/git --git-dir='$HOME/.dotfiles/' --work-tree='$HOME'"

# yazi config
function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

starship init fish | source
