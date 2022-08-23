# Configuring the authentication server

## Kerberos

I've based this configuration on three tutorial: [this for Kerberos](http://techpubs.spinlocksolutions.com/dklar/kerberos.html), [this for LDAP](https://computingforgeeks.com/how-to-install-and-configure-openldap-server-on-debian/) and [this for the integration](https://wiki.debian.org/LDAP/Kerberos). As this step is a mix of these links, I'd recommend following from here.

Start by configuring debconf to low priority, so we can have more control of what's happening.

```
su -
dpkg-reconfigure debconf
```

When asked, go to interface=Dialog and set priority=low.

After that, we'll install some packages (it will ask some stuff on the process, so pay attention)

```
apt install krb5-{admin-server,kdc}
```

### Q&A

* Default Kerberos version 5 realm
	* LPS.UFRJ.BR
* Add locations of default Kerberos servers to /etc/krb5.conf?
	* Yes
* Kerberos servers for your realm
	* auth-server.lps.ufrj.br
* Administrative server for your Kerberos realm
	* auth-server.lps.ufrj.br
* Create the Kerberos KDC configuration automatically?
	* Yes
* Run the Kerberos V5 administration daemon (kadmind)?
	* Yes

Don't worry if it fails to start, since your server  isn't set yet. So let's set this!

```
krb5_newrealm
```

When asked for password, choose yours (recommended a really strong password as this is the master one). On the `/etc/krb5.conf` section, look for `[domain_realm]` not `[realms]` and append your definitions:

```
.lps.ufrj.br = LPS.UFRJ.BR
lps.ufrj.br = LPS.UFRJ.BR
```

[Optional] Add the logging section at the bottom of the file

```
[logging]
	kdc = FILE:/var/log/kerberos/krb5kdc.log
	admin_server = FILE:/var/log/kerberos/kadmin.log
	default = FILE:/var/log/kerberos/krb5lib.log

```

If you've set the `logging` section, create the directory and set correct permissions

```
mkdir /var/log/kerberos
touch /var/log/kerberos/{krb5kdc,kadmin,krb5lib}.log
chmod -R 750  /var/log/kerberos
```

Edit the `/etc/krb5kdc/kadm5.acl` file and make sure the following line is there and NOT commented

```
*/admin *
```

Apply changes

```
invoke-rc.d krb5-kdc restart
invoke-rc.d krb5-admin-server restart
```

[Optional] Add password policies for new principals, a privileged principal and an unprivileged principal

```
kadmin.local

add_policy -minlength 8 -minclasses 3 admin
add_policy -minlength 8 -minclasses 4 host
add_policy -minlength 8 -minclasses 4 service
add_policy -minlength 8 -minclasses 2 user
addprinc -policy admin root/admin
addprinc -policy user unprivileged_user
quit
```
