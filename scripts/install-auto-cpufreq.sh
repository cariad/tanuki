#!/usr/bin/env bash

set -e

echo -e "${li:?}Installing auto-cpufreq..."
sudo snap install auto-cpufreq

echo -e "${li:?}Installing auto-cpufreq process..."
sudo auto-cpufreq --install

echo -e "${ok:?}Installed auto-cpufreq!"
