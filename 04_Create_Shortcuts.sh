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

# 1. UNIVERSAL TERMINAL LAUNCHER
if [ -t 0 ]; then :; else
    for term in konsole gnome-terminal xfce4-terminal xterm; do
        if command -v $term >/dev/null 2>&1; then
            $term --hold -e "$0" "$@"; exit
        fi
    done
fi

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)/FishSpeech"
DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")

if [ ! -d "$PROJECT_ROOT" ]; then echo "🚨 ERROR: Run Script 2 first!"; exit 1; fi

cat << EOF_S > "$DESKTOP_DIR/🔱 Fish Voice Lab.desktop"
[Desktop Entry]
Type=Application
Name=🔱 Fish Voice Lab
Exec=bash -c 'cd "$PROJECT_ROOT" && ./venv/bin/python3 tools/run_webui.py --llama-checkpoint-path checkpoints/fish-speech-1.5 --decoder-checkpoint-path checkpoints/fish-speech-1.5/firefly-gan-vq-fsq-8x1024-21hz-generator.pth --decoder-config-name firefly_gan_vq; exec bash'
Icon=utilities-terminal
Terminal=true
EOF_S

cat << EOF_S > "$DESKTOP_DIR/🔱 Fish API Backend.desktop"
[Desktop Entry]
Type=Application
Name=🔱 Fish API Backend
Exec=bash -c 'cd "$PROJECT_ROOT" && ./venv/bin/python3 -m tools.api_server --listen 0.0.0.0:8080 --llama-checkpoint-path checkpoints/fish-speech-1.5 --decoder-checkpoint-path checkpoints/fish-speech-1.5/firefly-gan-vq-fsq-8x1024-21hz-generator.pth --decoder-config-name firefly_gan_vq; exec bash'
Icon=utilities-terminal
Terminal=true
EOF_S

chmod +x "$DESKTOP_DIR/🔱 Fish Voice Lab.desktop"
chmod +x "$DESKTOP_DIR/🔱 Fish API Backend.desktop"
echo "🔱 SHORTCUTS CREATED ON DESKTOP."
