DELIMITER $$

DROP FUNCTION IF EXISTS `get_from_set` $$
CREATE FUNCTION `get_from_set` (prmPos integer, prmStr  text,prmDelimiter varchar(25)) RETURNS text deterministic
BEGIN

  declare foundit integer default 0;
  declare pos integer default 0;
  declare cntr integer default 0;
  declare tmpRtn text default "";
  declare tmpStr text default "";
  declare tmpElementStr text default "";
  if(prmStr is NOT null AND prmDelimiter is NOT null AND prmPos IS NOT NULL AND length(prmStr) > prmPos) THEN
    set tmpStr = prmStr;
    while cntr < 255 and foundit = 0 DO
      set pos = pos + 1;
      if pos = prmPos then
        set tmpElementStr = left(tmpStr,locate(prmDelimiter,tmpStr)-1);
        if tmpElementStr="" AND (locate(prmDelimiter,tmpStr) = 0 ) then /* last element just return the remaining str */
          set tmpElementStr = tmpStr;
        end if;
        set foundit = 1;
        set tmpRtn = tmpElementStr;
        set cntr = 256;
      end if;
      if (locate(prmDelimiter,tmpStr) > 0 ) then
        set tmpStr = right(tmpStr,length(tmpStr) - locate(prmDelimiter,tmpStr));
      else
        set tmpStr = "";
      end if;
      set cntr = cntr + 1;
    End While;
  end if;
  set tmpRtn = if(foundit = 0,null,tmpRtn);
  return cast(tmpRtn as char);

END $$

DELIMITER ;