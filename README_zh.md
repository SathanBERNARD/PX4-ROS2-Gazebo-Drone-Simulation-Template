# PX4-ROS2-Gazebo 无人机仿真模板

本仓库提供了一个用于搭建带相机四旋翼无人机仿真环境的模板。它集成了 PX4、Gazebo Harmonic 与 ROS2 Humble，可用于开发和测试搭载机载计算机（companion computer）的无人机软件。该环境非常适合任务规划与计算机视觉类应用。仓库中包含一个 Python 示例脚本，演示如何控制无人机并获取相机图像，可作为后续开发的起点。

![总览 gif](media/1.gif)

## 目录结构

- **`PX4-Autopilot_PATCH/`**  
  包含需要复制到 PX4 安装目录中的自定义世界（world）、模型与配置文件。这些文件在 PX4 默认配置的基础上，扩展了额外的仿真环境和无人机模型。
- **`ws_ros2/`**  
  ROS2 工作空间，用于开发和构建自定义的 ROS2 节点。其中包含 `my_offboard_ctrl` 功能包，提供了使用 ROS2 控制无人机的示例。

## 安装

本方案已在 Ubuntu 22.04 上测试通过，与其衍生发行版（例如 Linux Mint）不兼容。

1. 克隆仓库并运行安装脚本：
   ```bash
   cd ~
   git clone --recursive https://github.com/SathanBERNARD/PX4-ROS2-Gazebo-Drone-Simulation-Template.git
   cd ~/PX4-ROS2-Gazebo-Drone-Simulation-Template
   ./install_px4_gz_ros2_for_ubuntu.sh
   ```
2. 将自定义世界与模型复制到 PX4 安装目录：
   ```bash
   cd ~/PX4-ROS2-Gazebo-Drone-Simulation-Template
   cp -r ./PX4-Autopilot_PATCH/* ~/PX4-Autopilot/
   ```
3. 安装 **QGroundControl**。

## 使用方法（首次启动）

### 1. 启动 QGroundControl

- 打开 **QGroundControl**。

### 2. 启动 Micro XRCE-DDS Agent

- 在新终端中启动 Micro XRCE-DDS Agent：
  ```bash
  MicroXRCEAgent udp4 -p 8888
  ```
  Micro XRCE-DDS Agent 使 uORB 消息能够作为 ROS 2 话题，在机载计算机上发布与订阅。

  更多信息请参阅 [uXRCE-DDS 文档](https://docs.px4.io/main/en/middleware/uxrce_dds.html)。

### 3. 运行 PX4 SITL 与 Gazebo

- 在另一个终端中，启动带 Gazebo 的 PX4 SITL：
  ```bash
  PX4_SYS_AUTOSTART=4010 \
  PX4_SIM_MODEL=gz_x500_mono_cam \
  PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9" \
  PX4_GZ_WORLD=test_world \
  ~/PX4-Autopilot/build/px4_sitl_default/bin/px4
  ```
  - `PX4_SYS_AUTOSTART=4010` 定义 PX4 使用的机架类型。**4010** 机架是 **x500_mono_cam** 的默认机架，等同于 **4001** 机架。
  - `PX4_SIM_MODEL=gz_x500_mono_cam` 指定在 Gazebo 中加载的模型。
  - `PX4_GZ_MODEL_POSE="1,1,0.1,0,0,0.9"` 设置载具的初始位姿。
  - `PX4_GZ_WORLD=test_world` 定义要加载的 Gazebo 世界。
  延伸阅读：
  - [Gazebo 仿真文档](https://docs.px4.io/main/en/sim_gazebo_gz/)
  - [机架参考](https://docs.px4.io/main/en/airframes/airframe_reference.html)
  - [4010 机架文件](https://github.com/PX4/PX4-Autopilot/blob/main/ROMFS/px4fmu_common/init.d-posix/airframes/4010_gz_x500_mono_cam)
  如果出现 `ERROR [gz_bridge] Service call timed out.` 报错，重试一次即可。

### 4. 构建并运行 ROS2 节点（机载计算机软件）

- 在新终端中构建并运行 ROS2 节点：
  ```bash
  cd ~/PX4-ROS2-Gazebo-Drone-Simulation-Template/ws_ros2
  colcon build
  source install/local_setup.bash
  ros2 run my_offboard_ctrl offboard_ctrl_example
  ```
- 若只需构建 `my_offboard_ctrl` 功能包：
  ```bash
  colcon build --packages-select my_offboard_ctrl
  ```
  更多细节请参阅 [ROS2 功能包文档](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Creating-Your-First-ROS2-Package.html)。
