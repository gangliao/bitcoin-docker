FROM ubuntu:16.04
MAINTAINER Gang Liao <gangliao@cs.umd.edu>

ARG UBUNTU_MIRROR
RUN /bin/bash -c 'if [[ -n ${UBUNTU_MIRROR} ]]; then sed -i 's#http://archive.ubuntu.com/ubuntu#${UBUNTU_MIRROR}#g' /etc/apt/sources.list; fi'

RUN apt-get update && apt-get install -y --no-install-recommends \
    git python3-pip python3-dev openssh-server g++ pkg-config \
    wget unzip unrar tar xz-utils bzip2 gzip coreutils \
    curl sed grep vim librdmacm-dev libibverbs-dev libboost-all-dev \
    automake locales clang-format cmake libtool bsdmainutils libevent-dev \
    openssl libssl-dev libcurl4-openssl-dev \
    && apt-get clean -y

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

# berkeley-db/db-4.8.30
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
RUN unzip db-4.8.30.zip && cd db-4.8.30/build_unix/
RUN ../dist/configure --prefix=/usr/local --enable-cxx
RUN make -j8 && make install

# git credential to skip password typing
RUN git config --global credential.helper store

# https://docs.docker.com/engine/examples/running_ssh_service/#build-an-eg_sshd-image
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

RUN echo "cd /" >> /etc/profile

RUN mkdir /root/.ssh/
RUN touch /root/.ssh/environment

CMD env >> /root/.ssh/environment; export -p | grep _ >> /etc/profile; /usr/sbin/sshd -D;

