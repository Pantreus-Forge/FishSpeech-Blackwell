# FishSpeech for RTX 50-Series (Blackwell)

Welcome to the definitive, foolproof installation suite for running **Fish Speech 1.5** on NVIDIA RTX 50-Series GPUs.

If you have an RTX 50-Series GPU (5070, 5080, 5090, including all Ti/Super variants), you already know the pain: standard AI installers crash. They rely on older PyTorch versions that do not understand the Blackwell architecture, leading to instant CUDA failures and dependency hell. 

This repository solves that. It is a fully automated deployment that surgically pieces together Torch Nightly (cu128), specific framework pins, and custom Linux code patches to make FishSpeech run flawlessly on current architecture. 

I did the hard work so you don't have to. 

---

## 🖥️ System Compatibility
* **Supported OSes:** Ubuntu, Kubuntu, Linux Mint, Pop!_OS, Zorin OS.
* **GPU:** NVIDIA RTX 50-Series (Blackwell architecture).
* **Storage:** ~10GB of free space (for drivers, environments, and models).

---

## 🚀 The "One-Click" Installation

If you just want things to work the first time, use this automated 4-step script suite. It handles all the pathing, downloading, and patching for you.

### Step 0: Download & Prepare
1. Click the green **`<> Code`** button at the top right of this page, then click **Download ZIP**. 
2. Extract the folder exactly where you want FishSpeech to live (e.g., your Documents or Home folder). Keep all four `.sh` files together. The scripts will build the entire AI engine directly inside this folder.
3. **Crucial Linux Step:** Linux will not let you run downloaded scripts by default. Select all four `.sh` files, right-click them, select **Properties**, go to the **Permissions** tab, and check the box that says **"Allow executing file as program"** (or similar, depending on your OS).

### Step 1: The Gatekeeper (System Drivers)
*(Note: If you already have NVIDIA 570 or newer open drivers and CUDA 12.8 installed, you can skip this step).*

Double-click `01_System_Drivers.sh` and run it in your terminal. 
* This script installs the core Ubuntu build tools, the `nvidia-driver-570-open`, and the CUDA 12.8 toolkit required for Blackwell.
* **Safety Check:** If the script detects old NVIDIA drivers on your system, it will safely abort to prevent breaking your OS. (If this happens, see the **Driver Purge** section below).
* **⚠️ THE SECURE BOOT / MOK SCREEN (READ THIS):** If your computer has Secure Boot enabled, the terminal will ask you to create a temporary password during this install. **Remember it.** When you reboot your computer, you will be met with a blue "Perform MOK management" screen. This is completely normal. 
  * Your goal here is simply to tell your motherboard to trust the new NVIDIA drivers. 
  * Look for the option that says **Enroll MOK** (⚠️ *Do NOT select "Enroll key from disk"*). 
  * Follow the on-screen prompts to confirm your choice (usually "Continue" and "Yes"), type the password you just made, and reboot. It's that simple. 
  * *(Missed the screen or messed up? Your computer might boot with a low-resolution display because the drivers didn't load. Don't panic. Just follow the **Driver Purge** steps below to clean it up, and run Script 1 again).*

### Step 2: The Ignition (Building the Engine)
Double-click `02_Blackwell_Ignition.sh`. 
* This downloads the Fish Speech source code, builds the Python environment, and fetches the massive Blackwell-compatible PyTorch engine.
* It automatically applies surgical code patches to fix bugs that natively crash on Linux.

### Step 3: The Heist (Downloading Models)
Double-click `03_Weight_Heist.sh`.
* This securely downloads the highly optimized Fish Speech 1.5 AI weights (~1.5GB) directly into the correct folder.

### Step 4: The Interface (Desktop Shortcuts)
Double-click `04_Create_Shortcuts.sh`.
* This generates two launch shortcuts directly on your computer's desktop for easy access. 
* **🔱 Fish Voice Lab:** Launches the Web UI in your browser.
* **🔱 Fish API Backend:** Launches the headless server (for tools like SillyTavern).
* *Note: You can right-click and rename these shortcuts on your desktop to anything you want!*

> [!WARNING]  
> **Do not close the terminal!** When you launch the desktop shortcuts, a terminal window will open alongside your web browser. The terminal is the actual AI engine. If you close the terminal window, the web interface will instantly shut down.

---

## 🧹 Driver Purge & Starting Over

**Did you mess up the installation order, or did Script 1 abort?** If you accidentally ran Script 2 or 3 before your drivers were ready, or if the installation failed for *any* reason, **don't panic. You haven't permanently broken anything.** To wipe the slate clean, simply right-click and **delete the `FishSpeech` folder** that the scripts created. That completely erases the failed AI environment. 

Then, follow these steps to reset your system drivers so you can start fresh:

Open your terminal and run these three commands one by one:

1. **Remove all old NVIDIA and CUDA packages:**
```bash
sudo apt purge nvidia-* cuda-* -y
```
2. **Clean up leftover dependencies:**
```bash
sudo apt autoremove -y
```
3. **Reboot your system:**
```bash
sudo reboot
```
Once your system restarts, your OS is perfectly clean. You can now run `01_System_Drivers.sh` safely.

---

## 🛠️ The Manual Installation (For Power Users)

If you use Arch, Fedora, or just prefer to build the environment by hand, here is the exact DNA required to force FishSpeech onto a Blackwell GPU.

**1. Clone the Source:**
```bash
wget -qO source.zip [https://github.com/fishaudio/fish-speech/archive/refs/tags/v1.5.0.zip](https://github.com/fishaudio/fish-speech/archive/refs/tags/v1.5.0.zip)
unzip -q source.zip && mv fish-speech-1.5.0/* . && mv fish-speech-1.5.0/.* . 2>/dev/null
rm -rf source.zip fish-speech-1.5.0
```

**2. Build VENV and Install Blackwell Drivers:**
```bash
python3 -m venv venv
source venv/bin/activate
pip install --pre torch torchvision torchaudio --index-url [https://download.pytorch.org/whl/nightly/cu128](https://download.pytorch.org/whl/nightly/cu128)
pip install nvidia-npp-cu12
```

**3. The Master Dependency Install:**
```bash
pip install -e .
```

**4. Force Stability Pins:**
```bash
pip install "transformers==5.3.0" "pydantic==2.9.2" "gradio==6.9.0" "tiktoken==0.12.0" "ormsgpack==1.12.2" "rich==14.3.3" "tokenizers>=0.19" "soundfile"
```

**5. Apply Linux Code Patches (Crucial):**
Open `tools/inference_engine/reference_loader.py`. 
Find the lines defining `torchaudio.list_audio_backends` and `torchaudio.load`, and replace them with the `soundfile` equivalents to prevent the Linux backend crash. *(See Script 2 for the exact replacement logic).*

**6. Download Weights:**
```bash
pip install huggingface_hub>=0.23.0
python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='fishaudio/fish-speech-1.5', local_dir='checkpoints/fish-speech-1.5', local_dir_use_symlinks=False)"
```

---

## ✒️ Author & License
Developed and maintained by **Pantreus** ([Pantreus-Forge](https://github.com/Pantreus-Forge)). 

This project is released under the **GNU GPLv3 License**. You are free to use, share, and modify these scripts, provided that you keep this license intact and provide clear credit with a link back to this repository.

---

## ☕ Support the Forge
Getting this architecture to run flawlessly on RTX 50-series hardware took weeks of trial, error, and burnt midnight oil. If this repository saved you from dependency hell and got you generating audio instantly, consider supporting the forge:

[🔗 **Support Pantreus on Ko-fi**](https://ko-fi.com/pantreus)
