

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
apt install gcc make ruby ruby-dev 
apt install libmariadb-dev-compat libmariadb-dev mariadb-server
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
apt install bzip2
bunzip2 slurm-22.05.3.tar.bz2
tar xfv slurm-22.05.3.tar
cd slurm-22.05.3
```

After that, lets compile it!

```
./configure --prefix=/mnt/slurm-build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm --with-mysql_config=/usr/bin/mysql_config
```

Then we build SLURM

```
make
make contrib
make install
```

After that, we need to make a package out of slurm and install it

```
gem install fpm
fpm -s dir -t deb -v 1.0 -n slurm-22.05.3 --prefix=/usr -C /mnt/slurm-build .
dpkg -i slurm-22.05.3_1.0_amd64.deb
```

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
```


Now we'll deploy SLURM. For it to work, I'll provide some scripts that I got from the original tutorial in order to add'em to systemd (cloning this repository is optional but, in order to ease the tutorial, I chose to do it)

```
apt install git
git clone https://github.com/gabriel-milan/slurm-cluster

cp slurm-cluster/slurmdbd.service /etc/systemd/system/
cp slurm-cluster/slurmctld.service /etc/systemd/system/

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

**This step should be done ONLY on the node(slurmd) machines**

First we're gonna install MUNGE, for authentication

```
su -
apt update
apt install libmunge-dev libmunge2 munge
```

We need to have the same copy of `munge.key` (located at `/etc/munge/munge.key`) for every node. In order to do that, copy it from `host.cluster` to every other machine. One way to do that is over SCP

```
scp host.cluster:/etc/munge/munge.key /etc/munge/.
```

Then fix permissions

```
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key
```

And restart MUNGE

```
systemctl enable munge
systemctl restart munge
```

After setting MUNGE, we're going to install the same copy of SLURM we've built on the host machine by doing

```
dpkg -i /storage/slurm-20.02.3_1.0_amd64.deb
```

Next, we need to create the `/etc/slurm` directory and have the same copy of `/etc/slurm/slurm.conf` on every machine. Similarly to the MUNGE key, do

```
scp host.cluster:/etc/slurm/slurm.conf /etc/slurm/.
```

Then you need to create the `/etc/slurm/gres.conf` file, which takes care of listing resources other than CPUs (like GPUs, for example). **In my case, this will be just an empty file** but, if you need an example, a configuration for the DGX-1 server is below

```
NodeName=linux1 Name=gpu File=/dev/nvidia0 CPUs=0-19,40-59
NodeName=linux1 Name=gpu File=/dev/nvidia1 CPUs=0-19,40-59
NodeName=linux1 Name=gpu File=/dev/nvidia2 CPUs=0-19,40-59
NodeName=linux1 Name=gpu File=/dev/nvidia3 CPUs=0-19,40-59
NodeName=linux1 Name=gpu File=/dev/nvidia4 CPUs=20-39,60-79
NodeName=linux1 Name=gpu File=/dev/nvidia5 CPUs=20-39,60-79
NodeName=linux1 Name=gpu File=/dev/nvidia6 CPUs=20-39,60-79
NodeName=linux1 Name=gpu File=/dev/nvidia7 CPUs=20-39,60-79
```

After that, as we'll use `cgroup`, you need to create both of these files:

* `/etc/slurm/cgroup.conf`

```
CgroupAutomount=yes 
CgroupReleaseAgentDir="/etc/slurm/cgroup" 

ConstrainCores=yes 
ConstrainDevices=yes
ConstrainRAMSpace=yes
#TaskAffinity=yes
```

* `/etc/slurm/cgroup_allowed_devices_file.conf`

```
/dev/null
/dev/urandom
/dev/zero
/dev/sda*
/dev/cpu/*/*
/dev/pts/*
/dev/nvidia*
```

This will be useful later for forbiding users from SSH into machines they have no jobs allocated

Then, create missing SLURM user and make some directories

```
useradd slurm
mkdir -p /var/spool/slurm/d
```

Assuming you've cloned this repository, copy the `slurmd.service` file and then enable it

```
cp /storage/slurm-cluster/slurmd.service /etc/systemd/system/
systemctl enable slurmd
systemctl start slurmd
```

At this point, if you've done everything right, you should be able to do `sinfo` and see your node state `idle`. But now, we'll configure `cgroup` in order to be able to manage memory quotas. For that, open `/etc/default/grub` for edition and match the following line

```
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
```
	
If your system uses cgroup v2 (as Debian bullseye):
	
```
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1 systemd.unified_cgroup_hierarchy=false systemd.legacy_systemd_cgroup_controller=false"
```

After that, update GRUB and reboot the machine

```
update-grub
reboot now
```

To finish the configuration of the nodes, we'll forbid users from ssh-ing into a compute node on which they do not have a job allocation AND we'll add sjstat, which is a very nice command. In order to do that, do

```
cp /storage/slurm-20.02.3/contribs/sjstat /usr/bin/.
cp /storage/slurm-20.02.3/contribs/pam/.libs/pam_slurm.so /lib/x86_64-linux-gnu/security/
```

and then edit the file `/etc/pam.d/sshd` by adding the following lines just **before** the first `required` statement:

```
account    sufficient   pam_localuser.so
account    required     /lib/x86_64-linux-gnu/security/pam_slurm.so
```

This way, we forbid SLURM users from doing any bypass on deploying workload into nodes and still allow non-SLURM users to SSH normally. And we're done with the nodes!

### Future work

* Multi-factor priority: https://slurm.schedmd.com/priority_multifactor.html
* SLURM account synchronization with UNIX groups and users: https://slurm.schedmd.com/SLUG19/DTU_Slurm_Account_Sync.pdf
* Setup multiple job queues: add new partitions to `slurm.conf`
* Some sort of mechanism to keep `slurm.conf` always synced. Maybe a shared mount?
* Web dashboard (couldn't put slurm-web to work)
* Install `modules`: https://modules.readthedocs.io/en/latest/INSTALL.html
* Install `clustershell`: https://clustershell.readthedocs.io/en/latest/install.html
