#!/usr/bin/env bash
set -e

echo "=== Mobile Security Lab Setup (Linux Mint / Debian / Ubuntu) ==="

# 1. Update and install base build & runtime dependencies
echo "[1/4] Installing system packages & Java OpenJDK..."
sudo apt update
sudo apt install -y \
    openjdk-17-jdk \
    android-tools-adb \
    android-tools-fastboot \
    python3-pip \
    python3-venv \
    unzip \
    curl \
    wget \
    git \
    zipalign \
    apksigner

# 2. Setup Python virtual environment for security instrumentation
echo "[2/4] Setting up Python virtual environment for Frida & Objection..."
VENV_DIR="$HOME/.mobile-lab-venv"
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install frida frida-tools objection mitmproxy

# 3. Setup local bin directory for static analysis tools
echo "[3/4] Preparing ~/tools directory..."
mkdir -p "$HOME/tools/jadx"
mkdir -p "$HOME/.local/bin"

# 4. Verify installations
echo "[4/4] Verifying installations..."
echo "Java version:"
java -version 2>&1 | head -n 1
echo "ADB version:"
adb --version | head -n 1
echo "Frida CLI:"
frida --version
echo "Objection CLI:"
objection version 2>/dev/null || echo "Objection installed in virtualenv"

echo -e "\nSetup completed successfully!"
echo "To activate your dynamic analysis tools in the future, run:"
echo "  source ~/.mobile-lab-venv/bin/activate"
