DROP TABLE IF EXISTS `tbl_results`;

CREATE TABLE `tbl_results` (
  `id_user` INT(11) NOT NULL,
  `category` VARCHAR(20) NOT NULL,
  `id_label` INT(11) NOT NULL,
  `day_count` INT(3) NOT NULL,
  `normal_text` VARCHAR(50) NOT NULL,
  `modus` INT(3) NOT NULL,
  `total_px` INT(3) NOT NULL,
  `p_value` FLOAT NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;