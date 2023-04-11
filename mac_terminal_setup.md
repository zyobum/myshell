# mac terminal setup

## homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
## terminal
* change system name
```bash
sudo scutil --set HostName <new host name> 
```
* oh-my-zsh
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
* add ~/.oh-my-zsh/custom/aliases.zsh
```bash
alias ll='ls -alFG'
alias ubrew='brew autoremove && brew cleanup && brew update && brew upgrade && brew cleanup && brew autoremove && brew cleanup && brew doctor && omz update && (cd ~/.oh-my-zsh/custom/themes/powerlevel10k ; git pull)'
alias qrencode='qrencode -t ansi256utf8 -r'
```
* MesloLGS NF Fonts
```bash
brew install homebrew/cask-fonts/font-meslo-lg-nerd-font
```
or
```
https://github.com/romkatv/powerlevel10k/blob/master/font.md
```
 * powerlevel10k
```bash
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```
* Import terminal profiles.

## misc packages
```bash
brew install --cask xquartz insomnia pulsar
brew install qrencode p7zip glow RfidResearchGroup/proxmark3/proxmark3 ffmpeg
```
* Misc configuration
```bash
git config --global user.email "j@roc.one"
git config --global user.name "jz"
```
## linux shell
Read more [here](./README.md)
## docker
```bash
brew install docker
docker context create lima-default --docker "host=unix://$HOME/.lima/default/sock/docker.sock"
docker context use lima-default
```
