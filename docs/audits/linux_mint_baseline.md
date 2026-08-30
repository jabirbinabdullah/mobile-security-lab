# Mobile App Security Lab — Linux Mint Baseline Audit & Inventory

- **Date:** 2026-08-30
- **Host / Model:** Dell OptiPlex 3070
- **Operating System:** Linux Mint 22.3 (Zena) / Ubuntu 24.04 LTS base (Kernel 7.0.0-30-generic)
- **Architecture:** x86_64
- **Status:** ✅ **Fully Configured & Operational**

---

## 1. Hardware & System Resources

| Parameter | Value | Lab Status |
| :--- | :--- | :--- |
| **Processor (CPU)** | Intel Core i3-9100T (4 cores / 4 threads @ 3.10 GHz) | ✅ Operational for AVD and decompilers |
| **System Memory (RAM)**| 15 GiB Total (~12 GiB Available) | ✅ Ready for concurrent emulators & analysis tools |
| **Root Disk Storage** | 125 GB (84 GB available on ext4) | ✅ 29% used; 84 GB available for APKs and images |
| **Hardware Virtualization** | KVM active (`/dev/kvm` present, VMX enabled) | ✅ Hardware acceleration ready for Android AVDs |

---

## 2. Installed Software & Toolchain Inventory

### Core Runtimes & Management
- **Java JDK:** `OpenJDK 17.0.20` ✅ *(Installed)*
- **Python:** `Python 3.12.3` with pip & virtualenv (`~/.mobile-lab-venv`) ✅ *(Installed)*
- **Node.js & npm:** `v18.19.1` / `npm 9.2.0` ✅ *(Installed)*
- **Git:** `2.43.0` ✅ *(Configured with GitHub CLI `gh`)*
- **Container Runtime:** `Docker 29.1.3` ✅ *(Installed & operational)*

### Android Bridge & Utilities
- **ADB & Fastboot:** `v1.0.41` / `34.0.4-1build3` ✅ *(In PATH)*
- **Apksigner & Zipalign:** Installed via APT ✅ *(In PATH)*

### Static Analysis & Reverse Engineering
- **JADX & JADX-GUI:** `v1.5.0` (`~/tools/jadx`, linked in `~/.local/bin/jadx-gui`) ✅
- **Apktool:** `v2.9.3` (`~/tools/apktool`, wrapper in `~/.local/bin/apktool`) ✅
- **NSA Ghidra:** `v11.1.2_PUBLIC` (`~/tools/ghidra`, linked in `~/.local/bin/ghidra`) ✅

### Dynamic Instrumentation & Interception
- **Frida CLI:** `v17.17.0` (in `~/.mobile-lab-venv`) ✅
- **Objection:** `v1.12.5` (in `~/.mobile-lab-venv`) ✅
- **mitmproxy:** `v10.x` (in `~/.mobile-lab-venv`) ✅
- **MobSF (Mobile Security Framework):** Docker container image pulled (`mobsf` launcher in `~/.local/bin/mobsf`) ✅
- **Burp Suite Community:** Installer ready at `~/Downloads/burpsuite_community.sh` ✅

---

## 3. Quick Reference / Tool Launcher Cheat Sheet

```bash
# 1. Activate Dynamic Security venv (Frida / Objection / mitmproxy)
source ~/.mobile-lab-venv/bin/activate

# 2. Launch JADX Decompiler GUI
jadx-gui &

# 3. Launch NSA Ghidra (Native Disassembler)
ghidra &

# 4. Launch MobSF Web Dashboard (runs on http://localhost:8000)
mobsf

# 5. Run Burp Suite Community Installer (first-time GUI wizard)
~/Downloads/burpsuite_community.sh
```
