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
SOURCE_URL="https://github.com/fishaudio/fish-speech/archive/refs/tags/v1.5.0.zip"

echo "========================================================"
echo "   BLACKWELL IGNITION: BUILDING FISH SPEECH 1.5         "
echo "========================================================"

rm -rf "$PROJECT_ROOT"
mkdir -p "$PROJECT_ROOT"
cd "$PROJECT_ROOT" || exit

echo "1. DOWNLOADING SOURCE..."
wget -qO source.zip "$SOURCE_URL"
unzip -q source.zip && mv fish-speech-1.5.0/* . && mv fish-speech-1.5.0/.* . 2>/dev/null
rm -rf source.zip fish-speech-1.5.0

echo "2. CREATING VIRTUAL ENVIRONMENT..."
python3 -m venv venv
VENV_PIP="$PROJECT_ROOT/venv/bin/pip"

echo "3. INSTALLING BLACKWELL DRIVERS..."
"$VENV_PIP" install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128 --default-timeout=1000
"$VENV_PIP" install nvidia-npp-cu12 --default-timeout=1000

echo "4. RUNNING MASTER DEPENDENCY INSTALL (RESTORED)..."
"$VENV_PIP" install -e . --default-timeout=1000

echo "5. APPLYING STABILITY PINS..."
"$VENV_PIP" install "transformers==5.3.0" "pydantic==2.9.2" "gradio==6.9.0" "tiktoken==0.12.0" "ormsgpack==1.12.2" "rich==14.3.3" "tokenizers>=0.19" "soundfile" --default-timeout=1000

echo "6. APPLYING SURGICAL PATCHES (WILDCARD PROTECTED)..."
REF_LOADER="tools/inference_engine/reference_loader.py"
sed -i 's/.*backends = torchaudio.list_audio_backends().*/        backends = ["soundfile", "ffmpeg"]/' "$REF_LOADER"
sed -i 's/.*waveform, original_sr = torchaudio.load(reference_audio, backend=self.backend).*/        import soundfile as sf; waveform_np, original_sr = sf.read(reference_audio); waveform = torch.from_numpy(waveform_np).float().t() if waveform_np.ndim > 1 else torch.from_numpy(waveform_np).float().unsqueeze(0)/' "$REF_LOADER"

sed -i 's/show_api=True//g' tools/run_webui.py
sed -i 's/app.launch()/app.launch(inbrowser=True)/g' tools/run_webui.py
sed -i 's/ + "(\\d"/ + r"(\\d"/' fish_speech/text/chn_text_norm/text.py

echo "🔱 IGNITION COMPLETE. SYSTEM READY."
