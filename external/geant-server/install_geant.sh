


#
# Based on Ubuntu > 22
#

CPU_N=$(grep -c ^processor /proc/cpuinfo)


# Install all dependencies 
apt-get install -y wget git dpkg-dev g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev python-dev-is-python3 libboost-all-dev librange-v3-dev libboost-python-dev libxerces-c-dev curl

apt-get install -y dpkg-dev cmake g++ gcc binutils libx11-dev libxpm-dev \
        libxft-dev libxext-dev python3 libssl-dev gfortran libpcre3-dev \
        xlibmesa-glu-dev libglew-dev libftgl-dev \
        libmysqlclient-dev libfftw3-dev libcfitsio-dev \
        graphviz-dev libavahi-compat-libdnssd-dev \
        libldap2-dev libxml2-dev libkrb5-dev \
        libgsl0-dev qtwebengine5-dev install python3-pip

pip install numpy tqdm
 

# create base folder for custom
mkdir /physics && cd /physics
export BASEPATH=$PWD


# install ROOT
mkdir root && cd root
git clone https://github.com/root-project/root.git && cd root &&  git checkout v6-29-01
cd .. && mkdir build && cd build
cmake  -Dpython_version=3 -Dxrootd=OFF -Dbuiltin_xrootd=OFF ../root
make -j$CPU_N
source /physics/root/build/bin/thisroot.sh


# Install Geant4
cd $BASEPATH
mkdir geant && cd geant
git clone https://github.com/Geant4/geant4.git && cd geant4 && git checkout v11.0.4ls
mkdir build && cd build
cmake -DGEANT4_INSTALL_DATA=ON -DGEANT4_BUILD_MULTITHREADED=ON -DGEANT4_USE_SYSTEM_ZLIB=ON -DGEANT4_USE_QT=ON -DGEANT4_USE_GDML=ON -DGEANT4_BUILD_MUONIC_ATOMS_IN_USE=ON ../geant4
make -j$CPU_N
make install



# Install FastJet
cd $BASEPATH
curl -O http://fastjet.fr/repo/fastjet-3.3.3.tar.gz && tar zxvf fastjet-3.3.3.tar.gz && cd fastjet-3.3.3/ && ./configure && make -j$CPU_N && make install


# Install Pythia
cd $BASEPATH
mkdir hepmc && cd hepmc
git clone https://github.com/lorenzetti-hep/hepmc3.git && hepmc3 && git checkout 3.2.5
cd .. && mkdir build && cd build 
cmake -DHEPMC3_ENABLE_ROOTIO=ON -DHEPMC3_INSTALL_INTERFACES=ON -DHEPMC3_ENABLE_PROTOBUFIO=ON ../hepmc
make -j$CPU_N
make install



# Install PYTHIA
git clone https://github.com/lorenzetti-hep/pythia8.git
cd pythia8 && ./configure --with-python-config=python3-config && make -j$CPU_N


cd $BASEPATH


















