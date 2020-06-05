#!/bin/bash

# only run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "->>>>>>>>>> ROS Core Setup <<<<<<<<<<"

CALL_USER=${SUDO_USER:-${USER}}

# update env
source ros_env.sh

# setup timezone
echo 'Etc/UTC' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*


# install packages
apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list(tuna deb source)
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ bionic main" > /etc/apt/sources.list.d/ros1-latest.list



apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-ros-core=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*



# add source cmd to shell rc
SHELL_RC=`grep $CALL_USER </etc/passwd | cut -f 7 -d ":" | cut -f 3 -d "/"`
SOURCE_SCRIPT="source /opt/ros/$ROS_DISTRO/setup.${SHELL_RC}"
SHELL_RC_PATH="/home/$CALL_USER/.${SHELL_RC}rc"

echo "->> Append $SOURCE_SCRIPT to file ${SHELL_RC_PATH}."
grep -q "$SOURCE_SCRIPT" $SHELL_RC_PATH || echo "$SOURCE_SCRIPT" >> $SHELL_RC_PATH


