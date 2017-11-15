DELIMITER $$

DROP FUNCTION IF EXISTS `distinct_set_count`$$
CREATE FUNCTION  `distinct_set_count`( prmStr  text, prmEqual varchar(25),prmDelimiter varchar(25),prmReturnDelimiter varchar(25)) RETURNS text CHARSET latin1
    DETERMINISTIC
BEGIN
  declare cntr integer default 0;
  declare tmpStr varchar(4000) default "";
  declare tmpElementStr text default "";
  declare tmpElementStr2 text default "";
  declare tmpUnique varchar(4000) default "";
  declare tmpOUTERLEFT varchar(4000) default "";
  declare tmptest varchar(4000) default "";
  declare tmpRTN varchar(4000) default "";
  declare tmpQty char(5) default "";

  if(prmStr is NOT null AND prmDelimiter is NOT null) THEN

    set tmpStr = prmStr;
    while cntr < 255 DO

      set tmpElementStr = left(tmpStr,locate(prmDelimiter,tmpStr)-1);
      set tmpElementStr = if(tmpElementStr='',tmpStr,tmpElementStr);

      set tmpRTN = concat(tmpRTN,
            if(tmpRTN like concat('%[[',tmpElementStr,']]%'),'',concat('[[',
              tmpElementStr
           ,']]')));


      IF (tmptest LIKE concat("%[~~",tmpElementStr,"~~]%")) then
        set tmpQty = mid(tmptest,
              locate(concat("[~~",tmpElementStr,"~~]"),tmptest) +
                length(concat("[~~",tmpElementStr,"~~]",prmEqual)),
              5);
        if(tmpQty like "%[%") then
          set tmpQty = left(prmEqual,locate("[",tmpQty));
        end if;

        set tmptest = replace(tmptest,
            concat("[~~",tmpElementStr,"~~]",prmEqual,tmpQty),
            concat("[~~",tmpElementStr,"~~]",prmEqual,(cast(tmpQty as unsigned) + 1))
        );
      else
        set tmptest = concat(tmptest,"[~~",tmpElementStr,"~~]",prmEqual,"1");
      end if;


      if tmpElementStr="" AND (locate(prmDelimiter,tmpStr) = 0 ) then
         set tmpElementStr = tmpStr;
         set cntr = 256;
      end if;

      if tmpUnique NOT like concat("%[[",replace(tmpElementStr,"'","\\'"),"]]%") then
        set tmpUnique = concat(tmpUnique,"[[",replace(tmpElementStr,"'","\\'"),"]]");
      end if;

      if (locate(prmDelimiter,tmpStr) > 0 ) then
        set tmpStr = right(tmpStr,length(tmpStr) - locate(prmDelimiter,tmpStr));
      else
         set cntr = 256;
     end if;
      set cntr = cntr + 1;
    End While;

  end if;
  set tmptest = replace(tmptest,"[~~",prmReturnDelimiter);
  set tmptest = replace(tmptest,"~~]","");
  if(left(tmptest,length(prmReturnDelimiter))=prmReturnDelimiter)then
    set tmptest = mid(tmptest,length(prmReturnDelimiter)+1);
  end if;
  Set tmpStr = replace(replace(replace(tmpStr,"]][[",","),"]]",""),"[[","");
  return cast(tmptest as char);
#  return cast(tmpRTN as char);
END;

 $$

DELIMITER ;