DELIMITER $$

DROP FUNCTION IF EXISTS `set_item_match` $$
CREATE FUNCTION `set_item_match`( prmStr  text, prmStr2  text,prmDelimiter varchar(25)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  declare cntr integer default 0;
  declare matchcntr integer default 0;
  declare cntr2 integer default 0;
  declare tmpStr varchar(5000) default "";
  declare tmpElementStr text default "";
  declare tmpElementStr2 text default "";
  declare tmpUnique varchar(5000) default "";
  declare tmpOUTERLEFT varchar(5000) default "";

    # validation
  if(prmStr2 is NOT null AND prmDelimiter is NOT null) THEN

    # initialize the delimited string
    set tmpStr = prmStr2;
    while cntr < 512 DO
      # get the element
      set tmpElementStr = left(tmpStr,locate(prmDelimiter,tmpStr)-1);
      if tmpElementStr="" AND (locate(prmDelimiter,tmpStr) = 0 ) then /* last element just return the remaining str */
         set tmpElementStr = tmpStr;
         set cntr = 513;
      end if;
      # add element to list if not found
      if tmpUnique NOT like concat("%[[",replace(tmpElementStr,"'","\\'"),"]]%") then
        set tmpUnique = concat(tmpUnique,"[[",replace(tmpElementStr,"'","\\'"),"]]");
      end if;
      # remove got element from delimited string
      if (locate(prmDelimiter,tmpStr) > 0 ) then
        set tmpStr = right(tmpStr,length(tmpStr) - locate(prmDelimiter,tmpStr));
      else
         set cntr = 513;
      end if;
      # increment counter
      set cntr = cntr + 1;
      set cntr2 = cntr2 + 1;
    End While;


  end if;

  # validation
  if(prmStr is NOT null AND prmDelimiter is NOT null) THEN
    # reinitialize the delimited string
    set tmpStr = prmStr;
    # reinitialize the counter
    set cntr = 0;
    while cntr < 512 DO
      # get the element
      set tmpElementStr = left(tmpStr,locate(prmDelimiter,tmpStr)-1);
      if tmpElementStr="" AND (locate(prmDelimiter,tmpStr) = 0 ) then /* last element just return the remaining str */
         set tmpElementStr = tmpStr;
         set cntr = 513;
      end if;
      # add element to list if not found
      if tmpUnique NOT like concat("%[[",replace(tmpElementStr,"'","\\'"),"]]%") then
        set tmpUnique = concat(tmpUnique,"[[",replace(tmpElementStr,"'","\\'"),"]]");
        set tmpOUTERLEFT = concat(tmpOUTERLEFT,"[[",replace(tmpElementStr,"'","\\'"),"]]");
      else
        set matchcntr = matchcntr + 1;
      end if;
      # remove got element from delimited string
      if (locate(prmDelimiter,tmpStr) > 0 ) then
        set tmpStr = right(tmpStr,length(tmpStr) - locate(prmDelimiter,tmpStr));
      else
         set cntr = 513;
      end if;
      # increment counter
      set cntr = cntr + 1;
      set cntr2 = cntr2 + 1;
    End While;
  end if;
  return matchcntr;
END $$

DELIMITER ;