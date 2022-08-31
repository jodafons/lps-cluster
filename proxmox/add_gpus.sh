cp common/grub /etc/default 
update-grub

cp common/modules /etc/modules


#echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf
#echo "options kvm ignore_msrs=1" > /etc/modprobe.d/kvm.conf

#echo "blacklist radeon" >> /etc/modprobe.d/blacklist.conf
#echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
#echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf

lspci -nn | grep -i nvidia

echo "options vfio-pci ids=10de:1e07,10de:1e07 disable_vga=1"> /etc/modprobe.d/vfio.conf