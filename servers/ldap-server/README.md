# Configuring the LDAP server


First you have to install some packages (note that you can skip everything asked NOT THE PASSWORD, leaving the default options)

```
apt install -y slapd ldap-utils
```

Than lets reconfigure by hand the LDAP conf. Where domain will be `lps.ufrj.br` and dc base `dc=lps,dc=ufrj,dc=br`:

```
dpkg-reconfigure slapd
```

You can show your server's details by running

```
slapcat
```


Next we're going to install LAM, the LDAP Account Manager. It's a web app and it eases our life SO MUCH

```
wget http://prdownloads.sourceforge.net/lam/ldap-account-manager_7.2-1_all.deb
sudo dpkg -i ldap-account-manager_7.2-1_all.deb
apt -f install
```

Then you can access it through `http://auth.cluster/lam`. We'll now configure it through web.

First of all, click `[LAM configuration]` at the upper right corner, then click `Edit server profiles`. It will ask for your password, the default is `lam`.

At this point, it's safer to change your password, do this on the `Profile password` section.

After that, on the `Server settings` section, set `Server address` and `Tree suffix` to match your own.

On `Security settings`, set `List of valid users` to something like `cn=admin,dc=cluster`, always matching your setup.

Do few further modifications on the `Account types` tab changing from `dc=example,dc=com` to match your stuff.

Next we'll save the configurations, returning to the homepage, and will login with the admin password. If LAM asks to create anything that's missing, you can safely allow that.

[Optional] Add a group (the first one will be the default group for every new user) and add new user(s). It's really simple to use the interface.
