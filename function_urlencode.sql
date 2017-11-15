DELIMITER ;

DROP FUNCTION IF EXISTS urlencode;

DELIMITER |

CREATE FUNCTION urlencode (s VARCHAR(4096)) RETURNS VARCHAR(4096)
DETERMINISTIC 
CONTAINS SQL 
BEGIN
       DECLARE c VARCHAR(4096) DEFAULT '';
       DECLARE pointer INT DEFAULT 1;
       DECLARE s2 VARCHAR(4096) DEFAULT '';

       IF ISNULL(s) THEN
           RETURN NULL;
       ELSE
       SET s2 = '';
       WHILE pointer <= length(s) DO
          SET c = MID(s,pointer,1);
          IF c = ' ' THEN
             SET c = '+';
          ELSEIF NOT (ASCII(c) BETWEEN 48 AND 57 OR 
                ASCII(c) BETWEEN 65 AND 90 OR 
                ASCII(c) BETWEEN 97 AND 122) THEN
             SET c = concat("%",LPAD(CONV(ASCII(c),10,16),2,0));
          END IF;
          SET s2 = CONCAT(s2,c);
          SET pointer = pointer + 1;
       END while;
       END IF;
       RETURN s2;
END;
 
|

DELIMITER ;
