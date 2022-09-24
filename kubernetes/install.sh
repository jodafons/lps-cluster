
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i hosts tasks/users.yaml
ansible-playbook -i hosts tasks/install_k8s.yaml