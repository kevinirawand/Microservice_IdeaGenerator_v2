DROP PROCEDURE IF EXISTS p_get_keyword_result_page_by_keyword;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_get_keyword_result_page_by_keyword`(
  IN `i_user_id` INT,
  IN `i_dow` TINYINT,
  IN `i_keyword` VARCHAR(50)

)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'Get page of keyword'

BEGIN
SELECT kr.*
FROM tbl_keyword_result kr
WHERE kr.id_user = i_user_id
AND kr.dow = i_dow
AND kr.normal_text LIKE CONCAT('%', i_keyword , '%');
END//
DELIMITER ;