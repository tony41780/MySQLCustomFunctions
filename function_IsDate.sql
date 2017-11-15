DELIMITER $$

CREATE FUNCTION IsDate (sIn varchar(1024)) RETURNS INT DETERMINISTIC
BEGIN
  declare tp int;
  if (select length(date(sIn)) is null )then
    set tp = 0;
  else
    set tp = 1;
  end if;
  RETURN tp;

END $$

DELIMITER ;