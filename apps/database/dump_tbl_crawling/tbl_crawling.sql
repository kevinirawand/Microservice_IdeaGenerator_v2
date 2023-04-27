-- MySQL dump 10.16  Distrib 10.1.37-MariaDB, for Win32 (AMD64)
--
-- Host: localhost    Database: db_sma
-- ------------------------------------------------------
-- Server version	10.1.37-MariaDB

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_crawling`
--

LOCK TABLES `tbl_crawling` WRITE;
/*!40000 ALTER TABLE `tbl_crawling` DISABLE KEYS */;
INSERT INTO `tbl_crawling` VALUES (1,'aniesbaswedan','https://instagram.com/p/B5Hu76KgNym',3873821,109501,'Alhamdulillah, Pemprov DKI Jakarta baru saja menerima kembali Penghargaan Keterbukaan Informasi Publik Tahun 2019 yang berdasarkan penilaian oleh Komisi Informasi Pusat Republik Indonesia.⁣\n⁣\nIni menunjukkan komitmen Pemprov DKI Jakarta untuk terus mendukung dan melaksanakan praktik open governance. yang di dalamnya ada komponen transparansi, keterbukaan. Sesuai yang diamanatkan dalam Undang-undang nomor 14/2008 tentang Keterbukaan Informasi Publik. ⁣\n⁣\nTapi yang lebih penting adalah bahwa komitmen Pemprov DKI Jakarta dalam hal keterbukaan informasi ini telah melampaui apa yang telah diarahkan oleh Undang-undang KIP itu sendiri. Kita memberikan akses informasi kepada publik terhadap berbagai aspek kegiatan, dari perencanaan hingga hasil kinerja Pemprov DKI Jakarta. ⁣\n⁣\nJadi kami merasa bersyukur sekali bahwa kategori yang kita dapat adalah ketegori yang tertinggi sebagai Badan Publik yang Informatif, dua tahun berturut-turut. Apresiasi atas kerja keras seluruh jajaran Pejabat Pengelola Informasi dan Dokumentasi (PPID) Dinas Komunikasi, Informatika dan Statistik Pemprov DKI Jakarta.⁣\n⁣\nBerkat mereka semua inovasi, semua karya, semua kolaborasi, yang dilakukan Pemprov DKI selama ini bisa diketahui publik dan kami bisa mengajak publik lebih banyak lagi untuk terlibat di dalam pembangunan di Jakarta. ⁣\n⁣\nKami bersyukur dan akan terus tingkatkan di masa yang akan datang.⁣\n⁣\nppid.jakarta.go.id','2019-11-21 15:30:32',3,0,0,0,'2019-11-22 13:31:09','2019-11-22 13:31:09'),(2,'kaltaraprov','https://instagram.com/p/B5HQkQMIeCq',14106,240,'Mereka terdiri dari, Tenaga Kerja Asing (TKA) sebanyak 254 orang, orang asing yang memiliki Kartu Ijin Tinggal Sementara (KITAS) 295 orang, memiliki Kartu Ijin Tinggal Tetap (KITAP) 9 orang, dan kunjungan 1 orang. Selain itu, dilaporkan juga bahwa sepanjang Januari hingga November 2019, jumlah orang asing yang keluar-masuk Kaltara sebanyak 187 orang.\n_\nDiungkapkan Kepala Badan Kesbangpol Kaltara, Basiran, pengawasan orang asing ini melibatkan beberapa instansi. Seperti, TKA yang diawasi oleh satuan tugas (Satgas) TKA yang dibawahi Dinas Tenaga Kerja dan Transmigrasi (Disnakertrans). “Pemantauan orang asing didasarkan pada Permendagri No. 49/2010, tentang Pemantauan Orang Asing dan Organisasi Masyarakat Asing di Daerah, dan Permendagri No. 50/2010 untuk pengawasan TKA,” jelas Basiran yang ditemui di ruang kerjanya, kemarin (20/11).\n_\nBaca selengkapnya di humas.kaltaraprov.go.id','2019-11-21 11:05:09',2,0,0,0,'2019-11-22 13:31:19','2019-11-22 13:31:19'),(3,'humas_jabar','https://instagram.com/p/B5IKI2JBcwZ',88054,816,'Alhamdulillah Provinsi Jawa Barat (Jabar) mendapat penghargaan sebagai salah satu Provinsi Informatif di ajang Anugerah Keterbukaan Informasi Publik (KIP) 2019?\n.\nMenurut Kang @Ridwankamil tersebut menandakan bahwa Jawa Barat sebagai Provinsi yang taat pada aturan hukum?\n.\n\" Alhamdulillah, Jawa Barat mendapatkan anugerah salah satu provinsi yang paling informatif dalam keterbukaan informasi publik. Kategorinya informatif, menuju informatif, kurang informatif, dan tidak informatif\"\n- Gubernur Jabar, Ridwan Kamil\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas @kemensetneg.ri .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum','2019-11-21 19:28:13',5,0,0,0,'2019-11-22 13:31:26','2019-11-22 13:31:26'),(4,'kumparancom','https://instagram.com/p/B5IN577jahJ',647987,10571,'Ketua KPK Agus Rahardjo menjawab polemik diundangnya Ustaz Abdul Somad (UAS) ke kantornya pada Selasa (19/11). Ia mengaku, undangan terhadap UAS itu bukan dari KPK secara lembaga.⁠\n-⁠\nStaf yang mengundang UAS tersebut tergabung dalam organisasi kegiatan keagamaan internal, yaitu Badan Amal Islam KPK (BAIK). Agus menyampaikan, ia bahkan sudah mencegah BAIK untuk mengundang UAS. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #uas #ustaz #kpk #abdulsomad #tausiah #aguskpk #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 20:01:08',5,0,0,0,'2019-11-22 13:31:38','2019-11-22 13:31:38'),(5,'kumparancom','https://instagram.com/p/B5IHgW1AHEW',647987,8815,'Berniat membantu rekannya dengan meminjamkan KTP, nama Dimas Agung Prayitno justru dicatut untuk menyicil mobil mewah Rolls-Royce Phantom. Atas hal itu, Dimas pun kerap mendapatkan surat tagihan dari bank. Setelah ditelusuri di kantor pajak, Dimas tercatat telah menunggak pajak setahun, dengan nilai tunggakan nyaris Rp 200 juta.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #mobil #mobilmewah #rollroyce #tunggakan #bank #ktp #catutktp #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 19:10:22',5,0,0,0,'2019-11-22 13:31:38','2019-11-22 13:31:38'),(6,'kumparancom','https://instagram.com/p/B5IGVYnAmRD',647987,16540,'Presiden @jokowi mengenalkan 7 nama sebagai staf khusus kepresidenan yang baru di Istana Merdeka, Jakarta Pusat, Kamis (21/11). Dari 7 nama ini, staf khusus Jokowi didominasi oleh kalangan milenial.⁠\n-⁠\nMereka adalah pendiri Ruangguru Adamas Belva Syah Devara, CEO dan Founder CreativePreneur Putri Indahsari Tanjung, CEO PT Amartha Mikro Fintek Andi Taufan Garuda Putra, perumus Gerakan Sabang Merauke Ayu Kartika Dewi, putra asli Papua dan CEO Kitong Bisa Gracia Billy Mambrasar, penyandang disabilitas yang aktif di bidang sociopreneur Angkie Yudistia, dan mantan Ketua Umum PB PMII Aminudin Maruf.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 18:54:59',5,0,0,0,'2019-11-22 13:31:39','2019-11-22 13:31:39'),(7,'kumparancom','https://instagram.com/p/B5HsEcUAQJz',647987,11647,'Presiden @Jokowi akan segera mengumumkan stafsusnya hari ini, di antaranya dari kalangan milenial. Sekjen PPP, Arsul Sani, sebagai salah satu partai pengusung Jokowi, mengonfirmasi hal itu. Namun, Arsul belum mengetahui jumlah stafsus yang dibutuhkan Jokowi di periode kedua ini. Dia menyebut salah satu nama milenial yang akan jadi stafsus adalah anak konglomerat Chairul Tanjung, @putri_tanjung.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 15:10:38',3,0,0,0,'2019-11-22 13:31:39','2019-11-22 13:31:39'),(8,'kumparancom','https://instagram.com/p/B5Hkpt5DSpG',647987,8888,'Kopilot Wings Air Nicolaus Anjar Aji ditemukan tewas tergantung di kamar indekosnya di Kalideres, Jakarta Barat. Polisi menduga aksi bunuh diri ini terkait dengan pemecatan Nicolaus dari perusahaannya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #pilot #kopilot #bunuhdiri #wingsair #gantungdiri #kasus #polisi #meninggaldunia #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 14:00:40',3,0,0,0,'2019-11-22 13:31:39','2019-11-22 13:31:39'),(9,'viceind','https://instagram.com/p/B5HnxfQjRvs',338599,12012,'Noel kesal karena sering dikatain adiknya di Twitter. Udah lah, fans Oasis. Enggak usah banyak berharap mereka bakalan reunian. Kayaknya itu cuma mimpi. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Getty Images','2019-11-21 14:27:56',3,0,0,0,'2019-11-22 13:31:45','2019-11-22 13:31:45'),(10,'viceind','https://instagram.com/p/B5HXVRtA30t',338599,12076,'Menurut Menkes, praktik pengobatan alternatif itu bisa menarik turis-turis mancenagara yang suka \'back to nature\'. Hmm, sungguh pemikiran out of the box. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Sadewa Kristianto','2019-11-21 12:04:17',2,0,0,0,'2019-11-22 13:31:45','2019-11-22 13:31:45');
/*!40000 ALTER TABLE `tbl_crawling` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-22 20:37:39
