#!/bin/bash

#
# Fix kernel
#
apt install -y linux-headers-$(uname -r)
apt install -y nvidia-modprobe

# set binary path inside of the clusterdd
NVIDIA_DIR=/mnt/market_place/nvidia



apt install -y gnupg2
sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/debian10/x86_64/3bf863cc.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/debian10/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo apt update

echo ""
echo "Starting by installing NVIDIA drivers..."
echo ""


#cp /$NVIDIA_DIR/deps/NVIDIA-Linux-x86_64-470.74.run
#./NVIDIA-Linux-x86_64-470.74.run


sudo apt update -y && sudo apt upgrade -y

echo ""
echo "Now installing CUDA versions..."
echo ""

#sudo apt install -y cuda-toolkit-10-0
#sudo apt install -y cuda-toolkit-10-1
#sudo apt install -y cuda-toolkit-10-2
#sudo apt install -y cuda-toolkit-11-0
#sudo apt install -y cuda-toolkit-11-1
#sudo apt install -y cuda-toolkit-11-2
#sudo apt install -y cuda-toolkit-11-3
sudo apt install -y cuda-toolkit-11-4

echo ""
echo "Copying cudnn to expected path"
echo ""

#sudo cp -r $NVIDIA_DIR/deps/cudnn* /usr/local/ || RC=$?

#sudo cp $NVIDIA_DIR/deps/cudnn-7.4.2/cuda/include/cudnn* /usr/local/cuda-10.0/include
#sudo cp $NVIDIA_DIR/deps/cudnn-7.4.2/cuda/lib64/libcudnn* /usr/local/cuda-10.0/lib64
#sudo chmod a+r /usr/local/cuda-10.0/include/cudnn* /usr/local/cuda-10.0/lib64/libcudnn*

#sudo cp $NVIDIA_DIR/deps/cudnn-7.6.5/cuda/include/cudnn* /usr/local/cuda-10.1/include
#sudo cp $NVIDIA_DIR/deps/cudnn-7.6.5/cuda/lib64/libcudnn* /usr/local/cuda-10.1/lib64
#sudo chmod a+r /usr/local/cuda-10.1/include/cudnn* /usr/local/cuda-10.1/lib64/libcudnn*

#sudo cp $NVIDIA_DIR/deps/cudnn-8.0.5/cuda/include/cudnn* /usr/local/cuda-11.0/include
#sudo cp $NVIDIA_DIR/deps/cudnn-8.0.5/cuda/lib64/libcudnn* /usr/local/cuda-11.0/lib64
#sudo chmod a+r /usr/local/cuda-11.0/include/cudnn* /usr/local/cuda-11.0/lib64/libcudnn*

#sudo cp $NVIDIA_DIR/deps/cudnn-8.1.1/cuda/include/cudnn* /usr/local/cuda-11.2/include
#sudo cp $NVIDIA_DIR/deps/cudnn-8.1.1/cuda/lib64/libcudnn* /usr/local/cuda-11.2/lib64
#sudo chmod a+r /usr/local/cuda-11.2/include/cudnn* /usr/local/cuda-11.2/lib64/libcudnn*


cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/ /usr/local/
cp $NVIDIA_DIR/deps/cudnn-8.2.2/cuda/include/cudnn* /usr/local/cuda-11.4/include
cp $NVIDIA_DIR/deps/cudnn-8.2.2/cuda/lib64/libcudnn* /usr/local/cuda-11.4/lib64
sudo chmod a+r /usr/local/cuda-11.4/include/cudnn* /usr/local/cuda-11.4/lib64/libcudnn*



echo ""
echo "If there were no errors until here, you're probably done! :)"
echo ""


# setup modules
mkdir /etc/modulefiles/cuda
mkdir /etc/modulefiles/cudnn
cp files/modules/cuda/11.4 /etc/modulefiles/cuda
cp files/modules/cudnn/8.2.2 /etc/modulefiles/cudnn

# run twise to be sure 
source /mnt/market_place/nvidia/modprobe_nvidia_uvm.sh
source /mnt/market_place/nvidia/modprobe_nvidia_uvm.sh
