FROM ubuntu:16.04
LABEL maintainer="Vanderlei Junior<vanderlei.junior1510@gmail.com>"

ARG jenkins_password="jenkins"
ARG node_file_start="/data/production/www/server.js"
#install open ssh
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
#install sudo and create user jenkis for deploy
RUN  apt-get install -y sudo \
    && apt-get install -y vim\
    && useradd jenkins \ 
    && adduser jenkins sudo \
    && echo ' %jenkins  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers\
    && mkdir /home/jenkins \
    && mkdir /home/jenkins/.ssh \
    && chown -R jenkins:jenkins /home/jenkins/.ssh/ \
    && chmod 700 /home/jenkins/.ssh/ \
    && echo "jenkins:$jenkins_password"  | chpasswd
#install curl and node
RUN apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | sudo bash - \
    && sudo apt install -y nodejs

#Create directoryes for deploy
RUN mkdir -p /data/production/www/ \
    && mkdir -p /data/build/\
    && mkdir -p /scripts/

RUN echo "#!/bin/bash" >> /scripts/start.sh \
    && echo "node /data/production/www/server.js" >> /scripts/start.sh

#create server initial from node 
RUN echo "var http = require('http');" >> $node_file_start\
&& echo "http.createServer(function (req, res) {" >> $node_file_start\
&& echo "  res.writeHead(200, {'Content-Type': 'text/plain'});" >> $node_file_start\
&& echo "  res.write('Hello World!');" >> $node_file_start\
&& echo "  res.end();" >> $node_file_start\
&& echo "}).listen(8084);" >> $node_file_start
EXPOSE 2222
EXPOSE 8084
CMD ["/usr/sbin/sshd", "-D"]
RUN chmod +x /scripts/start.sh
ENTRYPOINT ["/scripts/start.sh"]