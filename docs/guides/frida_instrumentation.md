# Frida & Objection Workflow

Panduan dasar instrumentasi dinamis Android menggunakan Frida dan Objection, pada perangkat/emulator lab yang di-root. Gunakan hanya pada aplikasi yang Anda berwenang untuk diuji.

---

## 1. Persiapan environment

Versi klien (`frida-tools`) dan `frida-server` di perangkat **harus sama persis**, atau koneksi akan gagal.

```bash
source ~/.mobile-lab-venv/bin/activate
pip install frida-tools objection
frida --version
```

Cek arsitektur perangkat/emulator untuk mengunduh `frida-server` yang sesuai:

```bash
adb shell getprop ro.product.cpu.abi     # x86_64 / arm64-v8a / armeabi-v7a
```

Unduh `frida-server-<versi>-android-<arsitektur>.xz` dari halaman rilis resmi Frida (versi harus cocok dengan output `frida --version` di atas), lalu:

```bash
unxz frida-server-*.xz
adb root
adb push frida-server-* /data/local/tmp/frida-server
adb shell chmod 755 /data/local/tmp/frida-server
adb shell "/data/local/tmp/frida-server &"
frida-ps -U           # jika koneksi berhasil, daftar proses perangkat akan muncul
```

---

## 2. Alur kerja dasar

```bash
frida-ps -Uai                                                 # daftar aplikasi terpasang + PID jika berjalan
frida -U -f com.example.app -l snippets/list_classes.js       # spawn aplikasi + load script
frida -U -n "Example App" -l snippets/trace_method.js         # attach ke proses yang sudah berjalan
```

Catatan: pada beberapa versi Frida terbaru, `-f` (spawn) menghentikan proses di awal secara default — ketik `%resume` di REPL Frida untuk melanjutkan eksekusi, atau tambahkan flag yang sesuai pada dokumentasi versi yang dipakai.

---

## 3. Snippet yang tersedia di repo ini

| File | Fungsi |
| :--- | :--- |
| `snippets/list_classes.js` | Mengenumerasi class yang dimuat sesuai filter nama package |
| `snippets/trace_method.js` | Mencatat argumen dan return value dari method tertentu |

Gunakan `list_classes.js` dulu untuk memetakan struktur aplikasi target, lalu `trace_method.js` untuk mengamati perilaku method spesifik yang relevan dengan cakupan pengujian.

---

## 4. Objection (opsional, lapisan di atas Frida)

```bash
objection -g com.example.app explore
```

Di dalam REPL Objection, beberapa perintah eksplorasi yang berguna:

```text
android hooking list activities
android hooking list services
android hooking search classes <keyword>
android hooking watch class_method com.example.Login.check --dump-args --dump-return
android keystore list
env                                  # menampilkan path direktori data aplikasi
```

Objection juga menyediakan perintah untuk mem-patch APK agar frida-gadget tertanam (berguna untuk perangkat non-root), serta sejumlah modul eksplorasi/analisis bawaan lain — rujuk `--help` dan dokumentasi resmi Objection untuk daftar lengkap sesuai kebutuhan dan cakupan pengujian Anda.

---

## 5. Praktik yang baik

- Catat versi aplikasi (`adb shell dumpsys package <pkg> | grep versionName`) dan hash APK pada setiap sesi pengujian.
- Simpan hasil capture di luar repo ini — jangan commit APK pihak ketiga atau data yang berpotensi sensitif.
- Mulai dari analisis statis (JADX/Apktool) untuk menentukan class dan method mana yang relevan sebelum melakukan hooking dinamis.
