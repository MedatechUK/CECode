/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_PLOTELFIX/SPLIT2/POST-FIELD'
, :$.@ 
, :$$.ZCLA_TOTPRICE
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
GOTO 999 WHERE :$1.@ = :$.@ ;
GOTO 99 WHERE EXISTS (
SELECT 'X'
FROM ZCLA_PLOTELFIX
WHERE 0=0
AND   PROJACT = :$$.PROJACT
AND   FIXID = :$.FIXID
);
INSERT INTO ZCLA_PLOTELFIX (PROJACT,FIXID)
SELECT :$$.PROJACT , :$.FIXID
FROM DUMMY ;
LABEL 99
;
/*
*/
GOTO 999 WHERE :$.@ <= 0 ;
UPDATE ZCLA_PLOTELFIX
SET    SPLIT = :$.@
,      VALUE = (:$.@ / 100) * :$$.ZCLA_TOTPRICE
WHERE 0=0
AND   PROJACT = :$$.PROJACT
AND   FIXID = :$.FIXID
;
GOTO 9999 ;
LABEL 999 ;
:REM = 0.0 ;
SELECT :$$.ZCLA_TOTPRICE - SUM(VALUE)
INTO :REM
FROM ZCLA_PLOTELFIX
WHERE 0=0
AND   PROJACT = :$.PROJACT
AND   FIXID <> :$.FIXID ;
UPDATE ZCLA_PLOTELFIX
SET    VALUE = :REM
,      SPLIT = (:REM / :$$.ZCLA_TOTPRICE) * 100
WHERE 0=0
AND   PROJACT = :$$.PROJACT
AND   FIXID = :$.FIXID
;
LABEL 9999;
SELECT (:$.@ / 100) * :$$.ZCLA_TOTPRICE
INTO :$.VALUE2
FROM DUMMY 
;
LABEL 999 ;