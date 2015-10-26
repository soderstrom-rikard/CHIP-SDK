#!/bin/bash
SUNXI_TOOLS=${1:-sunxi-tools}
CHIP_TOOLS=${2:-chip-tools}
CHIP_BUILDROOT=${3:-chip-buildroot}

# sunxi tools
if [ ! -d $SUNXI_TOOLS ];
then
  echo -e "\n Installing sunxi-tools"
  git clone http://github.com/NextThingCo/sunxi-tools $SUNXI_TOOLS
  pushd $SUNXI_TOOLS
  make
  if [[ -L /usr/local/bin/fel ]]; then
    sudo rm /usr/local/bin/fel
  fi
  sudo ln -s $PWD/fel /usr/local/bin/fel
  popd
else
  echo -e "\n skipping sunxi-tools, already installed"
fi

# CHIP Tools
if [ ! -d $CHIP_TOOLS ];
then
  echo -e "\n Installing CHIP-tools"
  git clone http://github.com/NextThingCo/CHIP-tools $CHIP_TOOLS
else
  echo -e "\n skipping CHIP-tools, already installed"
fi

# CHIP Buildroot
if [ ! -d $CHIP_BUILDROOT ];
then
  echo -e "\n Installing CHIP-buildroot"
  git clone http://github.com/NextThingCo/CHIP-buildroot $CHIP_BUILDROOT
else
  echo -e "\n skipping CHIP-buildroot, already installed"
fi
