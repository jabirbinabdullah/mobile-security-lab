# Proxy CA Setup (Android 7+)

Sejak Android 7 (API 24), aplikasi secara default **tidak mempercayai CA user**. Agar Burp Suite atau mitmproxy bisa mengintersepsi traffic HTTPS, sertifikat CA proxy harus dipasang sebagai **system CA**. Ini memerlukan perangkat/emulator yang di-root. Gunakan hanya pada perangkat lab milik Anda dan aplikasi yang Anda berwenang untuk diuji.

---

## 1. Ekspor sertifikat CA dari proxy

**Burp Suite:**
Proxy → Proxy settings → *Import / export CA certificate* → pilih **Certificate in DER format** → simpan sebagai `burp.der`.

**mitmproxy:**
Jalankan sekali (`mitmproxy`, lalu keluar). Sertifikat PEM otomatis tersedia di `~/.mitmproxy/mitmproxy-ca-cert.cer`.

---

## 2. Konversi ke format system CA Android

Android menyimpan CA sistem sebagai file PEM dengan nama `<subject_hash_old>.0`.

```bash
# Burp (DER -> PEM)
openssl x509 -inform DER -in burp.der -out proxy-ca.pem

# mitmproxy (sudah PEM, cukup salin)
cp ~/.mitmproxy/mitmproxy-ca-cert.cer proxy-ca.pem

# Hitung nama file yang benar
HASH=$(openssl x509 -inform PEM -subject_hash_old -in proxy-ca.pem | head -1)
cp proxy-ca.pem "$HASH.0"
```

---

## 3. Pasang ke emulator / perangkat root

Gunakan AVD image **Google APIs** (bukan "Google Play"), karena hanya image tersebut yang mengizinkan partisi system writable.

```bash
emulator -avd <nama_avd> -writable-system -no-snapshot
adb root
adb remount
# Jika remount gagal karena dm-verity:
#   adb shell avbctl disable-verification && adb reboot
#   lalu ulangi 'adb root && adb remount'

adb push "$HASH.0" /system/etc/security/cacerts/
adb shell chmod 644 /system/etc/security/cacerts/"$HASH.0"
adb reboot
```

### Android 14+ (CA module via APEX)

Di versi ini `/system/etc/security/cacerts/` tidak lagi menjadi satu-satunya sumber; Conscrypt membaca dari APEX. Pendekatan umum: buat bind-mount tmpfs yang menggabungkan CA bawaan APEX dengan CA proxy, lalu mount ulang sebelum proses Zygote membaca direktori tersebut. Ini bersifat sementara (hilang setelah reboot) dan detail persisnya berbeda per build — rujuk dokumentasi resmi AOSP/vendor untuk langkah yang berlaku pada image spesifik Anda.

---

## 4. Arahkan traffic perangkat ke proxy

```bash
# Pastikan Burp/mitmproxy listen di 0.0.0.0:<port>, bukan hanya 127.0.0.1

adb shell settings put global http_proxy <IP_HOST_PC>:8080
# Pada emulator AVD, host dari sudut pandang guest adalah 10.0.2.2

# Reset ke default:
adb shell settings put global http_proxy :0
```

---

## 5. Verifikasi

Buka `https://example.com` di browser perangkat. Request harus muncul pada tab HTTP history proxy tanpa peringatan sertifikat pada perangkat.

---

## 6. Jika aplikasi menolak koneksi meski CA sudah terpasang

Kemungkinan aplikasi menerapkan **certificate/public-key pinning** sendiri (terlepas dari CA store sistem) atau memiliki `networkSecurityConfig` kustom yang membatasi `trust-anchors` ke `@raw/...` tertentu. Memasang CA sistem tidak akan menembus mekanisme ini — perlu analisis statis (decompile dengan JADX, cek `res/xml/network_security_config.xml` dan pustaka HTTP yang dipakai) untuk menentukan langkah lanjutan yang sesuai dengan cakupan pengujian Anda.

---

## Troubleshooting

| Gejala | Kemungkinan penyebab |
| :--- | :--- |
| `adb remount` gagal | dm-verity/AVB aktif; nonaktifkan verification lalu reboot |
| Traffic tidak muncul di proxy | Proxy hanya listen di `127.0.0.1`, atau firewall host memblokir port |
| Browser tetap menolak sertifikat | Hash nama file salah, atau perangkat belum reboot setelah push |
| Aplikasi spesifik tetap menolak, browser normal | Pinning atau konfigurasi khusus pada aplikasi tersebut |
