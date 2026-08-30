#!/usr/bin/env bash
set -e

echo "==============================================================="
echo "   Mobile App Security Laboratory Setup (Linux Mint / Ubuntu)  "
echo "==============================================================="

# 1. Base APT packages & Java
echo -e "\n[1/5] Installing base packages, Java OpenJDK 17, and Platform Tools..."
sudo apt update
sudo apt install -y \
    openjdk-17-jdk \
    android-tools-adb \
    android-tools-fastboot \
    python3-pip \
    python3-venv \
    zipalign \
    apksigner \
    unzip \
    curl \
    wget \
    git \
    libnotify-bin

# 2. Python virtual environment (Frida, Objection, mitmproxy)
echo -e "\n[2/5] Setting up Python virtual environment for Dynamic Instrumentation..."
VENV_DIR="$HOME/.mobile-lab-venv"
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install frida frida-tools objection mitmproxy

# 3. Create Tools & Local Bin directory
echo -e "\n[3/5] Setting up ~/tools and ~/.local/bin..."
mkdir -p "$HOME/tools"
mkdir -p "$HOME/.local/bin"

# Ensure ~/.local/bin is in PATH in ~/.bashrc if not present
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# 4. Download and configure JADX-GUI (Static Decompiler)
echo -e "\n[4/5] Installing JADX / JADX-GUI..."
JADX_VERSION="1.5.0"
if [ ! -d "$HOME/tools/jadx" ]; then
    mkdir -p "$HOME/tools/jadx"
    wget -q --show-progress "https://github.com/skylot/jadx/releases/download/v${JADX_VERSION}/jadx-${JADX_VERSION}.zip" -O /tmp/jadx.zip
    unzip -q -o /tmp/jadx.zip -d "$HOME/tools/jadx"
    rm /tmp/jadx.zip
    ln -sf "$HOME/tools/jadx/bin/jadx" "$HOME/.local/bin/jadx"
    ln -sf "$HOME/tools/jadx/bin/jadx-gui" "$HOME/.local/bin/jadx-gui"
    echo "✓ JADX v${JADX_VERSION} installed to $HOME/tools/jadx and linked to ~/.local/bin"
else
    echo "✓ JADX already exists in $HOME/tools/jadx"
fi

# 5. Download and configure Apktool
echo -e "\n[5/5] Installing Apktool..."
APKTOOL_VERSION="2.9.3"
if [ ! -f "$HOME/tools/apktool/apktool.jar" ]; then
    mkdir -p "$HOME/tools/apktool"
    wget -q --show-progress "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${APKTOOL_VERSION}.jar" -O "$HOME/tools/apktool/apktool.jar"
    
    # Create apktool wrapper script
    cat << 'WRAPPER' > "$HOME/.local/bin/apktool"
#!/usr/bin/env bash
exec java -jar "$HOME/tools/apktool/apktool.jar" "$@"
WRAPPER
    chmod +x "$HOME/.local/bin/apktool"
    echo "✓ Apktool v${APKTOOL_VERSION} installed and linked to ~/.local/bin"
else
    echo "✓ Apktool already exists"
fi

echo -e "\n==============================================================="
echo "   ✅ Core Lab Setup Completed Successfully!"
echo "==============================================================="
echo "Tooling Summary:"
echo " - Java: $(java -version 2>&1 | head -n 1)"
echo " - ADB: $(adb --version | head -n 1)"
echo " - JADX GUI: Run 'jadx-gui' (or $HOME/tools/jadx/bin/jadx-gui)"
echo " - Apktool: Run 'apktool'"
echo " - Dynamic tools (Frida / Objection): Run 'source ~/.mobile-lab-venv/bin/activate'"
echo "==============================================================="
