FROM rockylinux:9.1.20230215

ENV username=Arthur

RUN yum install -y sudo telnet openssh-server vim git rsyslog
RUN useradd ${username}

# add ssh key
COPY files/authorized_keys /home/${username}/.ssh/
RUN chown -R ${username}:${username} /home/${username}/.ssh/ && chmod 700 /home/${username}/.ssh/ && chmod 600 /home/${username}/.ssh/authorized_keys
COPY files/id_rsa /home/${username}/.ssh/
RUN chmod 600 /home/${username}/.ssh/id_rsa && chown ${username}:${username} /home/${username}/.ssh/id_rsa
COPY files/start.sh /root/

# add node install script in to user home
COPY files/node_install.sh /home/${username}/
RUN chown ${username}:${username} /home/${username}/node_install.sh && chmod 755 /home/${username}/node_install.sh

# Enable sshd
COPY files/sshd_config /etc/ssh/
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa 

# Add account into sudoers and this account don't need to type password
COPY files/sudoers /etc/


# create a /u01 folder for deploy
RUN mkdir /u01 && chown ${username}:${username} /u01
