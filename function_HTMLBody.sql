DELIMITER $$

DROP FUNCTION IF EXISTS `HTMLBody` $$
CREATE FUNCTION `HTMLBody`(Msg varchar(8192)) RETURNS varchar(17408) CHARSET latin1
    DETERMINISTIC
BEGIN
  declare tmpMsg varchar(17408);
  declare tmpRandomID char(36) DEFAULT '_NextPart_000_0000_01CA4B3F.8C263EE0';
  set tmpMsg = cast(concat(
      'MIME-Version: 1.0','\r\n',
      'Content-Type: multipart/alternative;','\r\n','\t',
      'boundary=\"----=',tmpRandomID,'\"','\r\n',
      'Content-Class: urn:content-classes:message','\r\n',
      'Importance: normal','\r\n',
      'Priority: normal','\r\n','','\r\n','','\r\n',
      'This is a multi-part message in MIME format.','\r\n','','\r\n',
      '------=',tmpRandomID,'\r\n',
      'Content-Type: text/plain;','\r\n',
      '  charset=\"iso-8859-1\"','\r\n',
      'Content-Transfer-Encoding: 7bit','\r\n','','\r\n','','\r\n',
      replace(replace(replace(replace(replace(ifnull(Msg,''),'<br/>','\r\n'),'<b>','['),'</b>',']'),'<i>','*'),'</i>','*'),
      '\r\n','','\r\n','','\r\n',
      '------=',tmpRandomID,'\r\n',
      'Content-Type: text/html','\r\n',
      'Content-Transfer-Encoding: 7bit','\r\n','','\r\n',
      ifnull(Msg,''),
      '','\r\n','------=',tmpRandomID,'--'
      ) as char);
  RETURN tmpMsg;
END $$

DELIMITER ;