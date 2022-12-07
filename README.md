# Caloba Cluster

This repository is responsible to hold the necessary documentation and scrits to build each 
server (service) into the lab infrastructure.



## Storage:

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




