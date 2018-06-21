# Setup ConfigServer Security & Firewall (CSF) di CentOS 7

ConfigServer Security & Firewall (CSF) adalah Stateful Packet Inspection (SPI) firewall, deteksi gangguan, dan aplikasi keamanan untuk server Linux. CSF adalah rangkaian keamanan yang sangat poluler dan keren.

Dalam artikel ini, saya akan menunjukkan cara menonaktifkan firewalld, menginstal IPtables, dependensi CSF, dan CSF.

### Step 1 - Firewalld

Stop dan disable firewalld

```shell
systemctl disable firewalld.service
systemctl stop firewalld.service
```

### Step 2 - IPtables

Install iptables

```shell
yum -y install iptables-services
```

Buat file yang dibutuhkan iptables

```shell
touch /etc/sysconfig/iptables
touch /etc/sysconfig/iptables6
```

Start iptables dan Enable iptables saat boot

```shell
systemctl start iptables.service && systemctl enable iptables.service
systemctl start ip6tables.service && systemctl enable ip6tables.service
```

### Step 3 - ConfigServer Security & Firewall (CSF)

Install CSF dependensi

```shell
yum -y install wget perl unzip net-tools perl-libwww-perl perl-LWP-Protocol-https perl-GDGraph perl-Time-HiRes
```

Masuk ke direktori `/usr/src/` dan download CSF dengan perintah wget

```shell
cd /usr/src
wget https://download.configserver.com/csf.tgz
```

Ekstrak file `csf.tgz` dan masuk ke direktori csf, lalu install

```shell
tar -xzf csf.tgz
cd csf
sh install.sh
```

Sekarang lakukan verifikasi apakah CSF bekerja di server. Masuk direktori `/usr/local/csf/bin/`, dan jalankan `csftest.pl`

```shell
cd /usr/local/csf/bin/
perl csftest.pl
```

Jika output verifikasi seperti di bawah ini, CSF bekerja tanpa masalah di server

![alt tag](https://github.com/tealinuxos/infrastruktur/blob/master/images/image002.png)

# Konfigurasi CSF

### File Konfigurasi CSF

Untuk melihat pilihan apa saja yang ada pada baris perintah `csf`

```shell
man csf
```

atau dengan cara

```shell
csf -h
```

Semua file konfigurasi untuk `csf` ada di directory `/etc/csf/`

* `csf.conf` : file konfigurasi utama dari CSF, ada beberapa komentar yang bermanfaat untuk menjelaskan apa yang harus dilakukan
* `csf.allow` : daftar alamat IP dan CIDR yang mendapatkan akses izinkan melalui firewall
* `csf.deny` : daftar alamat IP dan CIDR yang tidak mendapatkan akses izinkan melalui firewall atau diblokir
* `csf.ignore` : daftar alamat IP dan CIDR yang diabaikan dan tidak diblokir jika terdeteksi oleh firewall
* `csf.*ignore` : berbagai macam file yang diabaikan oleh firewall dan berisi daftar file, pengguna, IP yang diabaikan. Setiap file memiliki tujuan yang spesifik

Setelah selesai mengedit beberapa file konfigurasi CSF, layanan CSF biasanya direstart

```shell
csf -ra
```

### Konfigurasi Dasar

CSF dapat dikonfigurasi dengan mengedit file konfigurasinya `csf.conf` pada directory `/etc/csf`

```shell
vim /etc/csf/csf.conf
```

Setelah selesai simpan file konfigurasi dan jalankan perintah berikut

```shell
csf -ra
```

### Konfigurasi Dasar II

#### Konfigurasi Port

Semakin sedikit akses yang ada pada VPS, semakin aman VPS nya. Namun tidak semua port yang aktif bisa ditutup, karena klien harus menggunakan layanan yang ada pada VPS.

Port yang dibuka secara default oleh CSF sebagai berikut

```shell
TCP_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995"

TCP_OUT = "20,21,22,25,53,80,110,113,443"

UDP_IN = "20,21,53"

UDP_OUT = "20,21,53,113,123"

```

Layanan yang menggunakan port:

* Port 20: FTP data transfer
* Port 21: FTP control
* Port 22: Secure shell (SSH)
* Port 25: Simple mail transfer protocol (SMTP)
* Port 53: Domain name system (DNS)
* Port 80: Hypertext transfer protocol (HTTP)
* Port 110: Post office protocol v3 (POP3)
* Port 113: Authentication service/identification protocol
* Port 123: Network time protocol (NTP)
* Port 143: Internet message access protocol (IMAP)
* Port 443: Hypertext transfer protocol over SSL/TLS (HTTPS)
* Port 465: URL Rendesvous Directory for SSM (Cisco)
* Port 587: E-mail message submission (SMTP)
* Port 993: Internet message access protocol over SSL (IMAPS)
* Port 995: Post office protocol 3 over TLS/SSL (POP3S)

Ada kemungkinan tidak menggunakan semua layanan yang ada diatas. Jadi saya akan merekomendasikan untuk menutup port yang tidak digunakan, dan kemudian menambahkan port yang dibutuhkan.

#### Konfigurasi Lainnya

Konfigurasi lanjutan dari CSF, masuk ke direktori CSF `/etc/csf/` dan edit file `csf.conf` dengan editor vim

```shell
cd /etc/csf/
vim csf.conf
```

Cari dan ganti value dari baris `TESTING` menjadi `0` untuk menerapkan konfigurasi firewall

```shell
TESTING = "0"
```

Simpan file konfigurasi, dan restart CSF

```shell
csf -ra
```

Untuk melihat daftar rules hasil dari konfigurasi CSF

```shell
csf -l
```

### Konfigurasi Lanjutan

Berikut adalah beberapa tweak firewall CSF, dapat di konfigurasi sesuai kebutuhan

Kembali masuk ke direktori CSF `/etc/csf/` dan edit file `csf.conf` dengan editor vim

```shell
cd /etc/csf/
vim csf.conf
```

1. Mencegah diblokirnya alamat IP yang ada di file konfigurasi `csf.allow`

    Jadi jika menginginkan alamat IP di file konfigurasi `csf.allow` tidak diblokir, maka cari dan ganti value dari baris `IGNORE_ALLOW` menjadi `1`. Hal ini akan berguna apabila memiliki IP statis di rumah atau di kantor dan memastikan bahwa alamat IP tidak diblokir oleh firewall.

    ```shell
    IGNORE_ALLOW = "1"
    ```

2. Ijin akses Incoming dan Outgoing ICMP

    Cari dan ganti value dari baris `ICMP_IN` menjadi `1`, Incoming ICMP

    ```shell
    ICMP_IN = "1"
    ```

    Cari dan ganti value dari baris `ICMP_OUT` menjadi `1`, Outgoing ICMP

    ```shell
    ICMP_OUT = "1"
    ```

3. Block Certain Countrys

    CSF dapat memberikan opsi untuk mengizinkan dan memblokir akses dari beberapa Negara menggunakan CIDR (Country Code). Cari baris dengan nama variabel `CC_DENY` dan `CC_ALLOW`, dan tambahkan kode negara yang akan diizinkan `(CC_ALLOW)` dan diblokir `(CC_DENY)`

    ```shell
    CC_DENY = "CN,UK,US"
    CC_ALLOW = "ID"
    ```

4. Kirim log akses SSH dan Super User(su) ke E-mail

    ```shell
    LF_SSH_EMAIL_ALERT = "1"

    ...

    LF_SU_EMAIL_ALERT = "1"
    ```

    ```shell
    LF_ALERT_TO = "mymail@mydomain.ulala"
    ```

Setelah selesai mengedit beberapa file konfigurasi CSF, simpan dan restart CSF

```shell
csf -ra
```

# Cara Menggunakan CSF

1. Start firewall (memulai rule dari firewall)

    ```shell
    csf -s
    ```

2. Flush/Stop firewall (menghentikan rule dari firewall)

    ```shell
    csf -f
    ```

3. Restart firewall (me-restart rule dari firewall)

    ```shell
    csf -r
    ```

4. Status firewall (melihat hasil rule dari firewall)

    ```shell
    csf -l
    ```

5. Menambahkan IP ke `csf.allow` dan `rule akses`

    ```shell
    csf -a 192.168.1.109
    ```

    Output:

    ```shell
    Adding 192.168.1.109 to csf.allow and iptables ACCEPT...
    ACCEPT  all opt -- in !lo out *  192.168.1.109  -> 0.0.0.0/0
    ACCEPT  all opt -- in * out !lo  0.0.0.0/0  -> 192.168.1.109
    ```

6. Menghapus IP dari `csf.allow` dan `rule akses`

    ```shell
    csf -ar 192.168.1.109
    ```

    Output:

    ```shell
    Removing rule...
    ACCEPT  all opt -- in !lo out *  192.168.1.109  -> 0.0.0.0/0
    ACCEPT  all opt -- in * out !lo  0.0.0.0/0  -> 192.168.1.109
    ```

7. Menambahkan IP ke `csf.deny` dan `rule block`

    ```shell
    csf -d 192.168.1.109
    ```

    Output:

    ```shell
    Adding 192.168.1.109 to csf.deny and iptables DROP...
    DROP  all opt -- in !lo out *  192.168.1.109  -> 0.0.0.0/0
    LOGDROPOUT  all opt -- in * out !lo  0.0.0.0/0  -> 192.168.1.109
    ```

8. Menghapus IP ke `csf.deny` dan `rule block`

    ```shell
    csf -dr 192.168.1.109
    ```

    Output:

    ```shell
    Removing rule...
    DROP  all opt -- in !lo out *  192.168.1.109  -> 0.0.0.0/0
    LOGDROPOUT  all opt -- in * out !lo  0.0.0.0/0  -> 192.168.1.109
    ```

9. Menghapus semua record / data dari `csf.deny`.

    ```shell
    csf -df
    ```

    Output:

    ```shell
    DROP  all opt -- in !lo out *  192.168.1.110  -> 0.0.0.0/0
    LOGDROPOUT  all opt -- in * out !lo  0.0.0.0/0  -> 192.168.1.110
    DROP  all opt -- in !lo out *  192.168.1.111  -> 0.0.0.0/0
    LOGDROPOUT  all opt -- in * out !lo  0.0.0.0/0  -> 192.168.1.111   
    csf: all entries removed from csf.deny
    ```

10. Untuk mencari pola yang sesuai dengan IPtables, contoh: IP, CIDR, Port

    ```shell
    csf -g 192.168.1.110
    ```

11. Disable firewall (menonaktifkan rule dari firewall)

    ```shell
    csf -x
    ```

12. Enable firewall (mengaktifkan rule dari firewall)

    ```shell
    csf -e
    ```

13. Check update firewall

    ```shell
    csf -c
    ```
14. Update firewall (mendownload paket dan fitur baru firewall)

    ```shell
    csf -u
    ```

# CSF GUI

![alt tag](https://github.com/tealinuxos/infrastruktur/blob/master/images/image003.png)

![alt tag](https://github.com/tealinuxos/infrastruktur/blob/master/images/image004.png)

Jika menginginkan lebih banyak tweak firewall CSF, baca opsi / komentar / dokumentasi  di dalam file konfigurasi `/etc/csf/csf.conf` atau di [Dokumentasi CSF](https://download.configserver.com/csf/readme.txt "ConfigServer Security & Firewall (csf)").

Sekian Dokumentasi :D

Semoga berhasil!
