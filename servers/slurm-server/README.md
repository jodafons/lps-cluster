
# SLURM Server Configuration:


## LDAP/Kerberos integration

**This step should be done on each one of the following machines:**

* Host machine (where slurmctld will run)
* Computing nodes (where slurmd will run)

Install few packages (the setup is pretty straightforward, just fill things to match your own)

```
su -
apt install krb5-config krb5-user
```

## Q&A:
- Kerberos realm: LPS.UFRJ.BR
- Kerberos server: auth-server.lps.ufrj.br
- Kerberos adm-server: auth-server.lps.ufrj.br

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

The default configurations after installation should work fine. Next, we'll set LDAP with NSS

```
apt install libnss-ldap
```

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

Finally, we'll setup passwordless SSH using Kerberos tickets. For that, inside the `kadmin` shell, run (replacing `<hostname.hostdomain>`):

```
addprinc -policy service -randkey host/<hostname.hostdomain>
ktadd -k /etc/krb5.keytab host/<hostname.hostdomain>
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


