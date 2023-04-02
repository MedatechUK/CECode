/*
Consumer Unit parts for Element */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'PARTARC/ZCLA_ELCUNITBOM' , SQL.USER , :ELEMENT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
:ROOM = 0;
/*
Determine blank part */
#INCLUDE PART/ZCLA_CUNITBOM
SELECT :BLANKPART
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Declare CUNIT cursor */
DECLARE @ELCU CURSOR FOR
SELECT CU.CONSUMERUNIT
FROM ZCLA_PLOTCU CU
WHERE 0=0
AND CU.PROJACT = :ELEMENT
;
OPEN @ELCU;
GOTO 9898 WHERE :RETVAL <= 0;
LABEL 1212;
:CONSUMERUNIT = :CFGCOUNT = :TOTALWAYS = 0;
FETCH @ELCU INTO :CONSUMERUNIT;
GOTO 9898 WHERE :RETVAL <= 0;
SELECT :CONSUMERUNIT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/* 
Count how many child parts in the consumer unit */
SELECT SUM(ZCLA_CUNITWAYS)
INTO :CFGCOUNT
FROM ZCLA_PLOTCUCFG CFG, PART P
WHERE CFG.CONSUMERUNIT = :CONSUMERUNIT
AND CFG.PART = P.PART ;
/*
Select total waycount from cunit, total required blanks */
:BLANKSUM = 0;
SELECT P.ZCLA_CUNITWAYS - :CFGCOUNT
INTO :BLANKSUM
FROM ZCLA_PLOTCU CU, PART P
WHERE CU.CONSUMERUNIT = :CONSUMERUNIT
AND CU.PART = P.PART ;
SELECT :BLANKSUM
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
/* 4 inserts take place here.
PART, SON = 0, ZCLA.CONSUMERUNIT.PART
PART, SON = ZCLA_CONSUMERUNITS.PART, ZCLA_CUNITCONFIG.PART
PART, SON = ZCLA_CONSUMERUNITS.PART, :BLANKPART
PART, SON = ZCLA_CUNITCONFIG.PART, PARTARC.SON
/*
Insert CUNIT and CUNITCONFIG parts into bom */
/*
Insert PART,SON as 0, cunitpart */
INSERT INTO ZCLA_PARTARC ( USER
,   PART
,   SON
,   ACT
,   OP
,   COEF
,   SONACT
,   SONQUANT
,   RVFROMDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
)
SELECT SQL.USER
,      PART.PART
,      SONPART.PART
,      -3
,      'C'
,      PARTARC.SONQUANT
,      -3
,      PARTARC.SONQUANT
,      SQL.DATE
,      PARTARC.ZCLA_FIXID
,      PARTARC.ZCLA_WHITE
FROM   PART SONPART
,      PARTARC
,      ZCLA_PLOTCU
,      PART
WHERE 0=0
AND   ZCLA_PLOTCU.PART = PART.PART
AND   PARTARC.PART = ZCLA_PLOTCU.PART
AND   SONPART.PART = PARTARC.SON
AND   ZCLA_PLOTCU.PROJACT = :ELEMENT
AND   ZCLA_PLOTCU.CONSUMERUNIT = :CONSUMERUNIT ;
/* 
Insert CUNITCONFIG parts */
INSERT INTO ZCLA_PARTARC ( USER
,   PART
,   SON
,   ACT
,   OP
,   COEF
,   SONACT
,   SONQUANT
,   RVFROMDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
)
SELECT SQL.USER
,      PARTARC.PART
,      SONPART.PART
,      -3
,      'C'
,      PARTARC.SONQUANT
,      -3
,      PARTARC.SONQUANT
,      SQL.DATE
,      PARTARC.ZCLA_FIXID
,      PARTARC.ZCLA_WHITE
FROM   PART SONPART
,      PARTARC
,      ZCLA_PLOTCU
,      ZCLA_PLOTCUCFG
WHERE 0=0
AND   ZCLA_PLOTCU.CONSUMERUNIT = ZCLA_PLOTCUCFG.CONSUMERUNIT
AND   PARTARC.PART = ZCLA_PLOTCUCFG.PART
AND   SONPART.PART = PARTARC.SON
AND   ZCLA_PLOTCU.PROJACT = :ELEMENT
AND   ZCLA_PLOTCUCFG.CONSUMERUNIT = :CONSUMERUNIT ;
/* 
Insert CUNIT and BLANKS parts as part, son */
INSERT INTO ZCLA_PARTARC ( USER
,   PART
,   SON
,   ACT
,   OP
,   COEF
,   SONACT
,   SONQUANT
,   RVFROMDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
)
SELECT SQL.USER
,      PART
,      :BLANKPART
,      -3
,      'C'
,      :BLANKSUM
,      -3
,      :BLANKSUM
,      SQL.DATE
,      2
,      'Y'
FROM ZCLA_PLOTCU
WHERE 0=0
AND   ZCLA_PLOTCU.PROJACT = :ELEMENT
AND   ZCLA_PLOTCU.CONSUMERUNIT = :CONSUMERUNIT ;
/*
*/
LOOP 1212;
LABEL 9898;
CLOSE @ELCU;
LABEL 9999 ;
