
basedir=$PWD
apt install -y tcl8.6-dev

cd /tmp
wget https://github.com/cea-hpc/modules/releases/download/v5.1.1/modules-5.1.1.tar.gz
tar xfz modules-5.1.1.tar.gz
cd modules-5.1.1
./configure --prefix=/usr/share/Modules \
              --modulefilesdir=/etc/modulefiles
make
make install
ln -s /usr/share/Modules/init/profile.sh /etc/profile.d/modules.sh
ln -s /usr/share/Modules/init/profile.csh /etc/profile.d/modules.csh
source /usr/share/Modules/init/bash
cd $basedir


# setup modules
#mkdir /etc/modulefiles/cuda
#cp modules/cuda/11.4 /etc/modulefiles/cuda