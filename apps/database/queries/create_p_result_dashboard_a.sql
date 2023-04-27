DROP PROCEDURE IF EXISTS p_result_dashboard_a;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_result_dashboard_a`(IN `iid_user` INT(11), IN `iinterval` INT(2), IN `icategory` VARCHAR(20), IN `iid_label` INT(2))
    READS SQL DATA
    
BEGIN
DECLARE total_px INT(11);
DECLARE date_from DATE DEFAULT DATE_SUB(CURDATE(), INTERVAL iinterval DAY);

SELECT COUNT(*) INTO total_px FROM tbl_crawling WHERE DATE(taken_at) >= date_from;

SELECT normal_text, modus, total_px, (modus / total_px) p_value
FROM (
    SELECT normal_text, COUNT(*) modus 
    FROM tbl_normalizations
    JOIN tbl_crawling USING(id_crawling)
    JOIN tbl_targets USING(ig_username)
    JOIN tbl_users_targets USING(id_target)
    JOIN tbl_classifications USING (id_normalization)
    WHERE DATE(taken_at) >= date_from
    AND id_user = iid_user
    AND category = icategory
    AND id_label = iid_label
    GROUP BY normal_text
) x
ORDER BY p_value DESC;
END//
DELIMITER ;