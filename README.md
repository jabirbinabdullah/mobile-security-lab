# Mobile Application Security Laboratory

A cross-platform mobile security testing and reverse engineering laboratory setup for Android application security assessments.

---

## 📁 Repository Structure

```text
mobile-security-lab/
├── README.md                   # Project overview & roadmap
├── docs/
│   ├── audits/
│   │   ├── linux_mint_baseline.md   # Baseline audit on Linux Mint 22.3
│   │   └── windows_11_baseline.md  # Baseline audit on Windows 11
│   └── guides/
│       ├── proxy_ca_setup.md       # Root CA injection for Android 7+
│       └── frida_instrumentation.md# Frida & Objection workflow guide
├── scripts/
│   ├── setup_linux.sh              # Linux automated environment installer
│   └── setup_windows.ps1           # Windows PowerShell setup script
├── configs/
│   ├── README.md
│   └── network_security_config_debug.xml.template
└── snippets/
    ├── list_classes.js             # Enumerate loaded classes matching a filter
    └── trace_method.js             # Trace args/return value of a target method
```

---

## 🧪 Laboratory Architecture & Tooling

| Category | Recommended Tool | Purpose |
| :--- | :--- | :--- |
| **Bridge & Management** | `adb`, `fastboot` | Android debugging, shell access, APK installation |
| **Virtualization / Emulation** | Android AVD (KVM/WHPX) / Rooted Device | Running test targets with root privileges |
| **Static Decompilation** | JADX-GUI, Apktool | Decompiling DEX/Smali and inspecting AndroidManifest.xml |
| **Native Disassembly** | Ghidra, Radare2 | Reverse engineering native `.so` shared libraries |
| **Dynamic Instrumentation** | Frida, Objection | Runtime hooking, method tracing, bypassing SSL pinning |
| **Traffic Interception** | Burp Suite Community, mitmproxy | Intercepting HTTP/HTTPS/WebSocket API endpoints |
| **Automated Auditing** | MobSF (via Docker) | Automated static and dynamic vulnerability scanning |

---

## 🚀 Getting Started

### On Linux (Linux Mint / Ubuntu):
Run the setup script to install dependencies, Java JDK, platform tools, and Python virtual environment:
```bash
chmod +x scripts/setup_linux.sh
./scripts/setup_linux.sh
```

### On Windows 11:
Run the PowerShell setup script in an elevated PowerShell session:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\setup_windows.ps1
```

---

## 📖 Guides
- [Proxy CA Setup (Android 7+)](docs/guides/proxy_ca_setup.md) — installing a Burp/mitmproxy CA into the system trust store
- [Frida & Objection Instrumentation](docs/guides/frida_instrumentation.md) — dynamic instrumentation workflow

---

## 📊 OS Comparison
See the detailed baseline reports comparing system performance, driver compatibility, and tooling convenience:
- [Linux Mint Baseline Audit](docs/audits/linux_mint_baseline.md)
- [Windows 11 Baseline Audit](docs/audits/windows_11_baseline.md)
