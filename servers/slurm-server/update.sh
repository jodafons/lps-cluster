cp slurm.conf /etc/slurm/
cp slurmdbd.conf /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf
chown -R slurm /etc/slurm
cp slurmdbd.service /etc/systemd/system/
cp slurmctld.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable slurmdbd
systemctl start slurmdbd
systemctl enable slurmctld
systemctl start slurmctld

cp slurm.conf /mnt/market_place/slurm_build