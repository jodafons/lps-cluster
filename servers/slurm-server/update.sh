
# recopy everything to SLURM
sudo cp files/slurm/slurm.conf /etc/slurm/
sudo cp files/slurm/slurmdbd.conf /etc/slurm
sudo chmod 600 /etc/slurm/slurmdbd.conf
sudo chown -R slurm /etc/slurm
sudo cp files/slurm/slurmdbd.service /etc/systemd/system/
sudo cp files/slurm/slurmctld.service /etc/systemd/system/
sudo cp files/slurm/slurm.conf /mnt/market_place/slurm_build

# restart all services
sudo systemctl start munge
sudo systemctl daemon-reload
sudo systemctl start slurmdbd
sudo systemctl start slurmctld


# check slurm
#systemctl status slurmdbd
#systemctl status slurmctld
sudo scontrol reconfigure

restart_slurm.sh
