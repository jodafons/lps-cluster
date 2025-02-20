
import argparse
import sys,os,json
from time import sleep
from pprint import pprint




class Caloba:
  
  __preexec = "export ANSIBLE_HOST_KEY_CHECKING=False"
  
  def __init__(self,
               image     : str,
               hosts     : str,
               vmname    : str,
               vmid      : int,
               memory_mb : int,
               cores     : int,
               sockets   : int,
               hostname  : str,
               storage   : str,
               ip_address: str,
               dry_run   : bool=False,
               vmname_init : str="slurm-worker"
               ):
    self.image    = image
    self.hostname = hostname
    self.basepath = os.getcwd()
    self.hosts    = hosts
    self.vmid     = vmid 
    self.vmname   = vmname
    self.sockets  = sockets
    self.cores    = cores 
    self.memory_mb= memory_mb
    self.storage  = storage
    self.ip_address = ip_address
    self.dry_run  = dry_run
    self.vmname_init=vmname_init
  
  def run(self, script : str, params : str):
    
    command=f'{self.__preexec} && ansible-playbook -i {self.hosts} {script} -vv -e "{params}"'
    print(command)
    try:
      if not self.dry_run:
        os.system(command)
      return True
    except:
      return False

    
  def create(self, snapname : str=None):    
    self.restore()
    self.configure()
    if snapname:
      self.snapshot(snapname)
    
  def destroy(self):
    script = f"{self.basepath}/yaml/vm/destroy_vm.yaml"
    params = f"vmid={self.vmid} "
    params+= f"hostname={self.hostname} "
    self.run(script, params)
    
    
    
  def restore(self):
    script = f"{self.basepath}/yaml/vm/restore_vm.yaml"
    params = f"image={self.image} "
    params+= f"vmid={self.vmid} "
    params+= f"vmname={self.vmname} "
    params+= f"hostname={self.hostname} "
    params+= f"storage={self.storage} "
    params+= f"sockets={self.sockets} cores={self.cores} memory_mb={self.memory_mb}"
    self.run(script, params)
    
    
  def snapshot(self, name : str):
    script = f"{self.basepath}/yaml/vm/snapshot_vm.yaml"
    params = f"vmid={self.vmid} "
    params+= f"hostname={self.hostname} "
    params+= f"snapname={name} "
    self.run(script, params)

    
  def reset(self):
    script = f"{self.basepath}/yaml/vm/reset_vm.yaml"
    params+= f"vmid={self.vmid} "
    params+= f"hostname={self.hostname} "
    self.run(script, params)

    
  def configure(self):
    script = f"{self.basepath}/yaml/vm/configure_vm.yaml"
    params = f"ip_address={self.ip_address} "
    params+= f"vmname_init={self.vmname_init} "
    params+= f"vmname={self.vmname} "
    self.run(script, params)

    




parser = argparse.ArgumentParser(description = '', add_help = False)
parser = argparse.ArgumentParser()

parser.add_argument('-w', '--password', action='store', dest='password', required = False, type=str, default=os.environ.get("CALOBA_MASTER_KEY"),
                    help = "The master password")

parser.add_argument('--hosts', action='store', dest='hosts', required = False, type=str, default=f"{os.getcwd()}/hosts",
                    help = "The hosts file path.")

parser.add_argument('--config-path', action='store', dest='config_path', required = False, type=str, default=f"{os.getcwd()}/hosts_config.json",
                    help = "The hosts file path.")

parser.add_argument('-n','--vmname', action='store', dest='vmname', required = True,
                    help = "The name of the vm.")

parser.add_argument('--snapshot', action='store', dest='snapshot', required = False, default='base',
                    help = "The name of the snapshot.")

parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                    help = "dry run...")
if len(sys.argv)==1:
  parser.print_help()
  sys.exit(1)


args    = parser.parse_args()
configs = json.load(open(args.config_path, 'r'))
image   = configs["image"]
vm      = configs["nodes"][args.vmname]
pprint(vm)
node = Caloba( image = image, hosts = args.hosts, **vm )

node.create(snapname=args.snapshot)


