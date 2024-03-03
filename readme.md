```markdown
# Virtual Host Manager

Virtual Host Manager adalah alat sederhana untuk mengelola virtual host Apache menggunakan skrip shell.

## Fitur

- Instalasi otomatis Webmin dan konfigurasi lingkungan server.
- Kemampuan untuk menambah, menghapus, dan mengelola virtual host Apache dengan mudah.
- Integrasi dengan Webmin untuk pengelolaan server yang lebih baik.

## Instalasi

1. Pastikan Anda memiliki akses sudo di sistem Anda.
2. Clone repositori ini ke dalam sistem Anda dengan perintah:

#### kloning
    
   ```bash
   git clone https://github.com/miftah06/vhost-apache
   ```
3. Masuk ke direktori Virtual Host Manager:
   ```bash
   cd vhost-apache
   ```
4. Jalankan skrip `install.sh` untuk menginstal Webmin dan menyiapkan lingkungan:
   ```bash
   sudo ./install.sh
   sudo ./ftp.sh
   sudo ./ftp-manage.sh
   ```

## Peringatan

- Pastikan untuk menjalankan skrip `install.sh` dengan hati-hati, karena ini akan menginstal Webmin dan mengkonfigurasi lingkungan server Anda.
- Penggunaan skrip ini dengan tidak hati-hati dapat menyebabkan perubahan yang tidak diinginkan pada server Anda. Gunakan dengan bijak.

## Cara Penggunaan

1. Setelah instalasi selesai, buka Webmin melalui browser Anda dengan mengunjungi alamat `https://localhost:10000`.
2. Masuk menggunakan kredensial administrator Anda.
3. Di dalam Webmin, navigasikan ke bagian "Others" atau "System" dan buka "Command Shell".
4. Salin dan tempel skrip `start.sh` ke dalam jendela Command Shell, lalu jalankan skrip tersebut dengan mengklik tombol "Execute" atau "Run".
5. Tunggu hingga proses selesai. Setelah selesai, virtual host Anda akan siap digunakan.
6. Untuk menambahkan virtual host baru, jalankan skrip `vhost.sh` melalui Command Shell dan ikuti petunjuknya.

## Kontribusi

Anda dapat mengirimkan isu (issue) atau pull request jika Anda menemukan masalah atau ingin berkontribusi untuk meningkatkan proyek ini. Kami sangat menghargai kontribusi Anda!

## Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).
```

di buat lansung oleh t.me/izmiftah