

echo "Update fstab..."

mkdir -p /mnt/market_place
mkdir -p /mnt/cern_data
mkdir -p /mnt/shared_data

END=$(wc -l /etc/fstab | cut -d ' ' -f 1)
START=14
sed -i "${START},${END}d" /etc/fstab

echo "10.1.1.202:/volume1/homes /home nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.203:/volume1/cern_data /mnt/cern_data nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.203:/volume1/shared_data /mnt/shared_data nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
#mount -a







