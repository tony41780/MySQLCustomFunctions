  DELIMITER $$

DROP FUNCTION IF EXISTS `ToDate` $$
CREATE FUNCTION `ToDate`(sIn varchar(1024)) RETURNS date
    DETERMINISTIC
BEGIN
      declare rtnDate DATE DEFAULT '2001-01-01';
      if (sIn like "__/__/__") OR (sIn like "__/_/__") OR (sIn like "_/__/__") OR (sIn like "_/_/__")THEN
          SET rtnDate = str_to_date(sIn, "%c/%e/%y");
      end if;
      if (sIn like "__/__/____") OR (sIn like "__/_/____") OR (sIn like "_/__/____") OR (sIn like "_/_/____") THEN
          SET rtnDate = str_to_date(sIn, "%c/%e/%Y");
      end if;
      if (sIn like "__-__-____") OR (sIn like "__-_-____") OR (sIn like "_-__-____") OR (sIn like "_-_-____") THEN
          SET rtnDate = str_to_date(sIn, "%c-%e-%Y");
      end if;
      if (sIn like "____-__-__") OR (sIn like "____-_-__") OR (sIn like "____-__-_") OR (sIn like "____-_-_") THEN
          SET rtnDate = str_to_date(sIn, "%Y-%c-%e");
      end if;
      if (sIn like "____.__.__") OR (sIn like "____._.__") OR (sIn like "____.__._") OR (sIn like "____._._") THEN
          SET rtnDate = str_to_date(sIn, "%Y.%c.%e");
      end if;
      if (sIn like "____/__/__") OR (sIn like "____/_/__") OR (sIn like "____/__/_") OR (sIn like "____/_/_") THEN
          SET rtnDate = str_to_date(sIn, "%Y/%c/%e");
      end if;
      if (sIn like "__-___-____") OR (sIn like "_-___-____")  THEN
          SET rtnDate = str_to_date(sIn, "%d-%b-%Y");
      end if;

      if (str_to_date(sIn,"%b %d, %Y") IS NOT NULL AND str_to_date(sIn,"%b %d, %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%b %d, %Y");
      end if;

      if (str_to_date(sIn,"%a %b %e %H:%i:%s CST %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s CST %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s CST %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s PST %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s PST %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s PST %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s MST %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s MST %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s MST %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s MDT %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s MDT %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s MDT %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s PDT %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s PDT %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s PDT %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s CDT %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s CDT %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s CDT %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s HAST %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s HAST %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s HAST %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s GMT %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s GMT %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s GMT %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s EDT %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s EDT %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s EDT %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s EST %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s EST %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s EST %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s AST %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s AST %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s AST %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s AKDT %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s AKDT %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s AKDT %Y");
      end if;
      if (str_to_date(sIn,"%a %b %e %H:%i:%s AKST %Y") IS NOT NULL AND str_to_date(sIn,"%a %b %e %H:%i:%s AKST %Y")!='0000-00-00') THEN
          SET rtnDate = str_to_date(sIn,"%a %b %e %H:%i:%s AKST %Y");
      end if;
      if (rtnDate='0000-00-00') THEN
          SET rtnDate = '2001-01-01';
      end if;
      RETURN  rtnDate;
END $$

DELIMITER ;