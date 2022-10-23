#
# Fix kernel
#
apt install -y linux-headers-$(uname -r)

#
# Disabe novauo
#

echo "blacklist nouveau
options nouveau modeset=0
" > /etc/modprobe.d/blacklist-nouveau.conf

reboot now