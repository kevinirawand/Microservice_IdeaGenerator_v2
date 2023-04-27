# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.26)
# Database: db_sma2
# Generation Time: 2020-01-08 13:55:50 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;



--
-- Dumping routines (PROCEDURE) for database 'db_sma2'
--
DELIMITER ;;

# Dump of PROCEDURE p_result_dashboard_a
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `p_result_dashboard_a` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `p_result_dashboard_a`(IN `iid_user` INT(11), IN `iinterval` INT(2), IN `icategory` VARCHAR(20), IN `iid_label` INT(2))
    READS SQL DATA
BEGIN
DECLARE total_px INT(11);
DECLARE date_from DATE DEFAULT DATE_SUB(CURDATE(), INTERVAL iinterval DAY);

SELECT COUNT(*) INTO total_px FROM tbl_crawling WHERE DATE(taken_at) > date_from;

SELECT normal_text, modus, total_px, (modus / total_px) p_value
FROM (
    SELECT normal_text, COUNT(*) modus 
    FROM tbl_normalizations
    JOIN tbl_crawling USING(id_crawling)
    JOIN tbl_targets USING(ig_username)
    JOIN tbl_users_targets USING(id_target)
    JOIN tbl_classifications USING (id_normalization)
    WHERE DATE(taken_at) > date_from
    AND id_user = iid_user
    AND category = icategory
    AND id_label = iid_label
    GROUP BY normal_text
) x
ORDER BY p_value DESC
LIMIT 0, 5;
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
# Dump of PROCEDURE p_scraping_summary_by_client
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `p_scraping_summary_by_client` */;;
/*!50003 SET SESSION SQL_MODE="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `p_scraping_summary_by_client`(IN `iid_user` INT)
    READS SQL DATA
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
END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
DELIMITER ;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
