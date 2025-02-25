__all__ = ["VM",
           "vm_create_parser",
           "vm_destroy_parser",
           "vm_snapshot_parser"]


import os, argparse, json
from typing import List, Dict
from time import sleep
from pprint import pprint
from loguru import logger
from playbooks import Playbook, get_cluster_config, get_argparser_formatter
    



class VM(Playbook):
  
  def __init__(self,
               name                 : str,
               dry_run              : bool=True,
               ):
    Playbook.__init__(self,dry_run=dry_run)
        
    conf = get_cluster_config()
    for key, value in conf["vm"]["common"].items():
      setattr(self, key, value)
    for key, value in conf["vm"]["hosts"][name].items():
      setattr(self, key, value)
    pprint(conf["vm"]["hosts"][name])

  def run_shell_on_vm(self,command:str, script : str="shell.yaml" , configured : bool=True) -> bool:
    return self.run_shell(self.vmname if configured else self.vmname_image, command)
  
  def run_shell_on_host(self, command : str, script : str="shell.yaml") -> bool:
    return self.run_shell(self.host, command)
  
  def create(self, snapname : str="base"):  
    logger.info(f"restore image into the host {self.hostname}")  
    if self.restore():
      sleep(10)
      logger.info(f"configure network into {self.vmname}")
      if self.configure() and snapname:
        logger.info("take a snapshot...")
        self.snapshot(snapname)
    
  def destroy(self) -> bool:
    return self.run_shell_on_host(f"qm stop {self.vmid} && qm destroy {self.vmid}")
    
  def restore(self) -> bool:
    command = f"qmrestore {self.image} {self.vmid} --storage {self.storage} --unique --force && "
    command+= f"qm set {self.vmid} --name {self.vmname} --sockets {self.sockets} --cores {self.cores} --memory {self.memory_mb} && "
    command+= f"qm start {self.vmid}"
    return self.run_shell_on_host(command)
    
  def snapshot(self, name : str) -> bool:
    return self.run_shell_on_host(f"qm snapshot {self.vmid} {name}")

  def reset(self) -> bool:
    return self.run_shell_on_host( f"qm stop {self.vmid} && qm start {vmid}" )
  
  def configure(self) -> bool:
    script_http = "https://raw.githubusercontent.com/jodafons/lps-cluster/refs/heads/main/playbooks/yaml/vm/configure_network.sh" 
    script_name = script_http.split("/")[-1]
    command =  f"wget {script_http} && bash {script_name} {self.vmname} {self.ip_address}"
    ok = self.run_shell_on_vm( command , script='vm/configure_network.yaml', configured=False)
    if ok and hasattr(self, 'device'):
      script_http="https://raw.githubusercontent.com/jodafons/lps-cluster/refs/heads/main/servers/slurm-worker/05_install_cuda.sh"
      script_name = script_http.split("/")[-1]
      command = f"bash {script_name}"
      ok = self.run_shell_on_vm( command )
    return ok



def common_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                      help = "dry run...")
  parser.add_argument('-v','--verbose', action='store_true', dest='verbose', required = False, 
                      help = "Set as verbose output.")
  return parser

def vm_create_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser]

def vm_destroy_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser] 

def vm_snapshot_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False, formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                      help = "The name of the vm.")
  parser.add_argument('--snapshot', action='store', dest='snapshot', required = False, default='base',
                      help = "The name of the snapshot.") 
  return [common_parser(),parser]
  


