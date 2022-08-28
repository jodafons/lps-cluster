

# install munge
apt install -y libmunge-dev libmunge2 munge
cp /mnt/market_place/slurm_build/munge.key /etc/munge/
chown munge:munge /etc/munge/munge.key
chmod 400 /etc/munge/munge.key
systemctl enable munge
systemctl restart munge


# install SLURM
dpkg -i /mnt/market_place/slurm_build/slurm-22.05.3/slurm-22.05.3_1.0_amd64.deb 
mkdir /etc/slurm
cp /mnt/market_place/slurm_build/slurm.conf /etc/slurm/
cp cgroup_allowed_devices_file.conf /etc/slurm
cp cgroup.conf /etc/slurm
touch /etc/slurm/gres.conf
useradd slurm
mkdir -p /var/spool/slurm/d
cp slurmd.service /etc/systemd/system/
systemctl enable slurmd
systemctl start slurmd

# configure grub
cp grub /etc/default
update-grub

# configure PAM/ssh
cp /mnt/market_place/slurm_build/slurm-22.05.3/contribs/sjstat /usr/bin/
cp /mnt/market_place/slurm_build/slurm-22.05.3/contribs/pam/.libs/pam_slurm.so /lib/x86_64-linux-gnu/security/
cp sshd /etc/pam.d
reboot now

