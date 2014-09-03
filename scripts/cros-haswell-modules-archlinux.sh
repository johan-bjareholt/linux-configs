#!/bin/bash
# Modified for Arch Linux from ChrUbuntu's cros-haswell-modules.sh
# for kernel 3.14.x

set -e

# Create a temp directory for our work
tempbuild=`mktemp -d`
cd $tempbuild

# Determine kernel version
archkernver=$(uname -r)
kernver=$(uname -r | cut -d'-' -f 1)
if [ -n "$(wget --spider -Sq https://www.kernel.org/pub/linux/kernel/v3.x/linux-${kernver}.tar.gz 2>&1 | grep -E 'HTTP.+404')" ]; then
    kernver=$(echo -n $kernver | cut -f '-2' -d '.')
fi

# Install necessary deps to build a kernel
echo "Installing linux-headers..."
sudo pacman -S --needed linux-headers

# Grab kernel source
echo "Fetching kernel sources..."
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-${kernver}.tar.gz
echo "Extracting kernel sources..."
tar xfvz linux-${kernver}.tar.gz
cd linux-${kernver}

# Use Benson Leung's post-Pixel Chromebook patches:
# https://patchwork.kernel.org/bundle/bleung/chromeos-laptop-deferring-and-haswell/
echo "Applying Chromebook Haswell Patches..."
for patch in 3078491 3078481 3074401 3074431 3074411; do
  wget -O - https://patchwork.kernel.org/patch/$patch/raw/ | sed 's/drivers\/platform\/x86\/chromeos_laptop.c/drivers\/platform\/chrome\/chromeos_laptop.c/g'| patch -p1
done

# Need this
cp /usr/lib/modules/${archkernver}/build/Module.symvers .

# Prep tree
zcat /proc/config.gz > ./.config
make oldconfig
make prepare
make modules_prepare

echo "Building relevant modules..."
# Build only the needed directories
make SUBDIRS=drivers/platform/chrome modules
make SUBDIRS=drivers/i2c/busses modules

echo "Installing relevant modules..."
# switch to using our new chromeos_laptop.ko module
# preserve old as .orig
chros_lap='/lib/modules/$archkernver/kernel/drivers/platform/chrome/chromeos_laptop.ko.gz'
if [ -f $chros_lap ];
then
sudo mv  $chros_lap ${chros_lap}.orig
fi
sudo cp drivers/platform/chrome/chromeos_laptop.ko /lib/modules/$archkernver/kernel/drivers/platform/chrome/
sudo gzip /lib/modules/$archkernver/kernel/drivers/platform/chrome/chromeos_laptop.ko

# switch to using our new designware i2c modules
# preserve old as .orig
sudo mv /lib/modules/$archkernver/kernel/drivers/i2c/busses/i2c-designware-core.ko.gz /lib/modules/$archkernver/kernel/drivers/i2c/busses/i2c-designware-core.ko.gz.orig
sudo mv /lib/modules/$archkernver/kernel/drivers/i2c/busses/i2c-designware-pci.ko.gz /lib/modules/$archkernver/kernel/drivers/i2c/busses/i2c-designware-pci.ko.gz.orig
sudo cp drivers/i2c/busses/i2c-designware-*.ko /lib/modules/$archkernver/kernel/drivers/i2c/busses/
sudo gzip /lib/modules/$archkernver/kernel/drivers/i2c/busses/i2c-designware-*.ko
sudo depmod -a $archkernver

echo "Installing xf86-input-synaptics..."
sudo pacman -S --needed xf86-input-synaptics

echo "Reboot to use your touchpad!"
