# Configuring the authentication server


# LDAP:


First you have to install some packages (note that you can skip everything asked NOT THE PASSWORD, leaving the default options)

```
apt install -y slapd ldap-utils
```

Than lets reconfigure by hand the LDAP conf. Where domain will be `lps.ufrj.br` and dc base `dc=lps,dc=ufrj,dc=br`:

```
dpkg-reconfigure slapd
```
### Q&A:

* Omit OpenLDAP server configuration? No
* DNS domain name: `lps.ufrj.br`
* Organization name: `lps.ufrj.br`
* Enter with the password;
* Do you want the database to be removed when slapd is purged? No
* Move old database? Yes

You can show your server's details by running

```
slapcat
```


Next we're going to install LAM, the LDAP Account Manager. It's a web app and it eases our life SO MUCH

```
apt install -y ldap-account-manager
```

Then you can access it through `http://auth.cluster/lam`. We'll now configure it through web.

First of all, click `[LAM configuration]` at the upper right corner, then click `Edit server profiles`. It will ask for your password, the default is `lam`.

At this point, it's safer to change your password, do this on the `Profile password` section.

After that, on the `Server settings` section, set `Server address` and `Tree suffix` to match your own.

On `Security settings`, set `List of valid users` to something like `cn=admin,dc=cluster`, always matching your setup.

Do few further modifications on the `Account types` tab changing from `dc=example,dc=com` to match your stuff.

Next we'll save the configurations, returning to the homepage, and will login with the admin password. If LAM asks to create anything that's missing, you can safely allow that.

[Optional] Add a group (the first one will be the default group for every new user) and add new user(s). It's really simple to use the interface.

Note: username admin is: `cn=admin,dc=lps,dc=ufrj,dc=br`



## Kerberos

I've based this configuration on three tutorial: [this for Kerberos](http://techpubs.spinlocksolutions.com/dklar/kerberos.html), [this for LDAP](https://computingforgeeks.com/how-to-install-and-configure-openldap-server-on-debian/) and [this for the integration](https://wiki.debian.org/LDAP/Kerberos). As this step is a mix of these links, I'd recommend following from here.

Start by configuring debconf to low priority, so we can have more control of what's happening.

```
dpkg-reconfigure debconf
```

When asked, go to interface=Dialog and set priority=low.

After that, we'll install some packages (it will ask some stuff on the process, so pay attention)

```
apt install krb5-{admin-server,kdc}
```

### Q&A

* Default Kerberos version 5 realm: `LPS.UFRJ.BR`
* Add locations of default Kerberos servers to /etc/krb5.conf? Yes
* Kerberos servers for your realm: `auth-server.lps.ufrj.br`
* Administrative server for your Kerberos realm: `auth-server.lps.ufrj.br`
* Create the Kerberos KDC configuration automatically? Yes
* Run the Kerberos V5 administration daemon (kadmind)? Yes

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
ank -policy admin root/admin
ank -policy admin cluster/admin

quit
```
