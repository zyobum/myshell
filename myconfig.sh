#!/bin/bash
#exit when any command fails
set -e
GIT_USER=jz
GIT_EMAIL=j@roc.one
cd $HOME
umask 0077

echo "* Installing basic packages"
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install p7zip-full qrencode

#install on-my-zsh
echo "* Install Oh-my-zsh"
sudo apt-get install -y zsh
sudo chsh -s /bin/zsh $USER
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "source /etc/zsh_command_not_found" >> $HOME/.zshrc
sed -i '1s/^/umask 0077\n/' $HOME/.zshrc
chmod -R go-rwx $HOME

# add aliases
echo "* Setup aliases"
echo "alias ll='ls -alFG'
alias u='apt update && apt dist-upgrade && apt autoremove && apt update && omz update'
alias qrencode='qrencode -t ansiutf8 -r'
" > $HOME/.oh-my-zsh/custom/aliases.zsh

# install powerlevel10k theme
echo "* Install powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/1' $HOME/.zshrc

# config powerlevel10k
echo "* Configure powerlevel10k"
delay="0.1"
tmux new-session -d -s p10k
tmux send-keys 'zsh --login' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys '2' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys '2' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys '1' C-m
sleep $delay
tmux send-keys 'y' C-m
sleep $delay
tmux send-keys 'tmux wait -S fin' C-m
tmux send-keys 'exit' C-m
tmux send-keys 'exit' C-m

tmux wait fin

if [ ! -r .p10k.zsh ]
then
        echo '- p10k config file generation failed'
        exit 1
fi

if [ ! -d $HOME/.cache/gitstatus/ ]
then
        echo '- gitstatus init failed'
        exit 1
fi

echo "export POWERLEVEL9K_DISABLE_GITSTATUS=true" >> $HOME/.zshrc


# Setup git global env
echo "* Configure other settings"
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USER

# Clean up
sudo apt-get autoremove

echo "* Finished"

# reboot for system updates
sudo reboot
