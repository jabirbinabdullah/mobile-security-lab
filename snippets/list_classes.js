// Enumerasi class Java yang dimuat pada proses target, disaring berdasarkan FILTER.
// Usage: frida -U -f <package_name> -l list_classes.js
//
// Ganti FILTER dengan prefix package aplikasi target sebelum dijalankan.

var FILTER = 'com.example';

Java.perform(function () {
    console.log('[*] Mencari class yang cocok dengan filter: ' + FILTER);

    Java.enumerateLoadedClasses({
        onMatch: function (name) {
            if (name.indexOf(FILTER) !== -1) {
                console.log(name);
            }
        },
        onComplete: function () {
            console.log('[*] Enumerasi selesai.');
        }
    });
});
