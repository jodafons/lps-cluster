sudo apt install -y slapd ldap-utils
slapcat
sudo apt install -y ldap-account-manager



ldapadd -x -D cn=admin,dc=lps,dc=ufrj,dc=br -W -f basedn.ldif