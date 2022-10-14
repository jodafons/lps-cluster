username=$1
kadmin -q "ank -policy user -pw changemenow -needchange $username " -w $MASTER_PASSWORD
