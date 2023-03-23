/**/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'PARTARC/TZCLA_CUNITBOM' , SQL.USER
FROM DUMMY FORMAT ADDTO :DEBUGFILE ;
/*
*/
:PARENTPROJACT = :PARENTKLINE = 0
;
SELECT PROJACT , KLINE
INTO :PARENTPROJACT , :PARENTKLINE
FROM ZCLA_PROJACTTREE , PART
WHERE 0=0
AND   ZCLA_PROJACTTREE.SONPART = PART.PART
AND   ZCLA_PROJACTTREE.COPYUSER = SQL.USER ;
/*
*/
:ERR = '' ;
DELETE FROM ZCLA_PARTARC
WHERE 0=0
AND   USER = SQL.USER;
/* Select the HouseType BY ELEMENT */
:HOUSETYPE = 0;
SELECT ZCLA_HOUSETYPEID
INTO :HOUSETYPE
FROM PROJACTS
WHERE PROJACT = :ELEMENT
;
/* Declare CUNIT cursor */
DECLARE @CUCURSOR CURSOR FOR
SELECT CU.CONSUMERUNIT
FROM ZCLA_CONSUMERUNITS CU
WHERE 0=0
AND CU.HOUSETYPEID = :HOUSETYPE
;
OPEN @CUCURSOR;
GOTO 9898 WHERE :RETVAL <= 0;
LABEL 1212;
:CONSUMERUNIT = 0;
:CFGCOUNT = :TOTALWAYS = 0;
FETCH @CUCURSOR INTO :CONSUMERUNIT;
GOTO 9898 WHERE :RETVAL <= 0;
/* Count how many child parts in the consumer unit */
SELECT SUM(ZCLA_CUNITWAYS)
INTO :CFGCOUNT
FROM ZCLA_CUNITCONFIG CFG, PART P
WHERE CFG.CONSUMERUNIT = :CONSUMERUNIT
AND CFG.PART = P.PART
;
/* Select total waycount from cunit, total required blanks */
:BLANKSUM = 0;
SELECT P.ZCLA_CUNITWAYS - :CFGCOUNT
INTO :BLANKSUM
FROM ZCLA_CONSUMERUNITS CU, PART P
WHERE CU.CONSUMERUNIT = :CONSUMERUNIT
AND CU.PART = P.PART
;
/* Determine blank part */
#INCLUDE PART/ZCLA_CUNITBOM
LABEL 8787;
/* 4 inserts take place here.
PART, SON = 0, ZCLA.CONSUMERUNIT.PART
PART, SON = ZCLA_CONSUMERUNITS.PART, ZCLA_CUNITCONFIG.PART
PART, SON = ZCLA_CONSUMERUNITS.PART, :BLANKPART
PART, SON = ZCLA_CUNITCONFIG.PART, PARTARC.SON

/* Insert CUNIT and CUNITCONFIG parts into bom */
:PART = :SON = :SONACT = :ACT = :ZCLA_FIXID = :USER = 0 ;
:RVFROMDATE = 0;
:ZCLA_WHITE = '';
SELECT PART, SON, SONACT, ACT, RVFROMDATE, ZCLA_FIXID, USER, ZCLA_WHITE
INTO :PART, :SON, :SONACT, :ACT, :RVFROMDATE,:ZCLA_FIXID,:USER,:ZCLA_WHITE
FROM ZCLA_PARTARC WHERE PART <> 0
;
/* Insert PART,SON as 0, cunitpart */ 
/* Insert into ZCLA_PROJACTTREE for 25mm sheathing*/
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   PROJACT
,   KLINE
,   SONPART
,   SONQUANT
,   USER
,   UDATE
,   DUEDATE
,   RATIO
,   DOC
,   ZCLA_ROOM
,   WHITE
,   COL
)
SELECT SQL.USER
,   PROJACT
,   :LN
,   CU.PART
,   1
,   SQL.USER
,   SQL.DATE
,   SQL.DATE
,   1
,   DOC
,   ( :IGNOREROOM = 1 ? 0 : ZCLA_ROOM)
,   WHITE
,   COL
FROM ZCLA_PROJACTTREE, ZCLA_CONSUMERUNITS CU
WHERE 0=0
AND   CU.CONSUMERUNIT = :CONSUMERUNIT
AND   PROJACT = :PARENTPROJACT 
AND   KLINE =   :PARENTKLINE
;
/* Insert CUNITCONFIG parts */
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   PROJACT
,   KLINE
,   SONPART
,   SONQUANT
,   USER
,   UDATE
,   DUEDATE
,   RATIO
,   DOC
,   ZCLA_ROOM
,   WHITE
,   COL
)
SELECT SQL.USER
,   PROJACT
,   :LN
,   CFG.PART
,   1
,   SQL.USER
,   SQL.DATE
,   SQL.DATE
,   1
,   DOC
,   ( :IGNOREROOM = 1 ? 0 : ZCLA_ROOM)
,   WHITE
,   COL
FROM ZCLA_PROJACTTREE, ZCLA_CONSUMERUNITS CU, ZCLA_CUNITCONFIG CFG
WHERE 0=0
AND CU.CONSUMERUNIT = :CONSUMERUNIT
AND CU.CONSUMERUNIT = CFG.CONSUMERUNIT
AND   PROJACT = :PARENTPROJACT 
AND   KLINE =   :PARENTKLINE
;
/* Insert CUNIT and BLANKS parts as part, son */
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   PROJACT
,   KLINE
,   SONPART
,   SONQUANT
,   USER
,   UDATE
,   DUEDATE
,   RATIO
,   DOC
,   ZCLA_ROOM
,   WHITE
,   COL
)
SELECT SQL.USER
,   PROJACT
,   :LN
,   :BLANKPART
,   :BLANKSUM
,   SQL.USER
,   SQL.DATE
,   SQL.DATE
,   :BLANKSUM
,   DOC
,   ( :IGNOREROOM = 1 ? 0 : ZCLA_ROOM)
,   WHITE
,   COL
FROM ZCLA_PROJACTTREE, ZCLA_CONSUMERUNITS CU
WHERE 0=0
AND   CU.CONSUMERUNIT = :CONSUMERUNIT
AND   PROJACT = :PARENTPROJACT 
AND   KLINE =   :PARENTKLINE
;
/* Insert CUNITCONFIG children parts*/
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   PROJACT
,   KLINE
,   SONPART
,   SONQUANT
,   USER
,   UDATE
,   DUEDATE
,   RATIO
,   DOC
,   ZCLA_ROOM
,   WHITE
,   COL
)
SELECT SQL.USER
,   PROJACT
,   :LN
,   PARTARC.SON
,   PARTARC.SONQUANT
,   SQL.USER
,   SQL.DATE
,   SQL.DATE
,   PARTARC.SONQUANT
,   DOC
,   ( :IGNOREROOM = 1 ? 0 : ZCLA_ROOM)
,   WHITE
,   COL
FROM ZCLA_CUNITCONFIG CFG, PARTARC, ZCLA_PROJACTTREEE
WHERE 0=0
AND   CFG.CONSUMERUNIT = :CONSUMERUNIT
AND   PARTARC.PART = CFG.PART
AND   PROJACT = :PARENTPROJACT 
AND   KLINE =   :PARENTKLINE
;
LOOP 1212;
LABEL 9898;
CLOSE @CUCURSOR;

