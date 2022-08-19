

sudo dpkg-reconfigure debconf # Dialog and Low priority as input in textbox
sudo apt install -y krb5-{admin-server,kdc}
sudo krb5_newrealm
sudo cp kadm5.acl /etc/krb5kdc/kadm5.acl
sudo cp krb5.conf /etc/krb5.conf
mkdir /var/log/kerberos
touch /var/log/kerberos/{krb5kdc,kadmin,krb5lib}.log
chmod -R 750  /var/log/kerberos
invoke-rc.d krb5-kdc restart
invoke-rc.d krb5-admin-server restart


