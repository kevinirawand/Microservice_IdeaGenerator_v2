# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.26)
# Database: db_sma2
# Generation Time: 2019-11-22 10:34:43 +0000
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
	(1,'abellyc','https://instagram.com/p/B31lmi6ANKC',816629,88945,'Awalnya berencana untuk pertemuan keluarga secara sederhana aja dan ternyata berujung dengan acara yang menurutku cukup meriah di rumah dengan percampuran modern dan tradisional adat Padang. Bikin kebaya aja dadakan ? Bener-bener bersyukur karena acara kemarin berjalan dengan lancar dan sangat berterima kasih untuk semua pihak yang udah bantu untuk acara spesial ini ?? Organized by @chandaniweddings Decoration by @roemahboengapadang Koordinator Adat by @ambunsuri_bandung Seserahan organized by @seserahan_id Photo & Video by @imagenic Catering @umaracatering Makeup & hair do by @giovanninathaliemua & @hairbygionina Ring by @linoandsons Engagement Cake by @bittersweet_by_najla MC by @torojazzou #BeyMyRay','2019-10-21 17:51:15',4,1,1,0,'2019-10-22 17:00:22','2019-11-22 17:13:33');

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
	(38,1,'engagement',0,'2019-11-22 15:11:41',NULL);

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
	(33,1,0,'Extra 2',0,'2019-11-22 17:13:33');

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
	(2,'jajatismail',2,2,'2019-11-22 14:51:35',NULL);

/*!40000 ALTER TABLE `tbl_targets` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_users`;

CREATE TABLE `tbl_users` (
  `id_user` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_engine` int(11) NOT NULL,
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

INSERT INTO `tbl_users` (`id_user`, `id_engine`, `username`, `name`, `user_type`, `active`, `password`, `token`, `created`, `updated`)
VALUES
	(1,0,'myjajat@gmail.com','Jajat Ismail',1,1,'827ccb0eea8a706c4c34a16891f84e7b','d66bed2ad538d3a3019d7f16523cb16fdad54fa903fd691cb929185ce9aed2f1','2019-10-02 16:41:51','2019-11-22 17:32:12'),
	(2,1,'admin1@email.com','Admin 1',2,1,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-10-16 18:24:59','2019-10-18 21:20:26'),
	(3,1,'user1@email.com','User 1',3,0,'827ccb0eea8a706c4c34a16891f84e7b',NULL,'2019-10-18 17:19:14','2019-10-24 19:00:01');

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
	(3,1,'POLITIK','2019-10-18 19:06:08','2019-11-20 19:50:09');

/*!40000 ALTER TABLE `tbl_users_targets` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
