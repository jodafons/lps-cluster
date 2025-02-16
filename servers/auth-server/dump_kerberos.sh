sudo kdb5_util dump -verbose lps.ufrj.br.krb5

sudo chgrp cluster lps.ufrj.br.krb5
sudo chown cluster lps.ufrj.br.krb5
sudo rm lps.ufrj.br.krb5.dump_ok


sudo cp lps.ufrj.br.krb5 /mnt/market_place/data
mv lps.ufrj.br.krb5 files/data