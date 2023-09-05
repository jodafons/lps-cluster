#
# Ubuntu 20.04
#

current_path=$PWD


# update all palsckages
apt-get update -y --fix-missing


# Install all dependencies 
apt-get install -y wget 
apt-get install -y build-essential 
apt-get install -y dpkg-dev 
apt-get install -y cmake 
apt-get install -y git 
apt-get install -y curl 
apt-get install -y dpkg-dev 
apt-get install -y g++ 
apt-get install -y gcc 
apt-get install -y binutils 
apt-get install -y libx11-dev 
apt-get install -y libxpm-dev 
apt-get install -y libxft-dev 
apt-get install -y libxext-dev 
apt-get install -y python3 
apt-get install -y python-dev-is-python3 
apt-get install -y python3-pip 
apt-get install -y librange-v3-dev 
apt-get install -y libboost-python-dev 
apt-get install -y libxft-dev 
apt-get install -y libxext-dev  
apt-get install -y libssl-dev 
apt-get install -y gfortran 
apt-get install -y libpcre3-dev
apt-get install -y libglu1-mesa-dev 
apt-get install -y libglew-dev 
apt-get install -y libftgl-dev 
apt-get install -y libxerces-c-dev
apt-get install -y libmysqlclient-dev 
apt-get install -y libfftw3-dev 
apt-get install -y libcfitsio-dev
apt-get install -y libgraphviz-dev 
apt-get install -y libavahi-compat-libdnssd-dev
apt-get install -y libldap2-dev 
apt-get install -y libxml2-dev 
apt-get install -y libkrb5-dev 
apt-get install -y libgsl-dev 
apt-get install -y rsync
apt-get install -y libboost-all-dev
apt-get install -y xorg

# Install QT5
apt-get install -y  mesa-common-dev qtcreator qt5-default



mkdir -p /physics/root && cd /physics/root

# install ROOT
git clone https://github.com/root-project/root.git && cd root && git checkout v6-28-02 && cd ..
mkdir build && cd build && cmake  -Dpython_version=3 -Dxrootd=OFF -Dbuiltin_xrootd=OFF ../root && make -j$(nproc)
source /physics/root/build/bin/thisroot.sh


# Install Geant4
mkdir /physics/geant && cd /physics/geant
git clone https://github.com/lorenzetti-hep/geant4.git
mkdir build && cd build && cmake -DGEANT4_INSTALL_DATA=ON \
-DGEANT4_BUILD_MULTITHREADED=ON -DGEANT4_USE_SYSTEM_ZLIB=ON DGEANT4_USE_OPENGL_X11=ON \
-DGEANT4_USE_QT=ON -DGEANT4_USE_GDML=ON -DGEANT4_BUILD_MUONIC_ATOMS_IN_USE=ON ../geant4 && make -j$(nproc)
cp ../geant4/scripts/geant4_10.5.1.sh geant4.sh && source geant4.sh


# Install Pythia8
cd /physics
git clone https://github.com/lorenzetti-hep/pythia8.git && cd pythia8 && ./configure --with-python-config=python3-config && make -j$(nproc)

# Install FastJet
cd /physics
curl -O http://fastjet.fr/repo/fastjet-3.3.3.tar.gz && tar zxvf fastjet-3.3.3.tar.gz && cd fastjet-3.3.3/ && ./configure && make -j$(nproc) && make install


# Install HEPMC
mkdir -p /physics/hepmc && cd /physics/hepmc
git clone https://github.com/lorenzetti-hep/hepmc3.git && cd hepmc3 && git checkout 3.2.5 && cd ..
mkdir build && cd build && cmake -DHEPMC3_ENABLE_ROOTIO=ON -DHEPMC3_INSTALL_INTERFACES=ON -DHEPMC3_ENABLE_PROTOBUFIO=ON ../hepmc3 && make -j$(nproc) && make install


# Install pip packages
pip install --no-cache-dir setuptools pandas numpy sklearn seaborn jupyterlab tqdm atlas-mpl-style twine pyhepmc colorama

cd $current_path
# setup all environments before start bash terminal
cp files/setup_envs.sh /
chmod 774 /setup_envs.sh










