ALTER TABLE tbl_keyword_result
ADD COLUMN id_label INT(11) NULL AFTER dow;
ALTER TABLE tbl_keyword_result
ADD COLUMN count_label TINYINT(3) NULL AFTER id_label;