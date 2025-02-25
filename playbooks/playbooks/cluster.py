__all__ = ["Cluster", 
           "cluster_create_parser", 
           "cluster_destroy_parser",
           "cluster_ping_parser", 
           "cluster_reboot_parser"]

import os, argparse, json
from typing import List, Dict
from time import sleep
from pprint import pprint
from loguru import logger
from playbooks import Playbook, get_cluster_config, get_argparser_formatter
    
    
class Cluster(Playbook):
  
  def __init__(self, 
               cluster             : str,
               dry_run             : bool=False,
               verbose             : bool=False,
               ):
    Playbook.__init__(self, dry_run=dry_run, verbose=verbose)
    self.cluster=cluster
    conf = get_cluster_config()
    for key, value in conf["cluster"][cluster].items():
      setattr(self,key,value)
      
      
  def ping_all(self):
    self.ping(self.cluster)
     
  def run_shell_on_all(self,command:str, description : str="") -> bool:
    return self.run_shell(self.cluster, command, description=description)
  
  
  def run_shell_on_master_host(self, command : str, description : str="") -> bool:
    return self.run_shell(self.host, command, description=description)
    
    
  def reset_cluster(self) -> bool:
    logger.info(f"reset the cluster with name {self.cluster}")
    command = "systemctl stop pve-cluster corosync && "
    command+= "pmxcfs -l && "
    command+= "rm -rf /etc/corosync/* && "
    command+= "rm -rf /etc/pve/corosync.conf && "
    command+= "killall pmxcfs && "
    command+= "systemctl start pve-cluster && "
    command+= "rm -rf /etc/pve/nodes/*"
    return self.run_shell_on_all(command, description="reset nodes...")
    
    
  def reboot(self) -> bool:
    return self.run("reboot.yaml", params=f"hosts={self.cluster}")
    
    
  def create_cluster(self) -> bool:
    logger.info(f"create cluster into the host {self.host} for cluster {self.cluster}")
    command = f"pvecm create {self.cluster} --votes 1"
    return self.run_shell_on_master_host(command, description="create cluster...")


  def add_nodes(self, master_key : str) -> bool:
    logger.info(f"add nodes into the cluster {self.cluster}...")
    params = f"hosts={self.cluster} ip_address={self.ip_address} master_key='{master_key}'" 
    return self.run("host/add_node.yaml", params)


  def add_storage(self) -> bool:
    command = f"pvesm add nfs {{storage_name}} --server {{ip_address}} --export /volume1/proxmox --content iso,backup,images"
    return self.run_shell_on_master_host( command, description="add storages...")


  def configure_nodes(self) -> bool:
    script_http = "https://raw.githubusercontent.com/jodafons/lps-cluster/refs/heads/main/playbooks/yaml/host/configure_node.py"
    script_name = script_http.split("/")[-1]
    command     = f"wget {script_http} && python3 {script_name}"
    ok = self.run_shell_on_all(command, description="configure gpus passthorug...")
    if not ok:
      logger.error("it is not possible to configure nodes...")
      return False    
    return self.reboot()

    
  def destroy(self) -> bool:
    self.reset_cluster()
    self.reboot()


  def create(self, master_key : str) -> bool:
    logger.info(f"[step 1] resetting all nodes into the cluster {self.cluster}...")
    ok = self.reset_cluster()
    if not ok:
      logger.error(f"[step 1] it is not possible to reset all nodes")
      return False

    logger.info(f"[step 2] reboot all nodes into the cluster {self.cluster}...")
    ok = self.reboot()
    if not ok:
      logger.error(f"[step 2] it is not possible to reboot all nodes")
      return False
        
    sleep(30)
    logger.info(f"[step 3] create the cluster with name {self.cluster}...")
    ok = self.create_cluster()
    if not ok:
      logger.error(f"[step 3] it is not possible to create the cluster with name {self.cluster}")
      return False
          
    sleep(10)
    logger.info(f"[step 4] add nodes into the cluster {self.cluster}...")

    ok = self.add_nodes(master_key)
    if not ok:
      logger.error(f"[step 4] it is not possible to add nodes the cluster {self.cluster}")
      return False
    
    sleep(5)
    logger.info(f"[step 5] configure all nodes into the cluster {self.cluster}...")
    ok = self.configure_nodes()
    if not ok:
      logger.error(f"[step 5] it is not possible to configure all nodes into the cluster {self.cluster}")
      return False
    
    return True 




def common_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  
  parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                      help = "dry run...")
  parser.add_argument('-v','--verbose', action='store_true', dest='verbose', required = False, 
                      help = "Set as verbose output.")
  return parser

def cluster_create_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                      help = "The name of the cluster.")
  parser.add_argument('--master-key', action='store', dest='master_key', required = False, default=os.environ.get("CALOBA_MASTER_KEY",""),
                      help = "The master key.")
  return [common_parser(), parser]

def cluster_destroy_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                      help = "The name of the cluster.")
  return [common_parser(), parser]

def cluster_reboot_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                      help = "The name of the cluster.")
  return [common_parser(), parser]

def cluster_ping_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                      help = "The name of the cluster.")
  return [common_parser(),parser]