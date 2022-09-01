
# recopy everything to SLURM
cp files/slurm/slurm.conf /etc/slurm/
cp files/slurm/slurmdbd.conf /etc/slurm
chmod 600 /etc/slurm/slurmdbd.conf
chown -R slurm /etc/slurm
cp files/slurm/slurmdbd.service /etc/systemd/system/
cp files/slurm/slurmctld.service /etc/systemd/system/
cp files/slurm/slurm.conf /mnt/market_place/slurm_build

# restart all services
#systemctl start munge
#systemctl daemon-reload
#systemctl start slurmdbd
#systemctl start slurmctld


# check slurm
#systemctl status slurmdbd
#systemctl status slurmctld
scontrol reconfigure


# force all nodes to restart
ansible-playbook -i ../../playbooks/hosts ../../playbooks/tasks/restart_slurmd.yml

