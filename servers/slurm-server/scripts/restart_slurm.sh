echo "Ping all nodes..."
sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld
ansible-playbook -i ../../../hosts ../playbooks/restart_slurmd.yaml -e "hostgroup=vm"
