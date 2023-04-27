-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 02, 2019 at 02:02 PM
-- Server version: 5.7.26
-- PHP Version: 7.3.8


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sma2`
--

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_results`
--
ALTER TABLE `tbl_results`
  ADD PRIMARY KEY (`id_user`,`day_count`,`category`,`normal_text`),
  ADD KEY `p_value` (`p_value`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
