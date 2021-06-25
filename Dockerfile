ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update --fix-missing && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        python3-setuptools \
        openssh-server \
        gettext-base \
        iputils-ping \
        net-tools \
        build-essential \
        #libgl1-mesa-glx \
        #libgdal-dev \
        nodejs

# install docker client
#ARG DOCKER_CLI_VERSION="rootless-extras-20.10.7"
ARG DOCKER_CLI_VERSION
RUN mkdir -p /tmp/download \
    && curl -L "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz" | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/bin/ \
    && rm -rf /tmp/download \
    && rm -rf /var/cache/apk/*

ARG DOCKER_COMPOSE_CLI_VERSION
RUN curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_CLI_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
RUN chmod +x /usr/bin/docker-compose

#For GDAL
#ARG CPLUS_INCLUDE_PATH=/usr/include/gdal
#ARG C_INCLUDE_PATH=/usr/include/gdal

#Install python package
ARG USERNAME
RUN runuser -l $USERNAME -c 'pip3 install --no-warn-script-location torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html'
RUN runuser -l $USERNAME -c 'pip3 install --no-warn-script-location --no-cache-dir -r /resources/config/requirements.txt'
#RUN pip3 install --no-cache-dir -r /resources/config/requirements.txt

#jupyter lab
ARG JUP_PORT
RUN runuser -l $USERNAME -c 'jupyter lab --generate-config'
RUN envsubst < /resources/config/jupyter_lab_config.py > /home/$USERNAME/.jupyter/jupyter_lab_config.py

RUN /resources/init_doc.sh
CMD /usr/sbin/sshd -D
