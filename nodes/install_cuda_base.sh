


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


