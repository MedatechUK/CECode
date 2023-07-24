/**/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'PARTARC/ZCLA_PARTREPLACE' , SQL.USER
FROM DUMMY FORMAT ADDTO :DEBUGFILE ;
/*
*/
:ERR = '' ;
SELECT :PART , SQL.USER
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Get PARTARC by Part */
#INCLUDE PARTARC/ZCLA_BUF3
SELECT * FROM ZCLA_PARTARC
FORMAT ADDTO :DEBUGFILE ;
/*
*/
:ZCLA_FIXID = :FAMILY = :PART = 0 ;
:SON = :SONACT = :ACT = :RVFROMDATE = 0 ;
:REPLACEPART = :FAMILY = :WHITE = :MANFID = 0 ;
:DEL = :ZCLA_WHITE = ''
;
SELECT COL INTO :WHITE
FROM ZCLA_ACCYCOL
WHERE NAME = 'White'
;
DECLARE @BOM03 CURSOR FOR
SELECT DISTINCT PART , SON , SONACT
,               ACT , RVFROMDATE
,               ZCLA_FIXID , ZCLA_WHITE , STYLE
,               FAMILY
FROM ZCLA_PARTARC
WHERE 0=0
AND   USER = SQL.USER
AND   SON IN (SELECT PART FROM ZCLA_GENERICMANF)
;
OPEN @BOM03;
GOTO 9 WHERE :RETVAL = 0;
LABEL 1;
FETCH @BOM03 INTO :PART , :SON , :SONACT , :ACT , :RVFROMDATE
,              :ZCLA_FIXID, :ZCLA_WHITE, :STYLE , :FAMILY ;
GOTO 8 WHERE :RETVAL = 0
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
SELECT MANFID , ( :ZCLA_WHITE <> 'Y' ? ZCLA_DEFAULTMANF.COL : :WHITE )
INTO :MANFID , :COL
FROM ZCLA_DEFAULTMANF
WHERE 0=0
AND   ALT = :ALT
AND   CUST = :PCUST
AND   ZCLA_DEFAULTMANF.FAMILY = :FAMILY
AND   STYLE = :STYLE
;
GOTO 400 ;
LABEL 300 ;
/* from site */
SELECT MANFID , ( :ZCLA_WHITE <> 'Y' ? ZCLA_PROJMANF.COL : :WHITE )
INTO :MANFID , :COL
FROM ZCLA_PROJMANF
WHERE 0=0
AND   ALT = :ALT
AND   DOC = :DOC
AND   ZCLA_PROJMANF.FAMILY = :FAMILY
AND   STYLE = :STYLE
;
LABEL 400 ;
/*
*/
:REPLACEPART = 0 ;
SELECT REPLPART INTO :REPLACEPART
FROM ZCLA_GENERICMANF , PART
WHERE 0=0
AND   ZCLA_GENERICMANF.REPLPART = PART.PART
AND   PART.FAMILY = :FAMILY
AND   MNF = :MANFID
AND   ZCLA_GENERICMANF.PART = :SON
AND   COL = :COL
;
SELECT 'Y' INTO :ERR
FROM DUMMY
WHERE :REPLACEPART = 0
;
/*
*/
SELECT 'REPLACE FAIL >>'
,      :DOC , :ALT , :PART , :FAMILY , :SON , :MANFID 
,      FAMILY.FAMILYNAME
,      PARENT.PARTNAME AS PARENT
,      SON.PARTNAME AS SON
,      MNFCTR.MNFNAME
,      ( :ZCLA_WHITE <> 'Y' ? :COL : :WHITE ) AS COL
FROM PART PARENT , PART SON , FAMILY , MNFCTR
WHERE 0=0
AND   PARENT.FAMILY = FAMILY.FAMILY
AND   PARENT.PART = :PART
AND   SON.PART = :SON
AND   MNFCTR.MNF = :MANFID  
AND   :DEBUG = 1 
AND   :REPLACEPART = 0
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT :REPLACEPART , :ERR
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
UPDATE ZCLA_PARTARC
SET SON = :REPLACEPART
WHERE 0=0
AND   USER = SQL.USER
AND   PART = :PART
AND   SON = :SON
AND   ZCLA_WHITE = :ZCLA_WHITE
AND   STYLE = :STYLE
AND   :REPLACEPART > 0
;
LOOP 1;
LABEL 8;
CLOSE @BOM03;
LABEL 9;