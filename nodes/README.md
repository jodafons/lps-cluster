

# Node Configuration:


## Kerberos Client Configuration:

Install few packages (the setup is pretty straightforward, just fill things to match your own)

```
su -
apt install krb5-config krb5-user
```

### Q&A:

* Kerberos realm: `LPS.UFRJ.BR`
* Kerberos server: `auth-server.lps.ufrj.br`
& Kerberos adm-server: `auth-server.lps.ufrj.br`

[Optional] Test Kerberos setup by doing

```
kinit -p <your-username>
klist
kdestroy
```

For this optional step, you need to have at least one principal added on the server.

Next, we'll need to use PAM for Kerberos authentication. For that, install

```
apt install libpam-krb5
```

## LDAP Client Configuration:

The default configurations after installation should work fine. Next, we'll set LDAP with NSS

```
apt install libnss-ldap
```

## Q&A:

- server: `ldap://auth-server.lps.ufrj.br`
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

Finally, we'll setup passwordless SSH using Kerberos tickets. For that, inside the `kadmin` shell, run (replacing `<hostname.hostdomain>`):

```
addprinc -policy service -randkey host/slurm-server.lps.ufrj.br
ktadd -k /etc/krb5.keytab host/slurm-server.lps.ufrj.br
```

Then edit the `/etc/ssh/sshd_config` file to match the following:

```
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
GSSAPIKeyExchange yes
UsePAM yes
```

Restart SSH service

```
invoke-rc.d ssh restart
```

And you're done! Remember that, for this to work, **you have to create users both on LAM and on Kerberos server**. The password set on LAM can be anything, since the authentication is made through Kerberos. The LDAP server here is mostly used to store home path information and UID/GID management.




## Setting up mounts

Start by installing `nfs-common` and making directories

```
apt install nfs-common
```

After that, edit your `/etc/fstab` file for auto mount, appeding something like this on the bottom (always match your setup)

```
10.1.1.202:/volume1/homes /home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0
10.1.1.202:/volume1/slurm_build /mnt/slurm_build nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0
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


## Singularity Configuration: