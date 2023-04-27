-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 19, 2019 at 02:11 PM
-- Server version: 5.7.26
-- PHP Version: 7.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sma2`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `get_dashboard_a`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_dashboard_a` (IN `iid_user` INT, IN `icategory` VARCHAR(20), IN `idate_start` DATETIME)  READS SQL DATA
BEGIN
SELECT 
	tbl_users_targets.id_user, tbl_users_targets.id_target, tbl_users_targets.category,
    tbl_targets.ig_username,
    tbl_crawling.id_crawling, tbl_crawling.url, tbl_crawling.taken_at,
    tbl_normalizations.normal_text,
    tbl_labels.id_label, tbl_labels.label_name
FROM 
	tbl_users_targets
INNER JOIN
	tbl_targets ON tbl_targets.id_target = tbl_users_targets.id_target
RIGHT JOIN
	tbl_crawling ON tbl_crawling.ig_username = tbl_targets.ig_username
RIGHT JOIN
	tbl_normalizations ON tbl_normalizations.id_crawling = tbl_crawling.id_crawling
INNER JOIN
	tbl_classifications ON tbl_classifications.id_normalization = tbl_normalizations.id_normalization
INNER JOIN
	tbl_labels ON tbl_labels.id_label = tbl_classifications.id_label
WHERE
	tbl_users_targets.id_user = iid_user AND
    tbl_users_targets.category = icategory AND
    tbl_crawling.taken_at BETWEEN idate_start AND NOW();
END$$

DROP PROCEDURE IF EXISTS `p_scraping_summary_by_client`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_scraping_summary_by_client` (IN `iid_user` INT)  READS SQL DATA
BEGIN
DECLARE max_follower INT(11) DEFAULT f_get_max_follower(iid_user);
DECLARE max_post INT(11) DEFAULT f_get_max_post(iid_user);
DECLARE max_like DECIMAL(10,4) DEFAULT f_get_max_like(iid_user);
DECLARE max_response DECIMAL(10,4) DEFAULT f_get_max_response(iid_user);

SELECT
	tgrade.*,
    f_get_grade(total_score) AS grade
FROM (
    SELECT
        tscore.*,
        f_sum_score(score_follower, score_post, score_like, score_response) AS total_score
    FROM (
        SELECT 
            tavg.*,
            tbl_scraping.follower_count,
            (follower_count / max_follower) AS score_follower,
            (post_count / max_post) * 2 AS score_post,
            (like_avg / max_like) * 3 AS score_like,
            (response_avg / max_response) * 2 AS score_response
        FROM (
            SELECT
                ts.ig_username,
                ts.last_checked,
                ts.post_count,
                ts.like_count,
                ts.comment_count,
                ts.response_count,
                (ts.post_count / 334) AS post_avg,
                (ts.like_count / NULLIF(ts.post_count,0)) AS like_avg,
                (ts.response_count / NULLIF(ts.comment_count,0)) * 100 AS response_avg
            FROM (
                SELECT 
                    ig_username, 
                    COUNT(0) as post_count,
                    SUM(like_count) as like_count,
                    SUM(comment_count) as comment_count,
                    SUM(response_count) as response_count,
                    MAX(tbl_scraping.created) as last_checked
                FROM tbl_scraping
                JOIN tbl_targets USING (ig_username)
                JOIN tbl_users_targets USING (id_target)
                WHERE id_user = iid_user
                GROUP BY ig_username
            ) ts
        ) tavg
        JOIN tbl_scraping ON (
            tbl_scraping.ig_username = tavg.ig_username AND
            tbl_scraping.created = tavg.last_checked
        )
    ) tscore
) tgrade;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `f_get_grade`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `f_get_grade` (`iscore` DECIMAL(10,4)) RETURNS VARCHAR(1) CHARSET utf8 NO SQL
    DETERMINISTIC
RETURN (
    CASE 
    WHEN iscore > 60 THEN "A"
    WHEN iscore > 39 THEN "B"
    WHEN iscore > 10 THEN "C"
    ELSE "D"
    END
)$$

DROP FUNCTION IF EXISTS `f_get_max_follower`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `f_get_max_follower` (`iid_user` INT) RETURNS INT(11) READS SQL DATA
BEGIN
DECLARE max_follower INT(11);

SELECT MAX(follower_count) 
INTO max_follower
FROM v_scraping_summary
JOIN tbl_targets USING (ig_username)
JOIN tbl_users_targets USING (id_target)
WHERE id_user = iid_user;

RETURN max_follower;
END$$

DROP FUNCTION IF EXISTS `f_get_max_like`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `f_get_max_like` (`iid_user` INT) RETURNS DECIMAL(10,4) NO SQL
BEGIN
DECLARE max_like DECIMAL(10,4);

SELECT MAX(like_count / NULLIF(post_count,0)) 
INTO max_like
FROM v_scraping_summary
JOIN tbl_targets USING (ig_username)
JOIN tbl_users_targets USING (id_target)
WHERE id_user = iid_user;

RETURN max_like;
END$$

DROP FUNCTION IF EXISTS `f_get_max_post`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `f_get_max_post` (`iid_user` INT) RETURNS INT(11) NO SQL
BEGIN
DECLARE max_post INT(11);

SELECT MAX(post_count) 
INTO max_post
FROM v_scraping_summary
JOIN tbl_targets USING (ig_username)
JOIN tbl_users_targets USING (id_target)
WHERE id_user = iid_user;

RETURN max_post;
END$$

DROP FUNCTION IF EXISTS `f_get_max_response`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `f_get_max_response` (`iid_user` INT) RETURNS DECIMAL(10,4) NO SQL
BEGIN
DECLARE max_response DECIMAL(10,4);

SELECT MAX(response_count * 100 / NULLIF(comment_count,0)) 
INTO max_response
FROM v_scraping_summary
JOIN tbl_targets USING (ig_username)
JOIN tbl_users_targets USING (id_target)
WHERE id_user = iid_user;

RETURN max_response;
END$$

DROP FUNCTION IF EXISTS `f_sum_score`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `f_sum_score` (`ifollower` DECIMAL(10,4), `ipost` DECIMAL(10,4), `ilike` DECIMAL(10,5), `iresponse` DECIMAL(10,4)) RETURNS DECIMAL(10,4) NO SQL
    DETERMINISTIC
RETURN ((IFNULL(ifollower,0) + IFNULL(ipost,0) + IFNULL(ilike,0) + IFNULL(iresponse,0)) / 5.5) * 100$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_classifications`
--

DROP TABLE IF EXISTS `tbl_classifications`;
CREATE TABLE `tbl_classifications` (
  `id_normalization` int(11) NOT NULL,
  `id_label` int(11) NOT NULL,
  `id_crawling` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_classifications`
--

INSERT INTO `tbl_classifications` (`id_normalization`, `id_label`, `id_crawling`, `created`, `updated`) VALUES
(1, 2, 131, '2019-11-29 13:20:24', NULL),
(2, 2, 131, '2019-11-29 13:20:24', NULL),
(3, 2, 130, '2019-11-29 13:23:59', NULL),
(4, 5, 130, '2019-11-29 13:23:59', NULL),
(5, 2, 130, '2019-11-29 13:23:59', NULL),
(6, 2, 130, '2019-11-29 13:23:59', NULL),
(7, 2, 130, '2019-11-29 13:23:59', NULL),
(8, 2, 130, '2019-11-29 13:23:59', NULL),
(9, 5, 130, '2019-11-29 13:23:59', NULL),
(10, 6, 130, '2019-11-29 13:23:59', NULL),
(11, 1, 145, '2019-12-04 13:44:40', NULL),
(12, 2, 144, '2019-12-04 13:45:15', NULL),
(13, 1, 144, '2019-12-04 13:45:15', NULL),
(14, 2, 143, '2019-12-04 13:52:14', NULL),
(15, 3, 143, '2019-12-04 13:52:14', NULL),
(16, 1, 143, '2019-12-04 13:52:14', NULL),
(17, 2, 142, '2019-12-04 13:52:51', NULL),
(18, 1, 142, '2019-12-04 13:52:51', NULL),
(19, 4, 142, '2019-12-04 13:52:51', NULL),
(20, 4, 141, '2019-12-04 13:54:03', NULL),
(21, 2, 141, '2019-12-04 13:54:03', NULL),
(22, 1, 141, '2019-12-04 13:54:03', NULL),
(23, 1, 141, '2019-12-04 13:54:03', NULL),
(24, 1, 141, '2019-12-04 13:54:03', NULL),
(25, 1, 140, '2019-12-04 13:55:30', NULL),
(26, 2, 140, '2019-12-04 13:55:30', NULL),
(27, 4, 140, '2019-12-04 13:55:30', NULL),
(28, 4, 139, '2019-12-04 13:56:22', NULL),
(29, 1, 139, '2019-12-04 13:56:22', NULL),
(30, 4, 138, '2019-12-04 13:57:42', NULL),
(31, 4, 138, '2019-12-04 13:57:42', NULL),
(32, 2, 138, '2019-12-04 13:57:42', NULL),
(33, 2, 137, '2019-12-04 13:58:25', NULL),
(34, 1, 137, '2019-12-04 13:58:25', NULL),
(35, 1, 137, '2019-12-04 13:58:25', NULL),
(36, 2, 136, '2019-12-04 13:59:10', NULL),
(37, 1, 136, '2019-12-04 13:59:10', NULL),
(38, 3, 135, '2019-12-04 13:59:53', NULL),
(39, 2, 135, '2019-12-04 13:59:53', NULL),
(40, 1, 134, '2019-12-04 14:00:23', NULL),
(41, 2, 133, '2019-12-04 14:01:47', NULL),
(42, 4, 133, '2019-12-04 14:01:47', NULL),
(43, 4, 133, '2019-12-04 14:01:47', NULL),
(44, 4, 132, '2019-12-04 14:02:21', NULL),
(45, 4, 132, '2019-12-04 14:02:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_crawling`
--

DROP TABLE IF EXISTS `tbl_crawling`;
CREATE TABLE `tbl_crawling` (
  `id_crawling` int(11) NOT NULL,
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
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_crawling`
--

INSERT INTO `tbl_crawling` (`id_crawling`, `ig_username`, `url`, `follower_count`, `like_count`, `caption_text`, `taken_at`, `time_frame`, `is_extracted`, `is_normalized`, `is_classified`, `created`, `updated`) VALUES
(1, 'aniesbaswedan', 'https://instagram.com/p/B5XVKFmAsw-', 3888593, 100651, 'Menerima teman-teman pengemudi angkutan perkotaan (angkot) KWK Jakarta Utara di Pendopo Balaikota siang tadi.⁣\n⁣\nMereka datang menyampaikan aspirasi agar program Pemprov DKI untuk integrasi transportasi umum massal JakLingko diteruskan dan diperluas khususnya di Jakarta Utara.⁣\n⁣\nKami senang dengan kedatangan teman-teman hari ini, berarti program Jaklingko ini yang kita rancang untuk memfasilitasi kepentingan umum bisa menggunakan kendaraan umum dari mana saja yang terintegrasi itu sejalan dengan kepentingan pengemudi dan perusahaan, karena itu mereka ingin bergabung.⁣\n⁣\nOperator angkot merasa diuntungkan, publik juga diuntungkan, jadi ini merupakan contoh bagaimana integrasi bukan hanya aspek transportasinya tapi bisnis modelnya adalah bisnis model yang tidak merugikan bagi operator.⁣\n⁣\nKita berharap para operator bisa merawat kendaraan dengan baik, melakukan update kendaraan secara berkala, kualitas pelayanan baik karena mereka akan berada di dalam sistem JakLingko yang saling menguntungkan.⁣\n⁣\nKami senang dan mudah-mudahan harapan teman-teman bisa segera terlaksana, sebagian armada memang belum bisa bergabung di 2019 karena anggarannya belum cukup tapi insyaAllah di tahun 2020 semua bisa terlibat.⁣\n⁣\n#JakLingko⁣\n#integrasi⁣\n#transportasi⁣\n#KWK⁣\n#angkot', '2019-11-27 16:53:07', 4, 0, 0, 0, '2019-11-28 05:04:33', '2019-11-28 05:04:33'),
(2, 'aniesbaswedan', 'https://instagram.com/p/B5RVgVNgwb-', 3888593, 136556, 'Berjalan kaki di gang ini bisa menjadi lebih pintar. :)⁣\n⁣\nMural edukasi ini karya anak-anak muda di Pademangan Timur. Dengan dukungan Kelurahan mereka memperindah tembok-tembok Gang 22 dan Gang 33 di kawasan Jalan Pademangan 2 RT 13 RW 003, Jakarta Utara.⁣\n⁣\nMuralnya bukan sekadar gambar indah/ kata-kata mutiara, tapi materi ilmu pengetahuan dan pelajaran sekolah. Dihadirkan sebagai sarana edukasi bagi warga, khususnya pelajar SDN Pademangan Timur 01 yang sering melewati gang tersebut.⁣\n⁣\nWarga pun bisa menciptakan iklim pembelajaran menyenangkan, cinta ilmu pengetahuan.⁣\n⁣\nAda gang yang menarik seperti ini di lingkungan teman-teman? ⁣\n⁣\n#gangmuraledukasi⁣\n#muraljakarta⁣\n#DKIJakarta⁣\n#JakartaBerkolabo2asi', '2019-11-25 09:00:43', 2, 0, 0, 0, '2019-11-28 05:04:33', '2019-11-28 05:04:33'),
(3, 'aniesbaswedan', 'https://instagram.com/p/B5PphHCgcA-', 3888593, 90176, 'Semalam adalah babak baru, sebuah sejarah baru. Untuk pertama kalinya kita bisa memeriahkan Festival Deepavali dan diselenggarakan secara bersama di DKI Jakarta.⁣\n⁣\nIni menegaskan komitmen kami di Jakarta, bahwa Jakarta harus bisa menjadi tempat bagi semua. Rumah bagi semua dimana semua merasakan kesetaraan kesempatan.⁣\n⁣\nDan itu artinya dari seluruh aspek, kita harus fasilitasi. Termasuk bagi masyarakat Hindu, dan khususnya masyarakat Hindu keturunan India. Kita memastikan bahwa semua yang menjadi kebutuhan, apalagi terkait dengan kegiatan keagamaan, akan kita fasilitasi dan tuntaskan di Jakarta.⁣\n⁣\nTermasuk juga libur fakultatif, sejak 2017, kita sudah mengeluarkan Keputusan Gubernur untuk libur fakultatif Deepavali di Jakarta ini. Dan ini tentu menjadi harapan dari semua bahwa bukan hanya 2 Provinsi, Provinsi Bali dan Jakarta yang memberikan libur fakultatif. Mudah-mudahan akan bisa menjadi libur nasional di seluruh provinsi di Indonesia.⁣\n⁣\nApalagi kita menyadari bahwa Indonesia dan India adalah dua negara demokrasi terbesar di dunia. Dua-duanya menghormati prinsip-prinsip demokrasi. Dua-duanya mempraktikkan demokrasi. Dan dua-duanya menjadi rujukan bagi dunia.⁣\n⁣\nIni adalah dua negara yang memiliki sejarah yang jadi inspirasi bagi banyak kemerdekaan di berbagai belahan dunia. Perjuangan Indonesia, perjuangan India dan hari ini kita terhubungkan kembali lewat festival Deepavali.⁣\n⁣\nKebersamaan semalam adalah hasil kolaborasi antara Pemprov DKI Jakarta dengan Gema Sadhana dan Komunitas Hindu India. Dan kita merasakan bahwa kegiatan Deepavali kali ini melibatkan komunitas yang luar biasa. Apresiasi untuk semua pihak yang terlibat mewujudkannya.⁣\n⁣\nFestival Deepavali 23 November 2019 di Pasar Seni Ancol akan dicatat sebagai sejarah sebagai yang pertama kalinya di Jakarta. Kita ingin festival ini nantinya menjadi reguler dan lebih besar lagi. Kita sedang siapkan, nanti festival berikutnya di Pasar Baru yang akan menjadi Little India-nya Jakarta.⁣\n⁣\nKami ingin memfasilitasi komunitas yang selama ini ada di ibukota. Dan sekaligus menarik lebih banyak lagi orang datang ke Jakarta mendapatkan pengalaman yang unik berada di Jakarta.⁣\n⁣\n#Deepavali\n#FestivalDeepavali', '2019-11-24 17:17:06', 4, 0, 0, 0, '2019-11-28 05:04:33', '2019-11-28 05:04:33'),
(4, 'aniesbaswedan', 'https://instagram.com/p/B5MOQ87gh6p', 3888593, 88020, 'Melanjutkan jalan-jalan ke Jembatan Antar Kampung (JAK), pagi ini kita ke Koja, Jakarta Utara.⁣\n⁣\nJembatan Kerang Hijau ini menggantung di atas Kali Penghubung Bendungan Melayu. Menghubungkan antara RW 05 Kelurahan Tugu Selatan dan RW 01 Kelurahan Rawa Badak Selatan. Jembatan sepanjang 10 meter dengan lebar dua meter ini mengambil tema kerang hijau karena sesuai dengan karakteristik Jakarta Utara sebagai wilayah pesisir.⁣\n⁣\nJembatan ikonik ini dibangun Sudin Bina Marga Jakarta Utara atas permintaan warga untuk memperbaiki jembatan lama yang sudah tidak layak pakai.⁣\n⁣\nAda jembatan antar kampung yang sudah mengkhawatirkan kondisinya di dekatmu? Silakan laporkan ke kanal pengaduan CRM (Cepat Respon Masyarakat).⁣\n⁣\n#JembatanKerangHijau⁣\n#Koja⁣\n#BinaMargaDKI⁣\n#JembatanAntarKampung⁣\n#CRM', '2019-11-23 09:21:15', 2, 0, 0, 0, '2019-11-28 05:04:33', '2019-11-28 05:04:33'),
(5, 'aniesbaswedan', 'https://instagram.com/p/B5KDhmaggvy', 3888593, 80757, 'Terpukau memandang karya-karya foto mempesona ini. Lokasi sama, JPO sama, gedung sama. Yang dipandang sama, tapi dengan mata, pikiran dan hati yang berbeda-beda memunculkan sudut pandang yang beragam dan hasil fotonya pun beda-beda sekali.⁣\n⁣\nLihat saja karya-karya ini. Dan tentu terasa bahwa dari fotografer yang jernih itu memang mengalir karya yang memukau.⁣\n⁣\nSaat pikiran tak jernih, fotopun jadi suram, tiada keindahan. Karya pun nampak pucat, tanpa rasa, tanpa nuansa. Tapi, saat pikiran jernih, hati jernih, dan mata jernih maka foto pun seakan memancarkan keindahan. Foto memukau, tak henti dipandang.⁣\n⁣\nMemang keindahan sebuah foto itu adalah pancaran dari mata, hati dan pikiran fotografernya. Karya fotografi sesungguhnya adalah potret diri fotografernya. ⁣\n⁣\nIni bukan soal profesional atau amatir, bukan sekadar berpengalaman atau tak berpengalaman. Siapa pun bisa memotret. Pemula pun hasilnya bisa mempesona karena pada akhirnya, keindahan karya itu bukan cuma soal mata, tapi justru soal mata hati. ⁣\n⁣\nMari teruslah jadi pribadi-pribadi dengan pikiran jernih, mata jernih dan karya pun jadi memesona...', '2019-11-22 13:08:55', 3, 0, 0, 0, '2019-11-28 05:04:33', '2019-11-28 05:04:33'),
(6, 'aniesbaswedan', 'https://instagram.com/p/B5Hu76KgNym', 3888593, 119296, 'Alhamdulillah, Pemprov DKI Jakarta baru saja menerima kembali Penghargaan Keterbukaan Informasi Publik Tahun 2019 yang berdasarkan penilaian oleh Komisi Informasi Pusat Republik Indonesia.⁣\n⁣\nIni menunjukkan komitmen Pemprov DKI Jakarta untuk terus mendukung dan melaksanakan praktik open governance. yang di dalamnya ada komponen transparansi, keterbukaan. Sesuai yang diamanatkan dalam Undang-undang nomor 14/2008 tentang Keterbukaan Informasi Publik. ⁣\n⁣\nTapi yang lebih penting adalah bahwa komitmen Pemprov DKI Jakarta dalam hal keterbukaan informasi ini telah melampaui apa yang telah diarahkan oleh Undang-undang KIP itu sendiri. Kita memberikan akses informasi kepada publik terhadap berbagai aspek kegiatan, dari perencanaan hingga hasil kinerja Pemprov DKI Jakarta. ⁣\n⁣\nJadi kami merasa bersyukur sekali bahwa kategori yang kita dapat adalah ketegori yang tertinggi sebagai Badan Publik yang Informatif, dua tahun berturut-turut. Apresiasi atas kerja keras seluruh jajaran Pejabat Pengelola Informasi dan Dokumentasi (PPID) Dinas Komunikasi, Informatika dan Statistik Pemprov DKI Jakarta.⁣\n⁣\nBerkat mereka semua inovasi, semua karya, semua kolaborasi, yang dilakukan Pemprov DKI selama ini bisa diketahui publik dan kami bisa mengajak publik lebih banyak lagi untuk terlibat di dalam pembangunan di Jakarta. ⁣\n⁣\nKami bersyukur dan akan terus tingkatkan di masa yang akan datang.⁣\n⁣\nppid.jakarta.go.id', '2019-11-21 15:30:32', 3, 0, 0, 0, '2019-11-28 05:04:34', '2019-11-28 05:04:34'),
(7, 'aniesbaswedan', 'https://instagram.com/p/B5HYDgWgRw0', 3888593, 84455, 'Kali ini kita ke Jakarta Barat. Jembatan Krendang kini dipercantik oleh Suku Dinas Bina Marga Kota Administrasi Jakarta Barat.⁣\n⁣\nJembatan antar kampung (JAK) ini melintasi Kali Duri, Krendang Tambora Jakarta Barat, menghubungkan Kampung Krendang, khususnya RT.005 RW.07 dengan RPTRA Krendang.⁣\n⁣\nJembatan Krendang terlihat makin menarik pada malam hari sehingga jadi spot baru untuk warga berswafoto. Kita berharap jembatan ini tak hanya bermanfaat bagi warga tapi menjadi ruang ketiga yg menyatukan warga dari dua sisi kali. Kami titipkan pada teman-teman Kampung Krendang agar menjaga dan memelihara jembatan ini.⁣\n⁣\nApakah kamu tinggal di dekat Jembatan Krendang ini? Unggah fotomu, sertakan tagar #JembatanKrendang.⁣\n⁣\n#DinasBinaMargaDKI #pasukankuning #pelayananmasyarakat #kelurahankrendang #kominfotikjb #tambora #JembatanKrendang #jembatanantarkampung #DKIJakarta #WajahBaruJakarta', '2019-11-21 12:10:35', 2, 0, 0, 0, '2019-11-28 05:04:34', '2019-11-28 05:04:34'),
(8, 'humas.jateng', 'https://instagram.com/p/B5U5IF6FGDB', 11314, 371, '\"?????? ???? ???? ??? ????, ????? ????? ??????? ????? ??? ????? ???? ???? ????????????, ??????????? ????????? ??????? ??? ????? ???? ?????????? ?? ?????? ????????? ?? ???? ??????\"\n\nItu yang diungkapkan Gus @tajyasinmz saat bersama @najwashihab di @matanajwa On Stage Sabtu (23/11) lalu. Gus Yasin juga pamerkan sarung bermotif batik yang dikenakan adalah produk pesantren Jawa Tengah. ??\n———\n#HumasJateng #TajYasin #MataNajwaonStage #MataNajwaOnStageSemarang #MataNajwaMudaBerkuasa #Narasitv #NarasiNewsroom #Semarang #JatengGayeng #JawaTengah', '2019-11-26 18:09:42', 5, 0, 0, 0, '2019-11-28 05:04:39', '2019-11-28 05:04:39'),
(9, 'humas.jateng', 'https://instagram.com/p/B5Re1s0FiYc', 11314, 433, 'Selamat Hari Guru Nasional #SahabatHumas! ?\n\nKalian sudah baca pidato Peringatan Hari Guru Nasional dari Mas Menteri @kemdikbud.ri Nadiem Makarim?\n\nHanya 2 lembar, isinya langsung ke persoalan dan kalau dibacakan dalam upacara pasti cepat selesai, setidaknya itu komentar Pakdhe @ganjar_pranowo ?\n\nTadi pagi, setelah Upacara Peringatan #HariGuruNasional tingkat Jawa Tengah Padkhe juga punya pesan buat semua para guru, \"???? ????? ??????? & ???????? ????? ?????? ??????? ?? ???????!\" Gimana menurut kalian?\n———\n#HumasJateng #GanjarPranowo #HGN2019 #HariGuruNasional #SelamatHariGuru #HariGuruNasional2019 #MerdekaBelajar #GuruPenggerak #JatengGayeng #JawaTengah', '2019-11-25 10:22:17', 2, 0, 0, 0, '2019-11-28 05:04:39', '2019-11-28 05:04:39'),
(10, 'humasprovjatim', 'https://instagram.com/p/B5WhI1OA9Cz', 10415, 172, 'Gubernur Jawa Timur Khofifah Indar Parawansa melepas 119 atlet dan 29 pelatih  kontingan asal Jatim yang akan berlaga di Sea Games Manila 2019. Pelepasan atlet yang dilaksanakan di Hotel Sultan, Jakarta, Selasa malam (26/11) tersebut dihadiri Ketua DPD RI yang juga Ketua Dewan Penyantun KONI Jatim La Nyala Mataliti , Wakil Ketua Umum KONI Sarwono, Yuni Deputy Kemenpora dan Ketua KONI Jatim, Erlangga Satria Agung.\n.\nKesempatan tersebut dimanfaatkan Gubernur Khofifah sekaligus untuk memompa semangat seluruh atlet yang rencananya akan berangkat seluruhnya Kamis (28/11) menuju Manila, Filipina. \"Atlet Jawa Timur harus mampu mengibarkan bendera merah putih dan kumandangkan Indonesia  disana, raihlah emas sebanyak mungkin dan buatlah bangga Indonesia di mata dunia lewat prestasi kalian. Saya yakin Jawa Timur mampu,\" ungkap Khofifah. .\n.\n.\n#gubernurjatim #khofifah #atlet #atletjatim\n#seagames2019 #seagames #koni #olahraga', '2019-11-27 09:18:34', 2, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(11, 'humasprovjatim', 'https://instagram.com/p/B5T3sePAuFu', 10415, 167, 'Gubernur Jawa Timur Khofifah Indar Parawansa berhasil meraih dua penghargaan sekaligus dalam ajang Penghargaan Organisasi Masyarakat (Ormas) Tahun 2019 yang diselenggarakan oleh Kementerian Dalam Negeri RI di Hotel Kartika Candra Jakarta, Senin (25/11).\n.\nPenghargaan pertama diraih untuk kategori Pemerintah Provinsi Sebagai Pembina Ormas Terbaik. Bahkan Provinsi Jawa Timur merupakan satu- satunya provinsi yang mendapatkan anugerah penghargaan ini.  Sedangkan penghargaan kedua diterima Khofifah selaku Ketua Umum PP Muslimat NU untuk kategori Penghargaan Khusus Bakti Sepanjang Hidup (Long Life Achievement) untuk Muslimat NU.\n.\nPenghargaan tersebut diserahkan secara langsung oleh Menteri Dalam Negeri (Mendagri) Prof. H. Muhammad Tito Karnavian, Ph.D kepada Gubernur Jawa Timur Khofifah Indar Parawansa. Penghargaan kategori Pemerintah Provinsi Sebagai Pembina Ormas Terbaik diberikan karena Pemprov Jatim dianggap mampu dan berhasil membina ormas dengan baik. .\n.\nSecara keseluruhan, Jatim memiliki hampir 14.000 ormas, baik yang berbadan hukum maupun yang legalitasnya dengan surat keterangan terdaftar. Jumlah ormas yang besar ini mampu dikelola Pemprov Jatim. Jatim juga mampu melakukan pemberdayaan dan sinergitas ormas dengan baik. Ruang komunikasi dan koordinasi terjalin dengan lancar, dan ormas ditempatkan sebagai mitra pembangunan Provinsi Jatim.\n.\n.\n.\n#gubernurjatim #khofifah #penghargaan #ormas #penghargaanormas #muslimat #muslimatnu #mendagri #titokarnavian', '2019-11-26 08:37:57', 2, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(12, 'humasprovjatim', 'https://instagram.com/p/B5SSiU2AXMy', 10415, 219, 'Provinsi Jawa Timur menerima  penghargaan sebagai Provinsi Terbaik dalam dukungan pelaksanaan program Inovasi Desa Tahun 2019. Tidak hanya itu, Gubernur Jawa Timur, Khofifah Indar Parawansa pun memperoleh penghargaan atas dukungannya dalam pelaksanaan program inovasi desa besutan Kementerian Desa, Pembangunan Daerah Tertinggal, dan Transmigrasi.\n. .\nPenghargaan tersebut diserahkan Menteri Koordinator Bidang Pembangunan Manusia dan Kebudayaan, Muhadjir Effendy didampingi Menteri Desa dan PDTT, Abdul Halim Iskandar kepada Gubernur Khofifah di Merlyn Park Hotel, Jakarta, Senin (25/11).\n.\nKhofifah mengatakan, dana desa merupakan stimulus yang diberikan pemerintah untuk menggerakkan perekonomian masyarakat desa. Tentu saja, butuh inovasi dalam pemanfaatannya sehingga memiliki dampak yang besar bagi masyarakat. Besarnya dana yang ditransfer ke desa mampu menjadi pemicu sekaligus pemacu tumbuh dan berkembangnya seluruh potensi desa. .\n.\nUntuk itu mendorong masyarakat desa untuk turut mengawal setiap tahapan penggunaan dana desa yang digunakan dalam membangun infrastruktur, pengembangan ekonomi masyarakat, pendidikan, dan juga kesehatan. .\n.\n#gubernurjatim #khofifah #danadesa #inovasidesa #pembangunandesa #desa', '2019-11-25 17:54:01', 4, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(13, 'humasprovjatim', 'https://instagram.com/p/B5RG4zGAwYA', 10415, 167, 'Selamat Hari Guru Nasional Tahun 2019. Terimakasih atas pengabdian dan jasamu para guru. Tetaplah menjadi pelita bagi seluruh anak bangsa. Jasamu akan kami kenang selamanya ?\n.\n.\n#hariguru #hutpgri #hariguru2019 #selamathariguru #guru #pahlawantanpatandajasa', '2019-11-25 06:52:59', 1, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(14, 'humasprovjatim', 'https://instagram.com/p/B5P2F9nAOV0', 10415, 151, 'Dalam Peringatan Hari Guru Tahun 2019 dan HUT Ke-74 Persatuan Guru Republik Indonesia (PGRI)  Tingkat Jawa Timur yang diselenggarakan di JX International Surabaya, pagi ini, Gubernur @khofifah.ip menekankan pentingnya peranan guru dalam mewujudkan SDM  Unggul menuju Indonesia Maju 2045. Untuk mencapai masa depan Indonesia yang cerah perlu didukung peran guru yang ikut meningkatkan kualitas sumber daya manusia. Ini senada dengan tema peringatan Hari Guru Nasional Tahun 2019 dan HUT Ke-74 PGRI Tingkat Jatim yaitu “Peran Strategis Guru Dalam Mewujudkan Sumber Daya Manusia Indonesia Unggul”.\n.\n.\nDalam kesempatan ini Gubernur Khofifah juga menerima penghargaan dari Ketua  PGRI atas kepeduliannya terhadap peningkatan mutu pendidikan di Jawa Timur. Penghargaan tersebut diraihnya dengan berbagai langkah yang dilakukan untuk meningkatkan kualitas pendidikan di Jatim. .\n.\n.\n#gubernurjatim #khofifah #hariguru #hutpgri #hariguru2019 #selamathariguru #guru #pahlawantanpatandajasa', '2019-11-24 19:07:00', 5, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(15, 'humasprovjatim', 'https://instagram.com/p/B5PoUbwgS-V', 10415, 281, 'Ketua Dewan Kerajinan Nasional Daerah (Dekranasda) Jatim Arumi Emil Elestianto Dardak mengapresiasi penyelenggaraan Mojobatik Festival 2019 yang diselenggarakan di Alun-Alun Mojokerto, Sabtu (23/11) malam. Arumi berharap, acara yang diselenggarakan oleh Pemkot Mojokerto itu dapat semakin menumbuhkan rasa cinta dan sayang terhadap batik khas Kota Mojokerto. Apalagi kegiatan tersebut menampilkan berbagai kreativitas dan inovasi para perajin dan desainer batik.\n.\n.\nMenurutnya, keberadaan batik saat ini telah diakui sebagai warisan budaya asli bangsa Indonesia. Karena itu, sudah menjadi kewajiban bagi warga negara Indonesia untuk senantiasa mencintai dan menjaga warisan leluhur untuk terus dikembangkan dan dilestarikan. Melalui event Mojobatik Festival 2019, Arumi berharap agar event tersebut bisa menjadi sarana yang tepat untuk mengenalkan batik khas Kota Mojokerto kepada masyarakat luas. .\n.\n.\n#mojobatik #arumibachsin #dekranasda\r#dekranasdajatim\n#batik #batikjatim', '2019-11-24 17:06:38', 4, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(16, 'humasprovjatim', 'https://instagram.com/p/B5O3f9cALh9', 10415, 156, 'Membangun karakter bangsa adalah sebuah keniscayaan dan kebutuhan. Karakter bangsa akan terbangun melalui bangunan karakter pribadi  warga bangsanya. Kedudukan tinggi seseorang tidak akan berarti apapun jika tidak memilki karakter atau akhlak. Maka proses menjaga dan  menyempurnakan akhlak harus terus diikhtiarkan. .\n.\nPesan tersebut disampaikan Gubernur Jawa Timur Khofifah Indar Parawansa saat membuka Emotional Spiritual Quotient (ESQ) New Chapter Character Building Tingkat I di Empire Palace Jl. Blauran Genteng Surabaya, Sabtu (23/11) pagi.\n.\nMenurutnya, mengenali jati diri, lingkungan  serta mengenali sang pencipta dengan berbagai kebesaran ciptaanNya adalah salah satu cara untuk membangun karakter dalam diri seseorang sehingga menjadi insan yang pandai mensyukuri nikmat Allah yang maha  menciptakan kehidupan. Mengenali diri sendiri juga akan membuat seseorang lebih menghargai orang lain dan jauh dari keangkuhan dan kesombongan.\n.\n.\n.\n#gubernurjatim #khofifah #karakterbangsa #jatidiri #trainingesq #esq', '2019-11-24 10:00:02', 2, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(17, 'humasprovjatim', 'https://instagram.com/p/B5MOZ27A96S', 10415, 150, 'Gubernur Jawa Timur Khofifah Indar Parawansa meminta kepada bupati/walikota dalam menggunakan Daftar Isian Pelaksanaan Anggaran (DIPA) harus bisa tersampaikan kepada penerima manfaat. Ia meminta seluruh pihak tak hanya melakukan \'sent\' program tapi juga memastikan program \'delivered\' pada masyarakat. Seperti beberapa kali disampaikan oleh Presiden.\n.\nPesan itu disampaikannya saat membuka Rapat Koordinasi Provinsi Jawa Timur Tahun 2019 Sinergi Pemerintah Pusat dan Daerah Dalam Rangka Mensukseskan Lima Prioritas Pembangunan Nasional Untuk Mewujudkan Indonesia Maju dan Penyerahan DIPA Tahun Anggaran (TA) 2020 di Convex Grand City Surabaya, Jumat (22/11). .\n.\nMenurutnya penyerahan DIPA kepada bupati/walikota ini juga disertai transfer alokasi dana yang harus sampai ke desa,  total DAK dan alokasi dana transfer daerah dan desa se Jatim  jumlahnya mencapai  Rp. 79,31 triliun. Penyerahan DIPA ini diberikan guna menjalankan program prioritas pembangunan nasional 2019-2024 untuk mewujudkan Indonesia Maju  pada tahun 2045. .\n.\n.\n#gubernurjatim #khofifah #dipa #anggaran', '2019-11-23 09:22:28', 2, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(18, 'humasprovjatim', 'https://instagram.com/p/B5JgBM2g6E6', 10415, 257, 'Ketua Forum Peningkatan Konsumsi Ikan Nasional (Forikan) Jawa Timur, Arumi Emil Elestianto Dardak mendorong seluruh pihak, untuk membangun mentalitas rutin makan ikan di tengah-tengah masyarakat. Tujuannya agar tingkat konsumsi ikan di Jatim kian meningkat, sehingga kebutuhan gizi masyarakat, khususnya anak-anak terpenuhi.\n.\nMentalitas rutin konsumsi ikan ini harus terus dibangun, sebab ikan memiliki nilai gizi yang tinggi. Selain itu, kita tinggal di negara maritim, dimana wilayah lautannya lebih besar daripada daratan. Dengan demikian, potensi ikan kita sudah pasti sangat banyak, baik ikan laut, maupun ikan tawar. Hal itu disampaikannya saat membuka puncak Hari Ikan Nasional (Harkannas) ke-6 Tahun 2019 di Dyandra Expo Surabaya, Kamis (21/11).\n.\n.\n.\n#arumibachsin\n#forikan #forikanjatim #gemarikan #ayomakanikan', '2019-11-22 07:58:40', 1, 0, 0, 0, '2019-11-28 05:04:43', '2019-11-28 05:04:43'),
(19, 'humas_jabar', 'https://instagram.com/p/B5Xw72-Bk3V', 88728, 476, 'Pertemuan tersebut membahas sejumlah peluang kerja sama dari kedua belah pihak?\n.\nTerlebih, Pemda Provinsi Jawa Barat dan Souss Massa Region sudah membuat kesepakatan Sister City pada November 2017 lalu?\n.\nPada kesempatan tersebut, Kang @Ridwankamil menawarkan sejumlah produk unggulan Jabar. Mulai dari kopi, teh, kriya, sampai perikanan. Nah, selain itu Kang Emil juga membuka peluang kerja sama di bidang ekonomi, seperti UMKM dan investasi?\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas Jabar by @wdudi75 .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #KerjaSamaLN', '2019-11-27 20:55:51', 5, 0, 0, 0, '2019-11-28 05:04:49', '2019-11-28 05:04:49'),
(20, 'humas_jabar', 'https://instagram.com/p/B5Xf41Rhd4t', 88728, 419, 'Nantinya PT Pertamina (Persero) bakal mengintegrasikan kilang dan membangun pabrik yang memproduksi sejumlah produk petrokimia turunan ya di Kabupaten Indramayu?\n.\nKang @Ridwankamil mengatakan tugas Pemerintah Daerah Provinsi Jawa Barat dalam berinvestasi tersebut adalah mengamankan tata ruang dan menunjuk lokasi?\n.\nKarena, lahan yang digunakan lebih dari 200 hektare akan didorong untuk dijadikan Kawasan Ekonomi Khusus (KEK)\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas Jabar by @sleepybro_ .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum', '2019-11-27 18:26:53', 5, 0, 0, 0, '2019-11-28 05:04:49', '2019-11-28 05:04:49'),
(21, 'humas_jabar', 'https://instagram.com/p/B5W_WEFhtsi', 88728, 544, 'Wilujeng siang wargi Jabar sadayana ?\n.\nSaatos tuang sareng rerencangan di kantor atanapi di sakola, raos upami ngaemutan deui kecap sesebutan sipat jalma ?\n.\nDinten ieu, #Kangmin sareng Tim Humas Jabar bade masihan sababaraha kecap sesebutan, hayu diajar sasarengan wargi?\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nInfografis by @gunturrofika .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #Rebonyunda', '2019-11-27 13:42:31', 3, 0, 0, 0, '2019-11-28 05:04:49', '2019-11-28 05:04:49'),
(22, 'humas_jabar', 'https://instagram.com/p/B5WXTt-h1qz', 88728, 436, '“Tandur”merupakan istilah dalam pertanian masyarakat tanah Sunda yaitu singkatan dari bahasa sunda “Tanam Mundur”(Tandur)?\n.\nCara menanam padi ini dilakukan dengan membungkuk mundur, oleh karena itu munculah sebutan kata tandur wargi?\n.\nBenih padi ditanam di antara pertemuan garis lurus yang memanjang dan memotong pada satu petak sawah, sehingga terlihat rapi?\n.\nAda ga nih wargi Jabar yang pagi ini sedang \"tandur\" di desa tercintanya ? .\n.\n#JabarKita #JabarJuaraLahirBatin\nDokumentasi by @tembangsunda taken at Cisalak, Subang, Jawa Barat.\n. .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #DesaWisataJabar', '2019-11-27 07:52:40', 1, 0, 0, 0, '2019-11-28 05:04:49', '2019-11-28 05:04:49'),
(23, 'humas_jabar', 'https://instagram.com/p/B5UoLach7i7', 88728, 564, 'Melalui Musyawarah Nasional (Munas) ke-VI Asosiasi Pemerintah Provinsi Seluruh Indonesia (APPSI) di Jakarta, Menteri Dalam Negeri (Mendagri) Republik Indonesia (RI) Tito Karnavian mendorong gubernur untuk berimprovisasi dalam meningkatkan Pendapatan Asli Daerah (PAD).\n.\nKang @Ridwankamil  getol menawarkan berbagai proyek strategis di provinsi dengan jumlah penduduk terbesar se-Tanah Air ini melalui forum investasi, antara lain West Java Investment Summit (WJIS) 2019 dan US-Indonesia Investment Summit.\n.\nPemda Provinsi Jawa Barat pun memiliki konsep delapan pintu anggaran dalam membangun Jabar. Selain APBD, pembangunan provinsi dengan jumlah penduduk terbesar se-Tanah Air ini bersumber dari dana umat hingga Corporate Social Responsibility (CSR).\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas Jabar by @tatang.tarsiman .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum', '2019-11-26 15:41:36', 3, 0, 0, 0, '2019-11-28 05:04:49', '2019-11-28 05:04:49'),
(24, 'humas_jabar', 'https://instagram.com/p/B5Ts4_JB43F', 88728, 605, 'Selamat pagi Selasa, selalu berjuang tanpa putus asa ?\n.\nBegitupun dengan segenap jajaran @Infobijb yang sudah 5 tahun membangun dan mengelola Bandara kebanggaan Jawa Barat ?\n.\nKemarin, 25 November 2019 PT BIJB (Perseroda) berulang tahun yang ke-5 lhoo wargi ?\n.\nApanih harapan dan doa wargi untuk Bandara Kertajati ini ?\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDokumentasi from @infobijb .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #bijbkertajati #BangunJabar', '2019-11-26 07:03:32', 1, 0, 0, 0, '2019-11-28 05:04:51', '2019-11-28 05:04:51'),
(25, 'humas_jabar', 'https://instagram.com/p/B5SOIydBAwu', 88728, 425, '\"Guru Indonesia yang tercinta, tugas anda adalah yang termulia sekaligus yang tersulit\"\n.\nSalah satu petikan isi pidato dari Menteri Pendidikan dan Kebudayaan (Mendikbud) RI Nadiem Makarim dalam momentum Hari Guru Nasional Tahun 2019?\n.\nMenurut Kang @Ridwankamil arahan Mendikbud berkaitan dengan perubahan metode pembelajaran di sekolah?\n.\n\"Pak Menteri mengajak guru untuk membuat situasi belajar itu menjadi menyenangkan. Tidak hanya urusan menghafal, tapi juga bakti sosial, berpetualang, mengasah keterampilan, dan murid disuruh berani menyampaikan gagasan\"\n- Ridwan Kamil, Gubernur Jawa Barat.\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas Jabar by @tatang.tarsiman .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #HariGuruNasional2019', '2019-11-25 17:15:34', 4, 0, 0, 0, '2019-11-28 05:04:51', '2019-11-28 05:04:51'),
(26, 'humas_jabar', 'https://instagram.com/p/B5Ouk3shPt1', 88728, 559, 'Selamat berakhir pekan wargi Jabar ?\n.\nBobotoh yang hari ini nyetadion cuuung ☝️\n.\nJangan lupa untuk senantiasa menjaga fasilitas Stadion Si Jalak Harupat ya wargi ?\n.\nSemoga hari ini @Persib_official bisa meraih tiga point atas @psbaritoputeraofficial yaa?\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nFoto keren ini diabadikan oleh kang @randi_suryanagara .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #Persibday', '2019-11-24 08:42:04', 2, 0, 0, 0, '2019-11-28 05:04:51', '2019-11-28 05:04:51'),
(27, 'humas_jabar', 'https://instagram.com/p/B5NiGwqBD01', 88728, 478, 'Bekerja sama dengan Bank Indonesia, Pemerintah Daerah Provinsi Jawa Barat membuat Pilot Project Pusat Distribusi Provinsi (P3DP) Jawa Barat?\n.\nP3DP digagas untuk menjaga inflasi dan stabilitas harga bahan kebutuhan pokok masyarakat?\n.\n\"Kami tambahkan pusat distribusi bekerja sama dengan Bank Indonesia, supaya kita bisa menjaga inflasi. Karena kalau sudah inflasi, yang mahal harga dapur\"\n- @Ridwankamil Gubernur Jawa Barat. .\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas Jabar by @yanaimisiana .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum', '2019-11-23 21:33:51', 5, 0, 0, 0, '2019-11-28 05:04:51', '2019-11-28 05:04:51'),
(28, 'humas_jabar', 'https://instagram.com/p/B5MABW4Bcbh', 88728, 406, 'Selamat pagi Wargi Jabar?\n.\nTadi malam ada acara keren lho di Kabupaten Bandung Barat, ada yang datang langsung kesana gak nih ? Yap acara Festival Film Bandung (FFB) 2019?\n.\nFFB ini digelar sebagai bentuk komitmen dari Pemda Provinsi Jawa Barat dalam mendukung perkembangan industri kreatif dan film nasional?\n.\nKang @Ridwankamil berharap kualitas perfilman nasional yang konsisten bisa membawa film-film Indonesia semakin berjaya di masa depan?\n.\n\"Kita juga ingin film ini menjadi industri kreatif, menambah visi Jawa Barat sebagai provinsi pariwisata juga provinsi ekonomi kreatif\"\n- Ridwan Kamil, Gubernur Jawa Barat.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas Jabar by @yanaimisiana .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #FestivalFilmBandung', '2019-11-23 07:16:47', 1, 0, 0, 0, '2019-11-28 05:04:52', '2019-11-28 05:04:52'),
(29, 'humas_jabar', 'https://instagram.com/p/B5KZzGjhP-_', 88728, 1067, 'Wilujeng sonten, wilujeng leleson wargi Jabar?\n.\nKemarin, Presiden RI @Jokowi telah mengumumkan 7 Staff Khusus Presiden periode 2019-2024 lho wargi ?\n.\nKetujuh staff khusus tersebut merupakan anak muda Indonesia yang berbakat, keren dan tentunya menginspirasi dong?\n.\nKuy wargi Jabar, kita sama-sama bersinergi bersama mereka untuk memberikan gagasan segar yang inovatif demi mewujudkan visi misi Presiden dan Wakil Presiden RI Periode 2019-2024 dalam menjadikan negara kita Maju dan SDM Unggul?\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nInfografis by @kemensetneg.ri .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum #Jokowi #Marufamin #Staffkhususpresiden', '2019-11-22 16:23:33', 4, 0, 0, 0, '2019-11-28 05:04:53', '2019-11-28 05:04:53'),
(30, 'humas_jabar', 'https://instagram.com/p/B5IKI2JBcwZ', 88728, 872, 'Alhamdulillah Provinsi Jawa Barat (Jabar) mendapat penghargaan sebagai salah satu Provinsi Informatif di ajang Anugerah Keterbukaan Informasi Publik (KIP) 2019?\n.\nMenurut Kang @Ridwankamil tersebut menandakan bahwa Jawa Barat sebagai Provinsi yang taat pada aturan hukum?\n.\n\" Alhamdulillah, Jawa Barat mendapatkan anugerah salah satu provinsi yang paling informatif dalam keterbukaan informasi publik. Kategorinya informatif, menuju informatif, kurang informatif, dan tidak informatif\"\n- Gubernur Jabar, Ridwan Kamil\n.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas @kemensetneg.ri .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava #Ridwankamil #Uuruzhanululum', '2019-11-21 19:28:13', 5, 0, 0, 0, '2019-11-28 05:04:53', '2019-11-28 05:04:53'),
(31, 'jokowi', 'https://instagram.com/p/B5RtKzLBca9', 26786079, 522679, 'Dunia berkembang dan berubah cepat, teknologi kian mutakhir. Dan di tengah perubahan itu, para guru dituntut untuk tidak sekadar mengajar, tetapi juga mendidik dengan lebih fleksibel, kreatif, menarik, dan lebih menyenangkan.\n\nGuru tidak akan pernah tergantikan oleh mesin secanggih apa pun. Guru membentuk karakter anak bangsa dengan budi pekerti, toleransi, dan nilai-nilai kebaikan. Guru menumbuhkan empati sosial pada diri anak didik, membangun imajinasi dan kreativitas, serta mengokohkan semangat persatuan dan kesatuan bangsa.\n\nGuru adalah penggerak Indonesia Maju.', '2019-11-25 12:27:29', 2, 0, 0, 0, '2019-11-28 05:04:58', '2019-11-28 05:04:58'),
(32, 'jokowi', 'https://instagram.com/p/B5P00e6hd15', 26786079, 886462, 'Desa Gamcheon tadinya adalah kampung yang kumuh di Busan, Korea Selatan. Sudah kumuh, lokasinya pun sulit: di lereng gunung yang curam. Sampai kemudian desa ini berbenah, ditata, diberdayakan.\n\nJadilah Gamcheon Culture Village sebagai salah satu tujuan wisata yang ramai, bahkan dikenal dengan sebutan “Machu Picchu-nya Busan”. Mengisi hari Minggu di Busan, saya mengunjungi desa budaya Gamcheon selepas siang tadi. Luar biasa. Rumah-rumah yang dicat berwarna-warni, dinding-dindingnya dihiasi beragam karya seni seperti mural. Jalan-jalan dan lorongnya yang sempit dipenuhi toko cenderamata, galeri seni, dan tempat makan.\n\nDari sebuah kafe di ketinggian, saya dan Ibu Negara menikmati pemandangan atap-atap bangunan yang seolah bertumpuk seraya menikmati makanan khas Korea Selatan.\n\nPenataan Desa Gamcheon mengingatkan saya model serupa di Tanah Air seperti yang ada di Klaten, Yogyakarta, atau di Nglanggeran, Gunung Kidul. Gamcheon bisa menjadi inspirasi bagi kepala daerah kita, bagi kampung-kampung kita, bagi desa-desa kita, bahwa yang kumuh pun kalau ditata dengan baik, bisa meningkatkan ekonomi masyarakat.', '2019-11-24 18:55:52', 5, 0, 0, 0, '2019-11-28 05:04:58', '2019-11-28 05:04:58'),
(33, 'jokowi', 'https://instagram.com/p/B5O-MbPBEa2', 26786079, 635923, 'Temukan saya dalam gambar ini. Ada jurnalis, juru kamera, dan yang terbanyak adalah orang-orang yang tengah mengacungkan sehelai kertas. Kertas itu adalah lembar-lembar sertifikat hak milik atas sebidang tanah yang penerbitannya kita percepat semenjak tiga tahun terakhir.\n\nSaya ingat, pada akhir 2014 lalu saya mendapat laporan bahwa ada 126 juta bidang tanah di seluruh Tanah Air yang belum bersertifikat. Dari jumlah tersebut, baru 46 juta bidang yang diselesaikan.\n\nSementara, setiap tahun badan pertanahan hanya bisa menerbitkan 500 ribu sertifikat. Saya pernah merasakan jadi rakyat biasa, tahu betapa sulit dan berbelitnya mengurus sertifikat hak atas tanah. Kalau masih terus begitu, butuh 160 tahun lagi untuk menyelesaikan semua sertifikat lahan di Indonesia ini.\n\nAlhamdulillah, sejak tahun 2017, pendaftaran bidang tanah di Indonesia meningkat lebih sepuluh kali lipat. Dari lima juta lembar sertifikat tahun 2017, naik jadi sembilan juta tahun 2018, dan sampai November 2019 ini sudah 8,5 juta. Saya sendiri kerap menyerahkan langsung sertifikat tanah itu di setiap kunjungan ke daerah.', '2019-11-24 10:58:32', 2, 0, 0, 0, '2019-11-28 05:04:58', '2019-11-28 05:04:58'),
(34, 'jokowi', 'https://instagram.com/p/B5MuUFZB47A', 26786079, 677330, 'Bertolak menuju Busan, Korea Selatan, siang ini, untuk kunjungan selama tiga hari.\n\nDi Busan, saya menghadiri rangkaian acara Konferensi Tingkat Tinggi (KTT) ASEAN-RoK, juga mengadakan pertemuan bilateral dengan Presiden Moon Jae-in, dan bertemu beberapa pemimpin perusahaan Korea Selatan.\n\nSelain itu, saya juga akan menemui kelompok ilmuwan dan peneliti muda Indonesia di negara itu.\n\nSelamat berakhir pekan.', '2019-11-23 14:01:18', 3, 0, 0, 0, '2019-11-28 05:04:58', '2019-11-28 05:04:58'),
(35, 'jokowi', 'https://instagram.com/p/B5KyPHbBxOW', 26786079, 559704, 'Indonesia sebagai negara kepulauan terbesar di dunia, harus menjadi sebuah kekuatan regional yang baik dan disegani. Salah satunya ya dengan memperkuat alat utama sistem persenjataan (alutsista), yang modern, sejalan dengan perkembangan teknologi, sekaligus memperkuat industri pertahanan di dalam negeri.\n\nItulah yang saya tegaskan dalam rapat terbatas mengenai kebijakan pengadaan alutsista di Jakarta hari ini.\n\nSaya meminta jajaran terkait membuat rencana dan peta jalan yang jelas mengenai pengembangan industri alat pertahanan di dalam negeri. Peta jalan itu harus dapat menghubungkan industri alat pertahanan dari hulu ke hilir dan melibatkan BUMN dan pihak swasta. Dengan begitu, kita bisa mengurangi ketergantungan pada impor alutsista.\n\nSelain itu, pengadaan alutsista  jangan lagi berorientasi pada penyerapan anggaran, apalagi sekadar proyek. Kita hentikan cara-cara seperti itu.\n\nKalau pun ada impor alutsista dan kerja sama pertahanan dengan negara lain, saya minta kepastian alih teknologi kepada bangsa Indonesia.\n\nKarena itulah, kita tidak akan membeli alutsista yang teknologinya sudah usang.', '2019-11-22 19:57:05', 5, 0, 0, 0, '2019-11-28 05:04:58', '2019-11-28 05:04:58'),
(36, 'jokowi', 'https://instagram.com/p/B5IQPLNB1oF', 26786079, 591909, 'Tujuh anak muda  ini adalah jembatan saya ke anak-anak muda, para santri, para diaspora yang tersebar di berbagai tempat untuk bersama-sama membangun bangsa ini. Sebagai staf khusus presiden, mereka akan jadi teman diskusi saya setiap bulan, setiap minggu, atau setiap hari.\n\nBersama mereka, saya bisa mencari cara yang out of the box, yang melompat, mengejar kemajuan.', '2019-11-21 20:21:31', 5, 0, 0, 0, '2019-11-28 05:04:59', '2019-11-28 05:04:59'),
(37, 'kaltaraprov', 'https://instagram.com/p/B5Rs49Wjx5X', 14282, 404, 'Sesuai jadwal, tahap pendaftaran online dan penyerahan berkas persyaratan seleksi CPNS di lingkup Pemprov Kaltara Tahun 2019 akan ditutup pada 28 November 2019 mendatang. Meski demikian, jadwal tersebut masih tentatif dan bisa berubah. Tergantung keputusan dari Badan Kepagawaian Nasional (BKN)-selaku Panitia Seleksi Nasional (Penselnas) penerimanaan CPNS. .\nMelihat waktu yang kian mepet, Kepala @bkdkaltara Burhanuddin melalui Kepala Bidang Pengembangan dan Perencanaan Pegawai Denny Prayudi, meminta kepada para calon pelamar agar menyiapakan berkasnya sesuai dengan persyaratan yang ditentukan. “Kalau sesuai pengumuman hasil seleksi administrasi CPNS akan diumumkan pada 16 Desember 2019, namun jadwal ini masih tentatif dan dapat berubah sewaktu-waktu,” ungkap Deny. (@mukhlis.mhsut72)\n.\nCek keterangan lengkapnya di:\nhttps://humas.kaltaraprov.go.id\n.\n? by: @abdulghaf\n.\n#kaltarapastiterdepan\n#kaltaraprov\n#infokaltara \n#beritakaltara19\n#humasprovkaltara \n#humprosetdakaltara', '2019-11-25 12:25:03', 2, 0, 0, 0, '2019-11-28 05:05:03', '2019-11-28 05:05:03'),
(38, 'kaltaraprov', 'https://instagram.com/p/B5RehZ9Hwo0', 14282, 299, 'DIPA\n\nGubernur Kaltara @irianto_lambrie menyerahkan secara simbolik dana DIPA dan TKDD 2020 kepada pemerintah daerah, instansi vertikal dan Satker lainnya.\n_\n? : @anggrinogilangverlando\n.\n#kaltarapastiterdepan\n#kaltaraprov\n#infokaltara \n#beritakaltara19\n#humasprovkaltara \n#humprosetdakaltara', '2019-11-25 10:19:30', 2, 0, 0, 0, '2019-11-28 05:05:03', '2019-11-28 05:05:03'),
(39, 'kaltaraprov', 'https://instagram.com/p/B5RVcxMo9lS', 14282, 476, 'Sesuai dengan Surat Keputusan (SK) Gubernur Kalimantan Utara (Kaltara) No. 188.44/K.719/2019, tentang Upah Minimum Provinsi Kaltara Tahun 2020, Upah Minum Provinsi (UMP) di Kaltara pada 2020 ditetapkan sebesar Rp 3.000.804. Naik sebesar 8,51 persen dibandingkan dengan UMP tahun 2019 sebesar Rp 2.765.463. “Angka tersebut sesuai dengan formulasi yang menjadi ketetapan Kementerian Tenaga Kerja Republik Indonesia (Kemenker RI). Kenaikannya sebesar 8,51 persen dan telah disepakati oleh Dewan Pengupahan Kaltara,” ujar Armin Mustafa, Kepala @nakertrans_provkaltara didampingi Kabid Pengawasan Tenaga Kerja dan Hubungan Industrial (HI), Asnawi.\n.\nArmin mengatakan, sebelumnya Kemenaker RI menetapkan UMP tahun 2020 sebesar 8,51 persen. Di mana, hal itu tertuang dalam Surat Edaran (SE) Nomor B-m/308/HI.01.00/X/2019 tanggal 15 Oktober 2019, tentang Penyampaian Data Tingkat Inflasi Nasional dan Pertumbuhan Produk Domestik Bruto Tahun 2019. Dalam SE ini, menjelaskan bahwa inflasi nasional tercatat 3,39 persen dan pertumbuhan ekonomi nasional 5,12 persen, kemudian diakumulasi menjadi besaran kenaikan UMP 2020. “Kenaikan UMP memberi efek maksimal terhadap kesejahteraan pekerja,” ungkap Armin. (@iqbalhaerani)\n.\nCek keterangan lengkapnya di:\nhttps://humas.kaltaraprov.go.id\n.\n? by: @adhie_project\n.\n#kaltarapastiterdepan\n#kaltaraprov\n#infokaltara \n#beritakaltara19\n#humasprovkaltara \n#humprosetdakaltara', '2019-11-25 09:00:14', 2, 0, 0, 0, '2019-11-28 05:05:03', '2019-11-28 05:05:03'),
(40, 'kaltaraprov', 'https://instagram.com/p/B5HQkQMIeCq', 14282, 249, 'Mereka terdiri dari, Tenaga Kerja Asing (TKA) sebanyak 254 orang, orang asing yang memiliki Kartu Ijin Tinggal Sementara (KITAS) 295 orang, memiliki Kartu Ijin Tinggal Tetap (KITAP) 9 orang, dan kunjungan 1 orang. Selain itu, dilaporkan juga bahwa sepanjang Januari hingga November 2019, jumlah orang asing yang keluar-masuk Kaltara sebanyak 187 orang.\n_\nDiungkapkan Kepala Badan Kesbangpol Kaltara, Basiran, pengawasan orang asing ini melibatkan beberapa instansi. Seperti, TKA yang diawasi oleh satuan tugas (Satgas) TKA yang dibawahi Dinas Tenaga Kerja dan Transmigrasi (Disnakertrans). “Pemantauan orang asing didasarkan pada Permendagri No. 49/2010, tentang Pemantauan Orang Asing dan Organisasi Masyarakat Asing di Daerah, dan Permendagri No. 50/2010 untuk pengawasan TKA,” jelas Basiran yang ditemui di ruang kerjanya, kemarin (20/11).\n_\nBaca selengkapnya di humas.kaltaraprov.go.id', '2019-11-21 11:05:09', 2, 0, 0, 0, '2019-11-28 05:05:04', '2019-11-28 05:05:04'),
(41, 'kumparancom', 'https://instagram.com/p/B5Xxh04D6F6', 654741, 11416, 'Delegasi Indonesia tak sengaja makan daging babi di SEA Games 2019. Hal tersebut terjadi lantaran kurangnya informasi makanan halal dan nonhalal dari panitia.  Ketua Umum Komite Olimpiade Indonesia (KOI), Raja Sapta Oktohari. menegaskan agar cabang olahraga lebih teliti terhadap makanan. KOI menyesalkan insiden tersebut. Pihak KOI pun sudah meminta kepada penyelenggara SEA Games untuk memberi perhatian lebih soal makanan.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSPORT #halal #makanan #makananhalal #seagames #kontingen #sepakbola #sepakbolaindonesia #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 21:06:05', 5, 0, 0, 0, '2019-11-28 05:05:16', '2019-11-28 05:05:16'),
(42, 'kumparancom', 'https://instagram.com/p/B5XqsENDvZ3', 654741, 6256, 'Menteri Agama Fachrul Razi menyebut FPI sudah membuat pernyataan untuk setia pada Pancasila dan NKRI. Hal itu terkait dengan perpanjangan izin Surat Keterangan Terdaftar (SKT) FPI di Kemendagri yang membutuhkan surat rekomendasi dari Kemenag. Namun, ia menuturkan, pihaknya masih akan mendalami dulu pernyataan tersebut secepatnya. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #menteriagama #fachrulrazi #menag #agama #fpi #kemenag #nkri #pancasila #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 20:01:16', 5, 0, 0, 0, '2019-11-28 05:05:17', '2019-11-28 05:05:17'),
(43, 'kumparancom', 'https://instagram.com/p/B5XmJmMFJDG', 654741, 3475, 'Komedian Nunung dan suaminya July Jan Sambiran, divonis bersalah melakukan tindak pidana penyalahgunaan narkotika. Mereka terbukti melanggar Pasal 127 ayat 1 Undang-Undang Nomor 35 Tahun 2019 Tentang Narkotika.\n-\nDalam putusannya, majelis hakim menyatakan Nunung dan Iyan terbukti secara sah melanggar tindak pidana penyalahgunaan narkotika golongan 1 bagi diri sendiri.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanHITS #nunung #narkoba #vonisnunung #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 19:21:36', 5, 0, 0, 0, '2019-11-28 05:05:17', '2019-11-28 05:05:17'),
(44, 'kumparancom', 'https://instagram.com/p/B5XjUU7ln8f', 654741, 3411, 'Jadi, pekerjaan sambilan apa nih yang cocok buat kamu? Share di kolom komentar, ya!\n-\nCari tahu informasi atau tips-tips untuk si pejuang loker, di kum.pr/InfoLoker. Jangan lupa klik subscribe untuk mendapatkan notifikasi jika ada story terbaru, ya!\n-\n#infoloker #job #karier #tips #job #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 18:56:51', 5, 0, 0, 0, '2019-11-28 05:05:17', '2019-11-28 05:05:17'),
(45, 'kumparancom', 'https://instagram.com/p/B5XgTvLACXG', 654741, 8141, 'PT MRT Jakarta baru beroperasi secara komersial pada Bulan April 2019. Namun, penumpang @mrtjkt yang ditargetkan hanya 65.000 sehari saat ini sudah mencapai 90.000 penumpang. Jumlah penumpang itu menambah penghasilan MRT Jakarta dari segi pembelian tiket, serta tambahan pemasukan dari non tiket seperti iklan dan penamaan stasiun.⁠\n-⁠\nDirektur Utama MRT Jakarta William Syahbandar mengungkapkan, sejauh ini pihaknya sudah mendapatkan laba sebesar 60-70 miliar. Angka laba bersih itu baru perhitungan dari pihak MRT. Secara resmi MRT Jakarta masih menunggu audit terkait jumlah pendapatan di tahun 2019.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanBISNIS #mrt #mrtjakarta #bisnis #kereta #bisnismrt #labamrtjakarta #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan.⁠', '2019-11-27 18:30:33', 5, 0, 0, 0, '2019-11-28 05:05:17', '2019-11-28 05:05:17'),
(46, 'kumparancom', 'https://instagram.com/p/B5XdBmdDuCF', 654741, 3107, 'Penyanyi Agnez Mo menjadi pembicaraan karena ucapan kontroversial yang mengungkapkan dirinya tidak memiliki darah Indonesia, saat wawancara dengan media AS, Build Series by Yahoo, belum lama ini. Namun, @agnezmo sudah memberikan klarifikasi terkait hal itu. Bagaimana tanggapan kalian?⁠\n-⁠\n#reaksinetizen #penyanyi #agnezmo #agnes #wawancara #interview #buildseries #mediaas #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 18:01:52', 5, 0, 0, 0, '2019-11-28 05:05:17', '2019-11-28 05:05:17'),
(47, 'kumparancom', 'https://instagram.com/p/B5XV3EoFODw', 654741, 10775, 'Pengusaha properti terkemuka, Ciputra, meninggal dunia di Singapura pada Rabu (27/11) sekitar pukul 01.05 waktu setempat. Sebagai arsitek dan pengusaha properti, Ciputra diketahui memiliki minat besar terhadap seni. Berikut rekam jejaknya semasa hidup.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #ciputra #ciputragroup #bisnis #founderciputrameninggal #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 16:59:16', 4, 0, 0, 0, '2019-11-28 05:05:17', '2019-11-28 05:05:17'),
(48, 'kumparancom', 'https://instagram.com/p/B5XEz2UAln5', 654741, 14782, 'Bagi jubir Presiden Jokowi, Fadjroel Rachman, tidak ada yang salah dengan pernyataan Agnez Mo. Kata dia, @agnezmo hanya menceritakan asal-usulnya.⁠\n-⁠\n\"Dia bercerita tentang asal-usul dirinya, memuji keberagaman negeri tempat dia dilahirkan,\" ungkap dia.⁠\n-⁠\nFadjroel menambahkan, selama ini Agnez Mo telah membawa nama Indonesia dalam kancah musik internasional. Ia pun memotivasi warga negara Indonesia untuk bisa berbuat demikian, dengan caranya masing-masing.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanNEWS #jubirpresiden #agnezmo #agnes #wawancara #interview #buildseries #mediaas #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 14:30:16', 3, 0, 0, 0, '2019-11-28 05:05:17', '2019-11-28 05:05:17'),
(49, 'kumparancom', 'https://instagram.com/p/B5XBb81DX1B', 654741, 9296, 'Zhu Zhong-fa, pria berusia 43 tahun asal Hangzhou, China mengalami sakit kepala yang berlangsung satu bulan lamanya. Dokter pun kemudian memindai otaknya dan mendapati ratusan cacing pita hidup di sana.⁠\n-⁠\nMenurut laporan News 18, Zhu mengunjungi rumah sakit First Affiliated Hospital of College of Medicine, Zhejiang University, dengan keluhan sakit kepala yang disertai kejang. Setelah dilakukan MRI pada otak pasien, hasilnya otak pasien menderita kerusakan cukup parah yang diakibatkan oleh cacing pita atau disebut sebagai neurocysticercosis.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanSAINS #otak #cacingpita #penyakit #sakitkepala #china #dokter #rumahsakitchina #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan.⁠', '2019-11-27 14:00:48', 3, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18');
INSERT INTO `tbl_crawling` (`id_crawling`, `ig_username`, `url`, `follower_count`, `like_count`, `caption_text`, `taken_at`, `time_frame`, `is_extracted`, `is_normalized`, `is_classified`, `created`, `updated`) VALUES
(50, 'kumparancom', 'https://instagram.com/p/B5W2f2DDt-k', 654741, 20447, 'Sebuah mobil \"terjun bebas\" dari atas flyover, menimpa pejalan kaki di bawahnya. Satu orang tewas dan tiga lainnya terluka dalam kecelakaan itu. Video kecelakaan di India ini pun viral di media sosial.⁠\n-⁠\nMenurut media India Hindustan Times, peristiwa itu terjadi pada Sabtu lalu (23/11). Mobil sedan Volkswagen itu melaju dengan kecepatan tinggi di jalan layang kota Hyderabat sekitar pukul 01.00 siang. Ketika jalanan menikung, mobil hilang kendali dan menghantam pinggiran flyover.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanNEWS #india #kecelakaan #videokecelakaan #kecelakaanmobil #mobilkecelakaan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan.', '2019-11-27 12:30:18', 2, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18'),
(51, 'kumparancom', 'https://instagram.com/p/B5Wz7rmI8PM', 654741, 14554, 'Penyanyi Agnez Mo menjadi pembicaraan karena ucapan kontroversial yang mengungkapkan dirinya tidak memiliki darah Indonesia, saat wawancara dengan media AS, Build Series by Yahoo, belum lama ini. Agnez mengatakan Indonesia memiliki banyak pulau dengan beragam etnis dan budaya, ia pun tumbuh besar dengan keberagaman itu.⁠\n-⁠\nAgnez Mo sudah memberikan klarifikasi dalam unggahan di akun Instagram pribadinya. @agnezmo mengungkapkan bahwa ia tidak bisa memilih darah atau DNA untuknya sendiri. Ia menyatakan Indonesia amat berarti buat dirinya. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanHITS #agnezmo #agnes #wawancara #interview #buildseries #mediaas #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 12:02:48', 2, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18'),
(52, 'kumparancom', 'https://instagram.com/p/B5WsT-Rqk-T', 654741, 5917, 'Sebagai wujud cintanya kepada tanah air, @agnezmo kerap memperlihatkan budaya Indonesia di media sosial hingga video klip miliknya. Berikut kumparan rangkum ulasannya.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanHITS #agnezmo #agnes #wawancara #interview #buildseries #mediaas #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan.⁠', '2019-11-27 11:00:40', 2, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18'),
(53, 'kumparancom', 'https://instagram.com/p/B5WoMz1FRSG', 654741, 6839, 'Follow @kumparanmom untuk mengetahui informasi terkini seputar ibu dan anak.\n—\nSaat ingin cepat hamil, banyak pasangan biasanya mencoba berbagai saran. Terlebih bagi suami-istri yang telah lama menantikan kehadiran buah hati, semua dilakukan untuk memperbesar peluang kehamilan.⁠\n-⁠\nTerkait mitos yang beredar, Anda sebaiknya jangan langsung percaya jika belum terbukti secara ilmiah. Coba cek faktanya yuk, Moms!⁠\n-⁠\nSimak selengkapnya di kumparanmom.com, atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanMOM #IbuPastiBIsa #CariCara #prakonsepsi #programhamil #mitos #trending #trendingtopic #videooftheday #moms #kumparanmoms #ibu #infoibu #orangtua #infoanak #infobayi #strechmark #parent #beauty #tips #learning #anak #infoanak #indonesia #viral #news #like4like #instadaily #instapost #parenting', '2019-11-27 10:20:45', 2, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18'),
(54, 'kumparancom', 'https://instagram.com/p/B5WhJ4hFpNR', 654741, 12284, 'Pengusaha properti Ciputra meninggal dunia di Singapura pada Rabu (27/11) di usia 88 tahun. Founder @ciputra.group itu tutup usia sekitar pukul 01.05 waktu setempat. Kedutaan Besar Republik Indonesia (KBRI) di Singapura mengatakan jasad Ciputra akan segera dipulangkan ke Jakarta.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #ciputra #ciputragroup #bisnis #founderciputrameninggal #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 09:18:43', 2, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18'),
(55, 'kumparancom', 'https://instagram.com/p/B5WfF6moSdF', 654741, 3728, 'Menurut jurnal Molecular Nutrition and Food Research, alpukat mengandung senyawa yang mampu menghentikan pemicu diabetes. Selain itu, alpukat juga baik dikonsumsi untuk kesehatan otot, hati, dan ginjal. ⁠\n-⁠\nKalau kamu suka makan alpukat dicampur apa? Kalau mimin sih, dicampur pakai cokelat dan es batu. ??⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSAINS #alpukat #buah #sehat #kesehatan #healthy #lifestyle #makananenak #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-27 09:00:42', 2, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18'),
(56, 'kumparancom', 'https://instagram.com/p/B5VQFgdD5C2', 654741, 7282, 'Berdasarkan survey BPS dikutip dari Opus Creative Economy Outlook 2019, pada 2017, ekonomi kreatif menyumbang PDB mencapai Rp 989 triliun dan tembus Rp 1.100 triliun di tahun berikutnya. Sementara pada 2019, diperkirakan mencapai Rp 1.211 triliun atau 9,6 persen lebih tinggi dari tahun sebelumnya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #ekonomikreatif #bisnis #sumbangan #triliun #pemerintah #ekonomi #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 21:30:19', 5, 0, 0, 0, '2019-11-28 05:05:18', '2019-11-28 05:05:18'),
(57, 'kumparancom', 'https://instagram.com/p/B5VMWMFFj7P', 654741, 6313, 'Bhayangkara Taruna Irfan Urane Aziz, putra Kapolri Jenderal Idham Azis, kembali mendapat penghargaan. Irfan mendapat penghargaan dari Kalemdikpol Komjen Arief Sulistyanto atas prestasinya saat menjalani pendidikan dasar integrasi Taruna Akademi TNI dan Akpol di Akademi Militer Magelang. Berikut deretan prestasi akademiknya. Keren~\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #polri #tni #akpol #taruna #bhayangkara #idhamazis #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 20:57:39', 5, 0, 0, 0, '2019-11-28 05:05:19', '2019-11-28 05:05:19'),
(58, 'kumparancom', 'https://instagram.com/p/B5VJPUJjfK_', 654741, 11025, 'Agnez Mo bikin geger netizen Indonesia. Dalam wawancaranya dengan media AS Build Series by Yahoo, Agnez mengatakan bahwa dirinya tak memiliki darah Indonesia. Namun dalam unggahan terbarunya, Agnez seakan memberi klarifikasi. Ia menjelaskan bahwa dirinya selama ini tumbuh dalam keragaman budaya. Ia merasa bangga akan hal tersebut.\n-\n@agnezmo menjelaskan makna \'Bhinneka Tunggal Ika\' yang merupakan moto atau semboyan negara Indonesia. Ia pun menuliskan bahwa dirinya akan selalu mewakili Indonesia. \"#indonesia represents,\" tulisnya dalam Instagram pribadinya.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanHITS #agnezmo #agnes #wawancara #interview #buildseries #mediaas #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 20:35:39', 5, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(59, 'kumparancom', 'https://instagram.com/p/B5VF3b8gabt', 654741, 3540, 'Menteri Perhubungan Budi Karya Sumadi mendukung pemisahan PT Garuda Indonesia (Persero) Tbk (GIAA) dengan Sriwijaya Air Group. Menurutnya, hal ini akan berdampak positif dan membuat persaingan harga tiket semakin baik.⁠\n-⁠\nSelain itu, Budi Karya menuturkan, pemisahan Garuda dan Sriwijaya dapat memudahkan penyelesaian masalah. Sehingga pemerintah bisa lebih jelas untuk memisahkan masalah yang ada.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #menhub #budikarya #garudaindonesia #sriwijaya #tiket #tiketpesawat #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 20:01:01', 5, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(60, 'kumparancom', 'https://instagram.com/p/B5VDMXfAqED', 654741, 4854, '@erickthohir membabat semua pejabat eselon I di kementerian BUMN. Ditengarai atas perintah langsung dari Presiden @jokowi. Lantas, seperti apa sebenarnya peran Jokowi di balik kebijakan yang dikeluarkan Erick?⁠\n-⁠\nSimak selengkapnya dalam collection “Erick Thohir Menggebrak” di kum.pr/thohirmenggebrak atau klik link di bio.⁠\n-⁠\n#kumparanNEWS #thohirmenggebrak #lipsus #lipsuskumparan #erickthohir #bumn #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 19:42:29', 5, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(61, 'kumparancom', 'https://instagram.com/p/B5U3dKmDpJ5', 654741, 6241, 'Musisi Sandhy Sondoro diduga mengikuti dan memberikan likes unggahan akun porno. Hal itu diketahui dari tagar trending topic #SandhySondoroCabul yang muncul di Twitter. Dalam cuitan di Twitter, sejumlah netizen menampilkan screenshot yang memperlihatkan likes di akun Twitter @sandhysondoro_official. Terlihat akun tersebut memberikan likes pada unggahan pornografi. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanHITS #sandhysondoro #sandy #tagartwitter #unggahanporno #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 18:01:08', 5, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(62, 'kumparancom', 'https://instagram.com/p/B5UxOoDj_j2', 654741, 8698, 'Komisi VII DPR RI menggelar rapat dengar pendapat dengan PT PLN (Persero). Dalam kesempatan ini, Anggota Komisi VII DPR RI Mulan Jameela menyoroti peristiwa mati listrik massal pada Agustus lalu. Ia menanyakan terkait ganti rugi yang dijanjikan PLN.⁠\n-⁠\n@mulanjameela1 mengaku menyambut baik niat PLN mengganti kerugian yang dialami masyarakat. Namun, ia masih belum mengerti sudah sejauh mana kompensasi yang dibayarkan oleh PLN.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #pln #mulanjameela #mulan #dprri #ptpln #komisivii #matilistrik #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 17:00:41', 4, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(63, 'kumparancom', 'https://instagram.com/p/B5UmMSRDR8u', 654741, 2592, 'Tiga personel Polri kena sanksi disiplin karena pamer foto saat pergi ke luar negeri. Hal ini merupakan buntut dari surat imbauan dari Kapolri Jenderal Idham Azis yang berisi larangan hidup mewah dan hedonistik terhadap anggotanya. Namun, pihak kepolisian enggan menyebut identitas personel tersebut.⁠\n-⁠\nKredit foto: Shutterstock, Antara, kumparan.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #polri #polisi #luarnegeri #sidak #idhamaziz #aturan #rules #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 15:29:20', 3, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(64, 'kumparancom', 'https://instagram.com/p/B5UjnctjSk-', 654741, 4605, 'Ada kalanya kita membutuhkan suasana baru untuk menyegarkan pikiran yang penat. Apalagi bila keseharian kita diisi dengan rutinitas dan kesibukan yang sama.⁠\n-⁠\nPadahal bila dibiarkan, rasa bosan akan membuat produktivitas kita menurun saat bekerja. Bahkan bisa mempengaruhi emosi hingga menjauhkan kita dari orang-orang terdekat akibat kesibukan yang ada habisnya.⁠\n-⁠\nSaat kesibukan mulai yang tidak ada jedanya, jalan-jalan ke tempat baru bisa jadi solusi tepat meningkatkan produktivitas kerja yang sempat menurun akibat bosan. @bliblidotcom menyediakan berbagai kebutuhanmu saat ingin merencanakan liburan. Mulai dari tiket pesawat, hotel, hingga berbagai perlengkapan untuk menunjang liburanmu agar makin menyenangkan! @sahabatperjalananmu #sahabatperjalananmu #bliblitravel', '2019-11-26 15:01:45', 3, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(65, 'kumparancom', 'https://instagram.com/p/B5UcoDCA1Jb', 654741, 4837, 'Presiden @jokowi menyatakan akan membangun Pusat Riset dan Inovasi di Ibu Kota Baru. Bahkan Jokowi menyebut, pemerintah telah menyiapkan lahan yang luas untuk membangun sarana tersebut. Menurut Jokowi, saat ini fokus pemerintah adalah untuk memperkuat riset dan inovasi, serta pembangunan SDM.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #kalimantan #ibukota #presiden #pembangunan #riset #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 14:00:39', 3, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(66, 'kumparancom', 'https://instagram.com/p/B5UWeILFCmc', 654741, 4473, '@basukibtp tampil perdana sebagai Komisaris Utama PT Pertamina (Persero). Ahok hadir dalam acara Pertamina Energy Forum (PEF) 2019 di Hotel Raffles, Jakarta, Selasa (26/11), sekitar pukul 09.30 WIB\n-\nPEF merupakan acara tahunan Pertamina yang ketujuh. Dalam acara ini, biasanya diagendakan berbagai diskusi menarik seputar perkembangan dunia bisnis minyak dan gas Indonesia.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #ahok #basuki #pertamina #komutpertamina #pef #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 13:07:13', 3, 0, 0, 0, '2019-11-28 05:05:20', '2019-11-28 05:05:20'),
(67, 'kumparancom', 'https://instagram.com/p/B5UO3-xgroN', 654741, 7296, '@lrtjkt akan beroperasi melayani 6 stasiun, yakni Pegangsaan Dua, Boulevard Utara, Boulevard Selatan, Pulomas, Equestrian, hingga Velodrome sepanjang 5,8 kilometer. Penumpang dapat membayar menggunakan kartu Single Journey Trip (SJT) yang bisa didapatkan di loket stasiun maupun Ticket Vending Machine, atau dengan kartu elektronik berbayar, seperti Flazz dan e-Money.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #lrt #kereta #transportasi #krl #angkutan #dkijakarta #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 12:00:30', 2, 0, 0, 0, '2019-11-28 05:05:21', '2019-11-28 05:05:21'),
(68, 'kumparancom', 'https://instagram.com/p/B5UH3o-FsDJ', 654741, 8737, 'Follow @kumparanmom untuk mengetahui informasi seputar ibu dan anak!\n—\nHuruf X mungkin jarang dipakai sebagai huruf pertama anak di Indonesia, ya, Moms. Tapi, bila Anda sedang mencari inspirasi nama anak dari huruf X yang tidak pasaran dan berarti baik, ini bisa jadi pertimbangan Anda.⁠\n-⁠\nNah, Moms, mana yang Anda sukai?⁠\n-⁠\nSimak selengkapnya di kumparanmom.com, atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanMOM #IbuPastiBIsa #CariCara #namaanak #anaklaki-laki #anakperempuan #trending #trendingtopic #videooftheday #moms #kumparanmoms #ibu #infoibu #orangtua #infoanak #infobayi #strechmark #parent #beauty #tips #learning #anak #infoanak #indonesia #viral #news #like4like #instadaily #instapost #parenting⁠', '2019-11-26 10:59:17', 2, 0, 0, 0, '2019-11-28 05:05:21', '2019-11-28 05:05:21'),
(69, 'kumparancom', 'https://instagram.com/p/B5T6S3mowCI', 654741, 5129, 'Para peneliti di India mengumumkan bahwa mereka telah menyelesaikan uji klinis dari alat kontrasepsi pria yang dikenal sebagai reversible inhibition of sperm under guidance (RISUG) atau penghambatan sperma. Tim ilmuwan memaparkan, alat kb ini bekerja dengan cara disuntik di dekat testis pria, dan efeknya diklaim bisa bertahan hingga 13 tahun.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSAINS #kb #pertama #india #kbpria #pria #sperma #ujiklinis #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-26 09:00:40', 2, 0, 0, 0, '2019-11-28 05:05:21', '2019-11-28 05:05:21'),
(70, 'kumparancom', 'https://instagram.com/p/B5Sn8MQDQfn', 654741, 8475, 'Mantan Menteri Komunikasi dan Informatika, Rudiantara, dikabarkan bakal menjadi Direktur Utama PT PLN (Persero). Rudiantara sudah mendapat restu dari Istana. Tinggal diangkat oleh Menteri BUMN @erickthohir. Nah, begitupula dengan @basukibtp yang akan menjabat menjadi Komut Pertamina. Gimana tanggapan kalian, gaes?⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #ahok #btp #basuki #basukitjahajapurnama #rudiantara #bumn #komut #pertamina #komutpertamina #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 21:06:05', 5, 0, 0, 0, '2019-11-28 05:05:21', '2019-11-28 05:05:21'),
(71, 'kumparancom', 'https://instagram.com/p/B5SkbjgD4qe', 654741, 3405, 'Per 22 November 2019, Kemendagri mencatat jumlah ormas menembus angka 431 ribu lebih. Jumlah tersebut terbagi menjadi tiga kategori, yakni ormas yang telah mendapatkan surat keterangan terdaftar (SKT) di Kemendagri, ormas berbadan hukum yang terdaftar di Kemkumham, dan ormas yang terdaftar di Kementerian Luar Negeri.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #kemendagri #ormas #mendagri #organisasi #kementerian #hukum #ormasindonesia #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 20:30:23', 5, 0, 0, 0, '2019-11-28 05:05:21', '2019-11-28 05:05:21'),
(72, 'kumparancom', 'https://instagram.com/p/B5SiQjtlhmD', 654741, 2906, 'Hari ini (25/11), Wali Kota @surabaya Tri Rismaharini berkunjung ke kantor kumparan. Di momen yang langka ini, Ibu Risma bersama para direksi meresmikan salah satu ruangan baru di kantor kumparan, yaitu Ruang Baca kumparan. Terima kasih sudah berkunjung ke kantor kami, Bu Risma!\n-\n#percayakumparan #risma #surabaya #walikotasurabaya #kantorkumparan #ruangkumparan #kantor #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 20:11:24', 5, 0, 0, 0, '2019-11-28 05:05:21', '2019-11-28 05:05:21'),
(73, 'kumparancom', 'https://instagram.com/p/B5SfpzTlWlO', 654741, 14010, 'Belum sebulan menjabat Menteri BUMN, Erick Thohir menggebrak. Tokoh yang terkenal dengan tangan dinginnya semasa menjadi pengusaha ini membabat semua pejabat eselon I di jajaran kementeriannya. Bagaimana sesungguhnya peran Jokowi di balik kebijakan mengejutkan itu? PR apa saja yang diberikan Presiden @jokowi kepada @erickthohir?\n-\nSimak selengkapnya dalam collection “Erick Thohir Menggebrak” di kum.pr/thohirmenggebrak atau klik link di bio.\n-\n#kumparanNEWS #thohirmenggebrak #lipsus #lipsuskumparan #erickthohir #bumn #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 19:48:38', 5, 0, 0, 0, '2019-11-28 05:05:21', '2019-11-28 05:05:21'),
(74, 'kumparancom', 'https://instagram.com/p/B5SMc22gzqV', 654741, 2987, 'Wakil Presiden @kyai_marufamin menunjuk 8 orang yang akan menjadi pembantunya sebagai staf khusus wapres. 8 orang tersebut sudah mendapatkan surat keputusan dari Presiden @jokowi dan telah efektif bekerja sejak hari ini.⁠\n-⁠\nTokoh pertama yang diperkenalkan sebagai staf khusus adalah Mohamad Nasir. Di bidang hukum, Ma\'ruf menunjuk Satya Arinanto sebagai staf khusus, di bidang infrastruktur dan investasi, Ma\'ruf menunjuk Sukriansyah S Latief. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #marufamin #wapres #stafkhusus #staf #stafsus #presiden #jokowi #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 17:05:57', 4, 0, 0, 0, '2019-11-28 05:05:22', '2019-11-28 05:05:22'),
(75, 'kumparancom', 'https://instagram.com/p/B5SI8H8DKpE', 654741, 13390, 'Basuki Tjahaja Purnama atau Ahok yang akan menjadi Komisaris Utama PT Pertamina (Persero), tiba di BUMN sekitar pukul 9.24 WIB, (25/11). Ahok mengaku dipanggil untuk penyerahan Surat Keputusan Menteri BUMN Erick Thohir selaku RUPS Pertamina. Saat ditanya bagaimana strateginya menjadi Komut Pertamina, @basukibtp menjawab dengan candaan. \"Saya lulusan S3 dari Mako Brimob,\" katanya.⁠\n-⁠\nMako Brimob merupakan tempat mendekam Ahok saat dirinya menjadi terdakwa kasus penistaan agama. Ahok dipenjara selama 1 tahun 8 bulan.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #ahok #btp #basuki #basukitjahajapurnama #komut #pertamina #komutpertamina #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 16:30:09', 4, 0, 0, 0, '2019-11-28 05:05:22', '2019-11-28 05:05:22'),
(76, 'kumparancom', 'https://instagram.com/p/B5R-uiUAoji', 654741, 7065, 'Mantan Kepala Bappenas Andrinof Chaniago dan mantan Menteri Perindustrian Saleh Husin kehilangan sandal dan sepatu di sebuah masjid di Depok. Peristiwa ini diunggah oleh Andrinof di akun instagramnya.⁠\n-⁠\n@andrinofachaniago menuturkan, mereka kehilangan sandal dan sepatu pada Kamis (14/11). Saat itu mereka usai menyalatkan jenazah Ketua PP Muhammadiyah Prof. Bahtiar Effendy. Saat keduanya akan meninggalkan masjid, mereka tak menemukan sandal dan sepatunya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #menteri #mantanmenteri #menteriperindustrian #kehilangansandal #kepalabappenas #jenazahketuapp #masjiddepok #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 15:00:55', 3, 0, 0, 0, '2019-11-28 05:05:22', '2019-11-28 05:05:22'),
(77, 'kumparancom', 'https://instagram.com/p/B5R32xRAzkp', 654741, 11305, 'Menpora Malaysia Syed Saddiq telah meminta maaf atas insiden penyerangan suporter Indonesia melalui akun Twitter. Merespons hal ini, Menpora Zainudin Amali menilai seharusnya permintaan maaf tak hanya dilayangkan melalui media sosial tapi melalui surat resmi. Zainudin pun mengatakan, Kemenpora RI sudah mengirim surat resmi sebagai bentuk protes atas insiden penyerangan tersebut.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #kasus #sepakbola #penyerangan #malaysia #syedsaddiq #menpora #pertandingan #suporterbola #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 14:00:52', 3, 0, 0, 0, '2019-11-28 05:05:22', '2019-11-28 05:05:22'),
(78, 'kumparancom', 'https://instagram.com/p/B5RzINIlDRA', 654741, 2511, 'Menteri BUMN Erick Thohir tak butuh waktu lama mewujudkan keinginan Presiden Jokowi untuk menyederhanakan birokrasi. Belum sebulan, enam deputi eselon I ia berhentikan untuk menduduki pos baru di BUMN. Nantinya, jabatan deputi bakal cuma tiga, yang seluruhnya diisi orang baru.\n-\nBanyak yang bilang jurus kilat @erickthohir ini cukup menjanjikan. Namun apakah upaya bersih-bersih itu mampu melepas BUMN dari bayang-bayang kekuatan politik yang selama ini dicemaskan menjadikan perusahaan negara itu sebagai sapi perah?\n-\nSimak selengkapnya dalam collection “Erick Thohir Menggebrak” di kum.pr/thohirmenggebrak atau klik link di bio.\n-\n#kumparanNEWS #thohirmenggebrak #lipsus #lipsuskumparan #erickthohir #bumn #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 13:20:11', 3, 0, 0, 0, '2019-11-28 05:05:22', '2019-11-28 05:05:22'),
(79, 'kumparancom', 'https://instagram.com/p/B5RjFnnFShb', 654741, 5533, 'Follow @kumparanmom yuk, untuk mengetahui informasi seputar ibu dan anak!\n—\nSetelah menikah, suami tentu akan menjadi orang terdekat Anda. Karena begitu dekat,  Anda mungkin sudah tidak lagi merasa perlu jaga image di depannya. Tapi karena lupa jaim ini juga tanpa sadar bisa saja  Anda jadi semena-mena dan melukai perasaan atau menjatuhkan harga dirinya.⁠\n-⁠\nApakah Anda pernah melalukan salah satunya, Moms? Lebih hati-hati dalam mengungkapkan perasaan, ya ?⁠\n-⁠\nSimak selengkapnya di kumparanmom.com, atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠\n#kumparanMOM #IbuPastiBIsa #CariCara #image #hargadiri #bertengkar #trending #trendingtopic #videooftheday #moms #kumparanmoms #ibu #infoibu #orangtua #infoanak #infobayi #strechmark #parent #beauty #tips #learning #anak #infoanak #indonesia #viral #news #like4like #instadaily #instapost #parenting⁠', '2019-11-25 10:59:51', 2, 0, 0, 0, '2019-11-28 05:05:22', '2019-11-28 05:05:22'),
(80, 'kumparancom', 'https://instagram.com/p/B5RVfGfgRDe', 654741, 5083, 'Plasmodium falciparum, parasit yang bertanggungjawab menyebabkan penyakit malaria ternyata dapat dicegah pertumbuhannya dengan cara sederhana. Menurut laporan Medical Daily, penyakit menular itu dapat diperangi dengan mengonsumsi sup buatan sendiri yang menggunakan kaldu ayam hingga sapi.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSAINS #penyakitmalaria #malaria #penyakit #sup #kalduayam #sapi #kaldu #obat #parasit #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-25 09:00:33', 2, 0, 0, 0, '2019-11-28 05:05:22', '2019-11-28 05:05:22'),
(81, 'kumparancom', 'https://instagram.com/p/B5QDIy5DwQX', 654741, 7112, 'Dirlantas Polda Jawa Barat menilang seorang mahasiswa berinisial AG yang mengemudikan sebuah BMW. AG ditilang karena menggunakan pelat kendaraan Jepang. Dari hasil pemeriksaan polisi, kendaraan tersebut terdaftar resmi di Ditlantas Polda Jawa Barat. Namun, pelat yang digunakan palsu.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #bmw #pelatbmw #polisi #jabar #bandung #tilang #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 21:06:07', 5, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(82, 'kumparancom', 'https://instagram.com/p/B5P-pH4lvJW', 654741, 8528, 'Idola K-Pop Goo Hara ditemukan meninggal dunia, Minggu (24/11), di kediamannya di Cheongdam-dong, Gangnam-gu, Seoul. Goo Hara meninggal dunia sekitar pukul 18.09 waktu Korea Selatan di rumahnya. Belum diketahui penyebab kematian @koohara__. Pihak kepolisian hingga kini masih melakukan penyelidikan.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanKPOP #goohara #gooharameninggal #kpop #korean #idol #korea #koreanidol #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 20:21:42', 5, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(83, 'kumparancom', 'https://instagram.com/p/B5P7aQzl8OB', 654741, 3856, 'Badak Sumatra terakhir yang dimiliki Malaysia mati pada Sabtu (23/11). Badak betina yang mati bernama Iman, berusia 25 tahun. Selama ini, Iman tinggal di penangkaran Departemen Lingkungan Hidup Sabah di pulau Kalimantan. Kematiannya diumumkan langsung oleh Menteri Pariwisata, Budaya, dan Lingkungan Malaysia Christine Liew pada Minggu (24/11).\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #badak #badaksumatra #sumatra #malaysia #badakmati #punah #badakpunah #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 19:55:44', 5, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(84, 'kumparancom', 'https://instagram.com/p/B5Px3qtj5wO', 654741, 10569, 'Universitas Gadjah Mada (UGM) mengembangkan prototipe baterai nuklir. Baterai tersebut diklaim bisa tahan hingga 40 tahun. Penelitian ini digagas pada tahun 2016 dan mulai dikerjakan sejak 2017. Sumber energi baterai nuklir ini adalah radiasi plutonium (PU) 238 yang merupakan limbah thorium. Dalam baterai itu juga ditanamkan sel surya agar output yang dikeluarkan lebih besar. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSAINS #ugm #baterai #baterainuklir #prototipe #radiasi #limbah #penelitian #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 18:30:05', 5, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(85, 'kumparancom', 'https://instagram.com/p/B5Pgx2WAIvS', 654741, 5498, 'Super Charge Turbo punya kemampuan mengisi daya baterai ponsel sebesar 100W. Dengan daya sebesar itu, Xiaomi mengklaim teknologinya ini bisa mengisi daya baterai smartphone berkapasitas 4.000 mAh dalam waktu 17 menit. Teknologi turbo 100W di pengisi daya baterai itu dilengkapi dengan pompa muatan bertegangan tinggi yang dibundel dengan perlindungan muatan 9 kali lipat.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanTECH #xiaomi #bateraixiaomi #baterai #dayabaterai #ponsel #pengisidaya #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 16:00:45', 4, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(86, 'kumparancom', 'https://instagram.com/p/B5PTAnxgW9i', 654741, 2872, 'Huawei mengungkap rincian biaya reparasi layar ponsel Mate X yang harus ditanggung pemilik jika rusak. Untuk servis layarnya saja, pengguna harus menghabiskan setidaknya 1.000 dolar AS atau sekitar Rp 14 juta. Harga itu setara dengan beli satu unit motor TVS Dazz-FI yang harga on the road (OTR) di Jakarta adalah Rp 13,9 juta, atau motor Revo Fit dengan tambahan Rp 468 ribu.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanTECH #huawei #layarsmartphone #smartphone #motor #hargamotor #hargareparasi #reparasi #servislayar #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 14:00:26', 3, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(87, 'kumparancom', 'https://instagram.com/p/B5PIH1ljim2', 654741, 3632, 'Menpora Malaysia Syed Saddiq akhirnya meminta maaf terkait insiden penyerangan terhadap suporter Indonesia. Ia mengaku telah mendapat informasi kebenaran terkait insiden itu. Kasus penyerangan tidak terjadi saat pertandingan sepak bola di Stadion Bukit Jalil pada Selasa (19/11) malam. Tapi terjadi 20 kilometer dari Stadion Bukit Jalalil pada dini hari.⁠\n-\n@syedsaddiq pun meminta agar suporter Indonesia yang menjadi korban dalam insiden ini melapor dalam rangka pengusutan kasus. Ia memastikan pengusutan kasus ini berjalan secara adil bagi semua pihak.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #kasus #sepakbola #penyerangan #malaysia #syedsaddiq #menpora #pertandingan #suporterbola #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 12:30:20', 2, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(88, 'kumparancom', 'https://instagram.com/p/B5O3ie5AanC', 654741, 3105, 'Kita mungkin berpikir bahwa perselingkuhan selalu melibatkan kontak fisik di luar hubungan asmara yang sedang terjalin. Padahal, tidak selamanya demikian, lho. Ini ciri-cirinya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#MILLENNIAL #love #cheating #selingkung #relationship #couple #pacar #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-24 10:00:23', 2, 0, 0, 0, '2019-11-28 05:05:25', '2019-11-28 05:05:25'),
(89, 'kumparancom', 'https://instagram.com/p/B5NQl1hgM4Q', 654741, 4549, 'Kementerian PUPR akan membangun 3.000 km jalan arteri baru selama periode kedua kepemimpinan Presiden @jokowi. Direktur Jenderal Bina Marga Kementerian PUPR, Sugiyartanto merinci, pembangunan jalan baru itu akan dilakukan pada Trans Papua rute Manokwari-Pegunungan Arfak, Kawasan Ekonomi Khusus (KEK) Galang Batang Kep. Riau dan KEK Bitung Sulawesi, akses Pelabuhan Patimban, dan Bandara Kulon Progo.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanBISNIS #bola #jokowi #jalan #insfrastruktur #pembangunan #jalanraya #target #kementerianpupr #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-23 19:00:49', 5, 0, 0, 0, '2019-11-28 05:05:26', '2019-11-28 05:05:26'),
(90, 'kumparancom', 'https://instagram.com/p/B5NNF5agzNB', 654741, 5318, '@ustdzrizamuhammad tertahan di Imigrasi Bandara Internasional saat hendak mengisi ceramah di salah satu daerah di Hong Kong pada Sabtu (23/11). Pihak KJRI Hong Kong telah berkoordinasi dengan Imigrasi setempat. Namun, Ustaz Riza tetap tidak diperbolehkan masuk ke Hong Kong. Akhirnya, ia pun memilih untuk bertolak kembali ke tanah air.\n-\nKredit foto:  @ustdzrizamuhammad.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #hongkong #ustaz #imigrasi #ditolak #ceramah #ustazriza #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-23 18:30:14', 5, 0, 0, 0, '2019-11-28 05:05:26', '2019-11-28 05:05:26'),
(91, 'kumparancom', 'https://instagram.com/p/B5NFhc2gNEW', 654741, 4411, 'Penerimaan CPNS tahun ini Kejaksaan Agung menyertakan beberapa persyaratan. Salah satunya, pelamar CPNS tidak boleh memiliki orientasi seksual LGBT. Kepala Bagian Pengembangan dan Kepegawaian Kejaksaan Agung, Teguh Wardoyo menjelaskan, penolakan pelamar CPNS yang berorientasi LGBT ini masih pro dan kontra di kalangan masyarakat. Namun, tak menutup kemungkinan aturan tersebut akan ditambahkan.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #cpns #seleksi #dinas #pns #seksual #lgbt #status #kejaksaan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-23 17:29:07', 4, 0, 0, 0, '2019-11-28 05:05:26', '2019-11-28 05:05:26'),
(92, 'kumparancom', 'https://instagram.com/p/B5MuOTQgSsi', 654741, 16889, 'Menteri Pertahanan, @prabowo, meminta seluruh guru sejarah menyampaikan kejamnya peristiwa G30S/PKI kepada para siswa. Menurut Prabowo, pengetahuan ini penting untuk generasi muda. Sebab, pada saat itu PKI telah memberontak secara terang-terangan terhadap pemerintahan. Dengan cara tersebut, masyarakat diharapkan bisa lebih waspada terhadap gerakan dan propaganda yang dilakukan komunis untuk menjatuhkan negara. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #bola #menhan #prabowo #prabowosubianto #pki #g30spki #gerakan #komunis #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-23 14:00:30', 3, 0, 0, 0, '2019-11-28 05:05:26', '2019-11-28 05:05:26'),
(93, 'kumparancom', 'https://instagram.com/p/B5Mmn5ogTzx', 654741, 5726, 'Menpora Malaysia, @syedsaddiq, menyebut kasus penusukan dan pengeroyokan suporter Indonesia adalah hoaks. Syed Saddiq pun meminta warga Malaysia dan Indonesia tak terprovokasi dengan hoaks penyerangan terhadap suporter Indonesia.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #bola #menpora #syedsaddiq #sepakbola #malaysia #indonesia #kbri #terorbom #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-23 12:59:04', 2, 0, 0, 0, '2019-11-28 05:05:26', '2019-11-28 05:05:26'),
(94, 'kumparancom', 'https://instagram.com/p/B5MgehOg1Hx', 654741, 5846, 'Presiden @jokowi mengungkapkan bahwa 95 persen bahan baku obat hampir semuanya merupakan produk impor. Atas hal itu, Jokowi pun meminta kepada para menteri, untuk membuat skema insentif bagi pihak-pihak yang ingin melakukan penelitian agar masalah ini segera terselesaikan.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #presiden #jokowi #obat #farmasi #bahanbaku #impor #dokter #rumahsakit #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-23 12:00:23', 2, 0, 0, 0, '2019-11-28 05:05:26', '2019-11-28 05:05:26'),
(95, 'kumparancom', 'https://instagram.com/p/B5ML71wot4a', 654741, 6826, 'Ditlantas Polda Metro Jaya dan Dinas Perhubungan DKI Jakarta telah berkoordinasi membahas aturan penggunaan skuter listrik. Sampai ada regulasi resmi, penggunaan skuter listrik hanya boleh di area tertentu saja. Salah satunya di Gelora Bung Karno.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠\n#kumparanNEWS #scooter #wheels #larangan #aturan #polri #kepolisian #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-23 09:00:53', 2, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(96, 'kumparancom', 'https://instagram.com/p/B5K_VhADabu', 654741, 4667, 'Tak sedikit pihak yang memandang sebelah mata saat @basukibtp didaulat sebagai komisaris utama @pertamina. Namun, agaknya Ahok tak memusingkan hal itu. Dirinya cenderung cuek, dan menganggap penolakkan adalah suatu hal yang biasa.\n-\nDitunggu gebrakan barunya, ya, pak!\n-\nSimak selengkapnya di kum.pr/ahokisback, atau klik link pada bio. Dan, jangan lupa subscribe untuk mendapatkan notifikasi jika ada story terbaru.⁠\n-⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 21:56:37', 5, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(97, 'kumparancom', 'https://instagram.com/p/B5K1xh6ls9s', 654741, 8900, 'Ahok ditunjuk jadi Komisaris Utama Pertamina. Apa @basukibtp cukup mumpuni untuk posisi itu?\n-\nSimak selengkapnya di kum.pr/ahokisback, atau klik link pada bio. Dan, jangan lupa subscribe untuk mendapatkan notifikasi jika ada story terbaru.⁠\n-⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 20:28:00', 5, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(98, 'kumparancom', 'https://instagram.com/p/B5KvpI-FhBV', 654741, 4340, 'Satuan Kerja Khusus Pelaksana Kegiatan Usaha Hulu Minyak dan Gas Bumi (SKK Migas) mencatat, per awal 2018 terdapat 128 cekungan di seluruh Indonesia yang berpotensi memiliki kandungan hidrokarbon—senyawa migas. Dari 128 cekungan tersebut, 74 di antaranya belum dieksplorasi.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 19:34:26', 5, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(99, 'kumparancom', 'https://instagram.com/p/B5Kr3F8gxbA', 654741, 12373, '@basukibtp telah ditunjuk menjadi Komisaris Utama PT Pertamina. Menteri BUMN Erick Thohir mengatakan, dengan penunjukan tersebut, maka Ahok harus mundur dari @pdiperjuangan meski ia bukanlah pengurus partai. Erick menyebut, mundurnya Ahok dari PDIP tersebut semata-mata untuk menjaga independensi BUMN. @erickthohir juga telah berbicara dengan Ahok soal hal itu.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 19:01:23', 5, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(100, 'kumparancom', 'https://instagram.com/p/B5KmyLmlwtU', 654741, 11182, 'Simak penjelasannya dalam video berikut.\n-\n#kumparanNEWS #donaldtrump #america #presiden #dimakzulkan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 18:18:59', 5, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(101, 'kumparancom', 'https://instagram.com/p/B5Kk_edDQUX', 654741, 8088, 'Ahok is back! Kini mantan gubernur DKI Jakarta itu akan resmi menjabat sebagai komisaris utama @pertamina. Bagaimana pendapatmu, gaes? Sampaikan saran dan harapan kamu untuk @basukibtp di kolom komentar, ya!⁠\n-⁠\n#reaksinetizen #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 18:01:21', 5, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(102, 'kumparancom', 'https://instagram.com/p/B5KgdI9A-G8', 654741, 21486, 'Menteri BUMN @erickthohir menyebut bahwa @basukibtp atau Ahok resmi menjadi Komisaris Utama PT Pertamina. Ahok menggantikan posisi Tanri Abeng. Sementara itu, Budi Gunadi Sadikin akan menjadi Wakil Komisaris Utama Pertamina dan Emma Sri Martini menjadi Direktur Keuangan @pertamina.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 17:21:43', 4, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(103, 'kumparancom', 'https://instagram.com/p/B5KdbivjBns', 654741, 4159, '@ustadzabdulsomad_official menilai bermain catur dan dadu adalah haram. Menurut UAS, kedua permainan tersebut kerap membuat lupa waktu, sehingga pada akhirnya membuat seseorang melalaikan salat. Pernyataan itu menurut UAS pun telah sesuai rujukan Mazhab Hanafi. Bagaimana menurut kamu, gaes?⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #uas #ustaz #abdulsomad #catur #dadu #dosa #haram #hukum #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 17:00:50', 4, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27'),
(104, 'kumparancom', 'https://instagram.com/p/B5KakLHgNpq', 654741, 11307, 'Hingga kini status @luisleeds masih berkewarganegaraan ganda: Australia dan Indonesia. Hal itu tak diperbolehkan secara hukum jika Luis ingin bertanding Formula 1 mewakili Indonesia. Namun, Luis sudah menetapkan pilihan. Ia ingin menjadi Indonesia seutuhnya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSPORT #f1 #balap #mobil #balapmobil #luisleeds #atlet #kejuaraan #biografi #infografik #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 16:30:15', 4, 0, 0, 0, '2019-11-28 05:05:27', '2019-11-28 05:05:27');
INSERT INTO `tbl_crawling` (`id_crawling`, `ig_username`, `url`, `follower_count`, `like_count`, `caption_text`, `taken_at`, `time_frame`, `is_extracted`, `is_normalized`, `is_classified`, `created`, `updated`) VALUES
(105, 'kumparancom', 'https://instagram.com/p/B5KWSd-FJ9a', 654741, 4355, 'Peraturan penulisan ucapan cake oleh @touslesjoursid menuai kontroversi. Dalam aturan tersebut, konsumen dilarang merekues ucapan yang tak sesuai dengan syariat Islam. Menurut pihak TOUS les JOUR, aturan tersebut bukanlah peraturan resmi yang dikeluarkan perusahaan. Pihak TOUS les JOURS juga memastikan dalam menjalankan usahanya sangat mengedepankan toleransi.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanFOOD #bakery #kue #roti #toko #aturan #viral #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 15:53:24', 3, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(106, 'kumparancom', 'https://instagram.com/p/B5KQiKCAakG', 654741, 17952, 'Gaji Staf Khusus Presiden adalah sebesar Rp 51 juta. Besaran itu diatur dalam Peraturan Presiden (Perpres) Nomor 144 Tahun 2015. Gaji tersebut merupakan pendapatan keseluruhan dan sudah termasuk di dalamnya gaji pokok, tunjangan kinerja, dan tunjangan pajak penghasilan. Selain itu, Staf Khusus Presiden juga tidak memperoleh rumah dan kendaraan dinas.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 15:02:35', 3, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(107, 'kumparancom', 'https://instagram.com/p/B5KM9g-j2hw', 654741, 7859, 'Mewakili Indonesia di ajang balap mobil F1 adalah impian @luisleeds. Namun, sanggupkah Luis mewujudkannya? Berikut sepak terjang karier dan prestasi Luis.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSPORT #f1 #balap #mobil #balapmobil #luisleeds #atlet #kejuaraan #biografi #infografik #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 14:31:22', 3, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(108, 'kumparancom', 'https://instagram.com/p/B5KJddMDfD2', 654741, 9388, 'Ketua DPP PKS, @mardanialisera, mengapresiasi pilihan Jokowi terhadap milenial termasuk penyandang disabilitas tersebut. Namun, dia mempertanyakan peran dan tugas tiap stafsus. Ia khawatir pengangkatan stafsus ini berpotensi tumpang tindih dengan struktur staf kepresidenan, yang juga bertugas membantu Presiden @jokowi.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 14:00:47', 3, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(109, 'kumparancom', 'https://instagram.com/p/B5KF9pXAHDg', 654741, 4206, 'Jaksa Agung Israel, Avichai Mandelblit, mendakwa Perdana Menteri Israel @b.netanyahu atas tuduhan korupsi. Dalam keterangannya, Avichai mengajukan tuntutan terhadap Netanyahu terkait sejumlah pelanggaran seperti suap, penipuan, dan penyalahgunaan kepercayaan. Namun, walau sudah didakwa, Netanyahu tetap dianggap tak bersalah hingga dijatuhkan vonis akhir.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #presiden #netanyahu #korupsi #dakwa #pengadilan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 13:30:13', 3, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(110, 'kumparancom', 'https://instagram.com/p/B5KAWLWl91K', 654741, 5559, 'Seorang suporter Indonesia mengalami luka robek di bagian tangan saat menyaksikan laga Kualifikasi Piala Dunia 2022 Indonesia vs Malaysia di Stadion Bukit Jalil, Selasa (19/11. Luka tersebut akibat serangan dari oknum suporter Malaysia. Saat dikonfirmasi, KBRI Malaysia pun membenarkan hal itu.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #bola #sepakbola #malaysia #indonesia #kbri #terorbom #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 12:41:40', 2, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(111, 'kumparancom', 'https://instagram.com/p/B5J9GByoKMm', 654741, 8963, 'Karier @basukibtp alias Ahok ternyata belum tamat. Meredup di jalur politik akibat kasus penistaan agama, kini mantan gubernur DKI Jakarta itu akan menduduki jabatan Komisaris Utama Pertamina. Beban dan harapan disematkan ke pundaknya oleh pemerintah, seiring riuh penolakan dari internal Pertamina. Mampukah Ahok menghadapinya?⁠ #AhokisBack\n-⁠\nSimak selengkapnya di kum.pr/ahokisback, atau klik link pada bio. Dan, jangan lupa subscribe untuk mendapatkan notifikasi jika ada story terbaru.⁠\n-⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 12:12:43', 2, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(112, 'kumparancom', 'https://instagram.com/p/B5J2acLIzYK', 654741, 8152, 'Tiga suporter asal Bali ditahan polisi Malaysia dalam pertandingan Indonesia vs Malaysia di Stadion Bukit Jalil, Kuala Lumpur, Selasa (19/11). Mereka ditahan diduga karena teror bom di media sosial. Ketua Aliansi Suporter Indonesia Malaysia Luki Ardianto mengatakan, pihaknya telah meminta bantuan pengacara untuk menangani kasus ini.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #bola #sepakbola #malaysia #indonesia #kbri #terorbom #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 11:14:21', 2, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(113, 'kumparancom', 'https://instagram.com/p/B5JoRTnFD6U', 654741, 16038, 'Sedikit lagi, mantan gubernur DKI Jakarta, @basukibtp akan menjabat sebagai Komisaris Utama PT. Pertamina. Kira-kira, kebijakan baru apa saja, ya, yang akan Ahok buat?\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-22 09:10:46', 2, 0, 0, 0, '2019-11-28 05:05:29', '2019-11-28 05:05:29'),
(114, 'kumparancom', 'https://instagram.com/p/B5IUHQCIRiB', 654741, 2595, 'Otoritas Israel pada Rabu (20/11) menutup Palestine TV yang beroperasi di Yerusalem. Stasiun TV tersebut diberi waktu enam bulan untuk menutup segala bentuk operasionalnya. Menteri Keamanan Israel, Gilad Erdan mengatakan, penutupan Palestine TV adalah bagian penegakan kedaulatan Israel di Yerusalem. Sebab, media itu diduga kerap menyebarkan propaganda anti-Israel.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #israel #yerusalem #tv #stasiuntv #boikot #tutup #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 21:00:57', 5, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(115, 'kumparancom', 'https://instagram.com/p/B5IRPMiA3L6', 654741, 5802, 'Per November 2019 ini, jumlah utang Perum Bulog ke perbankan nyaris mencapai Rp 28 triliun. Angkanya terus membengkak dibandingkan tahun 2017 lalu yang hanya Rp 13,2 triliun.⁠\n-⁠\nDirektur Utama Perum Bulog, Budi Waseso, dibuat gelisah karena Bulog terlilit utang cukup besar. Dia mengungkapkan utang Bulog makin bertambah karena pengadaan beras baik dari dalam negeri maupun luar negeri.⁠\n-⁠\nHmm, bagaimana ini, gaes?⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #bulog #buwas #perumbulog #angka #utang #triliun #utangbulog #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 20:30:15', 5, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(116, 'kumparancom', 'https://instagram.com/p/B5IN577jahJ', 654741, 11055, 'Ketua KPK Agus Rahardjo menjawab polemik diundangnya Ustaz Abdul Somad (UAS) ke kantornya pada Selasa (19/11). Ia mengaku, undangan terhadap UAS itu bukan dari KPK secara lembaga.⁠\n-⁠\nStaf yang mengundang UAS tersebut tergabung dalam organisasi kegiatan keagamaan internal, yaitu Badan Amal Islam KPK (BAIK). Agus menyampaikan, ia bahkan sudah mencegah BAIK untuk mengundang UAS. ⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #uas #ustaz #kpk #abdulsomad #tausiah #aguskpk #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 20:01:08', 5, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(117, 'kumparancom', 'https://instagram.com/p/B5IHgW1AHEW', 654741, 9086, 'Berniat membantu rekannya dengan meminjamkan KTP, nama Dimas Agung Prayitno justru dicatut untuk menyicil mobil mewah Rolls-Royce Phantom. Atas hal itu, Dimas pun kerap mendapatkan surat tagihan dari bank. Setelah ditelusuri di kantor pajak, Dimas tercatat telah menunggak pajak setahun, dengan nilai tunggakan nyaris Rp 200 juta.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #mobil #mobilmewah #rollroyce #tunggakan #bank #ktp #catutktp #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 19:10:22', 5, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(118, 'kumparancom', 'https://instagram.com/p/B5IGVYnAmRD', 654741, 16816, 'Presiden @jokowi mengenalkan 7 nama sebagai staf khusus kepresidenan yang baru di Istana Merdeka, Jakarta Pusat, Kamis (21/11). Dari 7 nama ini, staf khusus Jokowi didominasi oleh kalangan milenial.⁠\n-⁠\nMereka adalah pendiri Ruangguru Adamas Belva Syah Devara, CEO dan Founder CreativePreneur Putri Indahsari Tanjung, CEO PT Amartha Mikro Fintek Andi Taufan Garuda Putra, perumus Gerakan Sabang Merauke Ayu Kartika Dewi, putra asli Papua dan CEO Kitong Bisa Gracia Billy Mambrasar, penyandang disabilitas yang aktif di bidang sociopreneur Angkie Yudistia, dan mantan Ketua Umum PB PMII Aminudin Maruf.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 18:54:59', 5, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(119, 'kumparancom', 'https://instagram.com/p/B5HsEcUAQJz', 654741, 11890, 'Presiden @Jokowi akan segera mengumumkan stafsusnya hari ini, di antaranya dari kalangan milenial. Sekjen PPP, Arsul Sani, sebagai salah satu partai pengusung Jokowi, mengonfirmasi hal itu. Namun, Arsul belum mengetahui jumlah stafsus yang dibutuhkan Jokowi di periode kedua ini. Dia menyebut salah satu nama milenial yang akan jadi stafsus adalah anak konglomerat Chairul Tanjung, @putri_tanjung.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #jokowi #presidenjokowi #stafsus #stafkhusus #sekjenppp #konglomerat #arsulsani #partai #milenial #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 15:10:38', 3, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(120, 'kumparancom', 'https://instagram.com/p/B5HoCvtDXjW', 654741, 6125, '@basukibtp alias Ahok menanggapi santai soal Federasi Serikat Pekerja Pertamina Bersatu (FSPPB) yang menentangnya menjadi Komisaris Utama PT Pertamina. Dia beranggapan bahwa penolakan merupakan hal yang wajar.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #rizalramli #quote #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 14:30:18', 3, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(121, 'kumparancom', 'https://instagram.com/p/B5Hkpt5DSpG', 654741, 9000, 'Kopilot Wings Air Nicolaus Anjar Aji ditemukan tewas tergantung di kamar indekosnya di Kalideres, Jakarta Barat. Polisi menduga aksi bunuh diri ini terkait dengan pemecatan Nicolaus dari perusahaannya.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanNEWS #pilot #kopilot #bunuhdiri #wingsair #gantungdiri #kasus #polisi #meninggaldunia #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 14:00:40', 3, 0, 0, 0, '2019-11-28 05:05:30', '2019-11-28 05:05:30'),
(122, 'kumparancom', 'https://instagram.com/p/B5HdMlBIzh1', 654741, 4039, 'Bank DKI melaporkan kasus dugaan pembobolan rekening yang dilakukan oleh anggota Satpol PP DKI Jakarta. Pembobolan ini merugikan Bank DKI hingga Rp 32 miliar. 12 Satpol PP yang diduga membobol ATM modusnya dengan mengambil uang di ATM Bersama tanpa membuat saldo rekening mereka berkurang.\n-\nOtoritas Jasa Keuangan (OJK) menyatakan telah menerima laporan terkait kasus pembobolan rekening di Bank DKI ini beberapa bulan yang lalu. Bank DKI pun telah melakukan perbaikan dalam proses transaksi melalui ATM.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #ojk #atm #satpolpp #bankdki #bobolatm #pembobolan #rekening #dki #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 13:00:38', 3, 0, 0, 0, '2019-11-28 05:05:31', '2019-11-28 05:05:31'),
(123, 'kumparancom', 'https://instagram.com/p/B5HW5tKgNxW', 654741, 5382, 'Ketua PP Muhammadiyah Prof Bahtiar Effendy meninggal dunia. Ia mengembuskan nafas terakhir di ICU RSIJ Cempaka Putih, pada Kamis (21/11) pukul 00.00 dini hari. Sebelumnya, Bahtiar sudah beberapa hari dirawat di RSIJ Cempaka Putih. Sejak Rabu (20/11), kondisinya menurun. Jenazah Bahtiar akan dikebumikan pada Kamis (21/11) setelah zuhur di pemakaman Lamperes, Depok.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #muhammadiyah #profbahtiar #effendy #bahtiareffendywafat #ketuappmuhammadiyah #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 12:00:31', 2, 0, 0, 0, '2019-11-28 05:05:31', '2019-11-28 05:05:31'),
(124, 'kumparancom', 'https://instagram.com/p/B5HIk2mga9j', 654741, 4250, 'Mantan Gubernur DKI Jakarta, Basuki Tjahaja Purnama alias Ahok, mengkritik balik pernyataan Rizal Ramli yang menyebut kapasitasnya kelas Glodok, sehingga tak pantas menjadi Komisaris Utama PT Pertamina. Menurut @basukibtp, kelas Glodok justru kerap memiliki beragam usaha yang sukses.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠⠀⁠\n-⁠⠀⁠\n#kumparanBISNIS #ahok #btp #basukitjahajapurnama #pertamina #jabatan #rizalramli #quote #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-11-21 10:00:33', 2, 0, 0, 0, '2019-11-28 05:05:31', '2019-11-28 05:05:31'),
(125, 'ridwankamil', 'https://instagram.com/p/B5T15mogc5I', 11234545, 107504, 'SELAMAT & TERIMA KASIH para pelajar Jawa Barat yang kembali menjadi juara umum 3 tahun berturut-turut dan Pekan Olahraga Pelajar Nasional XV tahun 2019 ini di Jakarta. .\n\nKamu-kamu adalah luar biasa.\n\nSesuai semboyan “Mens sana in corpore sano” yaitu menang di sana juara di sini. \n#JABARJUARA', '2019-11-26 08:22:16', 2, 0, 0, 0, '2019-11-28 05:05:36', '2019-11-28 05:05:36'),
(126, 'ridwankamil', 'https://instagram.com/p/B5RqvqnApKV', 11234545, 110205, 'Ini adalah Ibu Nunung Nurhasanah, guru jaman saya sekolah di SD Banjarsari Bandung, sekitar 35 tahun yang lalu. Beliau selain mengajari saya di kelas,  juga aktif mengarahkan dan memotivasi saya untuk menyalurkan energi motoriknya dengan aktif ikut organisasi: Pramuka, Pengibar Bendera dan ikut grup menari.\n\nWaktu SD saya hiper aktif dan agak bengal. Pernah main bola di kelas sampai memecahkan kaca ruang guru di sebelahnya. Pernah dihukum bersihkan WC selama seminggu tiap jam istirahat. Ibu Nunung lah yang menasehati saya dengan sabar. Dan buahnya, sebagian aspek kepemimpinan saya hari ini datang dari nasehat2 beliau. \nDi rumah, orangtua adalah guru kita. Sebaliknya, di sekolah, guru lah pengganti orang tua kita.\n\nAda sedikit bantuan ibadah umrah untuk Ibu Nunung dan suami sesuai cita-citanya. Hal yang sedikit dibanding ilmu yang diberikan Ibu kepada saya. Semoga manfaat dan mabrur.\n\nTerima kasih untuk Ibu Nunung dan guru-guru teladan lainnya se Indonesia yang selalu bersabar dalam mendidik kami para muridnya. .\n\nSelamat Hari Guru.', '2019-11-25 12:12:38', 2, 0, 0, 0, '2019-11-28 05:05:37', '2019-11-28 05:05:37'),
(127, 'ridwankamil', 'https://instagram.com/p/B5O5aPWAYCl', 11234545, 139875, '“Bunga-bunga Cinta di kebun pernikahan itu harus rajin dirawat dan dijaga”\n\nAda puluhan ribu pasangan di Jawa Barat mengajukan gugatan perceraian setiap tahun. Kebanyakan karena faktor ekonomi dan perselingkuhan. Apalagi godaan yang hilir mudik melalui media sosial atau digital.\nSuatu fenomena sosial yang mengkhawatirkan.\n\nKepada yang sudah menikah semoga kehangatan cintanya selalu dirawat dan dijaga dari godaan yang datang menghampiri.\n\nSelamat berhari Minggu. #JanganLupaBahagia bersama yang dicinta.', '2019-11-24 10:16:44', 2, 0, 0, 0, '2019-11-28 05:05:37', '2019-11-28 05:05:37'),
(128, 'viceind', 'https://instagram.com/p/B5XB-FlgqHc', 341855, 37403, 'Bisnis perumahan eksklusif Islami—dilengkapi dewan syuro dan hukum syariah—berkembang pesat. Ada kekhawatiran tren ini merusak kohesi sosial. Penghuni pada VICE mengaku ingin bebas menjalankan agama. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n?Muhammad Ishomuddin', '2019-11-27 14:05:27', 3, 0, 0, 0, '2019-11-28 05:05:42', '2019-11-28 05:05:42'),
(129, 'viceind', 'https://instagram.com/p/B5W0MOCDhO6', 341855, 24414, 'Penyanyi 33 tahun ini jadi trending topic di Twitter, gara-gara mengaku ke media asing kalau dia tidak berdarah Indonesia. Buat kalian yang sewot sama penyanyi pop 33 tahun itu, emang apa sih yang bisa kita sebut sebagai \"darah Indonesia\"? #opini\n-\nSelengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Matt Winklemeyer/AFP', '2019-11-27 12:05:03', 2, 0, 0, 0, '2019-11-28 05:05:42', '2019-11-28 05:05:42'),
(130, 'viceind', 'https://instagram.com/p/B5UckzUgDvO', 341855, 29885, 'Instant Pot adalah penemuan penting bagi jagat kuliner. Alat masak ini segera ngetren dan muncul dalam berbagai variasi fungsinya selama beberapa tahun terakhir. Intinya, Instant Pot merupakan kombinasi panci presto dan slow cooker ala-ala magic jar yang biasa kalian pakai menanak nasi. Instant Pot, yang pertama kali muncul di pasaran pada 2010, ternyata bisa dipakai untuk berbagai kebutuhan memasak. Termasuk, menghasilkan fermentasi anggur merah di rumah kalian sendiri. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Alachua Country/Flickr', '2019-11-26 14:00:13', 3, 1, 1, 1, '2019-11-28 05:05:43', '2019-11-29 13:23:59'),
(131, 'viceind', 'https://instagram.com/p/B5NbKHcA1hh', 341855, 21021, 'Kamu berhak mau balas chat atau enggak, terutama kalau kamu enggak menyukai orang yang menghubungimu. Selengkapnya di VICE.com. Link di bio. #viceindonesia', '2019-11-23 20:33:09', 5, 1, 1, 1, '2019-11-28 05:05:43', '2019-11-29 13:20:24'),
(132, 'humas.jateng', 'https://instagram.com/p/B5m0WwClxQQ', 11445, 499, 'Five, four, three, two, one, #CloseTheDoor!\nFamiliar sama dengan jargonnya? ?\n\nAkan ada bincang-bincang seru dan menarik. Pakdhe @ganjar_pranowo bersama mantan pesulap kenamaan Indonesia siapa lagi kalau bukan mas @mastercorbuzier \nTunggu tanggal mainnya ya #SahabatHumas ??\n———\n#HumasJateng #GanjarPranowo #DeddyCorbuzier #JatengGayeng #JawaTengah', '2019-12-03 17:14:20', 4, 1, 1, 1, '2019-12-04 13:22:36', '2019-12-04 14:02:21'),
(133, 'humasprovjatim', 'https://instagram.com/p/B5l4kaWABZ9', 10649, 290, 'Saat menjadi inspektur upacara peringatan HUT KORPRI ke 48, di halaman Grahadi, Senin (2/12) kemarin, Gubernur Jawa Timur @khofifah.ip meminta ASN di jajaran Pemprov Jawa Timur untuk berpikir lateral (lateral thinking) atau berpikir melompat. Sesuai arahan Presiden Joko Widodo, seluruh ASN harus membuat inovasi dan juga melakukan perubahan agar percepatan layanan masyarakat bisa terwujud. Percepatan layanan itu salah satunya bisa dilakukan dengan maksimalisi pemanfaatan teknologi.\n.\nDalam bekerja ASN tidak sekedar melakukan yang lebih baik dari kemarin. Tapi harus melakukan hal yang lebih baik dari negara lain. Oleh sebab itu berpikir melompat harus menjadi poin penekanan dalam cara kerja ASN.  Pasalnya saat ini tantangan dalam penerapan lateral thinking adalah ASN dalam bekerja senantiasa dalam format  struktural. Dimana cara kerja dan kordinasi  birokrasi harus sesuai dengan jenjang stuktural birokrasi. Sehingga terkesan strukturalis. Saat ini dibutuhkan format agar lebih fungsional. .\n.\n.\n#gubernurjatim #khofifah #korpri #harikorpri #harikorpri2019', '2019-12-03 08:31:55', 2, 1, 1, 1, '2019-12-04 13:22:38', '2019-12-04 14:01:47'),
(134, 'humas_jabar', 'https://instagram.com/p/B5nU_83hSik', 89274, 451, 'Salah satunya dengan mendesain kota baru di sekitar pelabuhan Patimban, supaya akses menuju pelabuhan tertata?\n.\n“ Saya sudah minta ke JICA bulan Januari 2020 untuk mulai mendesain masterplan sebuah kota, sehingga jelas kalau mau ada pusat pemerintahan Subang silakan, rekreasi, industri dan lainnya. Akhirnya (Patimban) menjadi contoh pelabuhan di Indonesia” - Ridwan Kamil, Gubernur Jawa Barat.\n.\n.\n#JabarKita #JabarJuaraLahirBatin\nDok Humas Jabar @yanaimisiana .\n.\n#banggajadiwargajabar #jawabarat #jabar #HumasJabar #gedungsate #westjava \n#RidwanKamil #UuRuzhanulUlum', '2019-12-03 21:59:35', 5, 1, 1, 1, '2019-12-04 13:22:41', '2019-12-04 14:00:23'),
(135, 'jokowi', 'https://instagram.com/p/B5mznYuh2Ly', 26899852, 313793, 'Disabilitas bukanlah penghalang seseorang untuk belajar, untuk bekerja, untuk maju.\n\nSaya ingin mengajak kita semua untuk memberikan perlakuan dan kesempatan yang sama pada saudara-saudara kita penyandang disabilitas untuk bersama-sama membangun bangsa.\n\nSelamat Hari Disabilitas Internasional.', '2019-12-03 17:07:52', 4, 1, 1, 1, '2019-12-04 13:22:43', '2019-12-04 13:59:53'),
(136, 'jokowi', 'https://instagram.com/p/B5l1UpZBXbO', 26899852, 309961, 'Selamat pagi. Menjelang akhir tahun 2019 ini, pembangunan jalan tol Trans Sumatra tetap berjalan. Panjang totalnya 2.974 kilometer, membelah Pulau Sumatra dari Lampung sampai Aceh, dan ditargetkan selesai tahun 2024.\n\nHingga akhir 2019 ini, Tol Trans Sumatra yang beroperasi adalah 501,16 kilometer!\n\nRuas-ruas yang telah rampung dan dapat dilalui adalah Bakauheni – Terbanggi Besar 141 kilometer, Terbanggi Besar - Pematang Panggang - Kayu Agung sepanjang 189 kilometer, Palembang – Indralaya 22 kilometer, Medan – Binjai 10,46 kilometer, Medan – Kualanamu – Tebing Tinggi 62,2 kilometer dan Belawan - Medan - Tanjung Morawa 43 kilometer. Dan yang segera beroperasi Desember ini adalah Kayu Agung-Jakabaring sepanjang 33,5 kilometer.\n\nJalan tol ini akan memangkas waktu tempuh antardaerah dan memperlancar arus distribusi barang dari pusat industri ke berbagai wilayah di Sumatra, dan menghidupkan titik-titik perekonomian baru di sepanjang Pulau Sumatra.', '2019-12-03 08:03:33', 2, 1, 1, 1, '2019-12-04 13:22:43', '2019-12-04 13:59:10'),
(137, 'kaltaraprov', 'https://instagram.com/p/B5mGqp6oPdB', 14414, 312, 'Salah satunya, adalah pembangunan jalan pendekat dari Tanjung Selor menuju Tanah Kuning. Kepala Bidang Bina Marga Dinas Pekerjaan Umum Penataan Ruang Perumahan dan Kawasan Permukiman (DPUR-Perkim) Kaltara, Yusran menjelaskan, jalan pendekat itu merupakan jalan baru dengan titik temu di Desa Binai dengan jarak 39,85 kilometer. Sementara jika dibandingkan dengan jalan yang ada sekarang berjarak 72,47 kilometer. “Dengan kata lain, jalan baru yang kita bangun nantinya akan memangkas 32,62 kilometer dengan jalan yang ada saat ini,” jelasnya.\n.\nJalan baru ini nantinya akan mendukung kegiatan di KIPI Tanah Kuning-Mangkupadi untuk mengangkut kendaraan yang bertonase besar. Menurutnya, jalan yang ada saat ini tidak layak digunakan untuk kegiatan industri. Lantaran fisik jalan yang sempit dan berkelok, di mana beban jalan yang ditanggung juga kecil. “Saat ini, proses pembentukan jalan masih berupa timbunan dan belum terkoneksi. Ini dibangun secara perlahan dan akan terus berprogress,” kata Yusran. (@abdul_khalik_p_barana)\n.\nCek keterangan lengkapnya di:\nhttps://humas.kaltaraprov.go.id\n.\n? by: dokumeninfopubdok\n.\n#kaltarapastiterdepan\n#kaltaraprov\n#infokaltara \n#beritakaltara19\n#humasprovkaltara \n#humprosetdakaltara', '2019-12-03 10:35:06', 2, 1, 1, 1, '2019-12-04 13:22:45', '2019-12-04 13:58:25'),
(138, 'kumparancom', 'https://instagram.com/p/B5nGyuPoNAN', 660574, 5731, 'Menantu Presiden @jokowi, Bobby Afif Nasution memantapkan niatnya mengikuti pemilihan Wali Kota Medan tahun 2020. Bobby menyerahkan formulir pendaftaran serta berkas persyaratan calon Wali Kota Medan ke kantor DPD PDIP Sumut, pada Selasa (3/12). Ia mengungkapkan, ini merupakan bentuk keseriusannya ingin terjun ke politik.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #bobby #pdip #jokowi #menantujokowi #presidenjokowi #walikotamedan #calonwalikota #calonwalikotamedan #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-12-03 20:01:21', 5, 1, 1, 1, '2019-12-04 13:22:48', '2019-12-04 13:57:42'),
(139, 'kumparancom', 'https://instagram.com/p/B5myynsjjwB', 660574, 4314, 'Seorang ibu di Makassar, Samina (42), memaksa anaknya (9) mengemis di sekitar Mall Panakkukang. Anaknya mengemis demi membayar arisan yang diikuti Samina. Perlakuan Samina kepada anaknya terungkap dari video yang beredar di media sosial pada Senin (2/12).⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #makassar #ibu #aniaya #penganiayaan #ibudananak #aniayaanak #kasus #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-12-03 17:00:40', 4, 1, 1, 1, '2019-12-04 13:22:48', '2019-12-04 13:56:22'),
(140, 'kumparancom', 'https://instagram.com/p/B5mnzxWAsxF', 660574, 7117, 'Cabang olahraga angkat besi kembali menyumbangkan medali emas untuk kontingen Indonesia di SEA Games 2019. Kali ini Deni mempersembahkannya dari nomor 69 kg putra di Ninoy Aquino Memorial Stadium, Selasa (3/12). Deni berhasil menorehkan angkatan terbaik dengan total beban 315 kg.⁠\n-⁠\nBerkat ini, Indonesia bisa melampaui jumlah perolehan emas Indonesia Malaysia di ajang SEA Games 2019. Indonesia menorehkan 11 emas, atau unggul 1 atas Malaysia.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanSPORT #deni #angkatbesi #seagames #seagames2019 #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-12-03 15:24:42', 3, 1, 1, 1, '2019-12-04 13:22:49', '2019-12-04 13:55:30'),
(141, 'kumparancom', 'https://instagram.com/p/B5mmhsOAx_N', 660574, 8228, 'Ditjen Bea dan Cukai Kemenkeu memastikan adanya 18 kotak selundupan yang dibawa melalui pesawat baru Airbus A330-900 Neo milik Garuda Indonesia. Kasubdit Komunikasi Dan Publikasi Bea Cukai Deni Surjantoro menegaskan, kotak itu milik penumpang VIP yang ikut dalam pendaratan pertama Airbus baru Garuda tersebut.⁠\n-⁠\n18 kotak selundupan tersebut terdiri dari 15 kotak yang berisi spare part motor Harley Davidson bekas dan sisanya merupakan unit sepeda lipat baru merek Brompton.⁠\n-⁠\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanBISNIS #pesawat #kemenkeu #pesawatgaruda #selundupan #sparepart #harley #brompton #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-12-03 15:13:30', 3, 1, 1, 1, '2019-12-04 13:22:49', '2019-12-04 13:54:03'),
(142, 'kumparancom', 'https://instagram.com/p/B5mDPuKD-Lc', 660574, 7353, 'Ledakan di Monas tak membuat aktivitas Presiden Jokowi terganggu. Jokowi tetap berkantor di Istana Negara, Jakarta, Selasa (3/12). Iring-iringan mobil kepresidenan tampak memasuki kompleks Istana sekitar pukul 08.50 WIB. Tampak penjagaan ketat oleh Paspampres di luar Istana. Sejumlah agenda kenegaraan rencananya akan diikuti @jokowi.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #bom #monas #bommonas #ledakan #ledakanjakarta #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-12-03 10:05:13', 2, 1, 1, 1, '2019-12-04 13:22:49', '2019-12-04 13:52:51'),
(143, 'kumparancom', 'https://instagram.com/p/B5mAsy2FGGb', 660574, 10147, 'Ledakan terjadi di Monas, Jakarta Pusat sekitar pukul 07.05 WIB, Selasa (3/12). Berdasarkan informasi yang diterima saat ini, ada dua korban terluka akibat insiden ini. Polri dan TNI masih berada di lokasi untuk melakukan penyelidikan dan olah TKP. Petugas telah meminta pengunjung untuk keluar dari area Monas.\n-\nSimak selengkapnya dengan klik link di bio, ﻿atau download aplikasi kumparan di App Store dan Google Play.⁠\n-⁠⠀⁠\n#kumparanNEWS #bom #monas #bommonas #ledakan #ledakanjakarta #trendingtopic #info #videoviral #videooftheday #beritahariini #berita #beritaterkini #terbaru #indonesia #viral #news #like4like #instalike #repost #instadaily #instanews #instavideo #kumparan', '2019-12-03 09:42:58', 2, 1, 1, 1, '2019-12-04 13:22:50', '2019-12-04 13:52:14'),
(144, 'viceind', 'https://instagram.com/p/B5m5m3Fgyfk', 346635, 17856, 'Sudah memaksa para ayam memproduksi telur lewat cara-cara tidak normal, kini setelah kelebihan kuota, jutaan ayam akan dibunuh begitu saja atas nama kontrol harga. Keputusan ini diambil Kementerian Pertanian (Kementan) pada 27 November lalu. Anjloknya harga ayam karena kelebihan suplai membuat 7 juta bibit ayam akan dimusnahkan setiap minggu sejak Desember 2019. Kata peternak lokal, ini semua gara-gara pemerintah membuka impor. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Ahmad Zamroni/AFP', '2019-12-03 18:00:14', 5, 1, 1, 1, '2019-12-04 13:22:56', '2019-12-04 13:45:15'),
(145, 'viceind', 'https://instagram.com/p/B5mQ96Sof_R', 346635, 25794, 'Startup pembuat matras Wakefit sedang mencari karyawan magang yang mau tidur sembilan jam penuh selama 100 malam, dengan iming-iming uang saku 100 Ribu Rupee atau setara Rp19,6 juta. Ini baru yang namanya pekerjaan ideal bagi kaum rebahan. Selengkapnya di VICE.com. Link di bio. #viceindonesia\n-\n? Kinga Chichewics/Unsplash', '2019-12-03 12:05:07', 2, 1, 1, 1, '2019-12-04 13:22:56', '2019-12-04 13:44:40');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_engines`
--

DROP TABLE IF EXISTS `tbl_engines`;
CREATE TABLE `tbl_engines` (
  `id_engine` int(11) NOT NULL,
  `ig_username` varchar(50) NOT NULL,
  `ig_password` varchar(50) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_engines`
--

INSERT INTO `tbl_engines` (`id_engine`, `ig_username`, `ig_password`, `created`, `updated`) VALUES
(1, 'demitaevnuri', 'evnurisl4lu', '2019-10-15 10:03:17', '2019-12-04 13:22:19'),
(2, 'demitaevnuri', 'evnurisl4lu', '2019-10-21 07:00:47', '2019-12-04 13:17:12');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_extractions`
--

DROP TABLE IF EXISTS `tbl_extractions`;
CREATE TABLE `tbl_extractions` (
  `id_extraction` int(11) NOT NULL,
  `id_crawling` int(11) NOT NULL,
  `keyword` varchar(50) NOT NULL,
  `is_normalize` tinyint(1) NOT NULL DEFAULT '0',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_extractions`
--

INSERT INTO `tbl_extractions` (`id_extraction`, `id_crawling`, `keyword`, `is_normalize`, `created`, `updated`) VALUES
(1, 131, 'berhak', 0, '2019-11-29 13:19:48', NULL),
(2, 131, 'balas', 0, '2019-11-29 13:19:48', NULL),
(3, 131, 'chat', 0, '2019-11-29 13:19:48', NULL),
(4, 130, 'instant', 0, '2019-11-29 13:22:28', NULL),
(5, 130, 'pot', 0, '2019-11-29 13:22:28', NULL),
(6, 130, 'kuliner', 0, '2019-11-29 13:22:28', NULL),
(7, 130, 'alat', 0, '2019-11-29 13:22:28', NULL),
(8, 130, 'masak', 0, '2019-11-29 13:22:28', NULL),
(9, 130, 'berbagai', 0, '2019-11-29 13:22:28', NULL),
(10, 130, 'variasi', 0, '2019-11-29 13:22:28', NULL),
(11, 130, 'panci', 0, '2019-11-29 13:22:28', NULL),
(12, 130, 'presto', 0, '2019-11-29 13:22:28', NULL),
(13, 130, 'slow', 0, '2019-11-29 13:22:28', NULL),
(14, 130, 'cooker', 0, '2019-11-29 13:22:28', NULL),
(15, 130, 'magic', 0, '2019-11-29 13:22:28', NULL),
(16, 130, 'jar', 0, '2019-11-29 13:22:28', NULL),
(17, 130, 'menanak', 0, '2019-11-29 13:22:28', NULL),
(18, 130, 'nasi', 0, '2019-11-29 13:22:28', NULL),
(19, 130, 'fermentasi', 0, '2019-11-29 13:22:28', NULL),
(20, 130, 'anggur', 0, '2019-11-29 13:22:28', NULL),
(21, 130, 'merah', 0, '2019-11-29 13:22:28', NULL),
(22, 145, 'wakefit', 0, '2019-12-04 13:44:24', NULL),
(23, 144, 'ayam', 0, '2019-12-04 13:44:57', NULL),
(24, 144, 'peternak', 0, '2019-12-04 13:44:57', NULL),
(25, 144, 'lokal', 0, '2019-12-04 13:44:57', NULL),
(26, 143, 'ledakan', 0, '2019-12-04 13:51:50', NULL),
(27, 143, 'monas', 0, '2019-12-04 13:51:50', NULL),
(28, 143, 'jakarta', 0, '2019-12-04 13:51:50', NULL),
(29, 142, 'ledakan', 0, '2019-12-04 13:52:32', NULL),
(30, 142, 'monas', 0, '2019-12-04 13:52:32', NULL),
(31, 142, 'jokowi', 0, '2019-12-04 13:52:32', NULL),
(32, 141, 'kemenkeu', 0, '2019-12-04 13:53:28', NULL),
(33, 141, 'selundupan', 0, '2019-12-04 13:53:28', NULL),
(34, 141, 'airbus', 0, '2019-12-04 13:53:28', NULL),
(35, 141, 'garuda', 0, '2019-12-04 13:53:28', NULL),
(36, 141, 'indonesia', 0, '2019-12-04 13:53:28', NULL),
(37, 141, 'harley', 0, '2019-12-04 13:53:28', NULL),
(38, 141, 'davidson', 0, '2019-12-04 13:53:28', NULL),
(39, 140, 'angkat', 0, '2019-12-04 13:54:44', NULL),
(40, 140, 'besi', 0, '2019-12-04 13:54:44', NULL),
(41, 140, 'menyumbangkan', 0, '2019-12-04 13:54:44', NULL),
(42, 140, 'sea', 0, '2019-12-04 13:54:44', NULL),
(43, 140, 'games', 0, '2019-12-04 13:54:44', NULL),
(44, 140, '2019', 0, '2019-12-04 13:54:44', NULL),
(45, 140, 'deni', 0, '2019-12-04 13:54:44', NULL),
(46, 139, 'samina', 0, '2019-12-04 13:56:04', NULL),
(47, 139, 'mengemis', 0, '2019-12-04 13:56:04', NULL),
(48, 138, '@jokowi', 0, '2019-12-04 13:57:05', NULL),
(49, 138, 'bobby', 0, '2019-12-04 13:57:05', NULL),
(50, 138, 'afif', 0, '2019-12-04 13:57:05', NULL),
(51, 138, 'nasution', 0, '2019-12-04 13:57:05', NULL),
(52, 138, 'pemilihan', 0, '2019-12-04 13:57:05', NULL),
(53, 138, 'wali', 0, '2019-12-04 13:57:05', NULL),
(54, 138, 'kota', 0, '2019-12-04 13:57:05', NULL),
(55, 138, 'medan', 0, '2019-12-04 13:57:05', NULL),
(56, 137, 'pembangunan', 0, '2019-12-04 13:58:05', NULL),
(57, 137, 'jalan', 0, '2019-12-04 13:58:05', NULL),
(58, 137, 'tanjung', 0, '2019-12-04 13:58:05', NULL),
(59, 137, 'selor', 0, '2019-12-04 13:58:05', NULL),
(60, 137, 'tanah', 0, '2019-12-04 13:58:05', NULL),
(61, 137, 'kuning', 0, '2019-12-04 13:58:05', NULL),
(62, 136, 'pembangunan', 0, '2019-12-04 13:58:48', NULL),
(63, 136, 'jalan', 0, '2019-12-04 13:58:48', NULL),
(64, 136, 'tol', 0, '2019-12-04 13:58:48', NULL),
(65, 136, 'trans', 0, '2019-12-04 13:58:48', NULL),
(66, 136, 'sumatra', 0, '2019-12-04 13:58:48', NULL),
(67, 135, 'disabilitas', 0, '2019-12-04 13:59:26', NULL),
(68, 135, 'selamat', 0, '2019-12-04 13:59:26', NULL),
(69, 135, 'hari', 0, '2019-12-04 13:59:26', NULL),
(70, 135, 'disabilitas', 0, '2019-12-04 13:59:26', NULL),
(71, 135, 'internasional', 0, '2019-12-04 13:59:26', NULL),
(72, 134, 'pelabuhan', 0, '2019-12-04 14:00:11', NULL),
(73, 134, 'patimban', 0, '2019-12-04 14:00:11', NULL),
(74, 133, 'hut', 0, '2019-12-04 14:00:44', NULL),
(75, 133, 'korpri', 0, '2019-12-04 14:00:44', NULL),
(76, 133, 'ke', 0, '2019-12-04 14:00:44', NULL),
(77, 133, '48', 0, '2019-12-04 14:00:44', NULL),
(78, 133, '@khofifahip', 0, '2019-12-04 14:00:44', NULL),
(79, 133, 'joko', 0, '2019-12-04 14:00:44', NULL),
(80, 133, 'widodo', 0, '2019-12-04 14:00:44', NULL),
(81, 132, '@ganjar_pranowo', 0, '2019-12-04 14:01:57', NULL),
(82, 132, '@mastercorbuzier', 0, '2019-12-04 14:01:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_labels`
--

DROP TABLE IF EXISTS `tbl_labels`;
CREATE TABLE `tbl_labels` (
  `id_label` int(11) NOT NULL,
  `label_name` varchar(50) NOT NULL,
  `label_desc` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_labels`
--

INSERT INTO `tbl_labels` (`id_label`, `label_name`, `label_desc`, `created`, `updated`) VALUES
(1, 'Nilai Sosial', 'memiliki nilai di sosial masyarakat, orang berbagi karena merasa akan terlihat bagus', '2019-10-29 10:16:39', NULL),
(2, 'Penghubung', 'menghubungkan pada hal lain, tip of mind, tip of tounge', '2019-10-29 10:16:39', NULL),
(3, 'Sisi Emosional', 'ya udah sisi emosional aja', '2019-10-29 10:16:39', NULL),
(4, 'Publik', 'orang atau orang orang yang mempengaruhi orang lain', '2019-10-29 10:16:39', NULL),
(5, 'Tips', 'This is for Tips', '2019-10-29 10:16:39', NULL),
(6, 'Cerita', 'This is For Story', '2019-10-29 10:16:39', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_normalizations`
--

DROP TABLE IF EXISTS `tbl_normalizations`;
CREATE TABLE `tbl_normalizations` (
  `id_normalization` int(11) NOT NULL,
  `id_crawling` int(11) NOT NULL,
  `id_extraction` int(11) NOT NULL,
  `normal_text` varchar(50) NOT NULL,
  `id_label` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_normalizations`
--

INSERT INTO `tbl_normalizations` (`id_normalization`, `id_crawling`, `id_extraction`, `normal_text`, `id_label`, `created`) VALUES
(1, 131, 1, 'hak', 0, '2019-11-29 13:20:06'),
(2, 131, 2, 'balas chat', 0, '2019-11-29 13:20:06'),
(3, 130, 4, 'instant pot', 0, '2019-11-29 13:23:23'),
(4, 130, 6, 'kuliner', 0, '2019-11-29 13:23:23'),
(5, 130, 7, 'alat masak', 0, '2019-11-29 13:23:23'),
(6, 130, 11, 'panci presto', 0, '2019-11-29 13:23:23'),
(7, 130, 13, 'slow cooker', 0, '2019-11-29 13:23:23'),
(8, 130, 15, 'magic jar', 0, '2019-11-29 13:23:23'),
(9, 130, 17, 'menanak nasi', 0, '2019-11-29 13:23:23'),
(10, 130, 19, 'fermentasi anggur', 0, '2019-11-29 13:23:23'),
(11, 145, 22, 'wakefit', 0, '2019-12-04 13:44:31'),
(12, 144, 23, 'ayam', 0, '2019-12-04 13:45:05'),
(13, 144, 24, 'peternak lokal', 0, '2019-12-04 13:45:05'),
(14, 143, 26, 'ledakan', 0, '2019-12-04 13:51:54'),
(15, 143, 27, 'monas', 0, '2019-12-04 13:51:54'),
(16, 143, 28, 'jakarta', 0, '2019-12-04 13:51:54'),
(17, 142, 29, 'ledakan', 0, '2019-12-04 13:52:37'),
(18, 142, 30, 'monas', 0, '2019-12-04 13:52:37'),
(19, 142, 31, 'jokowi', 0, '2019-12-04 13:52:37'),
(20, 141, 32, 'kemenkeu', 0, '2019-12-04 13:53:43'),
(21, 141, 33, 'selundupan', 0, '2019-12-04 13:53:43'),
(22, 141, 34, 'airbus', 0, '2019-12-04 13:53:43'),
(23, 141, 35, 'garuda indonesia', 0, '2019-12-04 13:53:43'),
(24, 141, 37, 'harley davidson', 0, '2019-12-04 13:53:43'),
(25, 140, 39, 'angkat besi', 0, '2019-12-04 13:55:10'),
(26, 140, 42, 'sea games 2019', 0, '2019-12-04 13:55:10'),
(27, 140, 45, 'deni', 0, '2019-12-04 13:55:10'),
(28, 139, 46, 'samina', 0, '2019-12-04 13:56:13'),
(29, 139, 47, 'mengemis', 0, '2019-12-04 13:56:13'),
(30, 138, 48, 'jokowi', 0, '2019-12-04 13:57:32'),
(31, 138, 49, 'bobby afif nasution', 0, '2019-12-04 13:57:32'),
(32, 138, 52, 'pemilihan wali kota medan', 0, '2019-12-04 13:57:32'),
(33, 137, 56, 'pembangunan jalan', 0, '2019-12-04 13:58:16'),
(34, 137, 58, 'tanjung selor', 0, '2019-12-04 13:58:16'),
(35, 137, 60, 'tanah kuning', 0, '2019-12-04 13:58:16'),
(36, 136, 62, 'pembangunan jalan tol', 0, '2019-12-04 13:59:03'),
(37, 136, 65, 'trans sumatra', 0, '2019-12-04 13:59:03'),
(38, 135, 67, 'disabilitas', 0, '2019-12-04 13:59:40'),
(39, 135, 68, 'selamat hari disabilitas internasional', 0, '2019-12-04 13:59:40'),
(40, 134, 72, 'pelabuhan patimban', 0, '2019-12-04 14:00:17'),
(41, 133, 74, 'hut korpri ke 48', 0, '2019-12-04 14:01:28'),
(42, 133, 78, 'Khofifah Indar Parawansa', 0, '2019-12-04 14:01:28'),
(43, 133, 79, 'joko widodo', 0, '2019-12-04 14:01:28'),
(44, 132, 81, 'ganjar pranowo', 0, '2019-12-04 14:02:13'),
(45, 132, 82, 'deddy corbuzier', 0, '2019-12-04 14:02:13');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_results`
--

DROP TABLE IF EXISTS `tbl_results`;
CREATE TABLE `tbl_results` (
  `id_user` int(11) NOT NULL,
  `day_count` int(3) NOT NULL,
  `category` varchar(20) NOT NULL,
  `normal_text` varchar(50) NOT NULL,
  `modus` int(3) NOT NULL,
  `total_px` int(3) NOT NULL,
  `p_value` float NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_scraping`
--

DROP TABLE IF EXISTS `tbl_scraping`;
CREATE TABLE `tbl_scraping` (
  `id` int(11) NOT NULL,
  `ig_username` varchar(100) NOT NULL,
  `url` text NOT NULL,
  `follower_count` int(11) NOT NULL,
  `like_count` int(11) NOT NULL,
  `comment_count` int(11) NOT NULL,
  `response_count` int(11) NOT NULL,
  `taken_at` datetime NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_scraping`
--

INSERT INTO `tbl_scraping` (`id`, `ig_username`, `url`, `follower_count`, `like_count`, `comment_count`, `response_count`, `taken_at`, `created`, `updated`) VALUES
(40, 'humasprovjatim', 'https://instagram.com/p/B52E84clpmM', 10850, 48, 0, 0, '2019-12-09 15:28:47', '2019-12-10 04:29:07', NULL),
(41, 'humas_jabar', 'https://instagram.com/p/B52cm5DB_rv', 89681, 140, 1, 0, '2019-12-09 18:54:41', '2019-12-10 04:29:27', NULL),
(42, 'humas_jabar', 'https://instagram.com/p/B52MH-BBYgH', 89681, 160, 0, 0, '2019-12-09 16:30:39', '2019-12-10 04:29:48', NULL),
(43, 'humas_jabar', 'https://instagram.com/p/B513s6WhO0_', 89681, 321, 7, 4, '2019-12-09 13:32:11', '2019-12-10 04:30:08', NULL),
(44, 'humas_jabar', 'https://instagram.com/p/B51SOwehO5C', 89681, 209, 0, 0, '2019-12-09 08:04:46', '2019-12-10 04:30:27', NULL),
(45, 'kaltaraprov', 'https://instagram.com/p/B51_eFmgfwJ', 14520, 161, 0, 0, '2019-12-09 14:40:04', '2019-12-10 04:30:48', NULL),
(46, 'kaltaraprov', 'https://instagram.com/p/B518Cc-Ajy_', 14520, 132, 0, 0, '2019-12-09 14:10:05', '2019-12-10 04:31:06', NULL),
(47, 'kaltaraprov', 'https://instagram.com/p/B51xvdGoLgE', 14520, 261, 0, 0, '2019-12-09 12:40:06', '2019-12-10 04:31:25', NULL),
(48, 'kaltaraprov', 'https://instagram.com/p/B51ncCSAHOE', 14520, 94, 0, 0, '2019-12-09 11:10:04', '2019-12-10 04:31:44', NULL),
(49, 'kaltaraprov', 'https://instagram.com/p/B51jqvFH-Rc', 14520, 50, 0, 0, '2019-12-09 10:37:58', '2019-12-10 04:32:03', NULL),
(50, 'kaltaraprov', 'https://instagram.com/p/B51gk0QoB3n', 14520, 167, 0, 0, '2019-12-09 10:10:06', '2019-12-10 04:32:28', NULL),
(51, 'kumparancom', 'https://instagram.com/p/B52qZKoj8Dt', 667094, 625, 20, 0, '2019-12-09 21:01:00', '2019-12-10 04:32:51', NULL),
(52, 'kumparancom', 'https://instagram.com/p/B52nitujvRy', 667094, 338, 4, 0, '2019-12-09 20:30:14', '2019-12-10 04:33:11', NULL),
(53, 'kumparancom', 'https://instagram.com/p/B52iYD3DOxw', 667094, 3524, 121, 0, '2019-12-09 19:45:05', '2019-12-10 04:33:58', NULL),
(54, 'kumparancom', 'https://instagram.com/p/B52W-iMAED-', 667094, 35499, 568, 0, '2019-12-09 18:10:37', '2019-12-10 04:35:28', NULL),
(55, 'kumparancom', 'https://instagram.com/p/B52WceRl80D', 667094, 12399, 681, 0, '2019-12-09 18:00:50', '2019-12-10 04:37:12', NULL),
(56, 'kumparancom', 'https://instagram.com/p/B52WJyolXoJ', 667094, 1502, 24, 0, '2019-12-09 17:58:17', '2019-12-10 04:37:33', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_targets`
--

DROP TABLE IF EXISTS `tbl_targets`;
CREATE TABLE `tbl_targets` (
  `id_target` int(11) NOT NULL,
  `ig_username` varchar(50) NOT NULL,
  `id_admin` int(11) NOT NULL,
  `id_engine` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_targets`
--

INSERT INTO `tbl_targets` (`id_target`, `ig_username`, `id_admin`, `id_engine`, `created`, `updated`) VALUES
(1, 'aniesbaswedan', 2, 2, '2019-11-21 22:49:01', '2019-12-06 06:47:24'),
(2, 'humas.jateng', 5, 2, '2019-11-21 22:53:05', '2019-12-10 04:38:16'),
(3, 'humasprovjatim', 2, 2, '2019-11-21 22:49:01', '2019-12-10 04:38:21'),
(4, 'humas_jabar', 2, 1, '2019-11-21 22:53:05', '2019-12-06 03:40:45'),
(5, 'jokowi', 2, 2, '2019-11-21 22:53:05', '2019-12-10 04:26:44'),
(6, 'kaltaraprov', 2, 1, '2019-11-21 22:53:05', '2019-12-06 03:40:45'),
(7, 'kumparancom', 2, 1, '2019-11-21 22:53:05', '2019-12-06 03:40:45'),
(8, 'ridwankamil', 2, 2, '2019-10-17 22:06:08', '2019-12-10 04:26:52'),
(9, 'viceind', 2, 2, '2019-11-21 22:53:25', '2019-12-10 04:38:31');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

DROP TABLE IF EXISTS `tbl_users`;
CREATE TABLE `tbl_users` (
  `id_user` int(11) UNSIGNED NOT NULL,
  `username` varchar(30) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL DEFAULT '',
  `user_type` tinyint(1) NOT NULL COMMENT '1. Owner 2. Admin 3. Client',
  `active` tinyint(1) NOT NULL,
  `password` varchar(50) NOT NULL DEFAULT '',
  `token` varchar(100) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`id_user`, `username`, `name`, `user_type`, `active`, `password`, `token`, `created`, `updated`) VALUES
(1, 'myjajat@gmail.com', 'Jajat Ismail', 1, 1, '827ccb0eea8a706c4c34a16891f84e7b', 'd66bed2ad538d3a3019d7f16523cb16fdad54fa903fd691cb929185ce9aed2f1', '2019-10-02 09:41:51', '2019-11-22 10:32:12'),
(2, 'admin1@email.com', 'Admin 1', 2, 1, '827ccb0eea8a706c4c34a16891f84e7b', NULL, '2019-10-16 11:24:59', '2019-10-18 14:20:26'),
(3, 'user1@email.com', 'User 1', 3, 1, '827ccb0eea8a706c4c34a16891f84e7b', NULL, '2019-10-18 10:19:14', '2019-11-25 14:05:31'),
(4, 'okyzaprabowo@gmail.com', 'Okyza Prabowo', 3, 1, '827ccb0eea8a706c4c34a16891f84e7b', '4b8e4ec3f586700e088a3b6c9f9ebcbee4290c168d87eb4f16d3b32e6b562957', '2019-11-25 03:15:01', '2019-11-28 09:19:11'),
(5, 'admin2@email.com', 'Admin 2', 2, 1, '827ccb0eea8a706c4c34a16891f84e7b', NULL, '2019-11-25 03:27:38', '2019-11-25 03:27:38');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users_targets`
--

DROP TABLE IF EXISTS `tbl_users_targets`;
CREATE TABLE `tbl_users_targets` (
  `id_user` int(11) NOT NULL,
  `id_target` int(11) NOT NULL,
  `category` varchar(20) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_users_targets`
--

INSERT INTO `tbl_users_targets` (`id_user`, `id_target`, `category`, `created`, `updated`) VALUES
(3, 1, 'POLITIK', '2019-10-18 12:06:08', '2019-11-20 12:50:09'),
(3, 3, 'POLITIK', '2019-11-25 03:52:34', '2019-11-25 03:52:34'),
(4, 1, 'PUBLIC FIGURE', '2019-11-25 03:51:13', '2019-11-25 03:51:13'),
(4, 2, 'PUBLIC FIGURE', '2019-11-25 03:51:20', '2019-11-25 03:51:20'),
(4, 4, 'NEWS', '2019-11-25 03:51:31', '2019-11-25 03:51:31'),
(4, 5, 'POLITIK', '2019-12-09 11:52:45', '2019-12-09 11:52:45'),
(4, 6, 'POLITIK', '2019-12-10 14:14:27', '2019-12-10 14:14:27'),
(4, 7, 'NEWS', '2019-12-10 14:14:42', '2019-12-10 14:14:42'),
(4, 9, 'NEWS', '2019-11-29 13:18:49', '2019-11-29 13:18:49');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_engagement`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `v_engagement`;
CREATE TABLE `v_engagement` (
`ig_username` varchar(100)
,`engagement` decimal(14,4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_follower_count`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `v_follower_count`;
CREATE TABLE `v_follower_count` (
`ig_username` varchar(100)
,`last_checked` timestamp
,`follower_count` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_post_avg`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `v_post_avg`;
CREATE TABLE `v_post_avg` (
`ig_username` varchar(100)
,`jumlah` bigint(21)
,`ratarata` decimal(24,4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_responsive`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `v_responsive`;
CREATE TABLE `v_responsive` (
`ig_username` varchar(100)
,`responsive` decimal(39,4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_scraping_summary`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `v_scraping_summary`;
CREATE TABLE `v_scraping_summary` (
`ig_username` varchar(100)
,`last_checked` timestamp
,`post_count` bigint(21)
,`like_count` decimal(32,0)
,`comment_count` decimal(32,0)
,`response_count` decimal(32,0)
,`follower_count` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `v_engagement`
--
DROP TABLE IF EXISTS `v_engagement`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_engagement`  AS  select `tbl_scraping`.`ig_username` AS `ig_username`,avg(`tbl_scraping`.`like_count`) AS `engagement` from `tbl_scraping` group by `tbl_scraping`.`ig_username` ;

-- --------------------------------------------------------

--
-- Structure for view `v_follower_count`
--
DROP TABLE IF EXISTS `v_follower_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_follower_count`  AS  select `tbl_scraping`.`ig_username` AS `ig_username`,`tmax`.`last_checked` AS `last_checked`,`tbl_scraping`.`follower_count` AS `follower_count` from (`tbl_scraping` join (select `tbl_scraping`.`ig_username` AS `ig_username`,max(`tbl_scraping`.`created`) AS `last_checked` from `tbl_scraping` group by `tbl_scraping`.`ig_username`) `tmax` on(((`tbl_scraping`.`ig_username` = `tmax`.`ig_username`) and (`tbl_scraping`.`created` = `tmax`.`last_checked`)))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_post_avg`
--
DROP TABLE IF EXISTS `v_post_avg`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_post_avg`  AS  select `tjumlah`.`ig_username` AS `ig_username`,`tjumlah`.`jumlah` AS `jumlah`,(`tjumlah`.`jumlah` / 334) AS `ratarata` from (select `tbl_scraping`.`ig_username` AS `ig_username`,count(0) AS `jumlah` from `tbl_scraping` group by `tbl_scraping`.`ig_username`) `tjumlah` ;

-- --------------------------------------------------------

--
-- Structure for view `v_responsive`
--
DROP TABLE IF EXISTS `v_responsive`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_responsive`  AS  select `tbl_scraping`.`ig_username` AS `ig_username`,((sum(`tbl_scraping`.`response_count`) / sum(`tbl_scraping`.`comment_count`)) * 100) AS `responsive` from `tbl_scraping` group by `tbl_scraping`.`ig_username` ;

-- --------------------------------------------------------

--
-- Structure for view `v_scraping_summary`
--
DROP TABLE IF EXISTS `v_scraping_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_scraping_summary`  AS  select `ts`.`ig_username` AS `ig_username`,`ts`.`last_checked` AS `last_checked`,`ts`.`post_count` AS `post_count`,`ts`.`like_count` AS `like_count`,`ts`.`comment_count` AS `comment_count`,`ts`.`response_count` AS `response_count`,`tbl_scraping`.`follower_count` AS `follower_count` from (((select `tbl_scraping`.`ig_username` AS `ig_username`,count(0) AS `post_count`,sum(`tbl_scraping`.`like_count`) AS `like_count`,sum(`tbl_scraping`.`comment_count`) AS `comment_count`,sum(`tbl_scraping`.`response_count`) AS `response_count`,max(`tbl_scraping`.`created`) AS `last_checked` from `tbl_scraping` group by `tbl_scraping`.`ig_username`)) `ts` join `tbl_scraping` on(((`tbl_scraping`.`ig_username` = `ts`.`ig_username`) and (`tbl_scraping`.`created` = `ts`.`last_checked`)))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_classifications`
--
ALTER TABLE `tbl_classifications`
  ADD PRIMARY KEY (`id_normalization`);

--
-- Indexes for table `tbl_crawling`
--
ALTER TABLE `tbl_crawling`
  ADD PRIMARY KEY (`id_crawling`),
  ADD KEY `taken_at` (`taken_at`),
  ADD KEY `ig_username` (`ig_username`);

--
-- Indexes for table `tbl_engines`
--
ALTER TABLE `tbl_engines`
  ADD PRIMARY KEY (`id_engine`);

--
-- Indexes for table `tbl_extractions`
--
ALTER TABLE `tbl_extractions`
  ADD PRIMARY KEY (`id_extraction`);

--
-- Indexes for table `tbl_labels`
--
ALTER TABLE `tbl_labels`
  ADD PRIMARY KEY (`id_label`);

--
-- Indexes for table `tbl_normalizations`
--
ALTER TABLE `tbl_normalizations`
  ADD PRIMARY KEY (`id_normalization`),
  ADD KEY `id_crawling` (`id_crawling`);

--
-- Indexes for table `tbl_results`
--
ALTER TABLE `tbl_results`
  ADD PRIMARY KEY (`id_user`,`day_count`,`category`,`normal_text`),
  ADD KEY `p_value` (`p_value`);

--
-- Indexes for table `tbl_scraping`
--
ALTER TABLE `tbl_scraping`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_targets`
--
ALTER TABLE `tbl_targets`
  ADD PRIMARY KEY (`id_target`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `login` (`username`,`password`),
  ADD KEY `loginByToken` (`token`);

--
-- Indexes for table `tbl_users_targets`
--
ALTER TABLE `tbl_users_targets`
  ADD PRIMARY KEY (`id_user`,`id_target`),
  ADD KEY `id_user` (`id_user`,`category`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_crawling`
--
ALTER TABLE `tbl_crawling`
  MODIFY `id_crawling` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT for table `tbl_engines`
--
ALTER TABLE `tbl_engines`
  MODIFY `id_engine` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_extractions`
--
ALTER TABLE `tbl_extractions`
  MODIFY `id_extraction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `tbl_labels`
--
ALTER TABLE `tbl_labels`
  MODIFY `id_label` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_normalizations`
--
ALTER TABLE `tbl_normalizations`
  MODIFY `id_normalization` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `tbl_scraping`
--
ALTER TABLE `tbl_scraping`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `tbl_targets`
--
ALTER TABLE `tbl_targets`
  MODIFY `id_target` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `id_user` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
