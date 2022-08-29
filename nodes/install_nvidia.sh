#!/bin/bash

sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/debian10/x86_64/3bf863cc.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/debian10/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo apt update

echo ""
echo "Starting by installing NVIDIA drivers..."
echo ""

NVIDIA_DIR=/mnt/market_place/nvidia

#sudo $NVIDIA_DIR/deps/NVIDIA-Linux-x86_64-470.74.run || RC=$?

if [ "${RC}" -ne 0 ]; then
  echo "Error code was $RC, which differs from 0, exiting...";
  exit $RC;
fi

sudo apt update -y && sudo apt upgrade -y

echo ""
echo "Now installing CUDA versions..."
echo ""

#sudo apt install -y cuda-toolkit-10-0
#sudo apt install -y cuda-toolkit-10-1
#sudo apt install -y cuda-toolkit-10-2
#sudo apt install -y cuda-toolkit-11-0
sudo apt install -y cuda-toolkit-11-1
sudo apt install -y cuda-toolkit-11-2
sudo apt install -y cuda-toolkit-11-3
sudo apt install -y cuda-toolkit-11-4

echo ""
echo "Copying cudnn to expected path"
echo ""

sudo cp -r $NVIDIA_DIR/deps/cudnn* /usr/local/ || RC=$?

#sudo cp $NVIDIA_DIR/deps/cudnn-7.4.2/cuda/include/cudnn* /usr/local/cuda-10.0/include
#sudo cp $NVIDIA_DIR/deps/cudnn-7.4.2/cuda/lib64/libcudnn* /usr/local/cuda-10.0/lib64
#sudo chmod a+r /usr/local/cuda-10.0/include/cudnn* /usr/local/cuda-10.0/lib64/libcudnn*

#sudo cp $NVIDIA_DIR/deps/cudnn-7.6.5/cuda/include/cudnn* /usr/local/cuda-10.1/include
#sudo cp $NVIDIA_DIR/deps/cudnn-7.6.5/cuda/lib64/libcudnn* /usr/local/cuda-10.1/lib64
#sudo chmod a+r /usr/local/cuda-10.1/include/cudnn* /usr/local/cuda-10.1/lib64/libcudnn*

#sudo cp $NVIDIA_DIR/deps/cudnn-8.0.5/cuda/include/cudnn* /usr/local/cuda-11.0/include
#sudo cp $NVIDIA_DIR/deps/cudnn-8.0.5/cuda/lib64/libcudnn* /usr/local/cuda-11.0/lib64
#sudo chmod a+r /usr/local/cuda-11.0/include/cudnn* /usr/local/cuda-11.0/lib64/libcudnn*

sudo cp $NVIDIA_DIR/deps/cudnn-8.1.1/cuda/include/cudnn* /usr/local/cuda-11.2/include
sudo cp $NVIDIA_DIR/deps/cudnn-8.1.1/cuda/lib64/libcudnn* /usr/local/cuda-11.2/lib64
sudo chmod a+r /usr/local/cuda-11.2/include/cudnn* /usr/local/cuda-11.2/lib64/libcudnn*

sudo cp $NVIDIA_DIR/deps/cudnn-8.2.2/cuda/include/cudnn* /usr/local/cuda-11.4/include
sudo cp $NVIDIA_DIR/deps/cudnn-8.2.2/cuda/lib64/libcudnn* /usr/local/cuda-11.4/lib64
sudo chmod a+r /usr/local/cuda-11.4/include/cudnn* /usr/local/cuda-11.4/lib64/libcudnn*

if [ "${RC}" -ne 0 ]; then
  echo "Error code was $RC, which differs from 0, exiting...";
  exit $RC;
fi

echo ""
echo "If there were no errors until here, you're probably done! :)"
echo ""
