-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 11 Des 2019 pada 04.50
-- Versi server: 10.4.8-MariaDB
-- Versi PHP: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sma_new`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_scraping`
--

CREATE TABLE `tbl_scraping` (
  `id` int(11) NOT NULL,
  `ig_username` varchar(100) NOT NULL,
  `url` text NOT NULL,
  `follower_count` int(11) NOT NULL,
  `like_count` int(11) NOT NULL,
  `comment_count` int(11) NOT NULL,
  `response_count` int(11) NOT NULL,
  `taken_at` datetime NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `tbl_scraping`
--

INSERT INTO `tbl_scraping` (`id`, `ig_username`, `url`, `follower_count`, `like_count`, `comment_count`, `response_count`, `taken_at`, `created`, `updated`) VALUES
(1, 'humas.jateng', 'https://instagram.com/p/B54CigSFHnY', 11584, 314, 0, 0, '2019-12-10 09:45:22', '2019-12-11 01:39:17', NULL),
(2, 'humas.jateng', 'https://instagram.com/p/B5z3CQmFIBX', 11584, 102, 1, 0, '2019-12-08 18:49:24', '2019-12-11 01:39:34', NULL),
(3, 'humas.jateng', 'https://instagram.com/p/B5ucXjAlEFo', 11584, 263, 3, 1, '2019-12-06 16:18:39', '2019-12-11 01:39:52', NULL),
(4, 'humas.jateng', 'https://instagram.com/p/B5rTjO3lH36', 11584, 272, 0, 0, '2019-12-05 11:03:53', '2019-12-11 01:40:09', NULL),
(5, 'humasprovjatim', 'https://instagram.com/p/B54-3-VgAaw', 10863, 91, 0, 0, '2019-12-10 18:32:35', '2019-12-11 01:40:28', NULL),
(6, 'humasprovjatim', 'https://instagram.com/p/B540jZiFvVu', 10863, 22, 0, 0, '2019-12-10 17:04:54', '2019-12-11 01:40:45', NULL),
(7, 'humasprovjatim', 'https://instagram.com/p/B53-4dDAXmH', 10863, 136, 2, 1, '2019-12-10 09:13:25', '2019-12-11 01:41:03', NULL),
(8, 'humasprovjatim', 'https://instagram.com/p/B52E84clpmM', 10863, 48, 0, 0, '2019-12-09 15:28:47', '2019-12-11 01:41:20', NULL),
(9, 'humasprovjatim', 'https://instagram.com/p/B5zlDq-AKC4', 10863, 234, 21, 0, '2019-12-08 16:10:47', '2019-12-11 01:41:38', NULL),
(10, 'humasprovjatim', 'https://instagram.com/p/B5wcS5jpG1f', 10863, 108, 1, 0, '2019-12-07 10:57:20', '2019-12-11 01:41:58', NULL),
(11, 'humasprovjatim', 'https://instagram.com/p/B5uKKJOgfQi', 10863, 160, 1, 0, '2019-12-06 13:39:32', '2019-12-11 01:42:15', NULL),
(12, 'humasprovjatim', 'https://instagram.com/p/B5pmabcAJJU', 10863, 103, 0, 0, '2019-12-04 19:10:14', '2019-12-11 01:42:33', NULL),
(13, 'humasprovjatim', 'https://instagram.com/p/B5oif9ag7UV', 10863, 141, 0, 0, '2019-12-04 09:16:48', '2019-12-11 01:42:50', NULL),
(14, 'humas_jabar', 'https://instagram.com/p/B55Dj_hhzBi', 89706, 396, 6, 0, '2019-12-10 19:13:33', '2019-12-11 01:43:09', NULL),
(15, 'humas_jabar', 'https://instagram.com/p/B54dODnh5ZW', 89706, 169, 0, 0, '2019-12-10 13:38:30', '2019-12-11 01:43:26', NULL),
(16, 'humas_jabar', 'https://instagram.com/p/B54KwYbBiDd', 89706, 132, 0, 0, '2019-12-10 11:03:25', '2019-12-11 01:43:44', NULL),
(17, 'humas_jabar', 'https://instagram.com/p/B53oJ0khgyY', 89706, 204, 4, 0, '2019-12-10 05:56:10', '2019-12-11 01:44:01', NULL),
(18, 'humas_jabar', 'https://instagram.com/p/B52cm5DB_rv', 89706, 148, 1, 0, '2019-12-09 18:54:41', '2019-12-11 01:44:19', NULL),
(19, 'humas_jabar', 'https://instagram.com/p/B52MH-BBYgH', 89706, 169, 0, 0, '2019-12-09 16:30:39', '2019-12-11 01:44:36', NULL),
(20, 'humas_jabar', 'https://instagram.com/p/B513s6WhO0_', 89706, 344, 7, 4, '2019-12-09 13:32:11', '2019-12-11 01:44:54', NULL),
(21, 'humas_jabar', 'https://instagram.com/p/B51SOwehO5C', 89706, 211, 0, 0, '2019-12-09 08:04:46', '2019-12-11 01:45:12', NULL),
(22, 'humas_jabar', 'https://instagram.com/p/B50GxGjhzut', 89706, 147, 7, 0, '2019-12-08 21:05:21', '2019-12-11 01:45:29', NULL),
(23, 'humas_jabar', 'https://instagram.com/p/B5z7frghcaa', 89706, 405, 28, 8, '2019-12-08 19:26:51', '2019-12-11 01:45:49', NULL),
(24, 'humas_jabar', 'https://instagram.com/p/B5z0kjOhix8', 89706, 169, 0, 0, '2019-12-08 18:26:21', '2019-12-11 01:46:06', NULL),
(25, 'humas_jabar', 'https://instagram.com/p/B5zqxSNh1hS', 89706, 379, 1, 0, '2019-12-08 17:00:42', '2019-12-11 01:46:24', NULL),
(26, 'humas_jabar', 'https://instagram.com/p/B5ywigjBcvr', 89706, 632, 13, 4, '2019-12-08 08:31:53', '2019-12-11 01:46:43', NULL),
(27, 'humas_jabar', 'https://instagram.com/p/B5xaEfDBxJf', 89706, 244, 5, 0, '2019-12-07 19:56:18', '2019-12-11 01:47:02', NULL),
(28, 'humas_jabar', 'https://instagram.com/p/B5xTNpZh6kx', 89706, 227, 1, 0, '2019-12-07 18:56:23', '2019-12-11 01:47:19', NULL),
(29, 'humas_jabar', 'https://instagram.com/p/B5w66qFBHNg', 89706, 182, 0, 0, '2019-12-07 15:24:05', '2019-12-11 01:47:37', NULL),
(30, 'humas_jabar', 'https://instagram.com/p/B5wji3nhqUJ', 89706, 256, 0, 0, '2019-12-07 11:59:51', '2019-12-11 01:47:54', NULL),
(31, 'humas_jabar', 'https://instagram.com/p/B5wXV24B9lA', 89706, 325, 2, 0, '2019-12-07 10:13:13', '2019-12-11 01:48:12', NULL),
(32, 'humas_jabar', 'https://instagram.com/p/B5v_zFShfOj', 89706, 794, 10, 4, '2019-12-07 06:47:30', '2019-12-11 01:48:30', NULL),
(33, 'humas_jabar', 'https://instagram.com/p/B5vIfX3hAgj', 89706, 263, 0, 0, '2019-12-06 22:44:12', '2019-12-11 01:48:47', NULL),
(34, 'humas_jabar', 'https://instagram.com/p/B5uoUlpBfRg', 89706, 589, 9, 0, '2019-12-06 18:03:07', '2019-12-11 01:49:05', NULL),
(35, 'humas_jabar', 'https://instagram.com/p/B5uQQsBh6I4', 89706, 103, 0, 0, '2019-12-06 14:38:00', '2019-12-11 01:49:22', NULL),
(36, 'humas_jabar', 'https://instagram.com/p/B5uGFtMhxYb', 89706, 217, 0, 0, '2019-12-06 13:03:59', '2019-12-11 01:49:40', NULL),
(37, 'humas_jabar', 'https://instagram.com/p/B5tVKLVBiHT', 89706, 505, 2, 0, '2019-12-06 05:56:25', '2019-12-11 01:49:58', NULL),
(38, 'humas_jabar', 'https://instagram.com/p/B5r3n4oBQ7Z', 89706, 197, 0, 0, '2019-12-05 16:19:06', '2019-12-11 01:50:16', NULL),
(39, 'humas_jabar', 'https://instagram.com/p/B5rGX9BhhFk', 89706, 383, 3, 0, '2019-12-05 09:08:45', '2019-12-11 01:50:34', NULL),
(40, 'humas_jabar', 'https://instagram.com/p/B5pzrKyBM4g', 89706, 183, 2, 0, '2019-12-04 21:06:07', '2019-12-11 01:50:52', NULL),
(41, 'humas_jabar', 'https://instagram.com/p/B5pWpoCBCAw', 89706, 402, 4, 0, '2019-12-04 16:52:30', '2019-12-11 01:51:09', NULL),
(42, 'humas_jabar', 'https://instagram.com/p/B5pM8uih1go', 89706, 350, 3, 0, '2019-12-04 15:27:43', '2019-12-11 01:51:27', NULL),
(43, 'humas_jabar', 'https://instagram.com/p/B5pHAzqBo_0', 89706, 183, 0, 0, '2019-12-04 14:35:51', '2019-12-11 01:51:45', NULL),
(44, 'humas_jabar', 'https://instagram.com/p/B5oS6BgBWLS', 89706, 398, 8, 2, '2019-12-04 07:00:32', '2019-12-11 01:52:03', NULL),
(45, 'kaltaraprov', 'https://instagram.com/p/B55B2yunOwS', 14523, 48, 0, 0, '2019-12-10 18:58:38', '2019-12-11 01:52:21', NULL),
(46, 'kaltaraprov', 'https://instagram.com/p/B55Amwon4Gj', 14523, 128, 0, 0, '2019-12-10 18:47:43', '2019-12-11 01:52:38', NULL),
(47, 'kaltaraprov', 'https://instagram.com/p/B54LqxtoSDx', 14523, 55, 1, 0, '2019-12-10 11:05:08', '2019-12-11 01:52:55', NULL),
(48, 'kaltaraprov', 'https://instagram.com/p/B54HFbGom-d', 14523, 57, 2, 0, '2019-12-10 10:25:05', '2019-12-11 01:53:13', NULL),
(49, 'kaltaraprov', 'https://instagram.com/p/B54BLYUnvs0', 14523, 114, 0, 0, '2019-12-10 09:33:28', '2019-12-11 01:53:30', NULL),
(50, 'kaltaraprov', 'https://instagram.com/p/B5397opnObp', 14523, 79, 0, 0, '2019-12-10 09:05:06', '2019-12-11 01:53:47', NULL),
(51, 'kaltaraprov', 'https://instagram.com/p/B538N7RIYq-', 14523, 235, 1, 0, '2019-12-10 08:50:08', '2019-12-11 01:54:05', NULL),
(52, 'kaltaraprov', 'https://instagram.com/p/B536b2fncv5', 14523, 50, 0, 0, '2019-12-10 08:34:33', '2019-12-11 01:54:22', NULL),
(53, 'kaltaraprov', 'https://instagram.com/p/B5355OJjZmC', 14523, 60, 0, 0, '2019-12-10 08:29:50', '2019-12-11 01:54:39', NULL),
(54, 'kaltaraprov', 'https://instagram.com/p/B534zAaIu_f', 14523, 54, 0, 0, '2019-12-10 08:20:14', '2019-12-11 01:54:57', NULL),
(55, 'kaltaraprov', 'https://instagram.com/p/B533pVqIp0p', 14523, 65, 0, 0, '2019-12-10 08:10:11', '2019-12-11 01:55:14', NULL),
(56, 'kaltaraprov', 'https://instagram.com/p/B533pCpDtpd', 14523, 93, 1, 0, '2019-12-10 08:10:08', '2019-12-11 01:55:31', NULL),
(57, 'kaltaraprov', 'https://instagram.com/p/B53165RD0ef', 14523, 83, 0, 0, '2019-12-10 07:55:06', '2019-12-11 01:55:49', NULL),
(58, 'kaltaraprov', 'https://instagram.com/p/B53udQ9DBKQ', 14523, 84, 0, 0, '2019-12-10 06:49:53', '2019-12-11 01:56:06', NULL),
(59, 'kaltaraprov', 'https://instagram.com/p/B51_eFmgfwJ', 14523, 165, 0, 0, '2019-12-09 14:40:04', '2019-12-11 01:56:23', NULL),
(60, 'kaltaraprov', 'https://instagram.com/p/B518Cc-Ajy_', 14523, 137, 0, 0, '2019-12-09 14:10:05', '2019-12-11 01:56:41', NULL),
(61, 'kaltaraprov', 'https://instagram.com/p/B51xvdGoLgE', 14523, 266, 0, 0, '2019-12-09 12:40:06', '2019-12-11 01:56:58', NULL),
(62, 'kaltaraprov', 'https://instagram.com/p/B51ncCSAHOE', 14523, 94, 0, 0, '2019-12-09 11:10:04', '2019-12-11 01:57:15', NULL),
(63, 'kaltaraprov', 'https://instagram.com/p/B51jqvFH-Rc', 14523, 52, 0, 0, '2019-12-09 10:37:58', '2019-12-11 01:57:33', NULL),
(64, 'kaltaraprov', 'https://instagram.com/p/B51gk0QoB3n', 14523, 170, 0, 0, '2019-12-09 10:10:06', '2019-12-11 01:57:50', NULL),
(65, 'kaltaraprov', 'https://instagram.com/p/B5zR_77HhZH', 14523, 132, 0, 0, '2019-12-08 13:24:15', '2019-12-11 01:58:07', NULL),
(66, 'kaltaraprov', 'https://instagram.com/p/B5t7W3ZI-nA', 14523, 163, 3, 0, '2019-12-06 11:30:12', '2019-12-11 01:58:25', NULL),
(67, 'kaltaraprov', 'https://instagram.com/p/B5t7Wx-gdpV', 14523, 90, 1, 0, '2019-12-06 11:30:12', '2019-12-11 01:58:42', NULL),
(68, 'kaltaraprov', 'https://instagram.com/p/B5t7SaOo43Y', 14523, 141, 1, 0, '2019-12-06 11:29:36', '2019-12-11 01:58:59', NULL),
(69, 'kaltaraprov', 'https://instagram.com/p/B5t6xLoghBb', 14523, 91, 2, 0, '2019-12-06 11:25:04', '2019-12-11 01:59:16', NULL),
(70, 'kaltaraprov', 'https://instagram.com/p/B5t6NCpIyR0', 14523, 91, 1, 0, '2019-12-06 11:20:08', '2019-12-11 01:59:34', NULL),
(71, 'kaltaraprov', 'https://instagram.com/p/B5t6MpvgVBf', 14523, 190, 2, 0, '2019-12-06 11:20:04', '2019-12-11 01:59:51', NULL),
(72, 'kaltaraprov', 'https://instagram.com/p/B5t48FiDo80', 14523, 119, 0, 0, '2019-12-06 11:09:04', '2019-12-11 02:00:08', NULL),
(73, 'kaltaraprov', 'https://instagram.com/p/B5rumDwgBaM', 14523, 48, 1, 0, '2019-12-05 15:00:12', '2019-12-11 02:00:26', NULL),
(74, 'kaltaraprov', 'https://instagram.com/p/B5rpb64gM5w', 14523, 105, 1, 0, '2019-12-05 14:15:08', '2019-12-11 02:00:43', NULL),
(75, 'kaltaraprov', 'https://instagram.com/p/B5rnusPgRb4', 14523, 64, 1, 0, '2019-12-05 14:00:13', '2019-12-11 02:01:01', NULL),
(76, 'kaltaraprov', 'https://instagram.com/p/B5rbtCAIumI', 14523, 209, 2, 0, '2019-12-05 12:15:08', '2019-12-11 02:01:18', NULL),
(77, 'kaltaraprov', 'https://instagram.com/p/B5rTI-VjfyX', 14523, 112, 1, 0, '2019-12-05 11:00:18', '2019-12-11 02:01:36', NULL),
(78, 'kaltaraprov', 'https://instagram.com/p/B5pv_yFnA9b', 14523, 107, 1, 0, '2019-12-04 20:33:58', '2019-12-11 02:01:55', NULL),
(79, 'kaltaraprov', 'https://instagram.com/p/B5pXCavnxwf', 14523, 206, 9, 0, '2019-12-04 16:55:53', '2019-12-11 02:02:12', NULL),
(80, 'kaltaraprov', 'https://instagram.com/p/B5o4n2AjvBA', 14523, 78, 0, 0, '2019-12-04 12:30:06', '2019-12-11 02:02:30', NULL),
(81, 'kaltaraprov', 'https://instagram.com/p/B5o4CzcDTVL', 14523, 41, 0, 0, '2019-12-04 12:25:03', '2019-12-11 02:02:47', NULL),
(82, 'kaltaraprov', 'https://instagram.com/p/B5o25wgDb0b', 14523, 168, 0, 0, '2019-12-04 12:15:05', '2019-12-11 02:03:04', NULL),
(83, 'kaltaraprov', 'https://instagram.com/p/B5o1wyro_K7', 14523, 129, 0, 0, '2019-12-04 12:05:07', '2019-12-11 02:03:22', NULL),
(84, 'kaltaraprov', 'https://instagram.com/p/B5o1NcLIP_k', 14523, 341, 0, 0, '2019-12-04 12:00:17', '2019-12-11 02:03:39', NULL),
(85, 'kaltaraprov', 'https://instagram.com/p/B5ozhXoDmPT', 14523, 83, 0, 0, '2019-12-04 11:45:32', '2019-12-11 02:03:56', NULL),
(86, 'kumparancom', 'https://instagram.com/p/B55PM_TH3GN', 667675, 436, 9, 0, '2019-12-10 21:01:02', '2019-12-11 02:04:15', NULL),
(87, 'kumparancom', 'https://instagram.com/p/B55PoG2ln0V', 667675, 7167, 230, 0, '2019-12-10 20:58:58', '2019-12-11 02:04:50', NULL),
(88, 'kumparancom', 'https://instagram.com/p/B55Lqq4l0VL', 667675, 2389, 19, 0, '2019-12-10 20:24:22', '2019-12-11 02:05:10', NULL),
(89, 'kumparancom', 'https://instagram.com/p/B55E9CFnXiV', 667675, 1396, 60, 0, '2019-12-10 19:30:31', '2019-12-11 02:05:31', NULL),
(90, 'kumparancom', 'https://instagram.com/p/B55CHdMDtuU', 667675, 1401, 27, 0, '2019-12-10 19:00:55', '2019-12-11 02:05:50', NULL),
(91, 'kumparancom', 'https://instagram.com/p/B54-ncZAotk', 667675, 645, 215, 0, '2019-12-10 18:30:20', '2019-12-11 02:06:22', NULL),
(92, 'kumparancom', 'https://instagram.com/p/B546mTEgNNK', 667675, 434, 4, 0, '2019-12-10 18:01:14', '2019-12-11 02:06:42', NULL),
(93, 'kumparancom', 'https://instagram.com/p/B543z2JFA9c', 667675, 1456, 52, 0, '2019-12-10 17:30:51', '2019-12-11 02:07:02', NULL),
(94, 'kumparancom', 'https://instagram.com/p/B5409t0Acpo', 667675, 1056, 4, 0, '2019-12-10 17:11:03', '2019-12-11 02:07:20', NULL),
(95, 'kumparancom', 'https://instagram.com/p/B54w3gqAmT_', 667675, 3689, 104, 0, '2019-12-10 16:30:11', '2019-12-11 02:07:42', NULL),
(96, 'kumparancom', 'https://instagram.com/p/B54qAF_A47e', 667675, 2577, 108, 0, '2019-12-10 15:30:12', '2019-12-11 02:08:08', NULL),
(97, 'kumparancom', 'https://instagram.com/p/B54mpTggXWx', 667675, 11325, 375, 0, '2019-12-10 15:00:52', '2019-12-11 02:08:51', NULL),
(98, 'kumparancom', 'https://instagram.com/p/B54jJxNAmCE', 667675, 12977, 1548, 0, '2019-12-10 14:30:21', '2019-12-11 02:12:46', NULL),
(99, 'kumparancom', 'https://instagram.com/p/B54cRluARZy', 667675, 7978, 363, 0, '2019-12-10 13:35:27', '2019-12-11 02:13:29', NULL),
(100, 'kumparancom', 'https://instagram.com/p/B54VaOSDcK7', 667675, 10737, 153, 0, '2019-12-10 12:30:16', '2019-12-11 02:13:58', NULL),
(101, 'kumparancom', 'https://instagram.com/p/B54SBCcA_16', 667675, 5909, 39, 0, '2019-12-10 12:00:37', '2019-12-11 02:14:18', NULL),
(102, 'kumparancom', 'https://instagram.com/p/B54LI87AmZ8', 667675, 689, 11, 0, '2019-12-10 11:05:36', '2019-12-11 02:14:35', NULL),
(103, 'kumparancom', 'https://instagram.com/p/B54EDlmlmPa', 667675, 423, 11, 0, '2019-12-10 09:59:10', '2019-12-11 02:14:53', NULL),
(104, 'kumparancom', 'https://instagram.com/p/B539cFaI2uT', 667675, 5741, 457, 0, '2019-12-10 09:00:48', '2019-12-11 02:15:49', NULL),
(105, 'kumparancom', 'https://instagram.com/p/B52qZKoj8Dt', 667675, 656, 23, 0, '2019-12-09 21:01:00', '2019-12-11 02:16:10', NULL),
(106, 'kumparancom', 'https://instagram.com/p/B52nitujvRy', 667675, 359, 4, 0, '2019-12-09 20:30:14', '2019-12-11 02:16:27', NULL),
(107, 'kumparancom', 'https://instagram.com/p/B52iYD3DOxw', 667675, 3654, 140, 0, '2019-12-09 19:45:05', '2019-12-11 02:16:53', NULL),
(108, 'kumparancom', 'https://instagram.com/p/B52W-iMAED-', 667675, 36011, 308, 0, '2019-12-09 18:10:37', '2019-12-11 02:17:35', NULL),
(109, 'kumparancom', 'https://instagram.com/p/B52WceRl80D', 667675, 12635, 24, 0, '2019-12-09 18:00:50', '2019-12-11 02:17:57', NULL),
(110, 'kumparancom', 'https://instagram.com/p/B52WJyolXoJ', 667675, 1556, 27, 0, '2019-12-09 17:58:17', '2019-12-11 02:18:16', NULL),
(111, 'kumparancom', 'https://instagram.com/p/B52Ufmajn5c', 667675, 10477, 165, 0, '2019-12-09 17:43:47', '2019-12-11 02:18:43', NULL),
(112, 'kumparancom', 'https://instagram.com/p/B52S8IpjQQ-', 667675, 6746, 115, 0, '2019-12-09 17:30:12', '2019-12-11 02:19:08', NULL),
(113, 'kumparancom', 'https://instagram.com/p/B52O5IWFgzZ', 667675, 5202, 207, 0, '2019-12-09 16:54:50', '2019-12-11 02:19:39', NULL),
(114, 'kumparancom', 'https://instagram.com/p/B52Iu7ljfDp', 667675, 16871, 285, 0, '2019-12-09 16:06:03', '2019-12-11 02:20:29', NULL),
(115, 'kumparancom', 'https://instagram.com/p/B52FM5MAryV', 667675, 407, 13, 0, '2019-12-09 15:30:09', '2019-12-11 02:20:47', NULL),
(116, 'kumparancom', 'https://instagram.com/p/B51-VUhA5LD', 667675, 2880, 73, 0, '2019-12-09 14:30:08', '2019-12-11 02:21:08', NULL),
(117, 'kumparancom', 'https://instagram.com/p/B513etcga6I', 667675, 10246, 1226, 0, '2019-12-09 13:35:16', '2019-12-11 02:24:13', NULL),
(118, 'kumparancom', 'https://instagram.com/p/B510md1gLXg', 667675, 1049, 21, 0, '2019-12-09 13:10:09', '2019-12-11 02:24:32', NULL),
(119, 'kumparancom', 'https://instagram.com/p/B51tM3_AAgo', 667675, 4344, 13, 0, '2019-12-09 12:00:26', '2019-12-11 02:24:50', NULL),
(120, 'kumparancom', 'https://instagram.com/p/B51mup1ljM7', 667675, 5266, 129, 0, '2019-12-09 11:03:53', '2019-12-11 02:25:17', NULL),
(121, 'kumparancom', 'https://instagram.com/p/B51fgvBqtm8', 667675, 2764, 51, 0, '2019-12-09 10:00:49', '2019-12-11 02:25:36', NULL),
(122, 'kumparancom', 'https://instagram.com/p/B51YFBLKjn_', 667675, 580, 8, 0, '2019-12-09 09:01:00', '2019-12-11 02:25:55', NULL),
(123, 'kumparancom', 'https://instagram.com/p/B50D-sPjUqn', 667675, 8270, 80, 0, '2019-12-08 20:41:00', '2019-12-11 02:26:18', NULL),
(124, 'kumparancom', 'https://instagram.com/p/B5z_61DAHoG', 667675, 2772, 84, 0, '2019-12-08 20:05:31', '2019-12-11 02:26:41', NULL),
(125, 'kumparancom', 'https://instagram.com/p/B5znYLqgZV1', 667675, 1853, 38, 0, '2019-12-08 16:31:04', '2019-12-11 02:27:01', NULL),
(126, 'kumparancom', 'https://instagram.com/p/B5zgdjHDaLA', 667675, 6862, 217, 0, '2019-12-08 15:30:38', '2019-12-11 02:27:33', NULL),
(127, 'kumparancom', 'https://instagram.com/p/B5zZNJzD1Fw', 667675, 12397, 215, 0, '2019-12-08 14:32:26', '2019-12-11 02:28:16', NULL),
(128, 'kumparancom', 'https://instagram.com/p/B5zQaEOlEgC', 667675, 2355, 28, 0, '2019-12-08 13:10:21', '2019-12-11 02:28:40', NULL),
(129, 'kumparancom', 'https://instagram.com/p/B5zIZyAAk4B', 667675, 8974, 462, 0, '2019-12-08 12:00:24', '2019-12-11 02:29:28', NULL),
(130, 'kumparancom', 'https://instagram.com/p/B5zBuovl4l7', 667675, 1832, 17, 0, '2019-12-08 11:02:09', '2019-12-11 02:29:46', NULL),
(131, 'kumparancom', 'https://instagram.com/p/B5y6qlujI1p', 667675, 32112, 641, 0, '2019-12-08 10:00:22', '2019-12-11 02:30:51', NULL),
(132, 'kumparancom', 'https://instagram.com/p/B5yzGdbjLRG', 667675, 813, 11, 0, '2019-12-08 08:59:23', '2019-12-11 02:31:11', NULL),
(133, 'kumparancom', 'https://instagram.com/p/B5xd9hugQFz', 667675, 2632, 10, 0, '2019-12-07 20:30:18', '2019-12-11 02:31:30', NULL),
(134, 'kumparancom', 'https://instagram.com/p/B5xamUjgx95', 667675, 4043, 46, 0, '2019-12-07 20:00:55', '2019-12-11 02:31:50', NULL),
(135, 'kumparancom', 'https://instagram.com/p/B5xX3Y2lU2Y', 667675, 11835, 246, 0, '2019-12-07 19:37:02', '2019-12-11 02:32:24', NULL),
(136, 'kumparancom', 'https://instagram.com/p/B5xPhAPjpY1', 667675, 13164, 345, 0, '2019-12-07 18:29:04', '2019-12-11 02:33:04', NULL),
(137, 'kumparancom', 'https://instagram.com/p/B5xOfyylOAP', 667675, 540, 7, 0, '2019-12-07 18:15:10', '2019-12-11 02:33:22', NULL),
(138, 'kumparancom', 'https://instagram.com/p/B5xLFgMAAbe', 667675, 13242, 160, 0, '2019-12-07 17:45:22', '2019-12-11 02:33:49', NULL),
(139, 'kumparancom', 'https://instagram.com/p/B5xKz1ylOOY', 667675, 522, 3, 0, '2019-12-07 17:43:33', '2019-12-11 02:34:06', NULL),
(140, 'kumparancom', 'https://instagram.com/p/B5xKfHwAwmk', 667675, 2465, 11, 0, '2019-12-07 17:40:08', '2019-12-11 02:34:24', NULL),
(141, 'kumparancom', 'https://instagram.com/p/B5xJWqNjug7', 667675, 1793, 10, 0, '2019-12-07 17:30:14', '2019-12-11 02:34:42', NULL),
(142, 'kumparancom', 'https://instagram.com/p/B5xB7uZgyBH', 667675, 4407, 328, 0, '2019-12-07 16:30:30', '2019-12-11 02:35:20', NULL),
(143, 'kumparancom', 'https://instagram.com/p/B5w-Lofldp1', 667675, 7410, 216, 0, '2019-12-07 15:52:37', '2019-12-11 02:35:54', NULL),
(144, 'kumparancom', 'https://instagram.com/p/B5w7m6oAhUh', 667675, 293, 2, 0, '2019-12-07 15:30:07', '2019-12-11 02:36:12', NULL),
(145, 'kumparancom', 'https://instagram.com/p/B5w0DhHj1i0', 667675, 8737, 286, 0, '2019-12-07 14:29:07', '2019-12-11 02:36:50', NULL),
(146, 'kumparancom', 'https://instagram.com/p/B5wt5JaggU8', 667675, 6927, 18, 0, '2019-12-07 13:30:16', '2019-12-11 02:37:12', NULL),
(147, 'kumparancom', 'https://instagram.com/p/B5wnDxVozTt', 667675, 8927, 69, 0, '2019-12-07 12:30:33', '2019-12-11 02:37:33', NULL),
(148, 'kumparancom', 'https://instagram.com/p/B5wfoQ4K4Ny', 667675, 1110, 61, 0, '2019-12-07 11:30:19', '2019-12-11 02:37:54', NULL),
(149, 'kumparancom', 'https://instagram.com/p/B5wcPqwFcV2', 667675, 2030, 18, 0, '2019-12-07 10:56:04', '2019-12-11 02:38:12', NULL),
(150, 'kumparancom', 'https://instagram.com/p/B5wV_xJo-0t', 667675, 7218, 241, 0, '2019-12-07 10:01:28', '2019-12-11 02:38:43', NULL),
(151, 'kumparancom', 'https://instagram.com/p/B5wOc2bIfUs', 667675, 4782, 23, 0, '2019-12-07 09:01:32', '2019-12-11 02:39:02', NULL),
(152, 'kumparancom', 'https://instagram.com/p/B5u8rrknFPz', 667675, 9125, 117, 0, '2019-12-06 21:01:02', '2019-12-11 02:39:26', NULL),
(153, 'kumparancom', 'https://instagram.com/p/B5u5J9RDnN5', 667675, 340, 6, 0, '2019-12-06 20:30:12', '2019-12-11 02:39:43', NULL),
(154, 'kumparancom', 'https://instagram.com/p/B5u12BLAPUa', 667675, 3588, 50, 0, '2019-12-06 20:01:16', '2019-12-11 02:40:03', NULL),
(155, 'kumparancom', 'https://instagram.com/p/B5u0L9wlmne', 667675, 570, 2, 0, '2019-12-06 19:46:47', '2019-12-11 02:40:20', NULL),
(156, 'kumparancom', 'https://instagram.com/p/B5uySjDDi63', 667675, 6957, 629, 0, '2019-12-06 19:30:13', '2019-12-11 02:41:23', NULL),
(157, 'kumparancom', 'https://instagram.com/p/B5utcMFlcKL', 667675, 14506, 857, 0, '2019-12-06 18:49:34', '2019-12-11 02:42:58', NULL),
(158, 'kumparancom', 'https://instagram.com/p/B5urbeuDHSv', 667675, 2065, 73, 0, '2019-12-06 18:30:16', '2019-12-11 02:43:24', NULL),
(159, 'kumparancom', 'https://instagram.com/p/B5und4EnXr5', 667675, 455, 5, 0, '2019-12-06 17:55:38', '2019-12-11 02:43:42', NULL),
(160, 'kumparancom', 'https://instagram.com/p/B5ueMmjDGhC', 667675, 8661, 250, 0, '2019-12-06 16:39:39', '2019-12-11 02:44:15', NULL),
(161, 'kumparancom', 'https://instagram.com/p/B5ub_ysF9lR', 667675, 1540, 13, 0, '2019-12-06 16:15:25', '2019-12-11 02:44:33', NULL),
(162, 'kumparancom', 'https://instagram.com/p/B5uYaREAlQf', 667675, 7014, 179, 0, '2019-12-06 15:44:05', '2019-12-11 02:45:00', NULL),
(163, 'kumparancom', 'https://instagram.com/p/B5uStVkgi_H', 667675, 1836, 13, 1, '2019-12-06 14:59:16', '2019-12-11 02:45:18', NULL),
(164, 'kumparancom', 'https://instagram.com/p/B5uP9FyD2Ze', 667675, 466, 3, 0, '2019-12-06 14:30:11', '2019-12-11 02:45:36', NULL),
(165, 'kumparancom', 'https://instagram.com/p/B5uMn1KggqC', 667675, 4907, 40, 0, '2019-12-06 14:01:04', '2019-12-11 02:45:55', NULL),
(166, 'kumparancom', 'https://instagram.com/p/B5uE9dqD7CW', 667675, 10660, 538, 0, '2019-12-06 12:59:06', '2019-12-11 02:46:52', NULL),
(167, 'kumparancom', 'https://instagram.com/p/B5uCOB-DoeS', 667675, 3601, 75, 0, '2019-12-06 12:30:10', '2019-12-11 02:47:14', NULL),
(168, 'kumparancom', 'https://instagram.com/p/B5t-NFhDIx8', 667675, 1786, 233, 0, '2019-12-06 12:00:32', '2019-12-11 02:47:48', NULL),
(169, 'kumparancom', 'https://instagram.com/p/B5t3-m9gVl8', 667675, 8865, 273, 0, '2019-12-06 11:00:41', '2019-12-11 02:48:25', NULL),
(170, 'kumparancom', 'https://instagram.com/p/B5tyyvIlApK', 667675, 2450, 88, 0, '2019-12-06 10:16:00', '2019-12-11 02:48:49', NULL),
(171, 'kumparancom', 'https://instagram.com/p/B5tqS-ZqCju', 667675, 6146, 108, 0, '2019-12-06 09:01:08', '2019-12-11 02:49:12', NULL),
(172, 'kumparancom', 'https://instagram.com/p/B5sbOv0j-Uu', 667675, 1442, 2, 0, '2019-12-05 21:30:14', '2019-12-11 02:49:30', NULL),
(173, 'kumparancom', 'https://instagram.com/p/B5sTrWJj5wM', 667675, 5176, 240, 0, '2019-12-05 20:29:28', '2019-12-11 02:50:05', NULL),
(174, 'kumparancom', 'https://instagram.com/p/B5sNd2QFLaL', 667675, 373, 2, 0, '2019-12-05 19:29:58', '2019-12-11 02:50:26', NULL),
(175, 'kumparancom', 'https://instagram.com/p/B5sKLVrHu6H', 667675, 288, 2, 0, '2019-12-05 19:01:13', '2019-12-11 02:50:43', NULL),
(176, 'kumparancom', 'https://instagram.com/p/B5sGodrDBbR', 667675, 3496, 971, 0, '2019-12-05 18:30:15', '2019-12-11 02:52:48', NULL),
(177, 'kumparancom', 'https://instagram.com/p/B5sDTwbj_fu', 667675, 10773, 332, 0, '2019-12-05 18:01:12', '2019-12-11 02:53:30', NULL),
(178, 'kumparancom', 'https://instagram.com/p/B5r_wSfDfDn', 667675, 2222, 8, 0, '2019-12-05 17:30:09', '2019-12-11 02:53:48', NULL),
(179, 'kumparancom', 'https://instagram.com/p/B5r8Ys3jnRS', 667675, 3785, 74, 0, '2019-12-05 17:00:43', '2019-12-11 02:54:09', NULL),
(180, 'kumparancom', 'https://instagram.com/p/B5r4RhzD8q5', 667675, 23749, 678, 0, '2019-12-05 16:24:47', '2019-12-11 02:55:48', NULL),
(181, 'kumparancom', 'https://instagram.com/p/B5r3m0YDp0Z', 667675, 25818, 22, 0, '2019-12-05 16:18:57', '2019-12-11 02:56:09', NULL),
(182, 'kumparancom', 'https://instagram.com/p/B5ryDCSjpXl', 667675, 8575, 74, 0, '2019-12-05 15:35:28', '2019-12-11 02:56:31', NULL),
(183, 'kumparancom', 'https://instagram.com/p/B5ruqeyAiiW', 667675, 1709, 19, 0, '2019-12-05 15:00:48', '2019-12-11 02:56:48', NULL),
(184, 'kumparancom', 'https://instagram.com/p/B5rsTdVg7FQ', 667675, 292, 0, 0, '2019-12-05 14:40:11', '2019-12-11 02:57:06', NULL),
(185, 'kumparancom', 'https://instagram.com/p/B5rkTJHj1R2', 667675, 3579, 73, 0, '2019-12-05 13:30:14', '2019-12-11 02:57:28', NULL),
(186, 'kumparancom', 'https://instagram.com/p/B5rg6txjDwU', 667675, 357, 2, 0, '2019-12-05 13:00:41', '2019-12-11 02:57:45', NULL),
(187, 'kumparancom', 'https://instagram.com/p/B5rZ--ojwzy', 667675, 24214, 722, 0, '2019-12-05 12:05:08', '2019-12-11 03:01:15', NULL),
(188, 'kumparancom', 'https://instagram.com/p/B5rWChMoI-y', 667675, 906, 55, 0, '2019-12-05 11:30:21', '2019-12-11 03:01:39', NULL),
(189, 'kumparancom', 'https://instagram.com/p/B5rTKDzjSo4', 667675, 14437, 607, 0, '2019-12-05 11:00:27', '2019-12-11 03:02:43', NULL),
(190, 'kumparancom', 'https://instagram.com/p/B5rQMQUF_xi', 667675, 497, 5, 0, '2019-12-05 10:36:29', '2019-12-11 03:03:04', NULL),
(191, 'kumparancom', 'https://instagram.com/p/B5rMSHLjuik', 667675, 375, 26, 0, '2019-12-05 10:00:23', '2019-12-11 03:03:21', NULL),
(192, 'kumparancom', 'https://instagram.com/p/B5rFdcMIOqv', 667675, 3245, 214, 0, '2019-12-05 09:00:46', '2019-12-11 03:03:53', NULL),
(193, 'kumparancom', 'https://instagram.com/p/B5p4tgRl7Fe', 667675, 6960, 53, 0, '2019-12-04 21:50:07', '2019-12-11 03:04:16', NULL),
(194, 'kumparancom', 'https://instagram.com/p/B5px2rvAQCT', 667675, 3016, 52, 0, '2019-12-04 20:55:25', '2019-12-11 03:04:37', NULL),
(195, 'kumparancom', 'https://instagram.com/p/B5psRFpD0Yg', 667675, 17958, 491, 0, '2019-12-04 20:01:23', '2019-12-11 03:05:28', NULL),
(196, 'kumparancom', 'https://instagram.com/p/B5po7ghFh-3', 667675, 10647, 63, 0, '2019-12-04 19:32:13', '2019-12-11 03:05:49', NULL),
(197, 'kumparancom', 'https://instagram.com/p/B5plYKXjNRX', 667675, 286, 4, 0, '2019-12-04 19:01:11', '2019-12-11 03:06:07', NULL),
(198, 'kumparancom', 'https://instagram.com/p/B5pefmYDyhw', 667675, 5989, 139, 0, '2019-12-04 18:06:04', '2019-12-11 03:06:34', NULL),
(199, 'kumparancom', 'https://instagram.com/p/B5pcsh8jaV8', 667675, 22372, 2388, 0, '2019-12-04 17:45:19', '2019-12-11 03:15:27', NULL),
(200, 'kumparancom', 'https://instagram.com/p/B5pa9xzgAcH', 667675, 862, 15, 0, '2019-12-04 17:30:12', '2019-12-11 03:15:46', NULL),
(201, 'kumparancom', 'https://instagram.com/p/B5pZWE0FWm-', 667675, 542, 6, 0, '2019-12-04 17:16:02', '2019-12-11 03:16:03', NULL),
(202, 'kumparancom', 'https://instagram.com/p/B5pUGP_A0TP', 667675, 1707, 29, 0, '2019-12-04 16:30:11', '2019-12-11 03:16:22', NULL),
(203, 'kumparancom', 'https://instagram.com/p/B5pMw8cg_DJ', 667675, 6360, 315, 0, '2019-12-04 15:31:05', '2019-12-11 03:17:01', NULL),
(204, 'kumparancom', 'https://instagram.com/p/B5pJ4uWgWDr', 667675, 9159, 76, 0, '2019-12-04 15:00:58', '2019-12-11 03:17:26', NULL),
(205, 'kumparancom', 'https://instagram.com/p/B5pGlQsAwAZ', 667675, 2744, 12, 0, '2019-12-04 14:32:05', '2019-12-11 03:17:44', NULL),
(206, 'kumparancom', 'https://instagram.com/p/B5o5E-4D37p', 667675, 5754, 302, 0, '2019-12-04 12:34:05', '2019-12-11 03:18:22', NULL),
(207, 'kumparancom', 'https://instagram.com/p/B5o1PXCIaix', 667675, 9140, 288, 0, '2019-12-04 12:00:33', '2019-12-11 03:18:59', NULL),
(208, 'kumparancom', 'https://instagram.com/p/B5oxSRQFPCz', 667675, 1668, 40, 0, '2019-12-04 11:26:04', '2019-12-11 03:19:20', NULL),
(209, 'kumparancom', 'https://instagram.com/p/B5ouZOSoBtc', 667675, 3947, 58, 0, '2019-12-04 11:00:44', '2019-12-11 03:19:40', NULL),
(210, 'kumparancom', 'https://instagram.com/p/B5onm-Tqdi4', 667675, 4275, 81, 0, '2019-12-04 10:05:36', '2019-12-11 03:20:01', NULL),
(211, 'kumparancom', 'https://instagram.com/p/B5okBYWjO7u', 667675, 2305, 19, 0, '2019-12-04 09:30:06', '2019-12-11 03:20:19', NULL),
(212, 'kumparancom', 'https://instagram.com/p/B5oh4bPlCga', 667675, 440, 3, 0, '2019-12-04 09:11:24', '2019-12-11 03:20:37', NULL),
(213, 'viceind', 'https://instagram.com/p/B547Lu-ATow', 350496, 13648, 76, 0, '2019-12-10 18:00:38', '2019-12-11 03:20:59', NULL),
(214, 'viceind', 'https://instagram.com/p/B54tcLaAod1', 350496, 2358, 7, 0, '2019-12-10 16:00:15', '2019-12-11 03:21:17', NULL),
(215, 'viceind', 'https://instagram.com/p/B54fssFj49f', 350496, 10877, 104, 0, '2019-12-10 14:00:10', '2019-12-11 03:21:41', NULL),
(216, 'viceind', 'https://instagram.com/p/B54Sn0_oQmv', 350496, 24545, 1862, 0, '2019-12-10 12:05:54', '2019-12-11 03:30:22', NULL),
(217, 'viceind', 'https://instagram.com/p/B52WYYnjbuv', 350496, 12422, 203, 0, '2019-12-09 18:00:16', '2019-12-11 03:30:55', NULL),
(218, 'viceind', 'https://instagram.com/p/B51650XAbqo', 350496, 21174, 633, 0, '2019-12-09 14:00:10', '2019-12-11 03:32:10', NULL),
(219, 'viceind', 'https://instagram.com/p/B51tLepgEL_', 350496, 14492, 188, 0, '2019-12-09 12:00:15', '2019-12-11 03:32:40', NULL),
(220, 'viceind', 'https://instagram.com/p/B5zxj-GAaal', 350496, 9421, 92, 0, '2019-12-08 18:00:03', '2019-12-11 03:33:02', NULL),
(221, 'viceind', 'https://instagram.com/p/B5xMxLhjQLz', 350496, 11366, 308, 0, '2019-12-07 18:00:04', '2019-12-11 03:33:41', NULL),
(222, 'viceind', 'https://instagram.com/p/B5w4KuYDsAN', 350496, 2148, 1, 0, '2019-12-07 15:00:03', '2019-12-11 03:34:01', NULL),
(223, 'viceind', 'https://instagram.com/p/B5wV2EzgiZs', 350496, 14948, 231, 0, '2019-12-07 10:00:35', '2019-12-11 03:34:37', NULL),
(224, 'viceind', 'https://instagram.com/p/B5uoMDig5BN', 350496, 11267, 107, 0, '2019-12-06 18:01:57', '2019-12-11 03:35:03', NULL),
(225, 'viceind', 'https://instagram.com/p/B5uMqmegNdK', 350496, 12414, 113, 0, '2019-12-06 14:01:27', '2019-12-11 03:35:27', NULL),
(226, 'viceind', 'https://instagram.com/p/B5t_1cyjkeA', 350496, 15640, 304, 0, '2019-12-06 12:09:20', '2019-12-11 03:36:05', NULL),
(227, 'viceind', 'https://instagram.com/p/B5sDM9RA14v', 350496, 15706, 931, 0, '2019-12-05 18:00:17', '2019-12-11 03:37:53', NULL),
(228, 'viceind', 'https://instagram.com/p/B5r1d32geM-', 350496, 2512, 2, 0, '2019-12-05 16:00:15', '2019-12-11 03:38:13', NULL),
(229, 'viceind', 'https://instagram.com/p/B5rpOmBg3n1', 350496, 5638, 9, 0, '2019-12-05 14:13:19', '2019-12-11 03:38:30', NULL),
(230, 'viceind', 'https://instagram.com/p/B5rcvB7DHr7', 350496, 17971, 508, 0, '2019-12-05 12:24:09', '2019-12-11 03:39:31', NULL),
(231, 'viceind', 'https://instagram.com/p/B5peaRQAha2', 350496, 27660, 117, 0, '2019-12-04 18:00:18', '2019-12-11 03:39:59', NULL),
(232, 'viceind', 'https://instagram.com/p/B5pQrw6g3kc', 350496, 12342, 32, 0, '2019-12-04 16:00:21', '2019-12-11 03:40:18', NULL),
(233, 'viceind', 'https://instagram.com/p/B5pDfaUgvwJ', 350496, 23423, 28, 0, '2019-12-04 14:05:05', '2019-12-11 03:40:36', NULL),
(234, 'viceind', 'https://instagram.com/p/B5o1NPIjGJW', 350496, 9988, 24, 0, '2019-12-04 12:00:16', '2019-12-11 03:40:54', NULL),
(235, 'viceind', 'https://instagram.com/p/B5ongnHI3SH', 350496, 2392, 27, 0, '2019-12-04 10:00:34', '2019-12-11 03:41:12', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_targets`
--

CREATE TABLE `tbl_targets` (
  `id_target` int(11) NOT NULL,
  `ig_username` varchar(50) NOT NULL,
  `id_admin` int(11) NOT NULL,
  `id_engine` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `tbl_targets`
--

INSERT INTO `tbl_targets` (`id_target`, `ig_username`, `id_admin`, `id_engine`, `created`, `updated`) VALUES
(1, 'aniesbaswedan', 2, 2, '2019-11-22 05:49:01', '2019-12-06 13:47:24'),
(2, 'humas.jateng', 5, 1, '2019-11-22 05:53:05', '2019-12-11 01:37:21'),
(3, 'humasprovjatim', 2, 1, '2019-11-22 05:49:01', '2019-12-11 01:37:25'),
(4, 'humas_jabar', 2, 1, '2019-11-22 05:53:05', '2019-12-06 10:40:45'),
(5, 'jokowi', 2, 2, '2019-11-22 05:53:05', '2019-12-10 11:26:44'),
(6, 'kaltaraprov', 2, 1, '2019-11-22 05:53:05', '2019-12-06 10:40:45'),
(7, 'kumparancom', 2, 1, '2019-11-22 05:53:05', '2019-12-06 10:40:45'),
(8, 'ridwankamil', 2, 2, '2019-10-18 05:06:08', '2019-12-10 11:26:52'),
(9, 'viceind', 2, 1, '2019-11-22 05:53:25', '2019-12-11 01:37:31');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `tbl_scraping`
--
ALTER TABLE `tbl_scraping`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tbl_targets`
--
ALTER TABLE `tbl_targets`
  ADD PRIMARY KEY (`id_target`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `tbl_scraping`
--
ALTER TABLE `tbl_scraping`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=236;

--
-- AUTO_INCREMENT untuk tabel `tbl_targets`
--
ALTER TABLE `tbl_targets`
  MODIFY `id_target` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
