# Konfigurasi repositori di klien

Dari sisi klien cukup mudah untuk konfigurasi repositori, cara konfigurasi repositori di klien Ubuntu ada dua:

1. source.list
2. setting apt proxy

---

### source.list

Buka file konfigurasi `/etc/apt/source.list` dan edit

```shell
sudo vim /etc/apt/source.list
```

Edit pada baris terakhir dan tambah path repositori localnya.

```shell
[...]
deb http://studio.tealinuxos.org/ubuntu trusty universe
deb http://studio.tealinuxos.org/ubuntu trusty main restricted
deb http://studio.tealinuxos.org/ubuntu trusty-updates main restricted
[...]
```

`studio.tealinuxos.org` adalah server repositori local.

Simpan file konfigurasi dan update repositori yang sudah di edit dengan command.

```shell
sudo apt-get update
```

Klien tidak perlu terhubung ke Internet untuk mendownload paket dari repositori. Sebagai gantinya, klien akan mendapatkan semua paket dan update dari server repositori lokal.

---

### setting apt proxy

Buat file konfigurasi `01proxy` di direktori `/etc/apt/apt.conf.d/`

```shell
sudo vim /etc/apt/apt.conf.d/01proxy
```

Edit file konfigurasi `01proxy` dan tambah konfigurasi di bawah

```shell
Acquire::http::Proxy "http://studio.tealinuxos.org:3142";
```

`studio.tealinuxos.org` adalah server repositori local.

Simpan file konfigurasi dan update repositori yang sudah di edit dengan command.

```shell
sudo apt-get update
```

Klien tidak perlu terhubung ke Internet untuk mendownload paket dari repositori. Sebagai gantinya, klien akan mendapatkan semua paket dan update dari server repositori lokal.

---

##Kesimpulan

Sejauh yang saya tahu dan pernah alami, kedua metode tersebut bekerja dengan baik dan sangat disarankan untuk menghemat quota internet. Kedua metode tersebut cukup mudah dikonfigurasi dan dipelihara(maintenance). Cobalah, tidak akan merasa kecewa.

Semoga berhasil!
