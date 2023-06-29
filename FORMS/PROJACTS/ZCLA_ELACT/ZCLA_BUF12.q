/*
*/
SELECT '>>> BEGIN EXTRA SPLIT'
FROM DUMMY FORMAT ADDTO :DEBUGFILE ;
/* 
Get Extras from pricelist */
SELECT SQL.TMPFILE INTO :PL FROM DUMMY ;
LINK PRICELIST TO :PL;
ERRMSG 1 WHERE :RETVAL = 0 ;
#INCLUDE ZCLA_ELACT/ZCLA_BUF14 
/*
*/
:EXTRAS = 0.0 ;
SELECT SUM 
(   ZCLA_PARTARC.SONQUANT * PARTPRICE.PRICE )
INTO :EXTRAS
FROM   ZCLA_PARTARC
,      PARTPRICE 
WHERE 0 = 0 
AND   ZCLA_PARTARC.PART = PARTPRICE.PART
AND   ZCLA_PARTARC.USER = SQL.USER 
AND   ZCLA_PARTARC.EXTRA = 'Y'
AND   ZCLA_PARTARC.PACKAGE <> 'Y'
;
UNLINK PRICELIST ;
/*
*/
SELECT SUM( PACKAGECOST ) + :EXTRAS INTO :ZCLA_TOTCOST
FROM ZCLA_ELEDIT WHERE EDITID IN (
SELECT DISTINCT ZCLA_PARTARC.EDITID 
FROM ZCLA_PARTARC , ZCLA_ELEDIT
WHERE 0=0
AND   ZCLA_PARTARC.EDITID = ZCLA_ELEDIT.EDITID
AND   ZCLA_PARTARC.USER = SQL.USER 
AND   ZCLA_PARTARC.EXTRA = 'Y'
AND   ZCLA_ELEDIT.PACKAGEFLAG = 'Y'
) ;
/*
*/
SELECT SQL.TMPFILE INTO :SPLIT FROM DUMMY ;
LINK ZCLA_SPLIT TO :SPLIT;
ERRMSG 1 WHERE :RETVAL = 0 ;
/*
Get extras Split by order of precedence */
#INCLUDE ZCLA_ELACT/ZCLA_BUF10
SELECT * FROM ZCLA_SPLIT 
FORMAT ADDTO :DEBUGFILE ;
/*
*/
DECLARE @EXPRICE CURSOR FOR
SELECT FIXID
,   (:ZCLA_TOTCOST * SPLIT) 
FROM   ZCLA_SPLIT
WHERE FIXID > 0 ;
/*
*/
OPEN @EXPRICE;
GOTO 26069 WHERE :RETVAL = 0 ;
LABEL 26061 ;
:FIXACT = 0 ;
:ZCLA_TOTPRICE = 0.0 ;
FETCH @EXPRICE INTO :FIXACT , :ZCLA_TOTPRICE ;
GOTO 26068 WHERE :RETVAL = 0 ;
/*
*/
SELECT 'PRICE>>'
,  :ELEMENT , :FIXACT , ZCLA_TOTPRICE , :ZCLA_TOTPRICE 
,  ZCLA_TOTPRICE + :ZCLA_TOTPRICE
FROM PROJACTS
WHERE 0=0
AND   ZCLA_FIX = :FIXACT
AND   ZCLA_PLOT = :ELEMENT 
AND   :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
SELECT ZCLA_TOTPRICE + :ZCLA_TOTPRICE INTO :ZCLA_TOTPRICE
FROM PROJACTS
WHERE 0=0
AND   ZCLA_FIX = :FIXACT
AND   ZCLA_PLOT = :ELEMENT ;
/*
*/
UPDATE PROJACTS
SET ZCLA_TOTPRICE = :ZCLA_TOTPRICE
WHERE 0=0
AND   ZCLA_FIX = :FIXACT
AND   ZCLA_PLOT = :ELEMENT ;
/*
*/
LOOP 26061 ;
LABEL 26068 ;
CLOSE @EXPRICE ;
LABEL 26069 ;
/*
*/
UNLINK ZCLA_SPLIT ;