:SUMVAL = 0.0 ;
SELECT SUM(VALUE) INTO :SUMVAL
FROM ZCLA_PLOTELFIX
WHERE 0=0
AND   PROJACT = :$$.PROJACT
;
GOTO 99 WHERE :SUMVAL = 0 ;
ERRMSG 1 WHERE :SUMVAL <> :$$.ZCLA_TOTPRICE ;
LABEL 99;
