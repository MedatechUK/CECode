/**/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'PARTARC/ZCLA_TCUNITBOM' , SQL.USER , :ELACT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Determine blank part */
#INCLUDE PART/ZCLA_CUNITBOM
SELECT :BLANKPART
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Declare CUNIT cursor */
DECLARE @CUCURSOR CURSOR FOR
SELECT CU.CONSUMERUNIT , ROOM
FROM ZCLA_PLOTCU CU
WHERE 0=0
AND CU.PROJACT = :ELACT
/*GergoM | 15/11/23 | ISDELETED <> 'Y' AND CONSUMERUNIT > 0*/
AND CU.ISDELETED <> 'Y'
AND CU.CONSUMERUNIT > 0
;
OPEN @CUCURSOR;
GOTO 9999 WHERE :RETVAL <= 0;
LABEL 1212;
:ROOM = :CONSUMERUNIT = :CFGCOUNT = :TOTALWAYS = 0;
FETCH @CUCURSOR INTO :CONSUMERUNIT , :ROOM ;
GOTO 9898 WHERE :RETVAL <= 0;
SELECT :CONSUMERUNIT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/* Count how many child parts in the consumer unit */
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
/* 3 inserts take place here.
.  parts under the consumer unit
.  parts in the CU config
.  Blanks
*/
/*
Insert Consumer unit parts */
SELECT MAX(KLINE) + 1 INTO :LN
FROM ZCLA_PROJACTTREE
WHERE COPYUSER = SQL.USER ;
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
,   PART
,   FAMILY
,   STYLE
)
SELECT SQL.USER
,      :FIXACT
,      :LN + SQL.LINE
,      SONPART.PART
/*GergoM | 04/12/23 |  * ZCLA_PLOTCU.ZGEM_TQUANT*/
,      PARTARC.SONQUANT * ZCLA_PLOTCU.ZGEM_TQUANT
,      SQL.USER
,      SQL.DATE
,      SQL.DATE
,      PARTARC.SONQUANT * ZCLA_PLOTCU.ZGEM_TQUANT
,      :DOC
,      ( :IGNOREROOM = 1 ? 0 : :ROOM)
,      'Y'
,      PART.PART
,      ( SONPART.FAMILY = :FAM_INHERIT ? PARENTPART.FAMILY :
SONPART.FAMILY )
,      'White'
FROM   PART SONPART
,      PART PARENTPART
,      PARTARC
,      ZCLA_PLOTCU
,      PART
WHERE 0=0
AND   ZCLA_PLOTCU.PART = PART.PART
AND   PARTARC.PART = ZCLA_PLOTCU.PART
AND   SONPART.PART = PARTARC.SON
AND   PARENTPART.PART = PARTARC.PART
AND   ZCLA_PLOTCU.PROJACT = :ELACT
AND   ZCLA_PLOTCU.CONSUMERUNIT = :CONSUMERUNIT
AND   PARTARC.ZCLA_FIXID = :FIX
/*GergoM | 15/11/23 | ISDELETED <> 'Y' AND CONSUMERUNIT > 0*/
AND   ZCLA_PLOTCU.ISDELETED <> 'Y'
AND   ZCLA_PLOTCU.CONSUMERUNIT > 0
;
/* Insert CUNITCONFIG parts */
SELECT MAX(KLINE) + 1 INTO :LN
FROM ZCLA_PROJACTTREE
WHERE COPYUSER = SQL.USER ;
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
,   PART
,   FAMILY
,   STYLE
)
SELECT SQL.USER
,      :FIXACT
,      :LN + SQL.LINE
,      SONPART.PART
/*GergoM | 04/12/23 |  * ZCLA_PLOTCU.ZGEM_TQUANT*/
,      PARTARC.SONQUANT * ZCLA_PLOTCU.ZGEM_TQUANT
,      SQL.USER
,      SQL.DATE
,      SQL.DATE
,      PARTARC.SONQUANT * ZCLA_PLOTCU.ZGEM_TQUANT
,      :DOC
,      ( :IGNOREROOM = 1 ? 0 : :ROOM)
,      'Y'
,      ZCLA_PLOTCUCFG.PART
,      ( SONPART.FAMILY = :FAM_INHERIT ? PARENTPART.FAMILY :
SONPART.FAMILY )
,      'White'
FROM   PART SONPART
,      PART PARENTPART
,      PARTARC
,      ZCLA_PLOTCU
,      ZCLA_PLOTCUCFG
WHERE 0=0
AND   ZCLA_PLOTCU.CONSUMERUNIT = ZCLA_PLOTCUCFG.CONSUMERUNIT
AND   PARTARC.PART = ZCLA_PLOTCUCFG.PART
AND   SONPART.PART = PARTARC.SON
AND   PARENTPART.PART = PARTARC.PART
AND   ZCLA_PLOTCU.PROJACT = :ELACT
AND   ZCLA_PLOTCUCFG.CONSUMERUNIT = :CONSUMERUNIT
AND   PARTARC.ZCLA_FIXID = :FIX
/*GergoM | 15/11/23 | ISDELETED <> 'Y' AND CONSUMERUNIT > 0*/
AND   ZCLA_PLOTCU.ISDELETED <> 'Y'
AND   ZCLA_PLOTCU.CONSUMERUNIT > 0
;
/* Insert CUNIT and BLANKS parts as part, son */
SELECT MAX(KLINE) + 1 INTO :LN
FROM ZCLA_PROJACTTREE
WHERE COPYUSER = SQL.USER ;
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
,   PART
,   FAMILY
,   STYLE
)
SELECT SQL.USER
,   :FIXACT
,   :LN
,   :BLANKPART
,   :BLANKSUM
,   SQL.USER
,   SQL.DATE
,   SQL.DATE
,   :BLANKSUM
,   :DOC
,   ( :IGNOREROOM = 1 ? 0 : :ROOM)
,   'Y'
,   PART
,   :FAM_CU
,   'White'
FROM ZCLA_PLOTCU
WHERE 0=0
AND   ZCLA_PLOTCU.PROJACT = :ELACT
AND   ZCLA_PLOTCU.CONSUMERUNIT = :CONSUMERUNIT
AND   :FIX = 2
/*GergoM | 15/11/23 | ISDELETED <> 'Y' AND CONSUMERUNIT > 0*/
AND   ZCLA_PLOTCU.ISDELETED <> 'Y'
AND   ZCLA_PLOTCU.CONSUMERUNIT > 0
;
LOOP 1212;
LABEL 9898;
CLOSE @CUCURSOR;
LABEL 9999 ;
