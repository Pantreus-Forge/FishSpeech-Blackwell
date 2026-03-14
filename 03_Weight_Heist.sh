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

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)/FishSpeech"
if [ ! -d "$PROJECT_ROOT" ]; then echo "🚨 Run Script 2 first!"; exit 1; fi
cd "$PROJECT_ROOT" || exit

echo "1. ACTIVATING ENGINE..."
source venv/bin/activate
pip install huggingface_hub>=0.23.0

echo "2. DOWNLOADING V1.5 WEIGHTS..."
python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='fishaudio/fish-speech-1.5', local_dir='checkpoints/fish-speech-1.5', local_dir_use_symlinks=False)"

echo "🔱 DOWNLOAD COMPLETE. ASSETS SECURED."
