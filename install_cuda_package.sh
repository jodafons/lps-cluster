




cp files/nvidia /etc/init.d
chmod 775 /etc/init.d/nvidia
update-rc.d nvidia defaults


echo ""
echo "Starting NVIDIA drivers and libraries..."
echo ""

apt install -y gnupg2
sudo apt-get -y install software-properties-common
sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/3bf863cc.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo apt update --fix-missing
apt install -y nvidia-modprobe
sudo apt update -y && sudo apt upgrade -y





echo ""
echo "Now installing CUDA versions..."
echo ""

# Cuda 11.8
#wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb
#sudo dpkg -i /mnt/market_place/nvidia/deps/cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb
#sudo cp /var/cuda-repo-debian11-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
#sudo add-apt-repository contrib
#sudo apt-get update
#sudo apt-get -y install cuda


# Cuda 12.1
sudo dpkg -i /mnt/market_place/nvidia/deps/cuda-repo-debian11-12-1-local_12.1.0-530.30.02-1_amd64.deb
sudo cp /var/cuda-repo-debian11-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo add-apt-repository contrib
sudo apt-get update
sudo apt-get -y install cuda


# Cuda 12.3
#sudo dpkg -i /mnt/market_place/nvidia/deps/cuda-repo-debian11-12-3-local_12.3.2-545.23.08-1_amd64.deb
#sudo cp /var/cuda-repo-debian11-12-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
#sudo add-apt-repository contrib
#sudo apt-get update
#sudo apt-get -y install cuda-toolkit-12-3



echo ""
echo "Copying cudnn to expected path"
echo ""

#cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/ /usr/local/
#cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/include/cudnn* /usr/local/cuda-11.7/include
#cp -r /mnt/market_place/nvidia/deps/cudnn-8.2.2/cuda/lib64/libcudnn* /usr/local/cuda-11.7/lib64
#sudo chmod a+r /usr/local/cuda-11.7/include/cudnn* /usr/local/cuda-11.7/lib64/libcudnn*


ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/ /usr/local/
ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/cuda/include/cudnn* /usr/local/cuda-12.1/include
ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/cuda/lib64/libcudnn* /usr/local/cuda-12.1/lib64
sudo chmod a+r /usr/local/cuda-12.1/include/cudnn* /usr/local/cuda-12.1/lib64/libcudnn*


echo ""
echo "Complete configuration..."
echo ""
cp files/nvidia /etc/init.d
chmod 775 /etc/init.d/nvidia
update-rc.d nvidia defaults
