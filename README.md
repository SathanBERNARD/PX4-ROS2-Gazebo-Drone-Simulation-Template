# PX4 Gazebo ROS2 Installation for Ubuntu

This repository provides a template to set up a simulation environment for a quadcopter equipped with a camera. It uses PX4, Gazebo harmonic, and ROS2 humble, enabling the development and testing of software for a drone with a companion computer for mission planning and computer vision. 

A Python example script is included to show how to control the drone and access the camera feed, serving as a starting point for further development.

## Install

This setup works on Ubuntu 22.04 but not on its derivatives (e.g., Linux Mint).

1. Clone the repository and run the installation script:
   ```sh
   cd ~
   git clone --recursive https://github.com/SathanBERNARD/PX4_Gazebo_ROS2_install_for_ubuntu.git
   cd ~/PX4_Gazebo_ROS2_install_for_ubuntu
   ./install_px4_gz_ros2_for_ubuntu.sh
   ```

2. Copy the custom worlds and models to the PX4 installation:
   ```sh
   cd ~/PX4_Gazebo_ROS2_install_for_ubuntu
   cp -r ./PX4-Autopilot_PATCH/* ~/PX4-Autopilot/
   ```

3. Install QGroundControl.

## Usage (First Launch)

### QGroundControl

- Launch QGroundControl.

### Micro XRCE-DDS Agent

- In a new terminal, start the Micro XRCE-DDS Agent:
  ```sh
  MicroXRCEAgent udp4 -p 8888
  ```

### PX4 SITL and Gazebo

- In a new terminal, launch PX4 SITL with Gazebo:
  ```sh
  cd ~/PX4-Autopilot
  PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9" PX4_GZ_WORLD=test_world make px4_sitl gz_x500_mono_cam
  ```

### ROS2 Node for Companion Computer

- In a new terminal, build and run the ROS2 node:
  ```sh
  cd ~/PX4_Gazebo_ROS2_install_for_ubuntu/ws_ros2
  colcon build
  source install/local_setup.bash
  ros2 run my_offboard_ctrl offboard_ctrl_example
  ```

- To build only the `my_offboard_ctrl` package:
  ```sh
  colcon build --packages-select my_offboard_ctrl
  ```
