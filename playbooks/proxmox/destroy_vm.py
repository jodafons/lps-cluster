
import argparse
import sys,os
from time import sleep



parser = argparse.ArgumentParser(description = '', add_help = False)
parser = argparse.ArgumentParser()


parser.add_argument('--hosts', action='store', dest='hosts', required = False, type=str, default=f"{os.getcwd()}/hosts",
                    help = "The hosts file path.")

parser.add_argument('--hostname', action='store', dest='hostname', required = True,
                    help = "The physical host name.")

parser.add_argument('-d','--vm-id-number', action='store', dest='vm_id_number', required = True,
                    help = "The id of the vm inside of the proxmox.")

parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                    help = "dry run...")
if len(sys.argv)==1:
  parser.print_help()
  sys.exit(1)


args = parser.parse_args()
pre_exec="export ANSIBLE_HOST_KEY_CHECKING=False"
command=f'{pre_exec} && ansible-playbook -i {args.hosts} yaml/vm/destroy_vm.yaml -vv -e "hostname={args.hostname} vmid={args.vm_id_number}"'
print(command)
if not args.dry_run:
  os.system(command)
