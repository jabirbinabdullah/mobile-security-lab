# Mobile App Security Lab — Windows 11 Baseline Audit

- **Date:** [To be completed in Windows agy session]
- **Host / Model:** Dell OptiPlex 3070
- **Operating System:** Windows 11 Pro / Home (x86_64)

---

## 1. System & Resource Checks

Run the following in PowerShell:
```powershell
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
Get-PSDrive -PSProvider FileSystem
```

---

## 2. Virtualization / Hypervisor Support

Check if Windows Hypervisor Platform (WHPX) or Hyper-V is enabled for Android Studio AVD hardware acceleration:
```powershell
Get-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform, VirtualMachinePlatform
```

---

## 3. Runtimes & Mobile Tools Status

```powershell
Get-Command java, javac, python, node, npm, git, docker -ErrorAction SilentlyContinue | Select-Object Name, Source
Get-Command adb, fastboot, jadx, apktool, ghidra, frida, objection -ErrorAction SilentlyContinue | Select-Object Name, Source
```

---

## 4. Key Comparative Findings (Linux vs Windows)
- **Virtualization overhead:** KVM on Linux vs WHPX / Hyper-V on Windows.
- **Device driver handling:** Linux `udev` rules vs Windows OEM USB Drivers.
- **CLI & Scripting ergonomics:** Bash + Python venv vs PowerShell.
