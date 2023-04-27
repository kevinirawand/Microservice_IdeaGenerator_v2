DROP TABLE IF EXISTS `tbl_scraping_result`;

CREATE TABLE `tbl_scraping_result` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'table id',
  `id_user` INT(11) UNSIGNED NULL DEFAULT '0' COMMENT 'user id',
  `id_target` VARCHAR(50) NULL DEFAULT NULL COMMENT 'target id',
  `ig_username` VARCHAR(50) NULL DEFAULT NULL COMMENT 'username ig',
  `total_follower` INT(11) UNSIGNED NULL DEFAULT '0' COMMENT 'total follower (follower_count) from tbl_scraping for this day',
  `total_content` INT(11) UNSIGNED NULL DEFAULT '0' COMMENT 'total content (url) from tbl_scraping for this day',
  `total_engagement` INT(11) UNSIGNED NULL DEFAULT '0' COMMENT 'total engagement (like_count) from tbl_scraping for this day',
  `total_comment` INT(11) UNSIGNED NULL DEFAULT '0' COMMENT 'total comment (comment_count) from tbl_scraping for this day',
  `total_response` INT(11) UNSIGNED NULL DEFAULT '0' COMMENT 'total response (response_count) from tbl_scraping for this day',
  `updated` DATETIME NULL DEFAULT NULL COMMENT 'this day',
  `per_follower` DOUBLE NULL DEFAULT NULL COMMENT 'total_follower / max of',
  `per_content_per_day` DOUBLE NULL DEFAULT NULL COMMENT 'total_content / 334 / max of',
  `per_engagement_per_content` DOUBLE NULL DEFAULT NULL COMMENT 'total_engagement / total_content / max of',
  `per_response` DOUBLE NULL DEFAULT NULL COMMENT 'total_response / total_comment / max of',
  `weight_follower` DOUBLE NULL DEFAULT NULL COMMENT 'per_follower * WEIGHT_FOLLOWER',
  `weight_content_per_day` DOUBLE NULL DEFAULT NULL COMMENT 'per_content_per_day * WEIGHT_CONTENT_PER_DAY',
  `weight_engagement_per_content` DOUBLE NULL DEFAULT NULL COMMENT 'per_engagement_per_content * WEIGHT_ENGAGEMENT_PER_CONTENT',
  `weight_response` DOUBLE NULL DEFAULT NULL COMMENT 'per_response * WEIGHT_RESPONSE_COMMENT',
  `total_score` DOUBLE NULL DEFAULT NULL COMMENT '((weight_follower + weight_content_per_day + weight_engagement_per_content + weight_response) / WEIGHT_TOTAL_SCORE) * 100',
  PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;