/**/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'PARTARC/ZCLA_HTREPLACE' , SQL.USER
FROM DUMMY FORMAT ADDTO :DEBUGFILE ;
/*
*/
:ERR = '' ;
DELETE FROM ZCLA_PARTARC
WHERE 0=0
AND   USER = SQL.USER
;
INSERT INTO ZCLA_PARTARC ( USER
,   PART
,   SON
,   ACT
,   VAR
,   OP
,   COEF
,   SONACT
,   SCRAP
,   SONQUANT
,   ISSUEONLY
,   FROMDATE
,   TILLDATE
,   RVFROMDATE
,   RVTILLDATE
,   INFOONLY
,   SONPARTREV
,   SETEXPDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
,   COL
)
SELECT SQL.USER
,   PARTARC.PART
,   SON
,   ACT
,   VAR
,   OP
,   SUM( PARTARC.SONQUANT) * SUM( ZCLA_COMPONENT.TQUANT / 1000 ) AS COEF
,   SONACT
,   SCRAP
,   SUM( PARTARC.SONQUANT) * SUM (ZCLA_COMPONENT.TQUANT / 1000) AS SONQUANT
,   ISSUEONLY
,   FROMDATE
,   TILLDATE
,   RVFROMDATE
,   RVTILLDATE
,   INFOONLY
,   SONPARTREV
,   SETEXPDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
,   ZCLA_COMPONENT.COL
FROM PARTARC , ZCLA_COMPONENT , ZCLA_ROOMS , ZCLA_HOUSETYPE
WHERE 0=0
AND   PARTARC.PART = ZCLA_COMPONENT.PART
AND   ZCLA_COMPONENT.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_ROOMS.HOUSETYPEID = ZCLA_HOUSETYPE.HOUSETYPEID
AND   ZCLA_HOUSETYPE.HOUSETYPEID = :HOUSETYPE
GROUP BY  PARTARC.PART
,     PARTARC.SON
,     PARTARC.ACT
,     PARTARC.VAR
,     PARTARC.OP
,     PARTARC.SONACT
,     PARTARC.SCRAP
,     PARTARC.ISSUEONLY
,     PARTARC.FROMDATE
,     PARTARC.TILLDATE
,     PARTARC.RVFROMDATE
,     PARTARC.RVTILLDATE
,     PARTARC.INFOONLY
,     PARTARC.SONPARTREV
,     PARTARC.SETEXPDATE
,     PARTARC.ZCLA_FIXID
,     PARTARC.ZCLA_WHITE
,     ZCLA_COMPONENT.COL
;
#INCLUDE PARTARC/ZCLA_HTCUNITBOM
#INCLUDE PARTARC/ZCLA_SHEATHING
/*
*/
SELECT * FROM ZCLA_PARTARC
WHERE 0=0
AND   USER = SQL.USER
AND   :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
:ZCLA_FIXID = :FAMILY = :PART = 0 ;
:SON = :SONACT = :ACT = :RVFROMDATE = :COL = 0 ;
:REPLACEPART = :MANFID = :FAMILY = :WHITE = 0 ;
:DEL = :ZCLA_WHITE = '';
/*
*/
SELECT COL INTO :WHITE
FROM ZCLA_ACCYCOL
WHERE NAME = 'White'
;
#INCLUDE ZCLA_ALTMANUF/ZCLA_HOUSETYPE
DECLARE @BOM02 CURSOR FOR
SELECT DISTINCT PART , SON , SONACT
,               ACT , RVFROMDATE
,               ZCLA_FIXID , ZCLA_WHITE , COL
FROM ZCLA_PARTARC
WHERE 0=0
AND   USER = SQL.USER
AND   SON IN (SELECT PART FROM ZCLA_GENERICMANF)
;
OPEN @BOM02;
GOTO 9 WHERE :RETVAL = 0;
LABEL 1;
FETCH @BOM02 INTO :PART , :SON , :SONACT , :ACT , :RVFROMDATE
,              :ZCLA_FIXID, :ZCLA_WHITE, :COL ;
GOTO 8 WHERE :RETVAL = 0
;
SELECT  :PART , :SON , :SONACT , :ACT
,       :RVFROMDATE , :ZCLA_FIXID
,       :ZCLA_WHITE , :COL , :ALT
FROM DUMMY
WHERE   :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
SELECT FAMILY INTO :FAMILY
FROM PART WHERE PART = :PART
;
/* select manufacturer from default or site
*/
GOTO 300 WHERE NOT EXISTS (
SELECT 'x' FROM ZCLA_HOUSETYPE
WHERE 0=0
AND   CORE = 'Y'
AND   HOUSETYPEID = :HOUSETYPE
);
/* from default */
:PCUST = 0 ;
SELECT PCUST INTO :PCUST
FROM CUSTOMERS
WHERE CUST = :DOC
;
SELECT :TYPE , :DOC , :PCUST
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT MANFID INTO :MANFID
FROM ZCLA_DEFAULTMANF
WHERE 0=0
AND   ALT = :ALT
AND   CUST = :PCUST
AND   ZCLA_DEFAULTMANF.FAMILY = :FAMILY
AND   COL = ( :ZCLA_WHITE <> 'Y' ? :COL : :WHITE)
;
GOTO 400 ;
LABEL 300 ;
/* from site */
SELECT MANFID INTO :MANFID
FROM ZCLA_PROJMANF
WHERE 0=0
AND   ALT = :ALT
AND   DOC = :DOC
AND   ZCLA_PROJMANF.FAMILY = :FAMILY
AND   COL = ( :ZCLA_WHITE <> 'Y' ? :COL : :WHITE)
;
LABEL 400 ;
/*
*/
SELECT :DOC , :COL , :MANFID , :FAMILY, :PART , :SON
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
:REPLACEPART = 0 ;
SELECT REPLPART INTO :REPLACEPART
FROM ZCLA_GENERICMANF , PART
WHERE 0=0
AND   ZCLA_GENERICMANF.REPLPART = PART.PART
AND   PART.FAMILY = :FAMILY
AND   MNF = :MANFID
AND   ZCLA_GENERICMANF.PART = :SON
AND   COL = ( :ZCLA_WHITE <> 'Y'? :COL : :WHITE )
;
SELECT 'Y' INTO :ERR
FROM DUMMY
WHERE :REPLACEPART = 0
;
/*
*/
SELECT 'REPLACE', :PART , :REPLACEPART , :ERR
,      :HOUSETYPE , ( :ZCLA_WHITE <> 'Y'? :COL : :WHITE )
FROM DUMMY
WHERE :DEBUG = 1 AND :REPLACEPART = 0
FORMAT ADDTO :DEBUGFILE ;
/*
Set the component missing flag */
UPDATE  ZCLA_COMPONENT
SET     ZCLA_MISSINGREPL = (:REPLACEPART = 0 ? 'Y' : '')
WHERE   0=0
AND    COMPONENT IN (
SELECT    ZCLA_COMPONENT.COMPONENT
FROM      ZCLA_COMPONENT , ZCLA_ROOMS , ZCLA_HOUSETYPE
WHERE     0=0
AND       ZCLA_COMPONENT.ROOM = ZCLA_ROOMS.ROOM
AND       ZCLA_ROOMS.HOUSETYPEID = ZCLA_HOUSETYPE.HOUSETYPEID
AND       ZCLA_COMPONENT.PART = :PART
AND       ZCLA_COMPONENT.COL = ( :ZCLA_WHITE <> 'Y'? :COL : :WHITE )
AND       ZCLA_HOUSETYPE.HOUSETYPEID = :HOUSETYPE
);
/*
*/
UPDATE ZCLA_PARTARC
SET SON = :REPLACEPART
WHERE 0=0
AND   USER = SQL.USER
AND   PART = :PART
AND   SON = :SON
AND   ZCLA_WHITE = :ZCLA_WHITE
AND   COL = :COL
AND   :REPLACEPART > 0
;
/*
*/
LOOP 1;
LABEL 8;
CLOSE @BOM02;
LABEL 9;
#INCLUDE PARTARC/ZCLA_HOUSETYPE