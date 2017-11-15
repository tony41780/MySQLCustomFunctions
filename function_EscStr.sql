DELIMITER $$

DROP FUNCTION IF EXISTS `escStr`$$
CREATE FUNCTION  `escStr`(_dirty_string varchar(4098)) RETURNS varchar(4098) CHARSET utf8
    DETERMINISTIC
BEGIN
DECLARE _cln varchar(4098);
SET _cln = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(    ifnull(_dirty_string,''),'\\','\\\\' ),'"','\"'),"'","\'"),'\r',''),'\n','\\n'),'\t','\\t');
RETURN _cln;
END;

 $$

DELIMITER ;