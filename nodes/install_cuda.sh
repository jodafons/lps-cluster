


cp files/nvidia /etc/init.d
chmod 775 /etc/init.d/nvidia
update-rc.d nvidia defaults

#
# Disabe novauo
#

echo "blacklist nouveau
options nouveau modeset=0
" > /etc/modprobe.d/blacklist-nouveau.conf
apt install -y gnupg2
sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/3bf863cc.pub
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
sudo apt update --fix-missing
apt install -y nvidia-modprobe
sudo apt update -y && sudo apt upgrade -y


echo "Install CUDA..."

#bash /mnt/market_place/nvidia/deps/cuda_12.1.0_530.30.02_linux.run
apt-get -y install cuda-toolkit-12-1


ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/ /usr/local/
ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/cuda/include/cudnn* /usr/local/cuda-12.1/include
ln -s /mnt/market_place/nvidia/deps/cudnn-8.9.7.29_cuda12/cuda/lib64/libcudnn* /usr/local/cuda-12.1/lib64
sudo chmod a+r /usr/local/cuda-12.1/include/cudnn* /usr/local/cuda-12.1/lib64/libcudnn*




