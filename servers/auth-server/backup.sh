source scripts/dump_ldap.sh
sudo cp lps.ufrj.br.ldif /mnt/market_place/data
sudo cp config.ldif /mnt/market_place/data

source scripts/dump_kerberos.sh
sudo cp lps.ufrj.br.krb5 /mnt/market_place/data
