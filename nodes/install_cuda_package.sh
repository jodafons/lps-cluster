

echo ""
echo "Starting NVIDIA drivers and libraries..."
echo ""

#
# Preparation
#
echo "blacklist nouveau
options nouveau modeset=0
" > /etc/modprobe.d/blacklist-nouveau.conf


apt install -y gnupg2
sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/3bf863cc.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo apt update --fix-missing
apt install -y nvidia-modprobe
apt install -y linux-headers-$(uname -r)
sudo apt update -y && sudo apt upgrade -y




echo ""
echo "Starting by installing NVIDIA drivers..."
echo ""
bash /mnt/market_place/nvidia/deps/NVIDIA-Linux-x86_64-515.76.run



echo ""
echo "Now installing CUDA versions..."
echo ""



sudo dpkg -i /mnt/market_place/nvidia/deps/cuda-repo-debian11-12-1-local_12.1.0-530.30.02-1_amd64.deb
sudo cp /var/cuda-repo-debian11-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo add-apt-repository contrib
sudo apt-get update
sudo apt-get -y install cuda




echo ""
echo "Copying cudnn to expected path"
echo ""

#cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/ /usr/local/
#cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/include/cudnn* /usr/local/cuda-11.7/include
#cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/lib64/libcudnn* /usr/local/cuda-11.7/lib64
#sudo chmod a+r /usr/local/cuda-11.7/include/cudnn* /usr/local/cuda-11.7/lib64/libcudnn*


ln -s /mnt/market_place/nvidia/deps/cudnn-8.2.2/ /usr/local/
ln -s /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/include/cudnn* /usr/local/cuda-11.7/include
ln -s /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/lib64/libcudnn* /usr/local/cuda-11.7/lib64
sudo chmod a+r /usr/local/cuda-11.7/include/cudnn* /usr/local/cuda-11.7/lib64/libcudnn*


echo ""
echo "Complete configuration..."
echo ""
cp files/nvidia /etc/init.d
chmod 775 /etc/init.d/nvidia
update-rc.d nvidia defaults
