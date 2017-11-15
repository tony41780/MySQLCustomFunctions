DELIMITER $$

DROP PROCEDURE IF EXISTS `CSVParser` $$
CREATE PROCEDURE `CSVParser` (strKeys VARCHAR(255),strVals VARCHAR(255),delim VARCHAR(25))
BEGIN
  DECLARE Counter   INT DEFAULT 0;
  DECLARE strLen    INT DEFAULT 0;
  DECLARE SubStrLen INT DEFAULT 0;

  DECLARE msg VARCHAR(1024) default '';

  CREATE TEMPORARY TABLE tmpKeys (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    KeyName  varchar(45)
  );
  CREATE TEMPORARY TABLE tmpVals (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    KeyValue  varchar(45)
  );

  IF strKeys IS NULL THEN
    SET strKeys = '';
  END IF;

  do_keys:
  LOOP
    SET strLen = LENGTH(strKeys);
    IF(INSTR(strKeys,delim) = 0)THEN
      INSERT INTO tmpKeys (KeyName) VALUE (strKeys);
      LEAVE do_keys;
    ELSE
      INSERT INTO tmpKeys (KeyName) VALUE (left(strKeys,instr(strKeys,delim)-LENGTH(delim)));
      SET SubStrLen = instr(strKeys,delim) + length(delim);
      SET strKeys = MID(strKeys, SubStrLen, strLen);
      SET Counter = Counter + 1;
      IF IFNULL(strKeys,'') = '' OR Counter > 100 THEN
        LEAVE do_keys;
      END IF;
#      set msg = concat(msg,'|',strKeys);
    END IF;
  END LOOP do_keys;
  SET Counter = 0;

  do_vals:
  LOOP
    SET strLen = LENGTH(strVals);
    IF(INSTR(strVals,delim) = 0)THEN
      INSERT INTO tmpVals (KeyValue) VALUE (strVals);
      LEAVE do_vals;
    ELSE
      INSERT INTO tmpVals (KeyValue) VALUE (left(strVals,instr(strVals,delim)-LENGTH(delim)));
      SET SubStrLen = instr(strVals,delim) + length(delim);
      SET strVals = MID(strVals, SubStrLen, strLen);
      SET Counter = Counter + 1;
      IF IFNULL(strVals,'') = '' OR Counter > 100 THEN
        LEAVE do_vals;
      END IF;
#      set msg = concat(msg,'|',strKeys);
    END IF;
  END LOOP do_vals;



  SELECT CONCAT(msg,' > ',IFNULL(GROUP_CONCAT(CONCAT(k.KeyName,':',ifnull(v.KeyValue,''))),'EMPTY')) INTO msg FROM
    tmpKeys k LEFT JOIN tmpVals v ON k.id = v.id;

  SELECT msg;

END $$
DELIMITER ;