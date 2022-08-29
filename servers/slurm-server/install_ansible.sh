apt install -y ansible sshpass
mkdir /etc/ansible
cp ansible/hosts /etc/ansible
cp ansible/ansible.cfg /etc/ansible
ansible-inventory --list -y

