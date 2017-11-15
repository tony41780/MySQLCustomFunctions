DELIMITER $$

DROP FUNCTION IF EXISTS `removeDelimited` $$
CREATE FUNCTION `removeDelimited`( prmStr  text,prmDelimiter varchar(25)) RETURNS text CHARSET latin1
    DETERMINISTIC
BEGIN
  declare tmpStr varchar(4000) default "";
  declare tmpUnStr varchar(4000) default "";
  declare tmpStrip varchar(4000) default "";
  declare tmpCntr INTEGER default 0;
  # validation
  if(prmStr is NOT null AND prmDelimiter is NOT null AND prmDelimiter !="") THEN
    set tmpStr = prmStr;
    WHILE LOCATE(prmDelimiter,tmpStr) > 0  AND tmpCntr < 50 DO
      set tmpUnStr = concat(tmpUnStr,left(tmpStr,LOCATE(prmDelimiter,tmpStr) - 1));
      if LOCATE(prmDelimiter,tmpStr,LOCATE(prmDelimiter,tmpStr) + 1) = 0 then
      BEGIN
        /* this means the delimiter doesn't have a closing delimiter */
        set tmpStr='';
      END;
      ELSE
      BEGIN
        /* this means the delimiter HAS a closing delimiter */
        set tmpStr = right(tmpStr, length(tmpStr) - LOCATE(prmDelimiter,tmpStr,LOCATE(prmDelimiter,tmpStr) + 1));
      END;
      end if;
      set tmpCntr = tmpCntr + 1;
    END WHILE;
    set tmpUnStr = concat(tmpUnStr,tmpStr);
  end if;
  return cast(tmpUnStr as char);
END $$

DELIMITER ;