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
        build-essential

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

#COPY ./requirements.txt requirements.txt
#RUN pip3 install --no-cache-dir -r requirements.txt
#RUN rm requirements.txt

#CMD /bin/bash
#jupyter lab
#RUN jupyter lab --generate-config
#COPY ./config/jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
#RUN envsubst < /root/.jupyter/jupyter_notebook_config.py > /root/.jupyter/jupyter_notebook_config.py

RUN /resources/init_doc.sh
CMD /usr/sbin/sshd -D
