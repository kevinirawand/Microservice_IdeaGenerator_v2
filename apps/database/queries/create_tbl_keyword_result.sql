DROP TABLE IF EXISTS `tbl_keyword_result`;

CREATE TABLE `tbl_keyword_result` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` INT(11) UNSIGNED NULL DEFAULT NULL COMMENT 'id user login',
  `id_target` INT(11) UNSIGNED NULL DEFAULT NULL COMMENT 'id target of user login',
  `ig_username` VARCHAR(50) NULL DEFAULT NULL COMMENT 'ig username target',
  `id_crawling` INT(11) UNSIGNED NULL DEFAULT NULL,
  `url` TEXT NULL COMMENT 'page or media',
  `taken_at` DATETIME NULL DEFAULT NULL COMMENT 'ig page taken',
  `dow` TINYINT(1) NULL DEFAULT NULL COMMENT 'day of week',
  `normal_text` VARCHAR(50) NULL DEFAULT NULL COMMENT 'normalization keyword',
  `created` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;