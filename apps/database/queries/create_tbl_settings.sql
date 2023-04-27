DROP TABLE IF EXISTS `tbl_settings`;

CREATE TABLE `tbl_settings` (
  `name` VARCHAR(50) NULL DEFAULT NULL,
  `value` VARCHAR(50) NULL DEFAULT NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;