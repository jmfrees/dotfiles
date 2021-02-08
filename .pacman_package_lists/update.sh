#!/bin/bash

echo "Running pacman -Qqne > ./driver"
              pacman -Qqne > ./driver
echo "Running pacman -Qqme > ./external"
              pacman -Qqme > ./external
