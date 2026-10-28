// Mencatat argumen dan return value setiap kali method target dipanggil.
// Usage: frida -U -f <package_name> -l trace_method.js
//
// Ganti CLASS_NAME dan METHOD_NAME sebelum dijalankan. Gunakan list_classes.js
// terlebih dahulu untuk menemukan nama class yang relevan.

var CLASS_NAME = 'com.example.app.LoginManager';
var METHOD_NAME = 'authenticate';

Java.perform(function () {
    var targetClass = Java.use(CLASS_NAME);

    if (!targetClass[METHOD_NAME]) {
        console.log('[-] Method tidak ditemukan: ' + CLASS_NAME + '.' + METHOD_NAME);
        return;
    }

    targetClass[METHOD_NAME].overloads.forEach(function (overload) {
        overload.implementation = function () {
            var args = Array.prototype.slice.call(arguments).map(function (a) {
                return String(a);
            });

            console.log('[>] ' + CLASS_NAME + '.' + METHOD_NAME + '(' + args.join(', ') + ')');

            var result = overload.apply(this, arguments);

            console.log('[<] return: ' + result);
            return result;
        };
    });

    console.log('[*] Hook terpasang pada ' + CLASS_NAME + '.' + METHOD_NAME +
                ' (' + targetClass[METHOD_NAME].overloads.length + ' overload)');
});
