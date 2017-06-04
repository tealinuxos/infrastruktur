# Setup ConfigServer Security and Firewall (CSF) on CentOS 7

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

### Step 3 - ConfigServer Security and Firewall (CSF)

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

Sekian Dokumentasi :D

Semoga berhasil!
