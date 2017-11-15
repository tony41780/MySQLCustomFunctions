DELIMITER $$

DROP FUNCTION IF EXISTS `WorkDayDiff` $$
CREATE FUNCTION `WorkDayDiff`(prmStartDate DateTime, prmEndDate DateTime) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE freedays int;
  SET freedays = 0;

  SET @x = DATEDIFF(prmEndDate, prmStartDate);
  IF @x<0 THEN
    SET @m = prmStartDate;
    SET prmStartDate = prmEndDate;
    SET prmEndDate = @m;
    SET @m = -1;
  ELSE
    SET @m = 1;
  END IF;
  SET @x = abs(@x) + 1;
  /* days in first week */
  SET @w1 = WEEKDAY(prmStartDate)+1;
  SET @wx1 = 8-@w1;
  IF @w1>5 THEN
    SET @w1 = 0;
  ELSE
    SET @w1 = 6-@w1;
  END IF;
  /* days in last week */
  SET @wx2 = WEEKDAY(prmEndDate)+1;
  SET @w2 = @wx2;
  IF @w2>5 THEN
    SET @w2 = 5;
  END IF;
  /* summary */
  SET @weeks = (@x-@wx1-@wx2)/7;
  SET @noweekends = (@weeks*5)+@w1+@w2;
  /* Uncoment this if you want exclude also hollidays */
  SELECT count(*) INTO freedays FROM holidayschedule WHERE holidaydate BETWEEN prmStartDate AND prmEndDate AND WEEKDAY(holidaydate)<5 and noShipping=1;
  /**/
  SET @result = @noweekends-freedays;
  RETURN @result*@m;

END $$

DELIMITER ;

/*
Requires tables: holidayschedule

CREATE TABLE  `holidayschedule` (
  `hsID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `holidayDate` datetime NOT NULL,
  `Note` varchar(45) NOT NULL,  
  `dayOff` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `noShipping` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`hsID`),
  KEY `dateIndex_2` (`holidayDate`),
  KEY `noShipping_3` (`noShipping`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

*/