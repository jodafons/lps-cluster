

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

## Syncing clocks with NTP

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


