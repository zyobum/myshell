#!/bin/bash
#exit when any command fails
echo "* Initial config"
set -e
GIT_USER=jz
GIT_EMAIL=j@roc.one
cd $HOME
umask 0077
chmod -R go-rwx $HOME
HOSTUSERNAME=$(ls /Users/ | head -n 1)
echo "Host USERNAME=$HOSTUSERNAME"

#install basic packages
echo "* Installing basic packages"
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install p7zip-full qrencode make build-essential
sudo apt-get -y install docker-compose
sudo apt-get -y install imagemagick ffmpeg
sudo apt-get -y install python-is-python3 python3-pip python3-venv
pip install --upgrade pip
pip install virtualenv

#setup locale
echo "* setup locale"
LOC=en_GB.UTF-8
sudo locale-gen $LOC
sudo update-locale LANG=$LOC LC_ALL=$LOC
#export LC_ALL=$LOC               # to fix, generating waring

#install on-my-zsh
echo "* Install Oh-my-zsh"
sudo apt-get install -y zsh x11-apps
sudo chsh -s /bin/zsh $USER
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "source /etc/zsh_command_not_found" >> $HOME/.zshrc
sed -i '1s/^/umask 0077\n/' $HOME/.zshrc
echo '[[ $(uname -m) == "aarch64" ]] && export DOCKER_DEFAULT_PLATFORM=linux/arm64' >> $HOME/.zshrc

# add aliases
echo "* Setup aliases"
echo "alias ll='ls -alF'
alias u='sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get -y autoremove && sudo apt-get update && omz update && (cd ~/.oh-my-zsh/custom/themes/powerlevel10k ; git pull)'
alias qrencode='qrencode -t ansiutf8 -r'
" > $HOME/.oh-my-zsh/custom/aliases.zsh

# patch login profile
echo "emulate sh -c '. ~/.profile'" >> $HOME/.zprofile
# filter duplicate path entries
echo $'export PATH="$(perl -e \'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))\')"' >> $HOME/.zshrc

# install powerlevel10k theme
echo "* Install powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/1' $HOME/.zshrc

# config powerlevel10k
echo "* Configure powerlevel10k"
delay="0.2"
tmux new-session -d -s p10k
tmux send-keys 'zsh --login' C-m
sleep $delay
tmux send-keys 'q'
sleep $delay

# wait for gitstatus installation
sleep 2
while true ; do
  if [ -d $HOME/.cache/gitstatus/ ] ; then
    break
  fi
  sleep 1
done

tmux send-keys 'TERM=xterm-256color' C-m
sleep $delay
tmux send-keys 'p10k configure' C-m
sleep $delay
tmux send-keys 'y'
sleep $delay
tmux send-keys 'y'
sleep $delay
tmux send-keys 'y'
sleep $delay
tmux send-keys 'y'
sleep $delay
tmux send-keys '1'
sleep $delay
tmux send-keys '1'
sleep $delay
tmux send-keys '1'
sleep $delay
tmux send-keys '2'
sleep $delay
tmux send-keys '1'
sleep $delay
tmux send-keys '1'
sleep $delay
tmux send-keys '2'
sleep $delay
tmux send-keys '1'
sleep $delay
tmux send-keys 'y'
sleep $delay
tmux send-keys '1'
sleep $delay
tmux send-keys 'y'
sleep $delay

sleep 2
tmux send-keys 'tmux wait -S fin' C-m
tmux send-keys 'exit' C-m
tmux send-keys 'exit' C-m

tmux wait fin

if [ ! -r $HOME/.p10k.zsh ] ; then
        echo '- p10k config file generation failed'
        exit 1
fi

if [ ! -d $HOME/.cache/gitstatus/ ] ; then
        echo '- gitstatus init failed'
        exit 1
fi

#echo "export POWERLEVEL9K_DISABLE_GITSTATUS=true" >> $HOME/.zshrc
echo "cd ~/workspace" >> $HOME/.zshrc

# Setup git global env
echo "* Configure other settings"
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USER

# link to mounted workspace
ln -s /Users/$HOSTUSERNAME/workspace $HOME/
ln -s /Users/$HOSTUSERNAME/Downloads $HOME/

#Copy ssh keys if exist
if [ -d "/Users/$HOSTUSERNAME/.ssh/myshell_keys" ]; then
  echo "Copying ssh keys"
  cp /Users/$HOSTUSERNAME/.ssh/myshell_keys/* $HOME/.ssh/ || true
fi

# Clean up
sudo apt-get autoremove

echo "* Finished, use \"limactl stop\" and \"limactl start\" to reboot"
