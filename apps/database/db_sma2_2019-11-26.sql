-- MySQL dump 10.13  Distrib 5.7.28, for Linux (x86_64)
--
-- Host: localhost    Database: db_sma2
-- ------------------------------------------------------
-- Server version	5.7.28-0ubuntu0.16.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tbl_classifications`
--

DROP TABLE IF EXISTS `tbl_classifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_classifications` (
  `id_normalization` int(11) NOT NULL,
  `id_label` int(11) NOT NULL,
  `id_crawling` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_normalization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_classifications`
--

LOCK TABLES `tbl_classifications` WRITE;
/*!40000 ALTER TABLE `tbl_classifications` DISABLE KEYS */;
INSERT INTO `tbl_classifications` VALUES (20,6,1,'2019-11-22 09:55:15',NULL),(21,2,1,'2019-11-22 09:55:15',NULL),(22,3,1,'2019-11-22 09:55:15',NULL),(23,3,1,'2019-11-22 09:55:15',NULL),(24,6,1,'2019-11-22 09:55:15',NULL),(26,5,1,'2019-11-22 09:55:15',NULL);
/*!40000 ALTER TABLE `tbl_classifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_crawling`
--

DROP TABLE IF EXISTS `tbl_crawling`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_crawling` (
  `id_crawling` int(11) NOT NULL AUTO_INCREMENT,
  `ig_username` varchar(50) NOT NULL,
  `url` text NOT NULL,
  `follower_count` int(11) NOT NULL,
  `like_count` int(11) NOT NULL,
  `caption_text` text NOT NULL,
  `taken_at` datetime NOT NULL,
  `time_frame` int(2) NOT NULL,
  `is_extracted` tinyint(1) NOT NULL DEFAULT '0',
  `is_normalized` tinyint(1) NOT NULL DEFAULT '0',
  `is_classified` tinyint(1) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_crawling`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_crawling`
--

LOCK TABLES `tbl_crawling` WRITE;
/*!40000 ALTER TABLE `tbl_crawling` DISABLE KEYS */;
INSERT INTO `tbl_crawling` VALUES (1,'abellyc','https://instagram.com/p/B31lmi6ANKC',816629,88945,'Awalnya berencana untuk pertemuan keluarga secara sederhana aja dan ternyata berujung dengan acara yang menurutku cukup meriah di rumah dengan percampuran modern dan tradisional adat Padang. Bikin kebaya aja dadakan ? Bener-bener bersyukur karena acara kemarin berjalan dengan lancar dan sangat berterima kasih untuk semua pihak yang udah bantu untuk acara spesial ini ?? Organized by @chandaniweddings Decoration by @roemahboengapadang Koordinator Adat by @ambunsuri_bandung Seserahan organized by @seserahan_id Photo & Video by @imagenic Catering @umaracatering Makeup & hair do by @giovanninathaliemua & @hairbygionina Ring by @linoandsons Engagement Cake by @bittersweet_by_najla MC by @torojazzou #BeyMyRay','2019-10-21 17:51:15',4,1,1,0,'2019-10-22 10:00:22','2019-11-22 10:13:33'),(2,'kaltaraprov','https://instagram.com/p/B5HQkQMIeCq',14106,240,'Mereka terdiri dari, Tenaga Kerja Asing (TKA) sebanyak 254 orang, orang asing yang memiliki Kartu Ijin Tinggal Sementara (KITAS) 295 orang, memiliki Kartu Ijin Tinggal Tetap (KITAP) 9 orang, dan kunjungan 1 orang. Selain itu, dilaporkan juga bahwa sepanjang Januari hingga November 2019, jumlah orang asing yang keluar-masuk Kaltara sebanyak 187 orang.\n_\nDiungkapkan Kepala Badan Kesbangpol Kaltara, Basiran, pengawasan orang asing ini melibatkan beberapa instansi. Seperti, TKA yang diawasi oleh satuan tugas (Satgas) TKA yang dibawahi Dinas Tenaga Kerja dan Transmigrasi (Disnakertrans). “Pemantauan orang asing didasarkan pada Permendagri No. 49/2010, tentang Pemantauan Orang Asing dan Organisasi Masyarakat Asing di Daerah, dan Permendagri No. 50/2010 untuk pengawasan TKA,” jelas Basiran yang ditemui di ruang kerjanya, kemarin (20/11).\n_\nBaca selengkapnya di humas.kaltaraprov.go.id','2019-11-21 11:05:09',2,0,0,0,'2019-11-22 06:31:19','2019-11-22 06:31:19'),(3,'humas_jabar','https://instagram.com/p/B5IKI2JBcwZ',88054,816,'Alhamdulillah Provinsi Jawa Barat (Jabar) mendapat penghargaan sebagai salah satu Provinsi Informatif di ajang Anugerah Keterbukaan Informasi Publik (KIP) 2019?\n.\nMenurut Kang @Ridwankamil tersebut menandakan bahwa Jawa Barat sebagai Provinsi yang taat pada aturan hukum?\n.\n\" Alhamdulillah, Jawa Barat mendapatkan anugerah salah satu provinsi yang paling informatif dalam keterbukaan informasi publik. Kategorinya informatif, menuju informatif, kurang informatif, dan tidak informatif\"\n- Gubernur Jabar, Ridwan Kamil\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas @kemensetneg.ri .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum','2019-11-21 19:28:13',5,0,0,0,'2019-11-22 06:31:26','2019-11-22 06:31:26'),(4,'kumparancom','https://instagram.com/p/B5IN577jahJ',647987,10571,'Ketua KPK Agus Rahardjo menjawab polemik diundangnya Ustaz Abdul Somad (UAS) ke kantornya pada Selasa (19/11). Ia mengaku, undangan terhadap UAS itu bukan dari KPK secara lembaga.⁠\n-⁠\nStaf yang mengundang UAS tersebut tergabung dalam organisasi kegiatan keagamaan internal, yaitu Badan Amal Islam KPK (BAIK). Agus menyampaikan, ia bahkan sudah mencegah BAIK untuk mengundang UAS. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #uas #ustaz #kpk #abdulsomad #tausiah #aguskpk #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 20:01:08',5,0,0,0,'2019-11-22 06:31:38','2019-11-22 06:31:38'),(5,'kumparancom','https://instagram.com/p/B5IHgW1AHEW',647987,8815,'Berniat membantu rekannya dengan meminjamkan KTP, nama Dimas Agung Prayitno justru dicatut untuk menyicil mobil mewah Rolls-Royce Phantom. Atas hal itu, Dimas pun kerap mendapatkan surat tagihan dari bank. Setelah ditelusuri di kantor pajak, Dimas tercatat telah menunggak pajak setahun, dengan nilai tunggakan nyaris Rp 200 juta.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #mobil #mobilmewah #rollroyce #tunggakan #bank #ktp #catutktp #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 19:10:22',5,0,0,0,'2019-11-22 06:31:38','2019-11-22 06:31:38'),(6,'kumparancom','https://instagram.com/p/B5IGVYnAmRD',647987,16540,'Presiden @jokowi mengenalkan 7 nama sebagai staf khusus kepresidenan yang baru di Istana Merdeka, Jakarta Pusat, Kamis (21/11). Dari 7 nama ini, staf khusus Jokowi didominasi oleh kalangan milenial.⁠\n-⁠\nMereka adalah pendiri Ruangguru Adamas Belva Syah Devara, CEO dan Founder CreativePreneur Putri Indahsari Tanjung, CEO PT Amartha Mikro Fintek Andi Taufan Garuda Putra, perumus Gerakan Sabang Merauke Ayu Kartika Dewi, putra asli Papua dan CEO Kitong Bisa Gracia Billy Mambrasar, penyandang disabilitas yang aktif di bidang sociopreneur Angkie Yudistia, dan mantan Ketua Umum PB PMII Aminudin Maruf.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 18:54:59',5,0,0,0,'2019-11-22 06:31:39','2019-11-22 06:31:39'),(7,'kumparancom','https://instagram.com/p/B5HsEcUAQJz',647987,11647,'Presiden @Jokowi akan segera mengumumkan stafsusnya hari ini, di antaranya dari kalangan milenial. Sekjen PPP, Arsul Sani, sebagai salah satu partai pengusung Jokowi, mengonfirmasi hal itu. Namun, Arsul belum mengetahui jumlah stafsus yang dibutuhkan Jokowi di periode kedua ini. Dia menyebut salah satu nama milenial yang akan jadi stafsus adalah anak konglomerat Chairul Tanjung, @putri_tanjung.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 15:10:38',3,1,1,0,'2019-11-22 06:31:39','2019-11-25 04:04:59'),(8,'kumparancom','https://instagram.com/p/B5Hkpt5DSpG',647987,8888,'Kopilot Wings Air Nicolaus Anjar Aji ditemukan tewas tergantung di kamar indekosnya di Kalideres, Jakarta Barat. Polisi menduga aksi bunuh diri ini terkait dengan pemecatan Nicolaus dari perusahaannya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #pilot #kopilot #bunuhdiri #wingsair #gantungdiri #kasus #polisi #meninggaldunia #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 14:00:40',3,0,0,0,'2019-11-22 06:31:39','2019-11-22 06:31:39'),(9,'viceind','https://instagram.com/p/B5HnxfQjRvs',338599,12012,'Noel kesal karena sering dikatain adiknya di Twitter. Udah lah, fans Oasis. Enggak usah banyak berharap mereka bakalan reunian. Kayaknya itu cuma mimpi. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Getty Images','2019-11-21 14:27:56',3,0,0,0,'2019-11-22 06:31:45','2019-11-22 06:31:45'),(10,'viceind','https://instagram.com/p/B5HXVRtA30t',338599,12076,'Menurut Menkes, praktik pengobatan alternatif itu bisa menarik turis-turis mancenagara yang suka \'back to nature\'. Hmm, sungguh pemikiran out of the box. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Sadewa Kristianto','2019-11-21 12:04:17',2,0,0,0,'2019-11-22 06:31:45','2019-11-22 06:31:45'),(11,'aniesbaswedan','https://instagram.com/p/B5Hu76KgNym',3873821,109501,'Alhamdulillah, Pemprov DKI Jakarta baru saja menerima kembali Penghargaan Keterbukaan Informasi Publik Tahun 2019 yang berdasarkan penilaian oleh Komisi Informasi Pusat Republik Indonesia.⁣\n⁣\nIni menunjukkan komitmen Pemprov DKI Jakarta untuk terus mendukung dan melaksanakan praktik open governance. yang di dalamnya ada komponen transparansi, keterbukaan. Sesuai yang diamanatkan dalam Undang-undang nomor 14/2008 tentang Keterbukaan Informasi Publik. ⁣\n⁣\nTapi yang lebih penting adalah bahwa komitmen Pemprov DKI Jakarta dalam hal keterbukaan informasi ini telah melampaui apa yang telah diarahkan oleh Undang-undang KIP itu sendiri. Kita memberikan akses informasi kepada publik terhadap berbagai aspek kegiatan, dari perencanaan hingga hasil kinerja Pemprov DKI Jakarta. ⁣\n⁣\nJadi kami merasa bersyukur sekali bahwa kategori yang kita dapat adalah ketegori yang tertinggi sebagai Badan Publik yang Informatif, dua tahun berturut-turut. Apresiasi atas kerja keras seluruh jajaran Pejabat Pengelola Informasi dan Dokumentasi (PPID) Dinas Komunikasi, Informatika dan Statistik Pemprov DKI Jakarta.⁣\n⁣\nBerkat mereka semua inovasi, semua karya, semua kolaborasi, yang dilakukan Pemprov DKI selama ini bisa diketahui publik dan kami bisa mengajak publik lebih banyak lagi untuk terlibat di dalam pembangunan di Jakarta. ⁣\n⁣\nKami bersyukur dan akan terus tingkatkan di masa yang akan datang.⁣\n⁣\nppid.jakarta.go.id','2019-11-21 15:30:32',3,0,0,0,'2019-11-22 06:31:09','2019-11-22 06:31:09'),(12,'ridwankamil','https://instagram.com/p/B5O5aPWAYCl',11227507,134487,'“Bunga-bunga Cinta di kebun pernikahan itu harus rajin dirawat dan dijaga”\n\nAda puluhan ribu pasangan di Jawa Barat mengajukan gugatan perceraian setiap tahun. Kebanyakan karena faktor ekonomi dan perselingkuhan. Apalagi godaan yang hilir mudik melalui media sosial atau digital.\nSuatu fenomena sosial yang mengkhawatirkan.\n\nKepada yang sudah menikah semoga kehangatan cintanya selalu dirawat dan dijaga dari godaan yang datang menghampiri.\n\nSelamat berhari Minggu. #JanganLupaBahagia bersama yang dicinta.','2019-11-24 10:16:44',2,0,0,0,'2019-11-25 13:05:20','2019-11-25 13:05:20'),(13,'jokowi','https://instagram.com/p/B5P00e6hd15',26744459,833924,'Desa Gamcheon tadinya adalah kampung yang kumuh di Busan, Korea Selatan. Sudah kumuh, lokasinya pun sulit: di lereng gunung yang curam. Sampai kemudian desa ini berbenah, ditata, diberdayakan.\n\nJadilah Gamcheon Culture Village sebagai salah satu tujuan wisata yang ramai, bahkan dikenal dengan sebutan “Machu Picchu-nya Busan”. Mengisi hari Minggu di Busan, saya mengunjungi desa budaya Gamcheon selepas siang tadi. Luar biasa. Rumah-rumah yang dicat berwarna-warni, dinding-dindingnya dihiasi beragam karya seni seperti mural. Jalan-jalan dan lorongnya yang sempit dipenuhi toko cenderamata, galeri seni, dan tempat makan.\n\nDari sebuah kafe di ketinggian, saya dan Ibu Negara menikmati pemandangan atap-atap bangunan yang seolah bertumpuk seraya menikmati makanan khas Korea Selatan.\n\nPenataan Desa Gamcheon mengingatkan saya model serupa di Tanah Air seperti yang ada di Klaten, Yogyakarta, atau di Nglanggeran, Gunung Kidul. Gamcheon bisa menjadi inspirasi bagi kepala daerah kita, bagi kampung-kampung kita, bagi desa-desa kita, bahwa yang kumuh pun kalau ditata dengan baik, bisa meningkatkan ekonomi masyarakat.','2019-11-24 18:55:52',5,0,0,0,'2019-11-25 13:05:25','2019-11-25 13:05:25'),(14,'jokowi','https://instagram.com/p/B5O-MbPBEa2',26744459,616784,'Temukan saya dalam gambar ini. Ada jurnalis, juru kamera, dan yang terbanyak adalah orang-orang yang tengah mengacungkan sehelai kertas. Kertas itu adalah lembar-lembar sertifikat hak milik atas sebidang tanah yang penerbitannya kita percepat semenjak tiga tahun terakhir.\n\nSaya ingat, pada akhir 2014 lalu saya mendapat laporan bahwa ada 126 juta bidang tanah di seluruh Tanah Air yang belum bersertifikat. Dari jumlah tersebut, baru 46 juta bidang yang diselesaikan.\n\nSementara, setiap tahun badan pertanahan hanya bisa menerbitkan 500 ribu sertifikat. Saya pernah merasakan jadi rakyat biasa, tahu betapa sulit dan berbelitnya mengurus sertifikat hak atas tanah. Kalau masih terus begitu, butuh 160 tahun lagi untuk menyelesaikan semua sertifikat lahan di Indonesia ini.\n\nAlhamdulillah, sejak tahun 2017, pendaftaran bidang tanah di Indonesia meningkat lebih sepuluh kali lipat. Dari lima juta lembar sertifikat tahun 2017, naik jadi sembilan juta tahun 2018, dan sampai November 2019 ini sudah 8,5 juta. Saya sendiri kerap menyerahkan langsung sertifikat tanah itu di setiap kunjungan ke daerah.','2019-11-24 10:58:32',2,0,0,0,'2019-11-25 13:05:25','2019-11-25 13:05:25'),(15,'detikcom','https://instagram.com/p/B5QDC7blkIX',1894301,8719,'Binomo sedang viral di dunia maya. Binomo adalah salah salah satu website penyedia jasa investasi trading.\n--\nBinomo sendiri viral setelah iklan produknya ramai diperbincangkan di dunia maya. Dalam video tersebut memperlihatkan seorang pria yang mengaku sukses dan kaya raya karena Binomo. Jargonnya: \"Jutaan orang bahkan tak menyadari bahwa mereka bisa menghasilkan US$ 1.000 sehari tanpa meninggalkan rumah. Dan Anda adalah salah satu dari mereka,\"\n--\nNamun tidak disangka, ternyata legalitas Binomo tidak jelas. Bahkan, pemerintah pun sudah memblokir situs utama Binomo, binomo.com dan binomo.net.\n--\nDua situs tersebut masuk ke dalam daftar 58 domain entitas ilegal yang disusun oleh Badan Pengawas Perdagangan Berjangka Komoditi (Bappebti) Kementerian Perdagangan. Bappebti pun sudah meminta Kementerian Komunikasi dan Informatika untuk memblokit situs-situs entitas tersebut.\n--\nKepala Bappebti Tjahya Widayanti mennyebut bahwa Binomo dan 58 entitas lainnya sering menawarkan investasi bodong berkedok forex. Tjahya juga menilai, entitas-entitas ini menjanjikan keuntungan tetap yang tidak wajar.\n--\nEntitas ini juga sering mengaku sebagai pialang berjangka dari luar negeri. \"Selain itu juga terdapat entitas yang melakukan kegiatan selayaknya Pialang Berjangka dengan menjadi Introducing Broker (IB) dari Pialang Luar Negeri,\" lanjutnya.\n--\nTjahya juga memperingatkan bahwa entitas seperti ini sudah menjamur di dunia maya. Persyaratan yang mudah pun digunakan untuk menjaring korban-korbannya.\n--\nDalam video iklan Binomo yang viral, memperlihatkan Budi Setiawan, seorang pria yang mengaku sukses jadi trader di Binomo. Bukan cuma mengaku sukses, pria ini pun membagikan tips-tipsnya menjadi orang sukses, ujungnya dia mengajak penonton untuk ikut jadi trader di Binomo.\n--\nBaca berita selengkapnya hanya di detikcom! (Foto: dok.Istimewa)\n--\n#detikcom #tahudaridetikcom #Binomo #Viral #BudiSetiawan','2019-11-24 21:00:10',5,0,0,0,'2019-11-25 13:05:29','2019-11-25 13:05:29'),(16,'detikcom','https://instagram.com/p/B5P1T7aFuBx',1894301,6857,'Menteri BUMN, Erick Thohir membuka pintu untuk Sandiaga Uno menempati posisi salah satu perusahaan plat merah. Namun Sandi menolak dan memilih berkonsentrasi di program OK OCE.\n--\nOK OCE atau One Kecamatan, One Center of Entrepreneurship merupakan program yang berusaha melakukan pembinaan kewirausahaan terhadap pelaku usaha mikro kecil dan menengah (UMKM). Sandi sedang mengembangkan OK OCE ke seluruh pelosok nusantara.\n--\nMantan Cawapres itu mengaku hingga Sabtu pagi masih berhubungan dengan Erick Thohir.\n--\nMeski tak ingin di posisi BUMN, namun Sandi menyebut selalu memberi masukan yang terbaik soal BUMN kepada sang Menteri.\n--\nBerkaitan dengan posisi yang diberikan kepada Basuki Tjahaja Purnama atau Ahok, Sandi hanya berujar singkat, \"Kita menunggu alasan penunjukan beliau dan bagaimana kinerjanya,\" tutup Sandi.\n--\nSimak berita selengkapnya hanya di detik.com! (Foto: Pradito R Pertana/detikcom)\n--\n#detikcom #tahudaridetikcom #SandiagaUno #okeoce','2019-11-24 19:00:10',5,0,0,0,'2019-11-25 13:05:29','2019-11-25 13:05:29'),(17,'detikcom','https://instagram.com/p/B5PnlGtFV_k',1894301,11731,'Menteri Pemuda dan Olahraga (Menpora) Malaysia, Syed Saddiq, menyampaikan permintaan maaf kepada Indonesia atas pengeroyokan suporter Indonesia di Malaysia. Permintaan maaf itu disampaikannya via akun Twitter resminya. Namun Menpora RI Zainudin Amali ingin agar permintaan maaf itu disampaikan secara resmi.\n--\nAmali telah menyurati Menteri Sukan dan Belia itu, istilah Menpora di Malaysia, pada Jumat (22/11). Isinya adalah Indonesia kecewa terhadap perlakuan pihak Malaysia ke suporter asal Indonesia.\n--\nDua hal yang diminta Indonesia lewat surat ke Malaysia itu, pertama, agar pihak Malaysia mengusut tuntas insiden itu dan melakukan upaya penegakan hukum secara transparan. Kedua, meminta supaya pemerintah Malaysia menyampaikan permohonan maaf yang disampaikan oleh Menpora.\n--\n\"Kenapa permintaan maaf itu kami minta disampaikan oleh Menpora Malaysia, itu karena sebelumnya pernah ada kejadian di Gelora Bung Karno Jakarta, saat itu Menpora sebelumnya, Imam Nahrawi, datang menemui langsung Menpora Malaysia di lokasi,\" kata Amali.\n--\nBaca berita selengkapnya hanya di detik.com!\n--\n#detikcom #tahudaridetikcom #indonesiavsmalaysia','2019-11-24 17:00:10',4,0,0,0,'2019-11-25 13:05:29','2019-11-25 13:05:29'),(18,'detikcom','https://instagram.com/p/B5PdR1XH6B4',1894301,8596,'Seorang pria di London, Inggris diburu oleh polisi usai ia melecehkan bocah Yahudi dengan sentimen antisemitisme. Aksi itu sempat terekam video dan viral. Dalam video tersebut, tampak seorang wanita muslim membela.\n--\nSebagaimana diketahui, antisemitisme ialah paham yang dianut oleh orang-orang yang tidak suka pada segala sesuatu yang bersangkutan dengan bangsa Yahudi. Paham ini pernah berjaya ketika Adolf Hitler memimpin partai Nazi Jerman.\n--\nSeperti dilansir BBC pada Sabtu (23/11/2019), mulanya, aksi pelecehan antisemitisme yang dilakukan pria itu terekam dalam sebuah video. Dia tampak sedang membacakan petikan-petikan Alkitab yang mengandung unsur antisemitisme untuk dua bocah laki-laki. Dua bocah itu sedang berpergian bersama keluarganya di Jalur Utara kereta bawah tanah London, pada Jumat (22/11).\n--\nPolisi Transportasi Inggris pun mencari pria itu dan meminta keterangan dari sejumlah saksi. Atkins merekam pertengkaran selama sekitar dua menit sebelum pindah untuk bertukar kursi dengan anak muda di sebelah pria itu.\n--\nPria pelaku pelecehan antisemitisme itu kemudian mengancam seorang pria lain yang berusaha ikut campur tangan. Namun, tiba-tiba seorang wanita berjilbab tampak muncul membela.\n--\nAtkins kemudian mengatakan bahwa keluarga itu pun akhirnya turun dari kereta di Leicester Square. Ayah dari dua anak laki-laki itu memberinya izin Atkins untuk membagikan video tersebut di Twitter.\n--\nPolisi Transportasi Inggris pun terus memburu pria pelontar ujaran antisemit itu. Polisi pun mengimbau kepada semua pihak untuk turut berbagi informasi terkait identitas si pria.\n--\nBaca berita selengkapnya hanya di detik.com! (Foto: dok.Istimewa)\n--\n#detikcom #tahudaridetikcom #viral','2019-11-24 15:30:10',3,0,0,0,'2019-11-25 13:05:29','2019-11-25 13:05:29'),(19,'detikcom','https://instagram.com/p/B5PZ2KylfFY',1894301,7604,'Polda Metro Jaya akan menilang pengendara skuter listrik di jalan raya, dan pelanggaran lainnya. Pelanggar bisa dikenai denda sampai Rp 250 ribu.\n--\nPolda Metro Jaya bersama dengan Dinas Perhubungan DKI Jakarta telah menentukan beberapa peraturan. Skuter listrik hanya diizinkan di lokasi-lokasi khusus yang sudah ada kerja sama antara pengelola kawasan dan operator skuter listrik.\n--\nSelain itu, ada syarat lain bagi pengendara skuter listrik. Termasuk kelengkapan keselamatan saat berkendara.\n--\nPenerapan tilang akan dilakukan pada Senin (25/11). Untuk saat ini, pelanggaran hanya dikenai teguran.\n--\nSementara itu, Direktur Lalu Lintas Polda Metro Jaya, Kombes Yusuf mengatakan skuter listrik dilarang beroperasi di trotoar ataupun jalan raya. Peraturan ini dibuat sambil menunggu kajian soal skuter listrik.\n--\nBaca berita selengkapnya hanya di detik.com! (Foto: Lamhot Aritonang/detikcom)\n--\n#detikcom #tahudaridetikcom #skuterlistrik','2019-11-24 15:00:10',3,0,0,0,'2019-11-25 13:05:30','2019-11-25 13:05:30'),(20,'detikcom','https://instagram.com/p/B5PHLTaFJIO',1894301,6936,'Menteri BUMN Erick Thohir telah memastikan Basuki Tjahaja Purnama alias Ahok menjadi Komisaris Utama PT Pertamina (Persero). Keputusan ini juga menuai beragam komentar.\n--\nSejumlah pihak menyayangkan Ahok ditempatkan sebagai komisaris, bukan direksi. Alasannya, menjadi komisaris, wewenang Ahok terbatas.\n--\nContohnya tanggapan dari Direktur Eksekutif Energy Watch Mamit Setiawan menilai Ahok lebih cocok jadi Dirut.\n--\nMamit Setiawan menilai bahwa wewenang Ahok sebagai Komisaris Utama Pertamina sangatlah terbatas.\n--\nTerutama untuk mengambil keputusan dalam menjalankan pekerjaan rumah utamanya, yakni membasmi mafia migas.\n--\nMeski begitu, ia memahami bahwa banyaknya penolakan terhadap Ahok atas latar belakang kasus yang pernah dialaminya membuat keputusan pemerintah menempati eks Gubernur DKI tersebut sebagai Komut adalah \'jalan aman\'.\n--\nBanyak PR yang harus dituntaskan Ahok sebagai Komut Pertamina. Ahok punya PR untuk membasmi mafia migas, hingga menekan impor migas dalam mengatasi Current Account Defisit (CAD).\n--\nDalam memperbaiki CAD tersebut, pengamat BUMN dari Universitas Indonesia, Toto Pranoto menuturkan bahwa Pertamina yang akan diawasi Ahok nanti harus meningkatkan produksi minyak yang tak pernah mencapai target nasional.\n--\nToto mengatakan, dalam melaksanakan hal tersebut Pertamina harus meningkatkan upaya eksplorasi dan eksploitasi migas.\n--\nMenambahkan PR Ahok, Mamit berpendapat bahwa Ahok juga harus menggenjot lagi program BBM satu harga di Indonesia.\n--\nTerakhir, Mamit juga menyebutkan bahwa Ahok harus berkontribusi dalam memperbaiki kebijakan peredaran elpiji subsidi 3 kg yang juga menjadi biang kerok dalam neraca dagang migas Indonesia.\n--\nMamit mengatakan, PR lain Ahok saat menjadi Komut Pertamina nanti menurut Mamit adalah Ahok harus bisa menjaga tutur katanya.\n--\nOleh sebab itu, ketika Ahok sah menjadi Komut nanti, ia menegaskan satu hal, yakni Ahok harus menjaga tutur katanya, dan tak mengeluarkan pernyataan keras yang bisa menimbulkan konflik.\n--\nSelengkapnya hanya di detik.com! (Ilustrasi: Fuad Hasim/detikcom)\n--\n#detikcom #tahudaridetikcom #Ahok #BUMN #Pertamina','2019-11-24 12:17:02',2,0,0,0,'2019-11-25 13:05:30','2019-11-25 13:05:30'),(21,'detikcom','https://instagram.com/p/B5PB0ICFhiQ',1894301,7130,'Pria berinisal LAW mengemudikan motor sport Yamaha R15 dan berboncengan dengan perempuan berinisial MA. LAW tidak bisa mengendalikan motor saat menikung hingga menghantam pagar apartemen.\n--\nLAW masih selamat saat kejadian. Sedangkan MA meninggal dunia di lokasi kejadian.\n--\nDiketahui, kejadian ini terjadi pada pukul 02.00 WIB. Polisi mengamankan barang bukti berupa sepeda motor Yamaha R15, STNK Yamaha R15, dan SIM atas nama LAW. Fahri menduga LAW melanggar pasal 283 UU nomor 22 tahun 2009 LLAJ tentang berkendara tidak wajar.\n--\nBaca berita selengkapnya hanya di detik.com! (Foto: Dok. TMC Polda Metro Jaya)\n--\n#detikcom #tahudaridetikcom #kecelakaan','2019-11-24 11:30:10',2,0,0,0,'2019-11-25 13:05:30','2019-11-25 13:05:30');
/*!40000 ALTER TABLE `tbl_crawling` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_engines`
--

DROP TABLE IF EXISTS `tbl_engines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_engines` (
  `id_engine` int(11) NOT NULL AUTO_INCREMENT,
  `ig_username` varchar(50) NOT NULL,
  `ig_password` varchar(50) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_engine`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_engines`
--

LOCK TABLES `tbl_engines` WRITE;
/*!40000 ALTER TABLE `tbl_engines` DISABLE KEYS */;
INSERT INTO `tbl_engines` VALUES (1,'jajatismail','1234567890','2019-10-15 10:03:17','2019-10-16 06:57:35'),(2,'testing','12345','2019-10-21 07:00:47','2019-10-21 07:03:04');
/*!40000 ALTER TABLE `tbl_engines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_extractions`
--

DROP TABLE IF EXISTS `tbl_extractions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_extractions` (
  `id_extraction` int(11) NOT NULL AUTO_INCREMENT,
  `id_crawling` int(11) NOT NULL,
  `keyword` varchar(50) NOT NULL,
  `is_normalize` tinyint(1) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_extraction`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_extractions`
--

LOCK TABLES `tbl_extractions` WRITE;
/*!40000 ALTER TABLE `tbl_extractions` DISABLE KEYS */;
INSERT INTO `tbl_extractions` VALUES (33,1,'pertemuan',0,'2019-11-22 08:11:41',NULL),(34,1,'keluarga',0,'2019-11-22 08:11:41',NULL),(35,1,'adat',0,'2019-11-22 08:11:41',NULL),(36,1,'padang',0,'2019-11-22 08:11:41',NULL),(37,1,'bersyukur',0,'2019-11-22 08:11:41',NULL),(38,1,'engagement',0,'2019-11-22 08:11:41',NULL),(39,7,'@jokowi',0,'2019-11-25 04:02:41',NULL),(40,7,'stafsusnya',0,'2019-11-25 04:02:41',NULL),(41,7,'arsul',0,'2019-11-25 04:02:41',NULL),(42,7,'sani',0,'2019-11-25 04:02:41',NULL),(43,7,'@putri_tanjung⁠',0,'2019-11-25 04:02:41',NULL);
/*!40000 ALTER TABLE `tbl_extractions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_labels`
--

DROP TABLE IF EXISTS `tbl_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_labels` (
  `id_label` int(11) NOT NULL AUTO_INCREMENT,
  `label_name` varchar(50) NOT NULL,
  `label_desc` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_label`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_labels`
--

LOCK TABLES `tbl_labels` WRITE;
/*!40000 ALTER TABLE `tbl_labels` DISABLE KEYS */;
INSERT INTO `tbl_labels` VALUES (1,'Nilai Sosial','memiliki nilai di sosial masyarakat, orang berbagi karena merasa akan terlihat bagus','2019-10-29 10:16:39',NULL),(2,'Penghubung','menghubungkan pada hal lain, tip of mind, tip of tounge','2019-10-29 10:16:39',NULL),(3,'Sisi Emosional','ya udah sisi emosional aja','2019-10-29 10:16:39',NULL),(4,'Publik','orang atau orang orang yang mempengaruhi orang lain','2019-10-29 10:16:39',NULL),(5,'Tips','This is for Tips','2019-10-29 10:16:39',NULL),(6,'Cerita','This is For Story','2019-10-29 10:16:39',NULL);
/*!40000 ALTER TABLE `tbl_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_normalizations`
--

DROP TABLE IF EXISTS `tbl_normalizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_normalizations` (
  `id_normalization` int(11) NOT NULL AUTO_INCREMENT,
  `id_crawling` int(11) NOT NULL,
  `id_extraction` int(11) NOT NULL,
  `normal_text` varchar(50) NOT NULL,
  `id_label` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_normalization`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_normalizations`
--

LOCK TABLES `tbl_normalizations` WRITE;
/*!40000 ALTER TABLE `tbl_normalizations` DISABLE KEYS */;
INSERT INTO `tbl_normalizations` VALUES (28,1,33,'pertemuan',0,'2019-11-22 10:13:33'),(29,1,34,'keluarga',0,'2019-11-22 10:13:33'),(30,1,36,'Kota Padang',0,'2019-11-22 10:13:33'),(31,1,37,'bersyukur',0,'2019-11-22 10:13:33'),(32,1,38,'engagement',0,'2019-11-22 10:13:33'),(33,1,0,'Extra 2',0,'2019-11-22 10:13:33'),(34,7,39,'Jokowi',0,'2019-11-25 04:04:59'),(35,7,40,'Staf Khusus Presiden',0,'2019-11-25 04:04:59'),(36,7,41,'Arsul Sani',0,'2019-11-25 04:04:59'),(37,7,43,'Putri Tanjung',0,'2019-11-25 04:04:59');
/*!40000 ALTER TABLE `tbl_normalizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_targets`
--

DROP TABLE IF EXISTS `tbl_targets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_targets` (
  `id_target` int(11) NOT NULL AUTO_INCREMENT,
  `ig_username` varchar(50) NOT NULL,
  `id_admin` int(11) NOT NULL,
  `id_engine` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_target`),
  UNIQUE KEY `target_username` (`ig_username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_targets`
--

LOCK TABLES `tbl_targets` WRITE;
/*!40000 ALTER TABLE `tbl_targets` DISABLE KEYS */;
INSERT INTO `tbl_targets` VALUES (1,'ridwankamil',2,1,'2019-11-20 12:52:23','2019-11-22 06:58:49'),(2,'jajatismail',2,2,'2019-11-22 07:51:35',NULL),(3,'jokowi',5,1,'2019-11-25 03:28:01',NULL),(4,'detikcom',5,2,'2019-11-25 03:28:36',NULL);
/*!40000 ALTER TABLE `tbl_targets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_users`
--

DROP TABLE IF EXISTS `tbl_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_users` (
  `id_user` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  `user_type` tinyint(1) NOT NULL COMMENT '1. Owner 2. Admin 3. Client',
  `active` tinyint(1) NOT NULL,
  `password` varchar(50) NOT NULL DEFAULT '',
  `token` varchar(100) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`),
  KEY `login` (`username`,`password`),
  KEY `loginByToken` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_users`
--

LOCK TABLES `tbl_users` WRITE;
/*!40000 ALTER TABLE `tbl_users` DISABLE KEYS */;
INSERT INTO `tbl_users` VALUES (1,'myjajat@gmail.com','Jajat Ismail',1,1,'827ccb0eea8a706c4c34a16891f84e7b','d66bed2ad538d3a3019d7f16523cb16fdad54fa903fd691cb929185ce9aed2f1','2019-10-02 09:41:51','2019-11-22 10:32:12'),(2,'admin1@email.com','Admin 1',2,1,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-10-16 11:24:59','2019-10-18 14:20:26'),(3,'user1@email.com','User 1',3,0,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-10-18 10:19:14','2019-10-24 12:00:01'),(4,'okyzaprabowo@gmail.com','Okyza Prabowo',3,1,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-11-25 03:15:01','2019-11-25 03:15:01'),(5,'admin2@email.com','Admin 2',2,1,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-11-25 03:27:38','2019-11-25 03:27:38');
/*!40000 ALTER TABLE `tbl_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_users_targets`
--

DROP TABLE IF EXISTS `tbl_users_targets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_users_targets` (
  `id_user` int(11) NOT NULL,
  `id_target` int(11) NOT NULL,
  `category` varchar(20) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`,`id_target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_users_targets`
--

LOCK TABLES `tbl_users_targets` WRITE;
/*!40000 ALTER TABLE `tbl_users_targets` DISABLE KEYS */;
INSERT INTO `tbl_users_targets` VALUES (3,1,'POLITIK','2019-10-18 12:06:08','2019-11-20 12:50:09'),(3,3,'POLITIK','2019-11-25 03:52:34','2019-11-25 03:52:34'),(4,1,'PUBLIC FIGURE','2019-11-25 03:51:13','2019-11-25 03:51:13'),(4,2,'PUBLIC FIGURE','2019-11-25 03:51:20','2019-11-25 03:51:20'),(4,4,'NEWS','2019-11-25 03:51:31','2019-11-25 03:51:31');
/*!40000 ALTER TABLE `tbl_users_targets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-25 20:26:43
