
# Station

Install the latest Operation System such as Ubuntu 22.04.
Lets start with `geneve` as example.

* Hostname: `geneve.lps.ufrj.br`
* Username: `cluster`

## Network Configuration

First, tip `fconfig` and get the name of the network interface. Example:



## Kerberos:

### Q&A:

* Kerberos realm: `LPS.UFRJ.BR`
* Kerberos server: `auth-server.lps.ufrj.br`
* Kerberos adm-server: `auth-server.lps.ufrj.br`

## LDAP:

### Q&A:

- server: `ldap://auth-server.lps.ufrj.br` or `ldap://146.164.147.3`
- Distinguished name of the search base: `dc=lps,dc=ufrj,dc=br`
- LDAP version: 3
- Select yes to create the local root database;
- Answer No for Does the LDAP database requires login?
- Set LDAP account for root, like `cn=admin,dc=lps,dc=ufrj,dc=br`
- Provide LDAP root account Password


Again, fill things to match your own. In order to ease configuration, I'll install another package where we can choose which services we'll enable. In my case, I just checked `passwd`, `group` and `shadow`

To test LDAP, use this command and you shoul see some accounts inside of the LDAP server:

```
getent passwd
```

## NFS:




