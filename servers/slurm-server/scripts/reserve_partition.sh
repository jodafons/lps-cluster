username=$1
days=$2
partition=$3

minutes=`expr $2 \* 60 \* 24`
echo $minutes
sudo scontrol create reservation user=$username starttime=now duration=$minutes partition=$partition 
