DELIMITER $$

DROP FUNCTION IF EXISTS `AddBusinessDay` $$
CREATE FUNCTION `AddBusinessDay`(prmDateTime datetime,prmDaysToAdd INTEGER) RETURNS date
    DETERMINISTIC
BEGIN

declare tmpDate datetime default NOW();
declare tmpLastDate datetime default NOW();
declare tmpCounter INTEGER default 0;

SET prmDaysToAdd = ifnull(prmDaysToAdd,0);
SET tmpDate = prmDateTime;

IF(prmDaysToAdd > 0)THEN
BEGIN
  WHILE (prmDaysToAdd > 0 AND tmpCounter < 10) DO
    SET tmpLastDate = tmpDate;
    SET tmpDate = DATE_ADD(tmpDate, INTERVAL prmDaysToAdd DAY);
    SELECT COUNT(*) INTO prmDaysToAdd
    FROM datevalues d LEFT JOIN holidayschedule h ON d.datevalue = h.holidaydate
    WHERE d.datevalue BETWEEN tmpLastDate and tmpDate
      AND (d.DAYOFWEEK IN (1,7) OR h.dayOff=1 OR h.noShipping = 1);
    SET tmpCounter = tmpCounter + 1;
  END WHILE;
END;
ELSE
BEGIN
  SET prmDaysToAdd = ABS(prmDaysToAdd);
  WHILE (prmDaysToAdd > 0 AND tmpCounter < 10) DO
    SET tmpLastDate = tmpDate;
    SET tmpDate = DATE_ADD(tmpDate, INTERVAL (0-prmDaysToAdd) DAY);
    SELECT COUNT(*) INTO prmDaysToAdd
    FROM datevalues d LEFT JOIN holidayschedule h ON d.datevalue = h.holidaydate
    WHERE d.datevalue BETWEEN tmpDate AND date_add(tmpLastDate,interval -1 day)
      AND (d.DAYOFWEEK IN (1,7) OR h.dayOff=1 OR h.noShipping = 1);
    SET tmpCounter = tmpCounter + 1;
  END WHILE;
END;
END IF;

return date(tmpDate);

END $$

DELIMITER ;

/*
Requires tables: datevalues, holidayschedule

CREATE TABLE  `datevalues` (
  `DateValue` date NOT NULL,
  `YearValue` int(10) unsigned NOT NULL,
  `MonthValue` int(10) unsigned NOT NULL,
  `DayValue` int(10) unsigned NOT NULL,
  `WeekValue` int(10) unsigned NOT NULL,
  `QuarterValue` int(10) unsigned NOT NULL,
  `DAYOFWEEK` int(10) unsigned NOT NULL,
  `WeekDay` char(10) CHARACTER SET latin1 NOT NULL,
  `Holiday` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`DateValue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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