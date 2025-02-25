__all__ = ["Slurm", 
           "slurm_ping_parser", 
           #"slurm_update_parser", 
           "slurm_restart_parser"
           ]


import os, argparse, json
from typing import List, Dict
from time import sleep
from pprint import pprint
from loguru import logger
from playbooks import Playbook, get_cluster_config, get_argparser_formatter
    



class Slurm(Playbook):
  
  def __init__(self,
               dry_run  : bool=False,
               verbose  : bool=False,
               ):
    Playbook.__init__(self,dry_run=dry_run, verbose=verbose)
    
  def ping_all(self):
    self.ping(self.hosts)
           
  def restart(self):
    description = "Restart slurm control..."
    command = "sudo systemctl daemon-reload && "
    command+= "sudo systemctl start munge && "
    command+= "sudo systemctl enable slurmdbd && "
    command+= "sudo systemctl start slurmdbd && "
    command+= "sudo systemctl enable slurmctld &&"
    command+= "sudo systemctl start slurmctld && "
    command+= "sudo scontrol reconfigure"
    params = f"hosts=slurmctld, command='{command}' description={description}"
    self.run("shell.yaml", params)
    params = f"hosts=vm"
    self.run( "slurm/restart_slurmd.yaml", params)
      
      
def common_parser():
  parser = argparse.ArgumentParser(description = '', add_help = False,  formatter_class=get_argparser_formatter())
  
  parser.add_argument('--dry-run', action='store_true', dest='dry_run', required = False,
                      help = "dry run...")
  parser.add_argument('-v','--verbose', action='store_true', dest='verbose', required = False, 
                      help = "Set as verbose output.")
  return parser
  
def slurm_ping_parser():
  return [common_parser()]
 
def slurm_restart_parser():
  return [common_parser()] 