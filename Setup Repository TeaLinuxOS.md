# Setup Repositori Lokal Di Ubuntu

### Mengapa repositori lokal penting?

Sebagai sistem administrator biasanya sering menginstal aplikasi, update keamanan dan perbaikan perangkat lunak di semua sistem. Tentunya, akan mengkonsumsi lebih banyak quota internet. Jadi, alih - alih menguduh dan menginstal aplikasi setiap saat di semua sistem dari repositori global Ubuntu, sebaiknya simpan semua aplikasi di server lokal dan distribusikan ke sistem Ubuntu lainnya bila diperlukan. Memiliki repositori lokal akan sangat cepat dan efisien, karena semua aplikasi yang dibutuhkan akan ditransfer melalui jaringan lokal. Sehingga menghemat quota internet dan pada akhirnya akan mengurangi biaya internet tahunan.

Dalam artikel ini, saya akan menunjukkan cara menata repositori lokal di server Ubuntu dengan dua metode.

1. apt-mirror
2. apt-cacher

Yang dibutuhkan adalah ruang hard drive yang cukup dan koneksi internet yang cepat, sedikitnya membutuhkan `50GB` atau lebih ruang penyimpanan didalam hard-drive internal. Selain itu, juga bisa menggunakan hard-drive eksternal untuk membuat repositori portabel.

---

### Metode 1 : apt-mirror

Dalam metode ini, server lokal akan menarik semua paket dari repositori global (server Ubuntu) dan menyimpannya di hard-drive server lokal.
Pertama instal Apache HTTP Server pada server lokal, Apache HTTP Server penting untuk berbagi paket melalui jaringan publik.

```shell
sudo apt-get install apache2
```

Setelah selesai maka dilajut untuk install apt-mirror dengan perintah.

```shell
sudo apt-get install apt-mirror
```

Setelah selesai meng-install paket, buatlah sebuah direktori untuk menyimpan semua paket. Sebagai contoh, mari buat sebuah direktori bernama `/myrepo`. Semua paket akan disimpan dalam direktori ini.

```shell
sudo mkdir /myrepo
```

Setelah itu buka file konfigurasi `/etc/apt/mirror.list` dan edit.

```shell
sudo vim /etc/apt/mirror.list
```

Uncomment dan edit pada baris `set base_path` dan tambah `/myrepo`

Uncomment dan edit pada baris `set nthreads` dan tambah `20`

```shell
############# config ##################
#
set base_path    /myrepo
#
# set mirror_path  $base_path/mirror
# set skel_path    $base_path/skel
# set var_path     $base_path/var
# set cleanscript $var_path/clean.sh
# set defaultarch  <running host architecture>
# set postmirror_script $var_path/postmirror.sh
# set run_postmirror 0
set nthreads     20
set _tilde 0
#
############# end config ##############
#
########################### Xenial ################################
# 32-bit
deb-i386 http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu xenial-security main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu xenial-proposed main restricted universe multiverse
deb-i386 http://archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse

deb-i386 http://archive.ubuntu.com/ubuntu xenial main/debian-installer restricted/debian-installer universe/debian-installer multiverse/debian-installer

deb-i386 http://archive.ubuntu.com/ubuntu xenial main/dep11 restricted/dep11 universe/dep11 multiverse/dep11

#--------------------------------------------------------------------------------------------------------
# 64-bit
deb-amd64 http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse
deb-amd64 http://archive.ubuntu.com/ubuntu xenial-security main restricted universe multiverse
deb-amd64 http://archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse
deb-amd64 http://archive.ubuntu.com/ubuntu xenial-proposed main restricted universe multiverse
deb-amd64 http://archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse

deb-amd64 http://archive.ubuntu.com/ubuntu xenial main/debian-installer restricted/debian-installer universe/debian-installer multiverse/debian-installer

deb-amd64 http://archive.ubuntu.com/ubuntu xenial main/dep11 restricted/dep11 universe/dep11 multiverse/dep11

#####################source tambahan###############################
deb-src http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu xenial-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu xenial-proposed main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse

clean http://archive.ubuntu.com/ubuntu
```

Pada file konfigurasi di atas, dapat menambahkan daftar sumber repositori global Ubuntu tergantung pada distribusi yang digunakan.

Jika menggunakan arsitektur 32bit dan 64bit, harus memberi nama secara terpisah pada isi file konfigurasi. Misalnya, jika menggunakan arsitektur 32bit harus dimulai dengan `deb-i386` dan jika menggunakan arsitektur 64bit harus dimulai dengan `deb-amd64`. Setelah selesai simpan file konfigurasi dan jalankan perintah berikut.

```shell
sudo apt-mirror
```

Sample output:

```shell
```

Sekarang paket dari repositori global Ubuntu sudah disimpan ke direktori lokal `/myrepo`. Proses apt-mirror bisa dibatalkan kapan saja, namun ketika dimulai lagi prosesnya, maka akan melanjutkan proses yang dibatalkan.

Sistem administrator tidak perlu menjalankan perintah `sudo apt-mirror` setiap hari untuk mendapatkan update repositori / update perangkat lunak terbaru, cukup menjadwalkan proses ini dengan menggunakan cron. Jadi server lokal akan secara otomatis menjalankan perintah `apt-mirror` setiap hari dan akan terus memperbarui repositori.

Buka file `/etc/cron.d/apt-mirror`

```shell
sudo vim /etc/cron.d/apt-mirror
```

Edit dan tambahkan konfigurasi file `/etc/cron.d/apt-mirror`

```shell
#
# Regular cron jobs for the apt-mirror package
#
0 4 * * *  apt-mirror  /usr/bin/apt-mirror > /var/log/apt-mirror/cron.log
```

Sesuai dengan file konfigurasi cron di atas, cron akan berjalan setiap hari jam `04:00` pagi(a.m) dan secara automatis menguduh dan memperbarui paketnya. Seperti yang sudah dijelaskan sebelumnya, semua paket akan diuduh dan disimpan pada direktori `/myrepo` di server lokal.

Setelah selesai, isi dari direktori `/myrepo` harus tersedia melalui HTTP (web) untuk diakses klien. Untuk melakukan itu cukup buat `symbolic links` ke `DocumentRoot` Apache HTTP Server.

```shell
cd /myrepo/
sudo ln -s /myrepo/mirror/archive.ubuntu.com/ubuntu/ /var/www/html/ubuntu
```

### Metode 2 : apt-cacher


Sekian Dokumentasi :D
