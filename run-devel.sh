#!/usr/bin/env bash

#sudo xhost +si:localuser:root
sudo docker run --runtime nvidia -it --rm --network host cuda-jetpack:4.4-devel
