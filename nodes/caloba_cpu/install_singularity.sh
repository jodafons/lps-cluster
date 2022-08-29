base=$PWD
export GOVERSION=1.17.3 OS=linux ARCH=amd64  # change this as you need
export SINGVERSION=v3.8.4

# Ensure repositories are up-to-date
sudo apt-get update
# Install debian packages for dependencies
sudo apt-get install -y \
    build-essential \
    libseccomp-dev \
    pkg-config \
    squashfs-tools \
    cryptsetup \
    curl wget git

#
# Install go
#
wget -O /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz \
  https://dl.google.com/go/go${GOVERSION}.${OS}-${ARCH}.tar.gz
sudo tar -C /usr/local -xzf /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

#
# Install Singularity
#
cd /tmp/
git clone https://github.com/hpcng/singularity.git
cd singularity
git checkout $SINGVERSION
./mconfig
make -C ./builddir
make -C ./builddir install
singularity --version

cd $base

