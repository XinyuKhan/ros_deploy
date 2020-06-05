#!/bin/bash

# only run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# dependency script
./ros_core_setup.sh


CALL_USER=${SUDO_USER:-${USER}}


# update env
source ros_env.sh


echo "->>>>>>>>>> ROS Base Setup <<<<<<<<<<"

# install bootstrap tools
apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
# run rosdep init as root, run rosdep update as normal user
# sometime url dns resolve fail, add url ip to hosts config file manuely can solve this problem.
ROSDEP_UPDATE_CMD="rosdep update --rosdistro $ROS_DISTRO"
rosdep init && \
  sudo -H -u $CALL_USER bash -c "$ROSDEP_UPDATE_CMD"

# install ros packages
apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-ros-base=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*
