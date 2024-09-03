#




## Install
Work on Ubuntu 22 but not it's derivatives (Mint...)

``` sh
git clone --recursive <...> [MODIFIER ------------------------- ]
cd Gazebo_PX4_Simulation_Template [MODIFIER ------------------------- ]
./install_px4_gz_ros2_for_ubuntu.sh
```



## Usage

In a terminal :

```
cd ~/PX4-Autopilot
make px4_sitl gz_x500_mono_cam (detailed version)
```

In a second terminal :

```
MicroXRCEAgent udp4 -p 8888
```

In a third terminal :

```
cd ~/jetsonsoftware/ws_ros2_jetson
colcon build
source install/local_setup.bash
ros2 run my_offboard_ctrl offboard_ctrl_example
```

For only building the my_offboard_ctrl package :

```
colcon build --packages-select my_offboard_ctrl
```
