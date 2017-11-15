delimiter //
DROP FUNCTION IF EXISTS remove_non_alphanum_char //
CREATE FUNCTION remove_non_alphanum_char(prm_strInput varchar(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE v_char VARCHAR(1);
  DECLARE v_parseStr VARCHAR(255) DEFAULT ' ';

  WHILE (i <= LENGTH(prm_strInput) )  DO

    SET v_char = SUBSTR(prm_strInput,i,1);
    IF v_char REGEXP  '^[A-Za-z0-9]+$' THEN  #alphanumeric

        SET v_parseStr = CONCAT(v_parseStr,v_char);

    END IF;
    SET i = i + 1;
  END WHILE;
RETURN trim(v_parseStr);
END
//
