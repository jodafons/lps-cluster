

apt install -y gcc make libpam0g-dev ruby ruby-dev libmariadb-dev-compat libmariadb-dev mariadb-server bzip2 libmunge-dev libmunge2 munge
systemctl enable munge
systemctl start munge
systemctl stop mariadb
systemctl disable mariadb
systemctl enable mysql
systemctl start mysql


mysql -u root -e "create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('slurmdbpass');grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';
flush privileges;"


# install slurm
dpkg -i /mnt/market_place/slurm_build/slurm-22.05.3_1.0_amd64.deb
useradd slurm
mkdir -p /etc/slurm 
mkdir -p /etc/slurm/prolog.d 
mkdir -p /etc/slurm/epilog.d 
chown -R slurm /etc/slurm
mkdir -p /var/spool/slurm/ctld 
mkdir -p /var/spool/slurm/d 
mkdir -p /var/log/slurm
chown -R slurm /var/spool/slurm/
cp slurm/slurm.conf /etc/slurm/
cp slurm/slurmdbd.conf /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf
chown -R slurm /etc/slurm
cp slurm/slurmdbd.service /etc/systemd/system/
cp slurm/slurmctld.service /etc/systemd/system/
ln -s slurm/slurm.conf /mnt/market_place/slurm_build

systemctl daemon-reload
systemctl enable slurmdbd
systemctl start slurmdbd
systemctl enable slurmctld
systemctl start slurmctld

# check status
systemctl status slurmdbd
systemctl status slurmctld

# create accounts into SLURM db
sacctmgr add cluster caloba
sacctmgr add account compute-account description="Compute accounts" Organization=lps
sacctmgr create user joao.pinto account=compute-account adminlevel=None

