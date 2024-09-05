# PX4 Gazebo ROS2 Installation for Ubuntu

This repository provides a template to set up a simulation environment for a quadcopter equipped with a camera. It uses PX4, Gazebo harmonic, and ROS2 humble, enabling the development and testing of software for a drone with a companion computer for mission planning and computer vision. 

A Python example script is included to show how to control the drone and access the camera feed, serving as a starting point for further development.
Here's a paragraph explaining the directory structure for the README:

## Directory Structure

- **`PX4-Autopilot_PATCH/`**: Contains custom worlds, models, and configurations to be copied into the PX4 installation. These files are used to extend the default PX4 setup with additional simulation environments and drone models.
- **`ws_ros2/`**: The ROS2 workspace where custom ROS2 nodes are developed and built. It includes the `my_offboard_ctrl` package, which provides an example of drone control using ROS2.

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
  MicroXRCEAgent is the interface that allows uORB messages to be published and subscribed on a companion computer as though they were ROS 2 topics.
  https://docs.px4.io/main/en/middleware/uxrce_dds.html

### PX4 SITL and Gazebo

- In a new terminal, launch PX4 SITL with Gazebo:
  ```sh
  PX4_SYS_AUTOSTART=4010 PX4_SIM_MODEL=gz_x500_mono_cam PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9" PX4_GZ_WORLD=test_world ~/PX4-Autopilot/build/px4_sitl_default/bin/px4
  ```
  This command launches the PX4 software in SITL (software in the loop) mode and Gazebo.
  
  - PX4_SYS_AUTOSTART=4010 defines the airframe to be used by PX4.
  The 4010 airframe is the default for x500_mono_cam and is equivalent to the 4001 airframe.
  
  - PX4_SIM_MODEL=gz_x500_mono_cam defines the model to be loaded in Gazebo.
  
  - PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9" defines the initial pose of the vehicle.
  
  - PX4_GZ_WORLD=test_world defines the world to be loaded in Gazebo.
  
  (Gazebo Simulation doc : https://docs.px4.io/main/en/sim_gazebo_gz/)

  (Airframes Reference : https://docs.px4.io/main/en/airframes/airframe_reference.html)

  (4010 airframe file https://github.com/PX4/PX4-Autopilot/blob/main/ROMFS/px4fmu_common/init.d-posix/airframes/4010_gz_x500_mono_cam) 


  

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

  (For more info, ROS2 Package doc : https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Creating-Your-First-ROS2-Package.html)
