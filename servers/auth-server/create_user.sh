username=$1
kadmin -q "ank -policy users $username" -w $MASTER_PASSWORD
