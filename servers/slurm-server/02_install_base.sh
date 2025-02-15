
# No kerberos here...

#
# Add some panic contraints in case of fail
#
echo "vm.panic_on_oom=1   ;enables panic on OOM">>/etc/sysctl.conf
echo "kernel.panic=10     ;tells the kernel to reboot ten seconds after panicking">>/etc/sysctl.conf


# install others
apt install -y htop vim sshpass ansible python3-virtualenv htop curl wget git python-is-python3 screen rsync


#
# Append market_place into the mount
#

apt install -y nfs-common
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
#echo "10.1.1.202:/volume1/homes /mnt/home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab




# install LDAP
apt install -y libnss-ldap
apt install -y libnss-ldapd
/etc/init.d/nscd restart
/etc/init.d/ssh restart
echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=022" >> /etc/pam.d/common-session



# Configure home folder
mkdir /etc/pam_scripts
chmod -R 700 /etc/pam_scripts
chown -R root:root /etc/pam_scripts
cp conf_files/login-logger.sh /etc/pam_scripts
chmod +x /etc/pam_scripts/login-logger.sh
#echo "session required pam_exec.so /etc/pam_scripts/login-logger.sh" >> /etc/pam.d/sshd


# configure NTP
cp ntp/timesynd.conf /etc/systemd/
timedatectl set-ntp true
timedatectl status



mkdir /etc/ansible





reboot now