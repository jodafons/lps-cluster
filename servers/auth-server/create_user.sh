master_password=$1
username=$2

sudo kadmin -q "ank -policy user -pw changemenow -needchange $username " -w $master_password
