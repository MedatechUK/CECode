SELECT '>>> BEGIN SPLIT'
FROM DUMMY FORMAT ADDTO :DEBUGFILE ;
/*
Update Housetype PRICE Totals */
SELECT SUM(ZCLA_NOPACK) INTO :ZCLA_TOTCOST
FROM PROJACTS
WHERE   ZCLA_PLOT = :ELEMENT ;
/*
Get Split and Markup */
SELECT SQL.TMPFILE INTO :SPLIT FROM DUMMY ;
LINK ZCLA_SPLIT TO :SPLIT;
ERRMSG 1 WHERE :RETVAL = 0 ;
/*
Get house type from element */
SELECT ZCLA_HOUSETYPEID 
INTO :HOUSETYPE
FROM PROJACTS 
WHERE PROJACT = :ELEMENT
;
#INCLUDE ZCLA_HOUSETYPE/ZCLA_BUF10
SELECT * FROM ZCLA_SPLIT 
FORMAT ADDTO :DEBUGFILE ;
/*
Does this element have it's own split? */
:ELSPLIT = 0 ;
SELECT ( SUM(SPLIT) = 100 ? 1 : 0 )
INTO   :ELSPLIT
FROM   ZCLA_PLOTELFIX
WHERE 0=0
AND   PROJACT = :ELEMENT
; 
/*
Override the site split with the element split */
GOTO 230523 WHERE :ELSPLIT = 0 ;
DELETE FROM ZCLA_SPLIT ;
INSERT INTO ZCLA_SPLIT (FIXID , SPLIT)
SELECT  FIXID 
,       (SPLIT > 0 ? ( SPLIT / 100 ) : 0 )
FROM ZCLA_PLOTELFIX
WHERE 0=0
AND   PROJACT = :ELEMENT
;
SELECT * FROM ZCLA_SPLIT 
FORMAT ADDTO :DEBUGFILE ;
LABEL 230523 ;
/* 
*/
DECLARE @PRICE CURSOR FOR
SELECT FIXID
,   (:ZCLA_TOTCOST * SPLIT) * :MARKUP
FROM   ZCLA_SPLIT
;
OPEN @PRICE;
GOTO 26069 WHERE :RETVAL = 0 ;
LABEL 26061 ;
:FIXACT = 0 ;
:ZCLA_TOTPRICE = 0.0 ;
FETCH @PRICE INTO :FIXACT , :ZCLA_TOTPRICE ;
GOTO 26068 WHERE :RETVAL = 0 ;
/*
*/
SELECT 'PRICE>>'
, :ELEMENT , :FIXACT , :ZCLA_TOTPRICE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
UPDATE PROJACTS
SET ZCLA_TOTPRICE = :ZCLA_TOTPRICE
WHERE 0=0
AND   ZCLA_FIX = :FIXACT
AND   ZCLA_PLOT = :ELEMENT ;
/*
*/
LOOP 26061 ;
LABEL 26068 ;
CLOSE @PRICE ;
LABEL 26069 ;
/*
*/
UNLINK ZCLA_SPLIT ;