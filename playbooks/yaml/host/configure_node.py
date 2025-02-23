import os, subprocess
from tempfile import mkstemp
from shutil import move, copymode
from os import fdopen, remove

def replace(file_path, pattern, subst):
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                if pattern in line:
                    new_file.write(subst+"\n")
                else:
                    new_file.write(line)
    copymode(file_path, abs_path)
    remove(file_path)
    move(abs_path, file_path)
    
    
has_gpu = "NVIDIA" in subprocess.check_output(['lspci', '-s', '01:00']).decode()

if has_gpu:
    gpu_codes = subprocess.check_output(['lspci', '-s', '01:00', '-n']).decode()[:-1]
    gpu_codes = [ o.split(' ')[-3] for o in gpu_codes.split('\n')]
    gpu_codes = ','.join(gpu_codes)
    print(gpu_codes)
    GRUB_CMDLINE_LINUX_DEFAULT=f'GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on pcie_acs_override=downstream,multifunction initcall_blacklist=sysfb_init video=vesa:off vfio-pci.ids={gpu_codes} vfio_iommu_type1.allow_unsafe_interrupts=1 kvm.ignore_msrs=1 modprobe.blacklist=radeon,nouveau,nvidia,nvidiafb,nvidia-gpu"'
    print(GRUB_CMDLINE_LINUX_DEFAULT)
    replace(f"/etc/default/grub" , "GRUB_CMDLINE_LINUX_DEFAULT", GRUB_CMDLINE_LINUX_DEFAULT)
    os.system("update-grub")
    modules = ["vfio","vfio_iommu_type1","vfio_pci","vfio_virqfd"]
    with open("/etc/modules",'w') as f:
        for module in modules:
            f.write(f"{module}\n")
    os.system("update-initramfs -u -k all")
else:
    print("current host has no GPUs installed")