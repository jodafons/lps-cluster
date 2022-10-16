sudo kdb5_util dump -verbose lps.ufrj.br.krb5

chgrp cluster lps.ufrj.br.krb5
chown cluster lps.ufrj.br.krb5
sudo rm lps.ufrj.br.krb5.dump_ok
