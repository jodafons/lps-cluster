
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i hosts tasks/docker.yaml
#ansible-playbook -i hosts tasks/install_k8s.yaml