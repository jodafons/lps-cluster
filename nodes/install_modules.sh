
basepath=$PWD
cd /tmp

#
# Install dependencies
#
apt install -y tcl8.6-dev


#
# Install modules
#
wget https://github.com/cea-hpc/modules/releases/download/v5.1.1/modules-5.1.1.tar.gz
tar xfz modules-5.1.1.tar.gz
cd modules-5.1.1
./configure --prefix=/usr/share/Modules \
              --modulefilesdir=/etc/modulefiles
make
make install
ln -s /usr/share/Modules/init/profile.sh /etc/profile.d/modules.sh
ln -s /usr/share/Modules/init/profile.csh /etc/profile.d/modules.csh
sh /usr/share/Modules/init/bash




# setup modules
#mkdir /etc/modulefiles/cuda
#cp modules/cuda/11.4 /etc/modulefiles/cuda

cd $basepath
