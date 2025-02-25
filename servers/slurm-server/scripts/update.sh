
# recopy everything to SLURM
echo "recopy..."
sudo cp files/slurm/slurm.conf /etc/slurm/
sudo cp files/slurm/slurmdbd.conf /etc/slurm
sudo chmod 600 /etc/slurm/slurmdbd.conf
sudo chown -R slurm /etc/slurm
sudo cp files/slurm/slurmdbd.service /etc/systemd/system/
sudo cp files/slurm/slurmctld.service /etc/systemd/system/
sudo cp files/slurm/slurm.conf /mnt/market_place/slurm_build



# check slurm
#systemctl status slurmdbd
#systemctl status slurmctld
#sudo scontrol reconfigure

play slurm restart -v
