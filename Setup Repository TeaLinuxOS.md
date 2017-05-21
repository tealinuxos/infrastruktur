# Setup Repositori Lokal di Ubuntu

### Mengapa repositori lokal penting?

Sebagai sistem administrator biasanya sering menginstal aplikasi, update keamanan dan perbaikan perangkat lunak di semua sistem. Tentunya, akan mengkonsumsi lebih banyak quota internet. Jadi, alih - alih menguduh dan menginstal aplikasi setiap saat di semua sistem dari repositori global Ubuntu, sebaiknya simpan semua aplikasi di server lokal dan distribusikan ke sistem Ubuntu lainnya bila diperlukan. Memiliki repositori lokal akan sangat cepat dan efisien, karena semua aplikasi yang dibutuhkan akan ditransfer melalui jaringan lokal. Sehingga menghemat quota internet dan pada akhirnya akan mengurangi biaya internet tahunan.

Dalam artikel ini, saya akan menunjukkan cara menata repositori lokal di server Ubuntu dengan dua metode:

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

Uncomment dan edit pada baris `set nthreads` dan ganti value menjadi `20`

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
sudo apt-mirror > /var/log/mirror.log
sudo tail -f /var/log/mirror.log
```

Sample output:

```shell
Downloading 1590 index files using 20 threads...
Begin time: Thu May 18 23:11:07 2017
[20]... [19]... [18]... [17]... [16]... [15]... [14]... [13]... [12]... [11]... [10]... [9]... [8]... [7]... [6]... [5]... [4]... [3]... [2]... [1]... [0]...
End time: Thu May 18 23:14:59 2017

Processing tranlation indexes: [TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT]

Downloading 2232 translation files using 20 threads...
Begin time: Thu May 18 23:14:59 2017
[20]... [19]... [18]... [17]... [16]... [15]... [14]... [13]... [12]... [11]... [10]... [9]... [8]... [7]... [6]... [5]... [4]... [3]... [2]... [1]... [0]...
End time: Thu May 18 23:28:36 2017

Processing indexes: [PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP]

185 GiB will be downloaded into archive.
Downloading 1024 archive files using 20 threads...
Begin time: Thu May 18 23:28:55 2017
[20]... [19]... [18]... [17]... [16]... [15]... [14]... [13]... [12]... [11]... [10]... [9]... [8]... [7]... [6]... [5]... [4]... [3]... [2]... [1]... [0]...
End time: Thu May 18 23:49:18 2017

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
0 4 * * *  apt-mirror > /var/log/mirror.log
```

Sesuai dengan file konfigurasi cron di atas, cron akan berjalan setiap hari jam `04:00` pagi(a.m) dan secara automatis menguduh dan memperbarui paketnya. Seperti yang sudah dijelaskan sebelumnya, semua paket akan diuduh dan disimpan pada direktori `/myrepo` di server lokal.

Setelah selesai, isi dari direktori `/myrepo` harus tersedia melalui HTTP (web) untuk diakses klien. Untuk melakukan itu cukup buat `symbolic links` ke `DocumentRoot` Apache HTTP Server.

```shell
cd /myrepo/
sudo ln -s /myrepo/mirror/archive.ubuntu.com/ubuntu/ /var/www/html/ubuntu
```

### Metode 2 : apt-cacher

Metode kedua yang digunakan untuk meniru paket pada repositori global Ubuntu yaitu apt-cacher.

Apt-cacher berbeda dari apt-mirror karena tidak menguduh keseluruhan isi repositori global Ubuntu, namun hanya menyimpan beberapa paket yang diminta oleh klien. Dengan kata lain, apt-cacher bekerja sebagai perantara antara repositori global Ubuntu dan klien. Setiap kali ada klien yang meminta request paket, server lokal apt-cache akan meminta pembaruan paket dari repositori global Ubuntu, menyimpan dan menyebarkan paketnya kembali ke klien yang meminta request paket. Paket ini kemudian tersimpan untuk request paket di jaringan lokal. Metode ini paling cocok untuk yang memiliki ruang penyimpanan minimal, atau yang hanya ingin membuat pembaruan lebih efisien.

Pertama instal Apache HTTP Server pada server lokal, Apache HTTP Server penting untuk berbagi paket melalui jaringan.

```shell
sudo apt-get install apache2
```

Lajut untuk install apt-cacher dengan perintah.

```shell
sudo apt-get install apt-cacher
```

Lalu akan muncul **text box** pilih `daemon` dan klik Ok

![alt tag](https://github.com/tealinuxos/infrastruktur/blob/master/images/image001.jpg)

Setelah itu buka file konfigurasi `/etc/default/apt-cacher` dan edit.

```shell
sudo vim /etc/default/apt-cacher
```

Uncomment dan edit pada baris `AUTOSTART=` dan ganti value dari `0` ke `1`

```shell
# apt-cacher daemon startup configuration file

# Set to 1 to run apt-cacher as a standalone daemon, set to 0 if you are going
# to run apt-cacher from /etc/inetd or in CGI mode (deprecated).  Alternatively,
# invoking "dpkg-reconfigure apt-cacher" should do the work for you.
#
AUTOSTART=1

# extra settings to override the ones in apt-cacher.conf
# EXTRAOPT=" daemon_port=3142 limit=30 "
```

Sistem administrator juga dapat mengizinkan atau menolak host yang ingin mengakses cache (paket).

Buka file konfigurasi `/etc/apt-cacher/apt-cacher.conf` dan edit.

```shell
sudo vim /etc/apt-cacher/apt-cacher.conf
```

Uncomment dan ganti value dari baris `allowed_hosts` atau `denied_hosts` sesuai dengan IP (Internet Protocol) yang dipakai host, contoh IP yang dapat izin untuk mengakses 192.168.1.10 s/d 192.168.1.20 dan yang di tolak untuk mengakses 192.168.1.2 s/d 192.168.1.8

```shell
[...]
## Uncomment and set the IP range ##
allowed_hosts = 192.168.1.10 - 192.168.1.20

denied_hosts = 192.168.1.2 - 192.168.1.8
[...]
```

Simpan file konfigurasi, dan restart layanan Apache HTTP Server

```shell
sudo systemctl restart apache2.service
sudo systemctl status apache2.service
```

atau

```shell
sudo service apache2 restart
sudo service apache2 status
```

Sekian Dokumentasi :D
