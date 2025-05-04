FROM fedora:42
RUN dnf -y update && dnf -y upgrade
RUN sudo dnf -y install java-latest-openjdk.x86_64 maven postgresql.x86_64 ncurses openssh-server ssh
RUN useradd -ms /bin/bash dev
RUN echo "dev        ALL=(ALL)       NOPASSWD:ALL">>/etc/sudoers
RUN sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config
USER dev
WORKDIR /home/dev
RUN mkdir .ssh && touch .ssh/authorized_keys
EXPOSE 8081 22
ENTRYPOINT sudo cd /etc/ssh/ && sudo ssh-keygen -A && sudo /usr/sbin/sshd && sleep infinity