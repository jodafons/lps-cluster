FROM tensorflow/tensorflow:2.9.2-gpu

LABEL maintainer "Joao Victor da Fonseca Pinto <jodafons@lps.ufrj.br>"

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TERM screen
USER root
SHELL [ "/bin/bash", "-c" ]


RUN ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && echo "Etc/UTC" > /etc/timezone

RUN apt-get update --fix-missing

RUN apt-get install -y git \
                       wget \
                       dpkg-dev \
                       g++ \
                       gcc \
                       binutils \
                       libx11-dev \
                       libxpm-dev \
                       libxft-dev \
                       libxext-dev \
                       gfortran \
                       libssl-dev \
                       libpcre3-dev \
                       libglew1.5-dev \
                       libftgl-dev \
                       libldap2-dev \
                       python-dev \
                       libxml2-dev \
                       libkrb5-dev \
                       libgsl0-dev \
                       libfftw3-dev \
                       libcfitsio-dev \
                       graphviz-dev \
                       libavahi-compat-libdnssd-dev \
                       libboost-all-dev \
                       vim \
                       librange-v3-dev \
                       libboost-python-dev \
                       libxerces-c-dev \
                       xlibmesa-glu-dev  \
                       libmysqlclient-dev \
                       qtwebengine5-dev



# Installing cmake
RUN wget --progress=dot:giga https://cmake.org/files/v3.19/cmake-3.19.7-Linux-x86_64.sh -P /usr/
RUN chmod 755 /usr/cmake-3.19.7-Linux-x86_64.sh
RUN cd /usr && ./cmake-3.19.7-Linux-x86_64.sh --skip-license
RUN ln -sf /usr/bin/python3 /usr/bin/python



# Install ROOT
RUN cd /opt && git clone https://github.com/root-project/root.git && cd root && git checkout v6-16-00 && mkdir buildthis 
RUN cd /opt/root/buildthis && CPU_N=$(grep -c ^processor /proc/cpuinfo) && cmake  --Dpython_version=3 .. && make -j$CPU_N



# Install Geant4
RUN CPU_N=$(grep -c ^processor /proc/cpuinfo) && cd /opt && git clone https://github.com/lorenzetti-hep/geant4.git && cd geant4 && mkdir buildthis && cd buildthis && cmake -DGEANT4_INSTALL_DATA=ON \
 -DGEANT4_BUILD_MULTITHREADED=ON -DGEANT4_USE_SYSTEM_ZLIB=ON -DGEANT4_USE_QT=OFF -DGEANT4_USE_GDML=ON -DGEANT4_BUILD_MUONIC_ATOMS_IN_USE=ON .. && make -j$CPU_N && \
cp ../scripts/geant4_10.5.1.sh geant4.sh && source geant4.sh


RUN ln -sf /usr/bin/pip3 /usr/bin/pip
RUN pip3 install -U pip setuptools

# Install pip packages
RUN pip3 install --no-cache-dir \
    setuptools \
    future \
    onnxruntime \
    onnx \
    keras2onnx \
    pandas \
    sklearn \
    seaborn \
    jupyterlab \
    Flask_Security \
    passlib \
    PTable \
    Flask_Mail \
    requests \
    Werkzeug \
    SQLAlchemy \
    Jinja2 \
    Flask \
    Flask_Login \
    Flask_SQLAlchemy \
    BeneDict \
    flask_admin \
    flask_bootstrap \
    flask_cors \
    flask_restful \
    prettytable \
    sqlalchemy_utils \
    psycopg2-binary \
    ansi2html \
    hub \
    pickle5 \
    tqdm \
    twine \
    atlas-mpl-style  

RUN pip install wandb

WORKDIR /
COPY setup_root.sh .
RUN chmod 777 /setup_root.sh