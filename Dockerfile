FROM rockylinux:9.1.20230215

RUN yum install -y sudo telnet openssh-server vim git rsyslog
RUN useradd z01241

# add ssh key
COPY files/authorized_keys /home/z01241/.ssh/
RUN chown -R z01241:z01241 /home/z01241/.ssh/ && chmod 700 /home/z01241/.ssh/ && chmod 600 /home/z01241/.ssh/authorized_keys
COPY files/id_rsa /home/z01241/.ssh/
RUN chmod 600 /home/z01241/.ssh/id_rsa && chown z01241:z01241 /home/z01241/.ssh/id_rsa
COPY files/start.sh /root/

# add node install script in to user home
COPY files/node_install.sh /home/z01241/
RUN chown z01241:z01241 /home/z01241/node_install.sh && chmod 755 /home/z01241/node_install.sh

# Enable sshd
COPY files/sshd_config /etc/ssh/
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa 
RUN echo "z01241:pass" | chpasswd

# Add account into sudoers and this account don't need to type password
COPY files/sudoers /etc/


# create a /u01 folder for deploy
RUN mkdir /u01 && chown z01241:z01241 /u01
