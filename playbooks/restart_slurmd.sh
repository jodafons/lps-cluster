#!/bin/bash 
export ANSIBLE_HOST_KEY_CHECKING=False
sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld
ansible-playbook -i hosts tasks/restart_slurmd.yaml
ansible-playbook -i hosts tasks/restart_slurmd_with_gpus.yaml
