username=$1
kadmin -q "ank -policy users $username -pw @$username -needchange" -w $MASTER_PASSWORD
