DELIMITER $$

DROP FUNCTION IF EXISTS `union_sets` $$
CREATE FUNCTION `union_sets`( prmStr  text, prmStr2  text,prmDelimiter varchar(25)) RETURNS text CHARSET latin1
    DETERMINISTIC
BEGIN
  declare cntr integer default 0;
  declare cntr2 integer default 0;
  declare tmpStr varchar(4000) default "";
  declare tmpElementStr text default "";
  declare tmpElementStr2 text default "";
  declare tmpSQL varchar(4000);
  declare tmpUnique varchar(4000) default "";
  # validation
  if(prmStr is NOT null AND prmDelimiter is NOT null) THEN
    # initialize the delimited string
    set tmpStr = prmStr;
    while cntr < 255 DO
      # get the element
      set tmpElementStr = left(tmpStr,locate(prmDelimiter,tmpStr)-1);
      if tmpElementStr="" AND (locate(prmDelimiter,tmpStr) = 0 ) then /* last element just return the remaining str */
         set tmpElementStr = tmpStr;
         set cntr = 256;
      end if;
      # add element to list if not found
      if tmpUnique NOT like concat("%[[",replace(tmpElementStr,"'","\\'"),"]]%") then
        set tmpUnique = concat(tmpUnique,"[[",replace(tmpElementStr,"'","\\'"),"]]");
      end if;
      # remove got element from delimited string
      if (locate(prmDelimiter,tmpStr) > 0 ) then
        set tmpStr = right(tmpStr,length(tmpStr) - locate(prmDelimiter,tmpStr));
      else
         set cntr = 256;
      end if;
      # increment counter
      set cntr = cntr + 1;
      set cntr2 = cntr2 + 1;
    End While;
  end if;
  # validation
  if(prmStr2 is NOT null AND prmDelimiter is NOT null) THEN
    # reinitialize the delimited string
    set tmpStr = prmStr2;
    # reinitialize the counter
    set cntr = 0;
    while cntr < 255 DO
      # get the element
      set tmpElementStr = left(tmpStr,locate(prmDelimiter,tmpStr)-1);
      if tmpElementStr="" AND (locate(prmDelimiter,tmpStr) = 0 ) then /* last element just return the remaining str */
         set tmpElementStr = tmpStr;
         set cntr = 256;
      end if;
      # add element to list if not found
      if tmpUnique NOT like concat("%[[",replace(tmpElementStr,"'","\\'"),"]]%") then
        set tmpUnique = concat(tmpUnique,"[[",replace(tmpElementStr,"'","\\'"),"]]");
      end if;
      # remove got element from delimited string
      if (locate(prmDelimiter,tmpStr) > 0 ) then
        set tmpStr = right(tmpStr,length(tmpStr) - locate(prmDelimiter,tmpStr));
      else
         set cntr = 256;
      end if;
      # increment counter
      set cntr = cntr + 1;
      set cntr2 = cntr2 + 1;
    End While;
  end if;
  #set tmpUnique = concat(tmpUnique,"[[gotto",cntr2,"]]");
  Set tmpUnique = replace(replace(replace(tmpUnique,"]][[",","),"]]",""),"[[","");
  return cast(tmpUnique as char);
END $$

DELIMITER ;