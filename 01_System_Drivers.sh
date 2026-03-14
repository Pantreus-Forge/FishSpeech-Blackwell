#!/bin/bash
# ==============================================================================
# 🔱 FishSpeech-Blackwell Ignition
# Author: Pantreus (Pantreus-Forge)
# Repository: https://github.com/Pantreus-Forge/FishSpeech-Blackwell
# License: GNU GPLv3
#
# Description: Automated local Fish Speech setup for NVIDIA 50-series GPUs.
# If you fork, share, or use this in your own project, credit is required.
# ==============================================================================

# AUTO-TERMINAL LAUNCHER
if [ -t 0 ]; then :; else konsole --hold -e "$0" "$@"; exit; fi

echo "========================================================"
echo "      BLACKWELL SUPREMACY: DRIVER INSTALLATION          "
echo "========================================================"

if dpkg -l | grep -i nvidia-driver > /dev/null 2>&1; then
    echo "🚨 STOP: EXISTING NVIDIA DRIVERS DETECTED 🚨"
    echo "This script is for fresh installations only."
    echo "Please refer to the README for manual upgrade steps."
    exit 1
fi

echo "Starting Blackwell Driver Deployment (Cold Start)..."
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update && sudo apt install -y build-essential cmake ffmpeg libavcodec-dev libavformat-dev libavutil-dev libswresample-dev git python3-pip python3-venv
sudo apt install -y nvidia-driver-570-open nvidia-cuda-toolkit
echo "🔱 PHASE 1 COMPLETE. REBOOT YOUR SYSTEM NOW."
