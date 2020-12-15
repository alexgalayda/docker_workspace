FROM ubuntu:20.04

ARG NAME
ARG PUB
ARG HOST
ARG PORT_JUP
ARG PROJECT_PATH
ARG HOST_NAME
ARG HOST_IP

RUN apt-get update --fix-missing && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-pip \
	    python3-dev \
        vim \
        git \
        openssh-server \
        gettext-base \
        iputils-ping \
        net-tools \
        #neovim \
        build-essential \
        make \
        curl \
        sudo

COPY ./config/.gitconfig /root/.gitconfig
COPY ./config/.vimrc /root/.vimrc

#install avesome vim
#RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
#RUN sh ~/.vim_runtime/install_awesome_vimrc.sh

#install python and pip
RUN echo alias python='/usr/bin/python3' >> /root/.bashrc
RUN pip3 install --upgrade pip

#install requirements
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

#copy config
COPY $PROJECT_PATH/config/config.env /root/config/config.env

#jupyter lab
RUN jupyter lab --generate-config
COPY $PROJECT_PATH/config/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
RUN envsubst < /root/.jupyter/jupyter_notebook_config.py > /root/.jupyter/jupyter_notebook_config.py

#SSH
RUN mkdir -m 600 /root/.ssh/
COPY $PUB /root/.ssh/authorized_keys

#make docker hook
COPY $HOST /root/.ssh/hostkey
RUN echo "#!/bin/bash\nssh -i /root/.ssh/hostkey $HOST_NAME@$HOST_IP \"bash -c \$@\"" >> /bin/runhost
RUN chmod +x /bin/runhost

# install docker client
#ARG DOCKER_CLI_VERSION="rootless-extras-19.03.9"
ARG DOCKER_CLI_VERSION 
RUN mkdir -p /tmp/download \
    	&& curl -L "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz" | tar -xz -C /tmp/download \
	&& mv /tmp/download/docker/docker /usr/bin/ \
    	&& rm -rf /tmp/download \
    	&& rm -rf /var/cache/apk/*

ARG DOCKER_COMPOSE_CLI_VERSION
RUN curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_CLI_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose

#SSH-server
RUN mkdir /var/run/sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

#make utils
COPY ./utils/switch_mount.py /usr/local/bin/switch_mount.py
RUN chmod +x /usr/local/bin/switch_mount.py

COPY ./utils/subdocker /usr/local/bin/docker                                                 
RUN chmod +x /usr/local/bin/docker

COPY ./utils/subdockercom /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

#RUN echo "#!/bin/bash\n/usr/bin/docker \$@" >> /usr/local/sbin/docker
#RUN chmod +x /usr/local/sbin/docker

#RUN echo "#!/bin/bash\n/usr/bin/docker-compose \$@" >> /usr/local/sbin/docker-compose
#RUN chmod +x /usr/local/sbin/docker-compose

#RUN useradd -ms /bin/bash lol

EXPOSE 22
CMD jupyter lab & /usr/sbin/sshd -D 
