

#from loguru import logger

def run(hostname, command, description="command..."):

  body = """---
- name: cluster task
  hosts: "{hostname}"
  remote_user: root
  become: yes
  tasks:
     - name: {description}
       ansible.builtin.shell: |
        {command}
"""
  return body.format(hostname=hostname,description=description,command=command)


print(run("caloba-v10", "ls -lisah", "list all..."))









