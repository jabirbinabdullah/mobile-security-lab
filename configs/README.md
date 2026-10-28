# Tool Configurations & Templates

Folder ini menyimpan file konfigurasi dan template yang dipakai berulang di lab ini.

## Isi

- `network_security_config_debug.xml.template` — template `networkSecurityConfig` untuk **build debug milik Anda sendiri**, yang mengizinkan CA proxy user agar traffic HTTPS bisa diinspeksi saat menguji aplikasi yang Anda kembangkan sendiri atau yang sumbernya Anda miliki secara sah.

## Catatan

Simpan di sini hanya template/konfigurasi yang tidak memuat data sensitif (kredensial, IP internal, token). Konfigurasi spesifik per sesi pengujian (misalnya scope Burp, target proxy tertentu) sebaiknya disimpan di luar repo ini.
