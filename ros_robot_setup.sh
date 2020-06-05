#!/bin/bash

# only run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# dependency script
./ros_base_setup.sh

echo "->>>>>>>>>> ROS Robot Setup <<<<<<<<<<"

CALL_USER=${SUDO_USER:-${USER}}

# update env
source ros_env.sh


# install ros packages
apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-robot=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*