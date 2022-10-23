#!/bin/bash

#
# Fix kernel
#
#apt install -y linux-headers-$(uname -r)



#
# Disabe novauo
#

#echo "blacklist nouveau
#options nouveau modeset=0
#" > /etc/modprobe.d/blacklist-nouveau.conf


# set binary path inside of the clusterdd
#NVIDIA_DIR=/mnt/market_place/nvidia

#bash /mnt/market_place/nvidia/deps/NVIDIA-Linux-x86_64-515.76.run


apt install -y gnupg2
sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/3bf863cc.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64 /" > /etc/apt/sources.list.d/cuda.list'

sudo apt update

apt install -y nvidia-modprobe
echo ""
echo "Starting by installing NVIDIA drivers..."
echo ""


sudo apt update -y && sudo apt upgrade -y

echo ""
echo "Now installing CUDA versions..."
echo ""

sudo apt install -y cuda-toolkit-11-7

echo ""
echo "Copying cudnn to expected path"
echo ""

ln -s /mnt/market_place/nvidia/deps/cudnn-8.2.2/ /usr/local/cudnn-8.2.2
ln -s /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/lib64/libcudnn* /usr/local/cuda-11.7/lib64
ln -s /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/include/cudnn* /usr/local/cuda-11.7/include
sudo chmod a+r /usr/local/cuda-11.7/include/cudnn* 
sudo chmod a+r /usr/local/cuda-11.7/lib64/libcudnn*



echo ""
echo "If there were no errors until here, you're probably done! :)"
echo ""


# setup modules
#mkdir /etc/modulefiles/cuda
#mkdir /etc/modulefiles/cudnn
#cp files/modules/cuda/11.7 /etc/modulefiles/cuda
#cp files/modules/cudnn/8.2.2 /etc/modulefiles/cudnn


cp files/nvidia /etc/init.d
chmod 775 /etc/init.d/nvidia
update-rc.d nvidia defaults

sudo reboot now

