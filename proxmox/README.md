
# Proxmox:


## Initial setup:

Inside of the `shell` proxmox node server:

```
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
```


### Configuration for GPU nodes:



## Backup machines

After `backup` the image using the `gui` proxmox interfaces go to
`/var/lib/vz/dump` and copy all files to `/mnt/market_place/images/base_caloba`

Than, for each proxmox node (inside of the `shell` interface), copy the `base_caloba` files to `/var/lib/vz/dump`. For each proxmox node, after copy,
go to `backup` and restore the image.

## Cloned VMs:

Before start, we need to setup somethings inside of the new cloned node:

* Proxmox interface: Need to remove the network card and include again to change the `MAC-address`;
* Inside of the node: Run the script `reconfigure_cloned.sh` inside of the `nodes`
folder. This script will change the `hostname`, the `IP` and reset all `ssh` keys. 

### Change MAC-address:
