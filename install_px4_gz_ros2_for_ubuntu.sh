#!/bin/bash

set -x

cd 

touch .profile

set +e
sudo apt-get update -y
sudo apt-get upgrade -y
set -e

sudo apt-get install lsb-release wget gnupg -y

sudo apt-get install wget -y
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
set +e
sudo apt-get update -y
set -e

sudo apt-get install gz-harmonic -y


cd
sudo apt-get install git python3-pip -y
git clone --depth 1 --branch v1.15.3 https://github.com/PX4/PX4-Autopilot.git --recursive
cd PX4-Autopilot/
# add a fix for ubuntu 24
set +e
git fetch origin main
set -e
git show 058fe54:Tools/setup/ubuntu.sh > Tools/setup/ubuntu.sh
#git submodule foreach git pull origin main
bash ./Tools/setup/ubuntu.sh --no-sim-tools
make px4_sitl

cd

set +e
sudo apt-get update -y
set -e
sudo apt install locales -y
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
sudo apt install software-properties-common -y
sudo add-apt-repository universe -y
set +e
sudo apt-get update -y
set -e
sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
set +e
sudo apt-get update -y
set -e
sudo apt upgrade -y
sudo apt install ros-jazzy-desktop -y
sudo apt install ros-dev-tools -y
source /opt/ros/jazzy/setup.bash && echo "source /opt/ros/jazzy/setup.bash" >> .bashrc

pip install --user -U empy==3.3.4 pyros-genmsg==0.5.8 setuptools==70.0.0 opencv-python


cd
git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/
cd


sudo apt install python3-colcon-clean -y


sudo apt autoremove -y


