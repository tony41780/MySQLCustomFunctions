/* create tables...

DROP TABLE IF EXISTS `neuron`;
CREATE TABLE  `neuron` (
  `neuronID` int(10) unsigned NOT NULL auto_increment,
  `activation` double NOT NULL default '0',
  `bias` double NOT NULL default '-1',
  `threshold` double NOT NULL default '0',
  `layer` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`neuronID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `weight`;
CREATE TABLE  `weight` (
  `weightID` int(10) unsigned NOT NULL auto_increment,
  `source_neuronID` int(10) unsigned NOT NULL,
  `dest_neuronID` int(10) unsigned NOT NULL,
  `weight_value` double NOT NULL default '0',
  PRIMARY KEY  (`weightID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

# a XOR neuron sample
INSERT INTO `neuron` (`neuronID`,`activation`,`bias`,`threshold`,`layer`) VALUES
 (1,0,1,0.5,0),
 (2,1,1,0.75,0),
 (4,0,1,0.25,1),
 (5,1,1,1,1),
 (6,0,1,1,2);

# a XOR weighted sample
INSERT INTO `weight` (`weightID`,`source_neuronID`,`dest_neuronID`,`weight_value`) VALUES
 (3,1,4,1),
 (4,2,4,-1),
 (5,1,5,-1),
 (6,2,5,1),
 (7,4,6,1),
 (8,5,6,1);

*/

DROP TRIGGER neuron_Add;
DROP TRIGGER neuron_Delete;

DELIMITER ;;
CREATE TRIGGER neuron_Add
AFTER INSERT
ON neuron
FOR EACH ROW BEGIN 
  /* create a weight (link) between each neuron in the layer above and/or below */
  INSERT INTO weight (source_neuronID,dest_neuronID,weight_value) (
  SELECT x.source_neuronID,x.dest_neuronID,x.weight_value FROM (
    SELECT neuronID as source_neuronID, NEW.neuronID as dest_neuronID, 0 as weight_value FROM neuron WHERE layer = (NEW.layer - 1) AND class = NEW.class
    UNION
    SELECT NEW.neuronID as source_neuronID, neuronID as dest_neuronID, 0 as weight_value FROM neuron WHERE layer = (NEW.layer + 1) AND class = NEW.class
  ) x
  );
END;
;;

CREATE TRIGGER neuron_Delete
BEFORE DELETE
ON neuron
FOR EACH ROW BEGIN /* delete any weight (link) between each neuron in the layer above and/or below */
  delete from weight where  (dest_neuronID =  OLD.neuronID OR source_neuronID =  OLD.neuronID);
END;
;;
DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `NN_calcActivation` $$
CREATE PROCEDURE `NN_calcActivation` (prmClass varchar(45))
BEGIN
  DECLARE  tmpBottomLayer         INTEGER     DEFAULT -1;
  DECLARE  tmpCurrentLayer        INTEGER     DEFAULT 0;
  DECLARE  tmpCurrentNeuronID     INTEGER     DEFAULT 0;
  DECLARE  tmpActive              INTEGER     DEFAULT 0;
  DECLARE  done                   INTEGER     DEFAULT 0;
  DECLARE  cnt                    INTEGER     DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND   SET done = 1;
  SET cnt = (SELECT COUNT(*) FROM neuron);
  IF (cnt > 0) THEN
  BEGIN
    set tmpBottomLayer = (select MIN(layer) from neuron where class=prmClass);
    if (tmpBottomLayer > -1) then
    begin
      DECLARE NNCur CURSOR FOR
         SELECT distinct layer, neuronID
          FROM neuron
  		WHERE layer > tmpBottomLayer and class=prmClass
          order by layer, neuronID;
      OPEN NNCur;
      REPEAT
        FETCH NNCur INTO tmpCurrentLayer, tmpCurrentNeuronID;
        # determine if the current neuron is activated
        select count(*) INTO cnt
          FROM neuron WHERE layer = tmpCurrentLayer and neuronID = tmpCurrentNeuronID;
        if (cnt > 0) then
        begin
          select if(sum(w.weight_value * (nnBottom.bias * nnBottom.activation))>=nnTop.threshold,1,0)
            INTO tmpActive
            from neuron nnTop
            INNER JOIN weight w ON nnTop.neuronID = w.dest_neuronID
            INNER JOIN neuron nnBottom ON w.source_neuronID = nnBottom.neuronID
            where nnTop.layer = tmpCurrentLayer and nnTop.neuronID = tmpCurrentNeuronID
            group by nnTop.neuronID;
          # update the current neuron
          UPDATE neuron SET activation = tmpActive WHERE neuronID = tmpCurrentNeuronID;
        end;
        end if;
      UNTIL done END REPEAT;
      CLOSE NNCur;
    end;
    end if;
  end;
  end if;
END $$


DROP PROCEDURE IF EXISTS `NN_backPropagate` $$
CREATE PROCEDURE `NN_backPropagate` (
  prmNeuronID       integer,
  prmExpextedValue  integer
)
BEGIN
  DECLARE  tmpCurrentLayer        INTEGER     DEFAULT 0;
  DECLARE  tmpDelta               INTEGER     DEFAULT 0;
  DECLARE  tmpClass               VARCHAR(45) DEFAULT "NONE";
  SET tmpClass = (SELECT class FROM neuron WHERE neuronID = prmNeuronID);
  call `NN_calcActivation`(tmpClass); /* make sure that we aren't correcting something that was never calculated */
  SELECT layer, (prmExpextedValue - (activation * bias))
    INTO tmpCurrentLayer,tmpDelta
    FROM neuron WHERE neuronID = prmNeuronID;
  if (tmpDelta != 0) then
  begin
    # adjust the weights based on weight percentage
    # TBD

  end;
  end if;

END $$

DELIMITER ;