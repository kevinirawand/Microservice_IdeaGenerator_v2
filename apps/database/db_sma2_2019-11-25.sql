# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.26)
# Database: db_sma2
# Generation Time: 2019-11-25 11:42:27 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table tbl_classifications
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_classifications`;

CREATE TABLE `tbl_classifications` (
  `id_normalization` int(11) NOT NULL,
  `id_label` int(11) NOT NULL,
  `id_crawling` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_normalization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_classifications` WRITE;
/*!40000 ALTER TABLE `tbl_classifications` DISABLE KEYS */;

INSERT INTO `tbl_classifications` (`id_normalization`, `id_label`, `id_crawling`, `created`, `updated`)
VALUES
	(20,6,1,'2019-11-22 16:55:15',NULL),
	(21,2,1,'2019-11-22 16:55:15',NULL),
	(22,3,1,'2019-11-22 16:55:15',NULL),
	(23,3,1,'2019-11-22 16:55:15',NULL),
	(24,6,1,'2019-11-22 16:55:15',NULL),
	(26,5,1,'2019-11-22 16:55:15',NULL);

/*!40000 ALTER TABLE `tbl_classifications` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_crawling
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_crawling`;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_crawling` WRITE;
/*!40000 ALTER TABLE `tbl_crawling` DISABLE KEYS */;

INSERT INTO `tbl_crawling` (`id_crawling`, `ig_username`, `url`, `follower_count`, `like_count`, `caption_text`, `taken_at`, `time_frame`, `is_extracted`, `is_normalized`, `is_classified`, `created`, `updated`)
VALUES
	(1,'abellyc','https://instagram.com/p/B31lmi6ANKC',816629,88945,'Awalnya berencana untuk pertemuan keluarga secara sederhana aja dan ternyata berujung dengan acara yang menurutku cukup meriah di rumah dengan percampuran modern dan tradisional adat Padang. Bikin kebaya aja dadakan ? Bener-bener bersyukur karena acara kemarin berjalan dengan lancar dan sangat berterima kasih untuk semua pihak yang udah bantu untuk acara spesial ini ?? Organized by @chandaniweddings Decoration by @roemahboengapadang Koordinator Adat by @ambunsuri_bandung Seserahan organized by @seserahan_id Photo & Video by @imagenic Catering @umaracatering Makeup & hair do by @giovanninathaliemua & @hairbygionina Ring by @linoandsons Engagement Cake by @bittersweet_by_najla MC by @torojazzou #BeyMyRay','2019-10-21 17:51:15',4,1,1,0,'2019-10-22 17:00:22','2019-11-22 17:13:33'),
	(2,'kaltaraprov','https://instagram.com/p/B5HQkQMIeCq',14106,240,'Mereka terdiri dari, Tenaga Kerja Asing (TKA) sebanyak 254 orang, orang asing yang memiliki Kartu Ijin Tinggal Sementara (KITAS) 295 orang, memiliki Kartu Ijin Tinggal Tetap (KITAP) 9 orang, dan kunjungan 1 orang. Selain itu, dilaporkan juga bahwa sepanjang Januari hingga November 2019, jumlah orang asing yang keluar-masuk Kaltara sebanyak 187 orang.\n_\nDiungkapkan Kepala Badan Kesbangpol Kaltara, Basiran, pengawasan orang asing ini melibatkan beberapa instansi. Seperti, TKA yang diawasi oleh satuan tugas (Satgas) TKA yang dibawahi Dinas Tenaga Kerja dan Transmigrasi (Disnakertrans). “Pemantauan orang asing didasarkan pada Permendagri No. 49/2010, tentang Pemantauan Orang Asing dan Organisasi Masyarakat Asing di Daerah, dan Permendagri No. 50/2010 untuk pengawasan TKA,” jelas Basiran yang ditemui di ruang kerjanya, kemarin (20/11).\n_\nBaca selengkapnya di humas.kaltaraprov.go.id','2019-11-21 11:05:09',2,0,0,0,'2019-11-22 13:31:19','2019-11-22 13:31:19'),
	(3,'humas_jabar','https://instagram.com/p/B5IKI2JBcwZ',88054,816,'Alhamdulillah Provinsi Jawa Barat (Jabar) mendapat penghargaan sebagai salah satu Provinsi Informatif di ajang Anugerah Keterbukaan Informasi Publik (KIP) 2019?\n.\nMenurut Kang @Ridwankamil tersebut menandakan bahwa Jawa Barat sebagai Provinsi yang taat pada aturan hukum?\n.\n\" Alhamdulillah, Jawa Barat mendapatkan anugerah salah satu provinsi yang paling informatif dalam keterbukaan informasi publik. Kategorinya informatif, menuju informatif, kurang informatif, dan tidak informatif\"\n- Gubernur Jabar, Ridwan Kamil\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas @kemensetneg.ri .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum','2019-11-21 19:28:13',5,0,0,0,'2019-11-22 13:31:26','2019-11-22 13:31:26'),
	(4,'kumparancom','https://instagram.com/p/B5IN577jahJ',647987,10571,'Ketua KPK Agus Rahardjo menjawab polemik diundangnya Ustaz Abdul Somad (UAS) ke kantornya pada Selasa (19/11). Ia mengaku, undangan terhadap UAS itu bukan dari KPK secara lembaga.⁠\n-⁠\nStaf yang mengundang UAS tersebut tergabung dalam organisasi kegiatan keagamaan internal, yaitu Badan Amal Islam KPK (BAIK). Agus menyampaikan, ia bahkan sudah mencegah BAIK untuk mengundang UAS. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #uas #ustaz #kpk #abdulsomad #tausiah #aguskpk #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 20:01:08',5,0,0,0,'2019-11-22 13:31:38','2019-11-22 13:31:38'),
	(5,'kumparancom','https://instagram.com/p/B5IHgW1AHEW',647987,8815,'Berniat membantu rekannya dengan meminjamkan KTP, nama Dimas Agung Prayitno justru dicatut untuk menyicil mobil mewah Rolls-Royce Phantom. Atas hal itu, Dimas pun kerap mendapatkan surat tagihan dari bank. Setelah ditelusuri di kantor pajak, Dimas tercatat telah menunggak pajak setahun, dengan nilai tunggakan nyaris Rp 200 juta.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #mobil #mobilmewah #rollroyce #tunggakan #bank #ktp #catutktp #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 19:10:22',5,0,0,0,'2019-11-22 13:31:38','2019-11-22 13:31:38'),
	(6,'kumparancom','https://instagram.com/p/B5IGVYnAmRD',647987,16540,'Presiden @jokowi mengenalkan 7 nama sebagai staf khusus kepresidenan yang baru di Istana Merdeka, Jakarta Pusat, Kamis (21/11). Dari 7 nama ini, staf khusus Jokowi didominasi oleh kalangan milenial.⁠\n-⁠\nMereka adalah pendiri Ruangguru Adamas Belva Syah Devara, CEO dan Founder CreativePreneur Putri Indahsari Tanjung, CEO PT Amartha Mikro Fintek Andi Taufan Garuda Putra, perumus Gerakan Sabang Merauke Ayu Kartika Dewi, putra asli Papua dan CEO Kitong Bisa Gracia Billy Mambrasar, penyandang disabilitas yang aktif di bidang sociopreneur Angkie Yudistia, dan mantan Ketua Umum PB PMII Aminudin Maruf.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 18:54:59',5,0,0,0,'2019-11-22 13:31:39','2019-11-22 13:31:39'),
	(7,'kumparancom','https://instagram.com/p/B5HsEcUAQJz',647987,11647,'Presiden @Jokowi akan segera mengumumkan stafsusnya hari ini, di antaranya dari kalangan milenial. Sekjen PPP, Arsul Sani, sebagai salah satu partai pengusung Jokowi, mengonfirmasi hal itu. Namun, Arsul belum mengetahui jumlah stafsus yang dibutuhkan Jokowi di periode kedua ini. Dia menyebut salah satu nama milenial yang akan jadi stafsus adalah anak konglomerat Chairul Tanjung, @putri_tanjung.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 15:10:38',3,1,1,0,'2019-11-22 13:31:39','2019-11-25 11:04:59'),
	(8,'kumparancom','https://instagram.com/p/B5Hkpt5DSpG',647987,8888,'Kopilot Wings Air Nicolaus Anjar Aji ditemukan tewas tergantung di kamar indekosnya di Kalideres, Jakarta Barat. Polisi menduga aksi bunuh diri ini terkait dengan pemecatan Nicolaus dari perusahaannya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #pilot #kopilot #bunuhdiri #wingsair #gantungdiri #kasus #polisi #meninggaldunia #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan','2019-11-21 14:00:40',3,0,0,0,'2019-11-22 13:31:39','2019-11-22 13:31:39'),
	(9,'viceind','https://instagram.com/p/B5HnxfQjRvs',338599,12012,'Noel kesal karena sering dikatain adiknya di Twitter. Udah lah, fans Oasis. Enggak usah banyak berharap mereka bakalan reunian. Kayaknya itu cuma mimpi. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Getty Images','2019-11-21 14:27:56',3,0,0,0,'2019-11-22 13:31:45','2019-11-22 13:31:45'),
	(10,'viceind','https://instagram.com/p/B5HXVRtA30t',338599,12076,'Menurut Menkes, praktik pengobatan alternatif itu bisa menarik turis-turis mancenagara yang suka \'back to nature\'. Hmm, sungguh pemikiran out of the box. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Sadewa Kristianto','2019-11-21 12:04:17',2,0,0,0,'2019-11-22 13:31:45','2019-11-22 13:31:45'),
	(11,'aniesbaswedan','https://instagram.com/p/B5Hu76KgNym',3873821,109501,'Alhamdulillah, Pemprov DKI Jakarta baru saja menerima kembali Penghargaan Keterbukaan Informasi Publik Tahun 2019 yang berdasarkan penilaian oleh Komisi Informasi Pusat Republik Indonesia.⁣\n⁣\nIni menunjukkan komitmen Pemprov DKI Jakarta untuk terus mendukung dan melaksanakan praktik open governance. yang di dalamnya ada komponen transparansi, keterbukaan. Sesuai yang diamanatkan dalam Undang-undang nomor 14/2008 tentang Keterbukaan Informasi Publik. ⁣\n⁣\nTapi yang lebih penting adalah bahwa komitmen Pemprov DKI Jakarta dalam hal keterbukaan informasi ini telah melampaui apa yang telah diarahkan oleh Undang-undang KIP itu sendiri. Kita memberikan akses informasi kepada publik terhadap berbagai aspek kegiatan, dari perencanaan hingga hasil kinerja Pemprov DKI Jakarta. ⁣\n⁣\nJadi kami merasa bersyukur sekali bahwa kategori yang kita dapat adalah ketegori yang tertinggi sebagai Badan Publik yang Informatif, dua tahun berturut-turut. Apresiasi atas kerja keras seluruh jajaran Pejabat Pengelola Informasi dan Dokumentasi (PPID) Dinas Komunikasi, Informatika dan Statistik Pemprov DKI Jakarta.⁣\n⁣\nBerkat mereka semua inovasi, semua karya, semua kolaborasi, yang dilakukan Pemprov DKI selama ini bisa diketahui publik dan kami bisa mengajak publik lebih banyak lagi untuk terlibat di dalam pembangunan di Jakarta. ⁣\n⁣\nKami bersyukur dan akan terus tingkatkan di masa yang akan datang.⁣\n⁣\nppid.jakarta.go.id','2019-11-21 15:30:32',3,0,0,0,'2019-11-22 13:31:09','2019-11-22 13:31:09');

/*!40000 ALTER TABLE `tbl_crawling` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_engines
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_engines`;

CREATE TABLE `tbl_engines` (
  `id_engine` int(11) NOT NULL AUTO_INCREMENT,
  `ig_username` varchar(50) NOT NULL,
  `ig_password` varchar(50) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_engine`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_engines` WRITE;
/*!40000 ALTER TABLE `tbl_engines` DISABLE KEYS */;

INSERT INTO `tbl_engines` (`id_engine`, `ig_username`, `ig_password`, `created`, `updated`)
VALUES
	(1,'jajatismail','1234567890','2019-10-15 17:03:17','2019-10-16 13:57:35'),
	(2,'testing','12345','2019-10-21 14:00:47','2019-10-21 14:03:04');

/*!40000 ALTER TABLE `tbl_engines` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_extractions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_extractions`;

CREATE TABLE `tbl_extractions` (
  `id_extraction` int(11) NOT NULL AUTO_INCREMENT,
  `id_crawling` int(11) NOT NULL,
  `keyword` varchar(50) NOT NULL,
  `is_normalize` tinyint(1) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_extraction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_extractions` WRITE;
/*!40000 ALTER TABLE `tbl_extractions` DISABLE KEYS */;

INSERT INTO `tbl_extractions` (`id_extraction`, `id_crawling`, `keyword`, `is_normalize`, `created`, `updated`)
VALUES
	(33,1,'pertemuan',0,'2019-11-22 15:11:41',NULL),
	(34,1,'keluarga',0,'2019-11-22 15:11:41',NULL),
	(35,1,'adat',0,'2019-11-22 15:11:41',NULL),
	(36,1,'padang',0,'2019-11-22 15:11:41',NULL),
	(37,1,'bersyukur',0,'2019-11-22 15:11:41',NULL),
	(38,1,'engagement',0,'2019-11-22 15:11:41',NULL),
	(39,7,'@jokowi',0,'2019-11-25 11:02:41',NULL),
	(40,7,'stafsusnya',0,'2019-11-25 11:02:41',NULL),
	(41,7,'arsul',0,'2019-11-25 11:02:41',NULL),
	(42,7,'sani',0,'2019-11-25 11:02:41',NULL),
	(43,7,'@putri_tanjung⁠',0,'2019-11-25 11:02:41',NULL);

/*!40000 ALTER TABLE `tbl_extractions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_labels
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_labels`;

CREATE TABLE `tbl_labels` (
  `id_label` int(11) NOT NULL AUTO_INCREMENT,
  `label_name` varchar(50) NOT NULL,
  `label_desc` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_label`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_labels` WRITE;
/*!40000 ALTER TABLE `tbl_labels` DISABLE KEYS */;

INSERT INTO `tbl_labels` (`id_label`, `label_name`, `label_desc`, `created`, `updated`)
VALUES
	(1,'Nilai Sosial','memiliki nilai di sosial masyarakat, orang berbagi karena merasa akan terlihat bagus','2019-10-29 17:16:39',NULL),
	(2,'Penghubung','menghubungkan pada hal lain, tip of mind, tip of tounge','2019-10-29 17:16:39',NULL),
	(3,'Sisi Emosional','ya udah sisi emosional aja','2019-10-29 17:16:39',NULL),
	(4,'Publik','orang atau orang orang yang mempengaruhi orang lain','2019-10-29 17:16:39',NULL),
	(5,'Tips','This is for Tips','2019-10-29 17:16:39',NULL),
	(6,'Cerita','This is For Story','2019-10-29 17:16:39',NULL);

/*!40000 ALTER TABLE `tbl_labels` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_normalizations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_normalizations`;

CREATE TABLE `tbl_normalizations` (
  `id_normalization` int(11) NOT NULL AUTO_INCREMENT,
  `id_crawling` int(11) NOT NULL,
  `id_extraction` int(11) NOT NULL,
  `normal_text` varchar(50) NOT NULL,
  `id_label` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_normalization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_normalizations` WRITE;
/*!40000 ALTER TABLE `tbl_normalizations` DISABLE KEYS */;

INSERT INTO `tbl_normalizations` (`id_normalization`, `id_crawling`, `id_extraction`, `normal_text`, `id_label`, `created`)
VALUES
	(28,1,33,'pertemuan',0,'2019-11-22 17:13:33'),
	(29,1,34,'keluarga',0,'2019-11-22 17:13:33'),
	(30,1,36,'Kota Padang',0,'2019-11-22 17:13:33'),
	(31,1,37,'bersyukur',0,'2019-11-22 17:13:33'),
	(32,1,38,'engagement',0,'2019-11-22 17:13:33'),
	(33,1,0,'Extra 2',0,'2019-11-22 17:13:33'),
	(34,7,39,'Jokowi',0,'2019-11-25 11:04:59'),
	(35,7,40,'Staf Khusus Presiden',0,'2019-11-25 11:04:59'),
	(36,7,41,'Arsul Sani',0,'2019-11-25 11:04:59'),
	(37,7,43,'Putri Tanjung',0,'2019-11-25 11:04:59');

/*!40000 ALTER TABLE `tbl_normalizations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_targets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_targets`;

CREATE TABLE `tbl_targets` (
  `id_target` int(11) NOT NULL AUTO_INCREMENT,
  `ig_username` varchar(50) NOT NULL,
  `id_admin` int(11) NOT NULL,
  `id_engine` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_target`),
  UNIQUE KEY `target_username` (`ig_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_targets` WRITE;
/*!40000 ALTER TABLE `tbl_targets` DISABLE KEYS */;

INSERT INTO `tbl_targets` (`id_target`, `ig_username`, `id_admin`, `id_engine`, `created`, `updated`)
VALUES
	(1,'ridwankamil',2,1,'2019-11-20 19:52:23','2019-11-22 13:58:49'),
	(2,'jajatismail',2,2,'2019-11-22 14:51:35',NULL),
	(3,'jokowi',5,1,'2019-11-25 10:28:01',NULL),
	(4,'detikcom',5,2,'2019-11-25 10:28:36',NULL);

/*!40000 ALTER TABLE `tbl_targets` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_users`;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_users` WRITE;
/*!40000 ALTER TABLE `tbl_users` DISABLE KEYS */;

INSERT INTO `tbl_users` (`id_user`, `username`, `name`, `user_type`, `active`, `password`, `token`, `created`, `updated`)
VALUES
	(1,'myjajat@gmail.com','Jajat Ismail',1,1,'827ccb0eea8a706c4c34a16891f84e7b','d66bed2ad538d3a3019d7f16523cb16fdad54fa903fd691cb929185ce9aed2f1','2019-10-02 16:41:51','2019-11-22 17:32:12'),
	(2,'admin1@email.com','Admin 1',2,1,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-10-16 18:24:59','2019-10-18 21:20:26'),
	(3,'user1@email.com','User 1',3,0,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-10-18 17:19:14','2019-10-24 19:00:01'),
	(4,'okyzaprabowo@gmail.com','Okyza Prabowo',3,1,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-11-25 10:15:01','2019-11-25 10:15:01'),
	(5,'admin2@email.com','Admin 2',2,1,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-11-25 10:27:38','2019-11-25 10:27:38');

/*!40000 ALTER TABLE `tbl_users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_users_targets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_users_targets`;

CREATE TABLE `tbl_users_targets` (
  `id_user` int(11) NOT NULL,
  `id_target` int(11) NOT NULL,
  `category` varchar(20) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`,`id_target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_users_targets` WRITE;
/*!40000 ALTER TABLE `tbl_users_targets` DISABLE KEYS */;

INSERT INTO `tbl_users_targets` (`id_user`, `id_target`, `category`, `created`, `updated`)
VALUES
	(3,1,'POLITIK','2019-10-18 19:06:08','2019-11-20 19:50:09'),
	(3,3,'POLITIK','2019-11-25 10:52:34','2019-11-25 10:52:34'),
	(4,1,'PUBLIC FIGURE','2019-11-25 10:51:13','2019-11-25 10:51:13'),
	(4,2,'PUBLIC FIGURE','2019-11-25 10:51:20','2019-11-25 10:51:20'),
	(4,4,'NEWS','2019-11-25 10:51:31','2019-11-25 10:51:31');

/*!40000 ALTER TABLE `tbl_users_targets` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
