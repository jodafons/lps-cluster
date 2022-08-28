

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
cp sshd_config /etc/ssh
invoke-rc.d ssh restart



# configure NTP
cp timesynd.conf /etc/systemd/
timedatectl set-ntp true
timedatectl status

