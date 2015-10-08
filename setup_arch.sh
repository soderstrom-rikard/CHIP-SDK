#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMON_SCRIPT=$DIR/setup_common.sh

echo -e "\n Setting up environment in $(uname -r)"

REQUIRED_PACKAGES="                                                           \
  rsync git mercurial cmake unzip dtc screen cpio python                      \
  uboot-tools android-tools libusb pkg-config"

if [ "$(uname -m)" = "x86_64" ];
then
  if [ ! -f /var/lib/pacman/sync/multilib.db ];
  then
    echo "You need to enable multilib, please visit                           \
      https://wiki.archlinux.org/index.php/Multilib for more details"
    exit -1
  else
    # ARCH LINUX 64-bit extra requirements
    REQUIRED_PACKAGES+=" gcc-multilib lib32-ncurses lib32-zlib"
  fi
else
  # ARCH LINUX 32-bit extra requirements
  REQUIRED_PACKAGES+=""
fi

# Perform full system update and install any missing packages
sudo pacman -Syyu --needed $REQUIRED_PACKAGES

echo -e "\n Adding udev rule for Allwinner device"
echo -e '\
SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="efe8", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="usb-chip"
SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="1010", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="usb-chip-fastboot"
' | sudo tee /etc/udev/rules.d/99-allwinner.rules
sudo udevadm control --reload-rules

${COMMON_SCRIPT} $@
exit $?
