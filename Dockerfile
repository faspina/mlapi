FROM phusion/baseimage:bionic-1.0.0 
LABEL maintainer="dlandon"


ENV	DEBCONF_NONINTERACTIVE_SEEN="true" \
	DEBIAN_FRONTEND="noninteractive" \
	DISABLE_SSH="true" \
	HOME="/root" \
	LC_ALL="C.UTF-8" \
	LANG="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8" \
	TZ="Etc/UTC" \
	TERM="xterm" \
	PUID="99" \
	PGID="100"
	
COPY init/ /etc/my_init.d/
COPY defaults/ /root/
	
	
RUN	apt-get update && \
	apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
	apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold" && \
    apt-get install -y gnupg2 unzip curl make 


RUN apt-get install -y wget git build-essential \
    cmake python-dev python3-dev python3-pip libopenblas-dev \ 
	liblapack-dev libblas-dev libsm-dev zlib1g-dev libjpeg8-dev \ 
	libtiff5-dev libpng-dev

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -



# Install dependencies.
RUN mkdir /tmp/build \
    && apt-get update \
    && apt-get --assume-yes install \
        jq \
        sudo \
		nano \
		libedgetpu1-std \
        libcrypt-mysql-perl \
        libcrypt-eksblowfish-perl \
        libmodule-build-perl \
        libyaml-perl \
        libjson-perl \
        libfile-spec-native-perl \
        libgetopt-long-descriptive-perl \
        libconfig-inifiles-perl \
        liblwp-protocol-https-perl \
        python-numpy \
        python3 \
        python3-pip \
        python3-numpy \
        python-idna \
        python3-idna \
        libsm6 \
        libxrender1 \
        libfontconfig1 \
        supervisor \
        g++-6 \
        gcc-6 \
    && curl "https://bootstrap.pypa.io/get-pip.py" -o "$BUILD_DIR/get-pip.py" \
    && python "$BUILD_DIR/get-pip.py" \
    && python3 -m pip install --upgrade pip \
    && pip install future \
    && pip3 install future 


RUN  apt install -y git cmake make g++ \ 
     && git clone https://github.com/pliablepixels/mlapi \
     && cd mlapi \
     && pip3 install -r requirements.txt --upgrade --ignore-installed \
	 && pip3 install numpy --upgrade --ignore-installed \
 	 && pip3 install opencv-python --upgrade --ignore-installed 

RUN	apt-get -y clean && \
	apt-get -y autoremove && \
	rm -rf /tmp/* /var/tmp/* && \
	chmod +x /etc/my_init.d/*.sh

RUN apt install -y libgl1-mesa-glx

EXPOSE 5000

VOLUME \
  ["/mlapi"] \
  ["/config"]
  
CMD ["/sbin/my_init"]