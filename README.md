# PX4-ROS2-Gazebo Drone Simulation Template

This repository provides a template to set up a simulation environment for a quadcopter equipped with a camera. It integrates PX4, Gazebo Harmonic, and ROS2 Humble, enabling the development and testing of software for a drone with a companion computer. This environment is ideal for mission planning and computer vision applications. A Python example script is included to demonstrate how to control the drone and access the camera feed, serving as a starting point for further development.

![Overview gif](media/1.gif) 

## Directory Structure

- **`PX4-Autopilot_PATCH/`**  
  Contains custom worlds, models, and configurations to be copied into the PX4 installation. These files extend the default PX4 setup with additional simulation environments and drone models.

- **`ws_ros2/`**  
  The ROS2 workspace where custom ROS2 nodes are developed and built. It includes the `my_offboard_ctrl` package, providing an example of drone control using ROS2.

## Installation

This setup is tested on Ubuntu 22.04 and is not compatible with its derivatives (e.g., Linux Mint).

1. Clone the repository and run the installation script:
   ```bash
   cd ~
   git clone --recursive https://github.com/SathanBERNARD/PX4_Gazebo_ROS2_install_for_ubuntu.git
   cd ~/PX4_Gazebo_ROS2_install_for_ubuntu
   ./install_px4_gz_ros2_for_ubuntu.sh
   ```

2. Copy the custom worlds and models into the PX4 installation:
   ```bash
   cd ~/PX4_Gazebo_ROS2_install_for_ubuntu
   cp -r ./PX4-Autopilot_PATCH/* ~/PX4-Autopilot/
   ```

3. Install **QGroundControl**.

## Usage (First Launch)

### 1. Launch QGroundControl

- Open **QGroundControl**.

### 2. Start the Micro XRCE-DDS Agent

- In a new terminal, start the Micro XRCE-DDS Agent:
  ```bash
  MicroXRCEAgent udp4 -p 8888
  ```
  The Micro XRCE-DDS Agent allows uORB messages to be published and subscribed to on a companion computer as ROS 2 topics.

  For more information, refer to the [uXRCE-DDS documentation](https://docs.px4.io/main/en/middleware/uxrce_dds.html).

### 3. Run PX4 SITL and Gazebo

- In another terminal, launch PX4 SITL with Gazebo:
  ```bash
  PX4_SYS_AUTOSTART=4010 \
  PX4_SIM_MODEL=gz_x500_mono_cam \
  PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9" \
  PX4_GZ_WORLD=test_world \
  ~/PX4-Autopilot/build/px4_sitl_default/bin/px4
  ```
  - `PX4_SYS_AUTOSTART=4010` defines the airframe to be used by PX4. The **4010** airframe is the default for **x500_mono_cam** and is equivalent to the **4001** airframe.
  - `PX4_SIM_MODEL=gz_x500_mono_cam` specifies the model to load in Gazebo.
  - `PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9"` sets the initial pose of the vehicle.
  - `PX4_GZ_WORLD=test_world` defines the Gazebo world to be loaded.

  Further information:
  - [Gazebo Simulation Documentation](https://docs.px4.io/main/en/sim_gazebo_gz/)
  - [Airframes Reference](https://docs.px4.io/main/en/airframes/airframe_reference.html)
  - [4010 Airframe File](https://github.com/PX4/PX4-Autopilot/blob/main/ROMFS/px4fmu_common/init.d-posix/airframes/4010_gz_x500_mono_cam)

  In case of error message `ERROR [gz_bridge] Service call timed out.` try again.

### 4. Build and Run the ROS2 Node (Companion Computer Software)

- In a new terminal, build and run the ROS2 node:
  ```bash
  cd ~/PX4_Gazebo_ROS2_install_for_ubuntu/ws_ros2
  colcon build
  source install/local_setup.bash
  ros2 run my_offboard_ctrl offboard_ctrl_example
  ```

- To build only the `my_offboard_ctrl` package:
  ```bash
  colcon build --packages-select my_offboard_ctrl
  ```

  For additional details, refer to the [ROS2 Package documentation](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Creating-Your-First-ROS2-Package.html).
