

# SLURM Server Configuration:

## LDAP Client Configuration:

The default configurations after installation should work fine. Next, we'll set LDAP with NSS

```
apt install libnss-ldap
```

## Q&A:

- server: `ldap://ldap-server.lps.ufrj.br`
- Distinguished name of the search base: `dc=lps,dc=ufrj,dc=br`
- LDAP version: 3
- Select yes to create the local root database;
- Answer No for Does the LDAP database requires login?
- Set LDAP account for root, like `cn=admin,dc=lps,dc=ufrj,dc=br`
- Provide LDAP root account Password


Again, fill things to match your own. In order to ease configuration, I'll install another package where we can choose which services we'll enable. In my case, I just checked `passwd`, `group` and `shadow`

```
apt install libnss-ldapd
```

Once that's done, do

```
/etc/init.d/nscd restart
/etc/init.d/ssh restart
```

Next, we'll setup PAM for creating home directories for users that don't have it yet. For that, edit the `/etc/pam.d/common-session` file by adding this line to the end of it

```
session    required    pam_mkhomedir.so skel=/etc/skel/ umask=022
```

To test LDAP, use this command and you shoul see some accounts inside of the LDAP server:

```
getent passwd
```


## Setting up mounts

Start by installing `nfs-common` and making directories

```
su -
apt install nfs-common
mkdir -p /storage
```

After that, edit your `/etc/fstab` file for auto mount, appeding something like this on the bottom (always match your setup)

```
nas.cluster:/mnt/share/shared_home /home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0
nas.cluster:/mnt/share/shared_storage /storage nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0
```

You can now mount everything

```
mount -a
```

## Syncing clocks with NTP:

Edit the following file: `/etc/systemd/timesyncd.conf` by making it look like this (match your own setup)

```
[Time]
NTP=1.br.pool.ntp.org 0.br.pool.ntp.org
```

Uncomment `FallbackNTP` line, but leave it as is.

Then enable NTP and check its status

```
timedatectl set-ntp true
timedatectl status
```

And you're done again! After this step, you're ready to install slurm and configure it.


**At this point, you shoud reboot to access the storage home folder** 


## SLURM Configuration:











## Installing SLURM

As this is a SLURM cluster, we have to install SLURM, right? I know it's been too much before this could happen, but setting everything I've shown before was really important for my setup. Let's do it then!

I've based my installation on the [ubuntu-slurm](https://github.com/mknoxnv/ubuntu-slurm) tutorial but, since I'm in Debian and it's kinda outdated, I made few changes

**This step should be done ONLY on the host(slurmctld/login) machine**

First you have to install some prerequisites

```
apt install -y gcc make ruby ruby-dev libmariadb-dev-compat libmariadb-dev mariadb-server bzip2
```

Then install MUNGE for authentication

```
apt install libmunge-dev libmunge2 munge
systemctl enable munge
systemctl start munge
```

Next we'll disable `mariadb` service and enable `mysql` service (if we don't disable `mariadb`, `mysql` will complain about symlinks)

```
systemctl stop mariadb
systemctl disable mariadb
systemctl enable mysql
systemctl start mysql
```

Now we create the database for SLURM by opening a mysql shell running `mysql -u root`

```
create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('slurmdbpass');
grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';
flush privileges;
exit
```

Then we'll download SLURM itself

```
cd /mnt/slurm_build
wget https://download.schedmd.com/slurm/slurm-22.05.3.tar.bz2
wget http://134.100.28.207/files/src/slurm/
apt install bzip2
bunzip2 slurm-22.05.3.tar.bz2
tar xfv slurm-22.05.3.tar
cd slurm-22.05.3
```

After that, lets compile it!

```
./configure --prefix=/tmp/slurm_build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm --with-mysql_config=/usr/bin/mysql_config
```

Then we build SLURM

```
make -j4
make contrib
make install
```

After that, we need to make a package out of slurm and install it

```
gem install fpm
fpm -s dir -t deb -v 1.0 -n slurm-20.02.3 --prefix=/usr -C /mnt/slurm_build .
dpkg -i slurm-20.02.3_1.0_amd64.deb
```

cd /mnt/slurm_build/
cp -r lib/* /usr/lib
cp -r sbin/* /usr/sbin
cp -r include/* /usr/include
cp -r bin/* /usr/bin

Finally, we need to add `slurm` user and make some dirs

```
useradd slurm
mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
chown slurm /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
```

Okay. So, by now, SLURM should be fully installed. Before we proceed, we need a `slurm.conf` file, in order to configure our cluster. You can generate your own conf file by using [this amazing tool](https://slurm.schedmd.com/configurator.html) from SchedMD, which is the SLURM official development and support team. The Caloba cluster 
configuration file is `slurm.conf`. This file shall be placed in `/etc/slurm/slurm.conf`.

```
cp slurm.conf /etc/slurm/
cp slurmdbd.conf /etc/slurm

```


Now we'll deploy SLURM. For it to work, I'll provide some scripts that I got from the original tutorial in order to add'em to systemd (cloning this repository is optional but, in order to ease the tutorial, I chose to do it)

```

cp slurmdbd.service /etc/systemd/system/
cp slurmctld.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable slurmdbd
systemctl start slurmdbd
systemctl enable slurmctld
systemctl start slurmctld
```

Okay, so now you can check if it's working fine by doing

```
systemctl status slurmdbd
systemctl status slurmctld
```

If everything is working fine, you can proceed. Now, create the SLURM cluster, account and some users (I recommend creating those users before on LDAP and Kerberos. That way, you'll be able to SSH into any machine and run commands without worrying with authentication and stuff)

```
sacctmgr add cluster compute-cluster
sacctmgr add account compute-account description="Compute accounts" Organization=OurOrg
sacctmgr create user <your-user> account=compute-account adminlevel=None
```

Finally, if everything went well, you can check system health by typing `sinfo`. Don't worry if your nodes show no state, we haven't configured them yet. So let's do this now!
