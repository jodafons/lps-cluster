# Caloba Cluster

This repository is responsible to hold the necessary documentation and scrits to build each 
server (service) into the lab infrastructure.


## Links:



## Service Nodes:

There are two physically service nodes into the network. The node `service01` is responsible
to hold:

- Domain name server managed by `dns-server` virtual machine with address `146.164.147.2`
- LDAP accounts and Kerberos passwords managed by `auth-server` virtual machine with address `146.163.147.3`
- SLURM manager control managed by `slurm-server` virtual machine with address `146.164.147.4`
- Login managed by `login-server` virtual machine with address `146.164.147.5`
- VPN server managed by `vpn-server` virtual machine with address `146.164.147.6`


## Main Storage:

The main storage is named as `storage01` with address `10.1.1.202` into the network.
Into the storage we have the `market_place` folder. This folder is responsible
to hold all necessary binaries, files and keys to build the entire infrastucture
and propagate it to all nodes. All nodes has access to this folder by `NFS` service.

The location is always `/mnt/market_place` inside any node and are physically located at `10.1.1.202:/volume1/market_place` into the `storage01`.

### Market Place:

- `/mnt/market_place/data` is responsible to hold `ldap` and `kerberos` backup.
- `/mnt/market_place/module_file` is responsible to hold all binaries linked by the `module` program.
- `/mnt/market_place/nvidia` is responsible to hold all `NVIDIA` binaries.
- `/mnt/market_place/slurm_build` is responsible to hold the `slurm` binary package, the generated `murge.key` and the `slurm` configuration. All nodes are linked with these files.
- `/mnt/market_place/volumes` is responsible to hold all docker volumes like `postgres`, `openvpn` and `proxy` services.

### Homes:

Is responsible to hold all user accounts. Is physically located at `10.1.1.202:/volume1/homes`.

## Backup Storage


