


# install kerberos
apt install -y krb5-config krb5-user
apt install -y libpam-krb5
kadmin -q "addprinc -policy service -randkey host/$HOSTNAME.lps.ufrj.br"
kadmin -q "ktadd -k /etc/krb5.keytab host/$HOSTNAME.lps.ufrj.br"



# install LDAP
apt install -y libnss-ldap
apt install -y libnss-ldapd
/etc/init.d/nscd restart
/etc/init.d/ssh restart
echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=022" >> /etc/pam.d/common-session
getent passwd

# configure SSH
cp conf_files/sshd_config /etc/ssh
invoke-rc.d ssh restart


# configure NTP
cp conf_files/timesyncd.conf /etc/systemd/
timedatectl set-ntp true
timedatectl status


# Configure home folder
echo "10.1.1.202:/volume1/homes /home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
mkdir /etc/pam_scripts
chmod -R 700 /etc/pam_scripts
chown -R root:root /etc/pam_scripts
cp conf_files/login-logger.sh /etc/pam_scripts
chmod +x /etc/pam_scripts/login-logger.sh
echo "session required pam_exec.so /etc/pam_scripts/login-logger.sh" >> /etc/pam.d/sshd


# install others
apt install -y htop


# add main message
cp conf_files/00-main-message /etc/update-motd.d
chmod +x /etc/update-motd.d/00-main-message
