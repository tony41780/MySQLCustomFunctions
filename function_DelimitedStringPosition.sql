DELIMITER $$

DROP FUNCTION IF EXISTS `DelimitedStringPosition` $$
CREATE FUNCTION `DelimitedStringPosition` ( prmStr  text,prmDelimiter varchar(25),prmElementString varchar(2048)) RETURNS INT  DETERMINISTIC
BEGIN
  declare foundit integer default 0;
  declare pos integer default 0;
  declare cntr integer default 0;
  declare tmpStr text default "";
  declare tmpElementStr text default "";
  if(prmStr is NOT null AND prmDelimiter is NOT null AND prmElementString IS NOT NULL AND length(prmStr) > length(prmElementString)) THEN
    set tmpStr = prmStr;
    while cntr < 255 and tmpStr != "" DO
      set tmpElementStr = left(tmpStr,locate(prmDelimiter,tmpStr)-1);
      if tmpElementStr = prmElementString then
        set foundit = 1;
        set cntr = 256;
      end if;
      if (locate(prmDelimiter,tmpStr) > 0) then
        set tmpStr = right(tmpStr,length(tmpStr) - locate(prmDelimiter,tmpStr));
      else
        set tmpStr = "";
      end if;
      set pos = pos + 1;
      set cntr = cntr + 1;
    End While;
  end if;
  set pos = if(foundit = 0,0,pos);
  return pos;


END $$

DELIMITER ;