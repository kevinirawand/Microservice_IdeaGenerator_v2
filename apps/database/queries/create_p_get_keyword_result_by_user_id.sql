DROP PROCEDURE IF EXISTS p_get_keyword_result_by_user_id;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_get_keyword_result_by_user_id`(
  IN `i_user_id` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'Get data from tbl_keyword_result for every dow (not specified)'

BEGIN
SELECT kr.dow, kr.normal_text, COUNT(kr.normal_text) AS total
FROM tbl_keyword_result kr
WHERE kr.id_user = i_user_id
GROUP BY kr.normal_text, kr.dow
ORDER BY total DESC;
END//
DELIMITER ;