

basepath=$PWD

cd scripts/proxmox/gpu
source build.sh
cd $basepath

cd scripts/proxmox/gpu-large
source build.sh
cd $basepath

cd scripts/proxmox/cpu-large
source build.sh
cd $basepath
