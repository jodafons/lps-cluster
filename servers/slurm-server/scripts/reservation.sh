username=$1
days=$2
nodes=$3


sudo scontrol create reservation user=$username starttime=now duration=$days nodes=$nodes 
