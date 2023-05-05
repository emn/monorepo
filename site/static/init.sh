#!/bin/bash
# Fedora 39 Sericea
set -xe

# TODO
# systemd timer to clean up ~/dwn daily
# git -> jujutsu
#   tar -C .local/bin -zvxf dwn/jj-v0.7.0-x86_64-unknown-linux-musl.tar.gz ./jj
# figure out browser stuff: 
#   does ff user profile exist prior to first launch
#   system ff has no codecs - switch to flatpak?
#   check for vivaldi flatpak release
# sway autotiling
# tmux
# anki addons
# custom toolbox image with foot,starship installed
# browser addons
#   tree-style tabs
#   singlefile
#   leechblock

# UPDATE SYSTEM
sudo rpm-ostree update
echo 'Reboot? (y/N)' && read x && [[ "$x" == "y" ]] && systemctl reboot
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --noninteractive app/net.ankiweb.Anki
flatpak install --noninteractive app/io.podman_desktop.PodmanDesktop/x86_64/stable
flaptak install --noninteractive app/com.logseq.Logseq/x86_64/stable
flatpak install --noninteractive com.visualstudio.code
flatpak install --noninteractive app/io.mpv.Mpv/x86_64/stable
flatpak install --noninteractive com.calibre_ebook.calibre

# VARS
BIN=~/.local/bin
DOT=~/dev/monorepo/dotfiles
BW="https://github.com/bitwarden/clients/releases/download/cli-v2023.3.0/bw-linux-2023.3.0.zip"
GITMAIL="35371027+emn@users.noreply.github.com"

# DIRS
mkdir -p $BIN
mkdir -p .ssh
mkdir -p dev
mkdir -p doc/notes
mkdir -p opt
sudo mkdir -p /usr/local/share/fonts/hanazono-mincho

# BITWARDEN
if ! hash bw 2>/dev/null; then
  curl -fsSL $BW -o bw.zip 
  unzip -qq bw.zip -d $BIN
  rm -f bw.zip  
fi
bw logout
BW_SESSION=$(bw login --raw)
export BW_SESSION
bw sync

# GIT
bw get notes github-auth > ~/.ssh/github-auth
chmod 0600 ~/.ssh/github-auth
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github-auth
git clone git@github.com:emn/monorepo.git ~/dev/monorepo

# JJ
cat <<EOF>.jjconfig.toml
[user]
name = "emn"
email = "$GITMAIL"
EOF
source <(jj debug completion)

# DOTFILES
rm -f ~/.bashrc
ln -s $DOT/.bashrc ~/.bashrc 

rm -f ~/.var/app/io.gitlab.librewolf-community/.librewolf/librewolf.overrides.cfg
# symlinking this file does not work
cp $DOT/librewolf.overrides.cfg ~/.var/app/io.gitlab.librewolf-community/.librewolf/librewolf.overrides.cfg
mkdir -p .var/app/io.gitlab.librewolf-community/.librewolf/bdtfbymv.default-release/chrome
cp $DOT/userChrome.css .var/app/io.gitlab.librewolf-community/.librewolf/bdtfbymv.default-release/chrome/userChrome.css
#sudo cp policies.json 
#browser.fullscreen.autohide

mkdir -p ~/dwn
mkdir -p ~/doc
rm -f ~/.config/user-dirs.dirs
ln -s user-dirs.dirs ~/.config/user-dirs.dirs
xdg-user-dirs-update
rm -rf ~/Desktop ~/Downloads ~/Templates ~/Public ~/Documents ~/Music ~/Pictures ~/Videos

# DATE/TIME/LOCALE
timedatectl set-timezone Europe/London
localectl set-keymap gb

# TYPEFACES
sudo curl -L https://github.com/cjkvi/HanaMinAFDKO/releases/download/8.030/HanaMinA.otf -o /usr/local/share/fonts/hanazoko-mincho/HanaMinA.otf
sudo curl -L https://github.com/cjkvi/HanaMinAFDKO/releases/download/8.030/HanaMinB.otf -o /usr/local/share/fonts/hanazoko-mincho/HanaMinB.otf
sudo curl -L https://github.com/cjkvi/HanaMinAFDKO/releases/download/8.030/HanaMinC.otf -o /usr/local/share/fonts/hanazoko-mincho/HanaMinC.otf
fc-cache

# DEV
curl -fssL https://starship.rs/install.sh | sh
systemctl --user enable --now podman.socket
sudo ln -s /run/user/1000/podman/podman.sock /var/run/docker.sock

# FINAL
cat <<EOF
Unavoidably manual steps:

Install anki addons:
  874215009
  759844606
EOF
