
# No kerberos here...

#
# Add some panic contraints in case of fail
#
echo "vm.panic_on_oom=1   ;enables panic on OOM">>/etc/sysctl.conf
echo "kernel.panic=10     ;tells the kernel to reboot ten seconds after panicking">>/etc/sysctl.conf


# install others
apt install -y htop vim sshpass ansible python3-virtualenv htop curl wget git python-is-python3 screen rsync
mkdir /etc/ansible


#
# Append market_place into the mount
#

apt install -y nfs-common
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
#echo "10.1.1.202:/volume1/homes /mnt/home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab


# configure NTP
cp ntp/timesynd.conf /etc/systemd/
timedatectl set-ntp true
timedatectl status



reboot now
