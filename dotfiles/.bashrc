# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

pw() {
 bw get password $1 | wl-copy
}
bw-login() {
 read BW_SESSION < <(bw login --raw)
 export BW_SESSION
}
gh-ssh() {
 eval "$(ssh-agent -s)"
 ssh-add ~/.ssh/github-auth
}
export -f pw
export -f bwl
export -f gh-ssh
