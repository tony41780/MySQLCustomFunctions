DELIMITER $$

DROP FUNCTION IF EXISTS `GetZipDistance` $$
CREATE FUNCTION `GetZipDistance` (prmZipFrom char(5),prmZipTo char(5)) RETURNS double
  DETERMINISTIC
BEGIN
  DECLARE tmpDist double default 0;

  SELECT ROUND(SQRT(POW((69.1 * (z2.latitude - z1.Latitude)),2) +
      POW((69.1 * (z2.longitude - z1.Longitude) * COS(z1.Latitude/57.3)),2)),2)
    into tmpDist
  FROM zip z1 inner join  zip z2 on z2.zipcode=prmZipFrom
  where z1.zipcode=prmZipTo;
  SET tmpDist = IFNULL(tmpDist,0);
  RETURN tmpDist;

END $$

DELIMITER ;

/*
Requires table: zip
CREATE TABLE  `zip` (
  `zipCode` char(7) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,  
  KEY `zipIndex_1` (`zipCode`)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

*/