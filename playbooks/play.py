#!/bin/python

import argparse
import sys,os,json,re
import socket
import traceback

from typing import List, Dict
from time import sleep
from pprint import pprint
from loguru import logger
from rich_argparse import RichHelpFormatter



def get_argparser_formatter():
  RichHelpFormatter.styles["argparse.args"]     = "green"
  RichHelpFormatter.styles["argparse.prog"]     = "bold grey50"
  RichHelpFormatter.styles["argparse.groups"]   = "bold green"
  RichHelpFormatter.styles["argparse.help"]     = "grey50"
  RichHelpFormatter.styles["argparse.metavar"]  = "blue"
  return RichHelpFormatter
    
class Playbook:
  __preexec = "export ANSIBLE_HOST_KEY_CHECKING=False"

  def __init__(self, 
               localpath : str=os.getcwd(),
               dry_run   : bool=False,
               verbose   : bool=False,
               ):
    self.dry_run   = dry_run
    self.localpath = localpath+"/yaml"
    self.verbose   = verbose

  def run_shell(self, 
                hostname    : str, 
                command     : str, 
                description : str="", 
                script      : str="shell.yaml"
              ) -> bool:
    
    params = f"description='{description}' "
    params+= f"hosts={hostname} "
    params+= f"command='{command}' "
    return self.run(script, params)

  def run(self, script : str, params : str) -> bool:
    script = f"{self.localpath}/{script}"
    command=f'{self.__preexec} && ansible-playbook -i {self.localpath}/hosts {script} -e "{params}"'
    if self.verbose:
      command+=" -vv"
    logger.info(command)
    try:
      if not self.dry_run:
        os.system(command)
      return True
    except:
      traceback.print_exp()
      return False

    


class VM(Playbook):
  
  def __init__(self,
               name                 : str,
               cluster_config_file  : str,
               dry_run              : bool=True,
               ):
    Playbook.__init__(self,dry_run=dry_run)
    with open(cluster_config_file,'r') as f:
      for key, value in f["common"].items():
        setattr(self, key, value)
      for key, value in f["vm"][vmname].items():
        setattr(self, key, value)

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
  parser.add_argument('--cluster-config-file', action='store', dest='cluster_config_file', required = False, type=str, default=f"{os.getcwd()}/cluster.json",
                      help = "The cluster configuration json file.")
  parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                      help = "dry run...")
  parser.add_argument('--master-key', action='store', dest='master_key', required = False, default=os.environ.get("CALOBA_MASTER_KEY",""),
                      help = "The master key.")
  parser.add_argument('-v','--verbose', action='store_true', dest='verbose', required = False, 
                      help = "Set as verbose output.")
  return parser

def vm_create_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--vmname', action='store', dest='vmname', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser]

def vm_destroy_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--vmname', action='store', dest='vmname', required = True,
                    help = "The name of the vm.")
  return [common_parser(),parser] 

def vm_snapshot_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False, formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--vmname', action='store', dest='vmname', required = True,
                      help = "The name of the vm.")
  parser.add_argument('--snapshot', action='store', dest='snapshot', required = False, default='base',
                      help = "The name of the snapshot.") 
  return [common_parser(),parser]
  
def cluster_create_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                      help = "The name of the cluster.")
  return [common_parser(), parser]

def cluster_destroy_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,formatter_class=get_argparser_formatter())
  parser.add_argument('-n','--name', action='store', dest='name', required = True,
                      help = "The name of the cluster.")
  return [common_parser(), parser]

def build_argparser( custom : bool=False):

    parser          = argparse.ArgumentParser(  formatter_class=get_argparser_formatter())
    mode            = parser.add_subparsers(dest='mode')
    
    cluster_parent = argparse.ArgumentParser( add_help=False,   formatter_class=get_argparser_formatter())
    option         = cluster_parent.add_subparsers(dest='option')
    option.add_parser("create", parents = cluster_create_parser()  ,help="")
    option.add_parser("destroy" , parents = cluster_destroy_parser()   ,help="")
    mode.add_parser( "cluster", parents=[cluster_parent]           ,help="")

    vm_parent = argparse.ArgumentParser( add_help=False,   formatter_class=get_argparser_formatter())
    option = vm_parent.add_subparsers(dest='option')
    option.add_parser("create"    , parents = vm_create_parser()    ,help="")
    option.add_parser("destroy"   , parents = vm_destroy_parser()   ,help="")
    option.add_parser("snapshot"  , parents = vm_snapshot_parser()  ,help="")
    mode.add_parser( "vm"         , parents=[vm_parent]             ,help="")
    return parser

def create_vm(args) -> VM:
  return VM( args.vmname, cluster_config_file=args.cluster_config_file, dry_run=args.dry_run)
  
def create_cluster(args) -> Cluster:
  return Cluster( args.name, 
                  master_key=args.master_key, 
                  cluster_config_file=args.cluster_config_file, 
                  dry_run=args.dry_run,
                  verbose=args.verbose)
  
def run_parser(args):
    if args.mode == "cluster":
        if args.option == "create":
          cluster = create_cluster(args)
          cluster.create()
        elif args.option == "destroy":
          cluster = create_cluster(args)
          cluster.destroy()
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