# ROS2 Performance Framework

The `master` branch of this repository targets the current ROS 2 development branch.
It may fail to compile if you are using a stable ROS 2 distribution.
If you want to run the framework using one of the stable ROS 2 distribtions switch to its specific branch (e.g. `dashing` or `eloquent`).

The **[irobot-benchmark](irobot-benchmark)** package contains the application used by iRobot to evaluate the ROS2 performance and the results obtained with it.

This executable depends on the performance framework contained in the other packages in this directory.

## Building the framework

This framework requires ROS2 Dashing Diademata.
Python3 is needed in order to use the visualization scripts.

```
mkdir -p ~/performance_ws/src
cd ~/performance_ws/src
git clone https://github.com/irobot-ros/ros2-performance
cd ..
colcon build
```

## Running the iRobot benchmark application

```
source ~/performance_ws/install/local_setup.sh
cd ~/performance_ws/install/irobot-benchmark/lib/irobot-benchmark
./irobot-benchmark topology/sierra_nevada.json
```

The results will be printed to screen and also saved in the directory `./sierra_nevada_log`.


## Extending the performance framework and testing your own system

The `irobot-benchmark/topology` directory contains some examples of json files that can be used to create a system.
If you want to create your own, follow the instructions in the `performance_test_factory` package:

[How to create a new topology](performance_test_factory/create_new_topology.md)

## Structure of the framework

 - **[performance_test](performance_test)**: this package provides the `performance_test::Node` class, which provides API for easily adding publishers, subscriptions, clients and services and monitor the performance of the communication. Moreover the `performance_test::System` class allows to start multiple nodes at the same time, while ensuring that they discover each other, and to monitor the performance of the whole system.
 Moreover, this pacakge contains scripts for visualizing the performance of applications.
 - **[performance_test_msgs](performance_test_msgs)**: this package contains basic interface definitions that are directly used by the `performance_test` package to measure performance.
 - **[performance_test_factory](performance_test_factory)**: this package provides the `performance_test::TemplateFactory` class that can be used to create `performance_test::Node` objects with specific publishers and subscriptions according to some arguments provided at runtime: this can be done through json files or command line options. The interfaces (msg and srv) that can be used in these nodes have to be defined in the so called `performance_test_factory_plugins`.
 - **[performance_test_plugin_cmake](performance_test_plugin_cmake)**: this package provides the CMake function used to generate a factory plugin from interfaces definitions.
 - **[irobot_interfaces_plugin](irobot_interfaces_plugin)**: this package is a `performance_test_factory_plugin` that provides all the interfaces used in the iRobot system topologies.
 - **[irobot-benchmark](irobot-benchmark)**: this package provides our main benchmark application. This executable can load one or multiple json topologies and it creates a ROS2 system running in a specific process from each of them.
 It also contains the json topologies used for iRobot performance evaluation.


#### Experiments

 The **[experiments](experiments)** directory contains the results obtained running several simple performance tests on different ROS2 distributions.
Each `README` file contains a description of the experiment, instructions for reproducing it and the results obtained.
The experiments are all using the example applications contained in the `performance_test_factory` package.

Evaluations have been performed on standard x86_64 laptops as well as on embedded platforms.

| Experiment | README |
| ------------- | ------------- |
| Discovery time | [README.md](experiments/crystal/discovery_time) |
| Pub/Sub Latency | [README.md](experiments/crystal/pub_sub_latency) |
| Pub/Sub Reliability | [README.md](experiments/crystal/pub_sub_reliability) |
| Pub/Sub Memory usage | [README.md](experiments/crystal/pub_sub_memory) |
| Pub/Sub CPU usage | [README.md](experiments/crystal/pub_sub_cpu) |
| Client/Service systems | [README.md](experiments/crystal/client_service) |
| Bouncy-Crystal regression test | [README.md](experiments/crystal/regression) |
