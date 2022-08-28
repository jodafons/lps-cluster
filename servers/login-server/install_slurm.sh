

# install munge
apt install -y libmunge-dev libmunge2 munge
cp /mnt/market_place/slurm_build/munge.key /etc/munge/
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key
systemctl enable munge
systemctl restart munge

# install SLURM
dpkg -i /mnt/market_place/slurm_build/slurm-22.05.3/slurm-22.05.3_1.0_amd64.deb 
mkdir /etc/slurm
#cp /mnt/market_place/slurm_build/slurm.conf /etc/slurm/
ln -s /mnt/market_place/slurm_build/slurm.conf /etc/slurm/slurm.conf
useradd slurm
mkdir -p /var/spool/slurm/d


