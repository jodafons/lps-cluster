#!/bin/bash 
export ANSIBLE_HOST_KEY_CHECKING=False
sudo systemctl daemon-reload
sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd
sudo systemctl enable slurmctld
sudo systemctl start slurmctld
ansible-playbook -i playbooks/hosts playbooks/restart_slurmd.yaml
