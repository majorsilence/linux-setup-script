#!/bin/bash

# update package list
apt-get update

# upgrade all packages
apt-get upgrade -y

configuremono()
{
	apt install gnupg ca-certificates
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
	echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list
	apt update

	apt-get install -y mono-complete sqlite3 unzip nuget
}

gitsetup()
{
  apt-get install -y git git-gui 
  wget https://gist.githubusercontent.com/majorsilence/69e3fd56b07657b2e951/raw/f8fe9185849f85094c3278b8d1c89fa5c4467c28/Git%2520Config -O ~/.gitconfig
  chown peter:peter .gitconfig
}

fluxboxinstall()
{
  apt-get install -y fluxbox 
  git clone https://github.com/majorsilence/FluxBoxConfig.git ~/.fluxbox
  chown peter:peter .fluxbox -R
}

neovim_setup()
{
  apt install build-essential -y
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  mv ./nvim.appimage /usr/local/bin
  export CUSTOM_NVIM_PATH=/usr/local/bin/nvim.appimage
  # Set the above with the correct path, then run the rest of the commands:
  set -u
  update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
  update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
  update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
  update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
  update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110
  
  curl -sLf https://spacevim.org/install.sh | bash
  #mkdir -p $XDG_CONFIG_HOME/nvim/lua
  #touch $XDG_CONFIG_HOME/nvim/lua/plugins.lua
}

tmux_setup()
{
    apt install -y tmux tmux-plugin-manager
    mkdir -p $XDG_CONFIG_HOME/tmux
    touch $XDG_CONFIG_HOME/tmux/tmux.conf
    cat <<EOF >> $XDG_CONFIG_HOME/tmux/tmux.conf
# List of plugins 
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '/usr/bin/tmux' 
set -g display-panes-time 3000
EOF
}

apt install -y p7zip-full curl docker.io flatpak gnome-software-plugin-flatpak synaptic flameshot pan dotnet-sdk-6.0 build-essential

groupadd docker
usermod -aG docker $USER
chown root:docker /var/run/docker.sock
chown -R root:docker /var/run/docker
# this works but the group does not?  Why?
chown $USER /var/run/docker.sock
newgrp docker 


# avoid unresponsive state due memory use, see https://github.com/rfjakob/earlyoom
# this may not want to be installed on machines with plenty of memory
# apt install -y earlyoom

configuremono
gitsetup
fluxboxinstall


#snap install slack --classic
snap install code --classic
snap install rider --classic
# snap install skype --classic
# if remmina does not work in wayland sessions use krdc
#snap install krdc
snap install powershell --classic

 
 # reboot before doing flatpak stuff?
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
 
flatpak install flathub -y --noninteractive us.zoom.Zoom
flatpak install flathub -y --noninteractive com.valvesoftware.Steam
flatpak install flathub -y --noninteractive org.gnome.meld
flatpak install flathub -y --noninteractive org.libreoffice.LibreOffice
flatpak install flathub -y --noninteractive io.mrarm.mcpelauncher
flatpak install flathub -y --noninteractive io.github.shiftey.Desktop
flatpak install flathub -y --noninteractive com.obsproject.Studio
flatpak install flathub -y --noninteractive com.getpostman.Postman
flatpak install flathub -y --noninteractive org.remmina.Remmina
flatpak install flathub -y --noninteractive org.kde.kolourpaint
flatpak install flathub -y --noninteractive app.resp.RESP
flatpak install flathub -y --noninteractive io.github.peazip.PeaZip

apt remove -y remmina libreoffice
# clean up unused packages
apt-get autoclean -y

