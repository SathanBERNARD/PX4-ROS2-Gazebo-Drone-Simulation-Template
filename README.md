# PX4_Gazebo_ROS2_install_for_ubuntu


## Install
Work on Ubuntu 22 but not it's derivatives (Mint...)

``` sh
cd ~
git clone --recursive https://github.com/SathanBERNARD/PX4_Gazebo_ROS2_install_for_ubuntu.git
cd ~/PX4_Gazebo_ROS2_install_for_ubuntu
./install_px4_gz_ros2_for_ubuntu.sh
```

To copy the custom worlds and models from Autopilot_PATCH to the PX4 installation

``` sh
cd ~/PX4_Gazebo_ROS2_install_for_ubuntu
cp -r ./PX4-Autopilot_PATCH/* ~/PX4-Autopilot/
```

Install QGroundControl

## Usage (first launch)

### QGroundControl :

> Launch QGroundControl

### MicroXRCEAgent

In a new terminal :

``` sh
MicroXRCEAgent udp4 -p 8888
```

### PX4 SITL and Gazebo

In a new terminal :

``` sh
cd ~/PX4-Autopilot
PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9" PX4_GZ_WORLD=test_world make px4_sitl gz_x500_mono_cam
```

### ROS2 node for companion computer

In a new terminal :

``` sh
cd ~/PX4_Gazebo_ROS2_install_for_ubuntu/ws_ros2
colcon build
source install/local_setup.bash
ros2 run my_offboard_ctrl offboard_ctrl_example
```

For building only the my_offboard_ctrl package :

``` sh
colcon build --packages-select my_offboard_ctrl
```
