export ANSIBLE_HOST_KEY_CHECKING=False
ansible gpu -m ping -v -i hosts
ansible gpu-large -m ping -v -i hosts
ansible cpu-large -m ping -v -i hosts
