
# update SLURM
cp slurm/slurm.conf /etc/slurm/
cp slurm/slurmdbd.conf /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf
chown -R slurm /etc/slurm
cp slurm/slurmdbd.service /etc/systemd/system/
cp slurm/slurmctld.service /etc/systemd/system/
cp slurm/slurm.conf /mnt/market_place/slurm_build


systemctl daemon-reload
systemctl enable slurmdbd
systemctl start slurmdbd
systemctl enable slurmctld
systemctl start slurmctld



# check slurm
systemctl status slurmctld