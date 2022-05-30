# Version 0.9.5
FROM ubuntu
LABEL maintainer="j@roc.one"
ENV REFRESHED_AT 2022-05-29

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
 ; apt-get update && apt-get install -y apt-utils dialog man-db curl gpg
RUN apt-get install -y curl zsh git tmux tzdata \
  command-not-found qrencode vim lsb-release ca-certificates gnupg iptables wget supervisor iputils-ping \
  && apt-get -y dist-upgrade
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN echo y | unminimize
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
RUN chsh -s /bin/zsh
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

#install on-my-zsh
RUN cd ~ && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN echo "source /etc/zsh_command_not_found" >> $HOME/.zshrc ; sed -i '1s/^/umask 0077\n/' $HOME/.zshrc ; chmod -R go-rwx $HOME

# add aliases
COPY aliases.zsh /tmp/
RUN cp /tmp/aliases.zsh $HOME/.oh-my-zsh/custom ; rm /tmp/aliases.zsh

# install powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
RUN sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/1' $HOME/.zshrc
COPY p10kconfig.zsh gitstatus.zsh /tmp/
RUN chmod +x /tmp/p10kconfig.zsh ; /tmp/p10kconfig.zsh ; rm /tmp/p10kconfig.zsh
#  first run to install gitstatusd
RUN chmod +x /tmp/gitstatus.zsh ; /tmp/gitstatus.zsh
# disable gitstatus by default
RUN echo "export POWERLEVEL9K_DISABLE_GITSTATUS=true" >> $HOME/.zshrc

# setup init
COPY modprobe startup.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/modprobe
VOLUME /var/lib/docker

RUN apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists

CMD ["startup.sh"]

