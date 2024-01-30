

from loguru import logger


template = """
---
- name: cluster task
  hosts: "{hostname}"
  remote_user: root
  become: yes
  tasks:
     - name: {description}
       ansible.builtin.shell: |
        {command}
"""


class Cluster:


    def __init__(self):



    def reset(self):


    def build(self):



cluster = Cluster( name="gpu" )


cluster+=Node( name="caloba-v01", master=True )
cluster+=Node( name="caloba-v02" )



cluster["caloba-v01"] += VM(name="caloba70", ip="10.1.1.70", image=image , snapname="base")



cluster.reset()
cluster.build()


