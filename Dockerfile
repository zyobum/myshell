# Version 0.9.0
FROM ubuntu
LABEL maintainer="j@roc.one"
ENV REFRESHED_AT 2022-05-27

RUN apt update && apt install -y apt-utils && apt -y dist-upgrade && apt -y autoremove
RUN echo y | unminimize
RUN DEBIAN_FRONTEND=noninteractive apt install -y zsh git dialog curl tmux tzdata
RUN chsh -s /bin/zsh
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

#install on-my-zsh
RUN cd ~ && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN echo "source /etc/zsh_command_not_found" >> $HOME/.zshrc

# add aliases
COPY aliases.zsh /tmp
RUN cp /tmp/aliases.zsh $HOME/.oh-my-zsh/custom ; rm /tmp/aliases.zsh

# install powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
RUN sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/1' $HOME/.zshrc
COPY p10kconfig.zsh gitstatus.zsh /tmp
RUN chmod +x /tmp/p10kconfig.zsh ; /tmp/p10kconfig.zsh ; rm /tmp/p10kconfig.zsh
#  first run to install gitstatusd
RUN chmod +x /tmp/gitstatus.zsh ; /tmp/gitstatus.zsh

# install required packages
RUN apt update \
	&& apt install -y command-not-found qrencode man-db vim lsb-release ca-certificates gnupg iptables wget supervisor

#install docker and compose
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# setup init
COPY modprobe startup.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/modprobe
VOLUME /var/lib/docker

RUN apt clean && rm -rf /var/lib/apt/lists

CMD ["startup.sh"]

