
sudo systemctl enable slurmctld
sudo systemctl start slurmctld
ansible-playbook -i hosts tasks/restart_slurmd.yml