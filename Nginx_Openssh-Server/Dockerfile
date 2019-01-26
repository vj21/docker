FROM nginx
LABEL maintainer="Vanderlei Junior<vanderlei.junior1510@gmail.com>"
RUN apt-get  update \
    && apt install -y openssh-server \
    && apt-get install sudo -y \
    && apt-get install vim -y \
    && useradd jenkins \ 
    && adduser jenkins sudo \
    && echo ' %jenkins  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers\
    && mkdir /home/jenkins \
    && mkdir /home/jenkins/.ssh \
    && chown -R jenkins:jenkins /home/jenkins/.ssh/ \
    && chmod 700 /home/jenkins/.ssh/ \