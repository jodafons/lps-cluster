username=$1
kadmin -q "ank -policy user -pw @$username -needchange $username " -w $MASTER_PASSWORD
