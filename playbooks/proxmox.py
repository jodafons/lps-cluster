#!/bin/python

import argparse
import sys,os,json
import socket

from typing import List
from time import sleep
from pprint import pprint

class Shell:
  __preexec = "export ANSIBLE_HOST_KEY_CHECKING=False"

  def __init__(self, basepath : str=f"{os.getcwd()}/yaml"):
    self.hosts    = f"{basepath}/hosts"
    self.basepath = basepath

  def run_shell(self, hostname : str, command : str, dry_run: bool=False, script : str="shell.yaml"):
    script = f"{self.basepath}/{script}"
    params = f"hostname={hostname} "
    params+= f"command='{command}' "
    self.run(script, params, dry_run)

  def run(self, script : str, params : str, dry_run : bool=False):
    command=f'{self.__preexec} && ansible-playbook -i {self.hosts} {script} -vv -e "{params}"'
    print(command)
    try:
      if dry_run:
        os.system(command)
      return True
    except:
      return False


class VM(Shell):
  
  def __init__(self,
               basepath  : str,
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
               cluster   : str,
               gpu       : bool,
               dry_run   : bool=False,
               vmname_init : str="slurm-worker"
               ):
    Shell.__init__()
    self.image    = image
    self.hostname = hostname
    self.vmid     = vmid 
    self.vmname   = vmname
    self.sockets  = sockets
    self.cores    = cores 
    self.memory_mb= memory_mb
    self.storage  = storage
    self.ip_address = ip_address
    self.cluster  = cluster
    self.dry_run  = dry_run
    self.vmname_init=vmname_init
  
  def run_shell_on_vm(self,command:str, script : str="shell.yaml"):
    return self.run_shell(self.vmname, command, dry_run=self.dry_run)
  
  def run_shell_on_host(self, command : str, script : str="shell.yaml"):
    return self.run_shell(self.hostname, command, dry_run=self.dry_run)
  
  def create(self, snapname : str=None):    
    self.restore()
    sleep(10)
    self.configure()
    if snapname:
      self.snapshot(snapname)
    
  def destroy(self):
    self.run_shell_on_host(f"qm stop {self.vmid} && qm destroy {self.vmid}")
    
        
  def restore(self):
    command = f"qmrestore {self.image} {self.vmid} --storage {self.storage} --unique --force && "
    command+= f"qm set {self.vmid} --name {self.vmname} --sockets {self.sockets} --cores {self.cores} --memory {self.memory_mb} && "
    command+= f"qm start {self.vmid}"
    self.run_shell_on_host(command)
    
  def snapshot(self, name : str):
    self.run_shell_on_host(f"qm snapshot {self.vmid} {name}")

  def reset(self):
    self.run_shell_on_host( f"qm stop {self.vmid} && qm start {vmid}" )
  
  def configure(self, max_retry : int=10):
    script_http = "https://raw.githubusercontent.com/jodafons/lps-cluster/refs/heads/main/servers/slurm-worker/scripts/reconfigure.sh" 
    script_name = script_http.split("/")[-1]
    command =  f"wget {script_http} && bash {script_name} {self.vmname} {self.ip_address}"
    self.run_shell_on_vm( command , script='configure_vm.yaml')
    retry=0
    while not self.ping() and retry<max_retry:
      sleep(5)
      retry+=1
      print(f"ping (retry={retry}/{max_retry})")
    if self.gpu:
      script_http="https://raw.githubusercontent.com/jodafons/lps-cluster/refs/heads/main/servers/slurm-worker/05_install_cuda.sh"
      script_name = script_http.split("/")[-1]
      command = f"bash {script_name}"
      self.run_shell_on_vm( command )

  def ping(self,timeout : int=2, port : int=22) -> bool:
    sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    sock.settimeout(timeout)
    try:
      sock.connect((self.ip_address,port))
    except:
      return False
    else:
      sock.close()
      return True



def common_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False)
  parser.add_argument('--yaml', action='store', dest='yaml', required = False, type=str, default=f"{os.getcwd()}/yaml",
                      help = "The yaml folder path.")
  parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                      help = "dry run...")
  return parser

def vm_create_parser():
  formatter_class = None #get_argparser_formatter()
  parser = argparse.ArgumentParser(description = '', add_help = False)
  parser.add_argument('-n','--vmname', action='store', dest='vmname', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser]

def vm_destroy_parser():
  formatter_class = None #get_argparser_formatter()
  parser = argparse.ArgumentParser(description = '', add_help = False)
  parser.add_argument('-n','--vmname', action='store', dest='vmname', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser] 

def vm_snapshot_parser():
  formatter_class = None #get_argparser_formatter()
  parser = argparse.ArgumentParser(description = '', add_help = False)
  parser.add_argument('-n','--vmname', action='store', dest='vmname', required = True,
                      help = "The name of the vm.")
  parser.add_argument('--snapshot', action='store', dest='snapshot', required = False, default='base',
                      help = "The name of the snapshot.") 
  return [common_parser(),parser]
  
def cluster_create_parser():
  return [common_parser()]
  
def cluster_reset_parser():
  return [common_parser()]

def build_argparser( custom : bool=False):

    formatter_class = None #get_argparser_formatter()
    parser          = argparse.ArgumentParser()
    mode            = parser.add_subparsers(dest='mode')
    
    cluster_parent = argparse.ArgumentParser( add_help=False, )
    option         = cluster_parent.add_subparsers(dest='option')
    #option.add_parser("create", parents = cluster_create_parser()  ,help="")
    #option.add_parser("reset" , parents = cluster_reset_parser()   ,help="")
    #mode.add_parser( "cluster", parents=[cluster_parent]           ,help="")

    vm_parent = argparse.ArgumentParser( add_help=False, )
    option = vm_parent.add_subparsers(dest='option')
    option.add_parser("create"    , parents = vm_create_parser()    ,help="")
    option.add_parser("destroy"   , parents = vm_destroy_parser()   ,help="")
    option.add_parser("snapshot"  , parents = vm_snapshot_parser()  ,help="")
    mode.add_parser( "vm"         , parents=[vm_parent]             ,help="")
    return parser

def load_json(path : str):
  return json.load(open(path,'r'))

def create_vm(args) -> VM:
  file = load_json(args.yaml+"/vms.json")
  vm   = file['vm'][args.vmname]
  image= file["common"]['image']
  return VM( hosts=args.hosts, image=image, dry_run=args.dry_run, **vm)
  

def run_parser(args):
    if args.mode == "cluster":
        if args.option == "create":
          pass
        elif args.option == "reset":
          pass
    elif args.mode == "vm":
        if args.option == "create":
            node = create_vm(args)
            node.create()
        elif args.option == "destroy":
            node = create_vm(args)
            node.destroy()
        elif args.option == "snapshot":
            node = create_vm(args)
            node.snapshot( snapname=args.snapshot )

def run():

    parser = build_argparser(custom=True)
    if len(sys.argv)==1:
        print(parser.print_help())
        sys.exit(1)
    args = parser.parse_args()
    run_parser(args)

if __name__ == "__main__":
  run()