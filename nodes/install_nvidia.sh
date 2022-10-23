#!/bin/bash

#
# Fix kernel
#
apt install -y linux-headers-$(uname -r)

bash /mnt/market_place/nvidia/deps/NVIDIA-Linux-x86_64-515.76.run


echo ""
echo "Copying cudnn to expected path"
echo ""

cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/ /usr/local/
cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/include/cudnn* /usr/local/cuda-11.7/include
cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/lib64/libcudnn* /usr/local/cuda-11.7/lib64
sudo chmod a+r /usr/local/cuda-11.7/include/cudnn* /usr/local/cuda-11.7/lib64/libcudnn*


cp files/nvidia /etc/init.d
chmod 775 /etc/init.d/nvidia
update-rc.d nvidia defaults

#sudo reboot now

