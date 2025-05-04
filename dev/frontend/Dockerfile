FROM fedora:42
RUN dnf update && dnf upgrade

RUN dnf module install nodejs:22.15.0/common ncurses openssh-server ssh

 
RUN useradd -ms /bin/bash dev
RUN echo "dev        ALL=(ALL)       NOPASSWD:ALL">>/etc/sudoers
RUN echo "dev:password" | chpasswd
RUN sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config
USER dev
WORKDIR ~
RUN mkdir .ssh && touch .ssh/authorized_keys
EXPOSE 8080 22
ENTRYPOINT sudo cd /etc/ssh/ && sudo ssh-keygen -A && sudo /usr/sbin/sshd && sleep infinity