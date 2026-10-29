#!/usr/bin/env bash
set -e

echo "==============================================================="
echo "   Installing Optional Mobile Security Lab Components          "
echo "==============================================================="

mkdir -p "$HOME/tools"
mkdir -p "$HOME/.local/bin"

# 1. Install Ghidra (Native Reverse Engineering)
echo -e "\n[1/3] Installing NSA Ghidra..."
GHIDRA_VER="11.1.2_PUBLIC"
GHIDRA_DATE="20240709"
if [ ! -d "$HOME/tools/ghidra" ]; then
    echo "Downloading Ghidra..."
    wget -q --show-progress "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.1.2_build/ghidra_${GHIDRA_VER}_${GHIDRA_DATE}.zip" -O /tmp/ghidra.zip
    unzip -q -o /tmp/ghidra.zip -d /tmp/
    mv /tmp/ghidra_${GHIDRA_VER} "$HOME/tools/ghidra"
    rm /tmp/ghidra.zip
    ln -sf "$HOME/tools/ghidra/ghidraRun" "$HOME/.local/bin/ghidra"
    echo "✓ Ghidra installed to $HOME/tools/ghidra (launch with 'ghidra')"
else
    echo "✓ Ghidra is already installed"
fi

# 2. Install Docker & MobSF (Mobile Security Framework)
echo -e "\n[2/3] Installing Docker Engine for MobSF..."
if command -v docker >/dev/null 2>&1; then
    echo "✓ Docker is already installed ($(docker --version)); skipping engine install."
else
    # Installs the distro's docker.io package. If Docker CE was already set up via
    # Docker's own apt repo (docker-ce/containerd.io), the command -v check above
    # skips this entirely and avoids a package conflict between docker.io and containerd.io.
    sudo apt update
    sudo apt install -y docker.io
fi

if ! groups "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
    echo "Added $USER to the 'docker' group. Log out and back in (or run 'newgrp docker') before using 'docker'/'mobsf' without sudo."
fi

echo "Pulling MobSF Docker image (opensecurity/mobile-security-framework-mobsf)..."
sudo docker pull opensecurity/mobile-security-framework-mobsf:latest

# Create MobSF launcher script
cat << 'MOBSF' > "$HOME/.local/bin/mobsf"
#!/usr/bin/env bash
echo "Starting Mobile Security Framework (MobSF) on http://localhost:8000 ..."
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
MOBSF
chmod +x "$HOME/.local/bin/mobsf"
echo "✓ MobSF configured (launch anytime with 'mobsf')"

# 3. Burp Suite Community Edition
echo -e "\n[3/3] Downloading Burp Suite Community Edition installer..."
mkdir -p "$HOME/Downloads"
if [ ! -f "$HOME/Downloads/burpsuite_community.sh" ]; then
    # No 'version' parameter: PortSwigger's download endpoint serves the current
    # release when it's omitted, so this doesn't go stale like a pinned version does.
    wget -q --show-progress "https://portswigger.net/burp/releases/download?product=community&type=Linux" -O "$HOME/Downloads/burpsuite_community.sh"
    chmod +x "$HOME/Downloads/burpsuite_community.sh"
    echo "✓ Burp Suite installer downloaded to $HOME/Downloads/burpsuite_community.sh"
    echo "Run '$HOME/Downloads/burpsuite_community.sh' to complete graphical setup."
fi

echo -e "\n==============================================================="
echo "   ✅ Optional Components Setup Complete!"
echo "==============================================================="
