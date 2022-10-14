username=$1
kadmin -q "ank -policy user -randkey -needchange $username " -w $MASTER_PASSWORD
