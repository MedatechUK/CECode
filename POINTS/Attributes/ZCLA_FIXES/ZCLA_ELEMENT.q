/*
:ELEMENT = 42 ;
Update fix uplift by ELEMENT
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_FIXES/ZCLA_ELEMENT' , :ELEMENT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
:FIXID = 0 ;
:FIXUPLIFT = 0.0 ;
/* Reset Values */
UPDATE PROJACTS SET
ZCLA_FIXUPLIFT = 1
WHERE 0=0
AND   PROJACTS.ZCLA_PLOT = :ELEMENT
;
/*
*/
DECLARE @FIX71 CURSOR FOR
SELECT PROJACTS.PROJACT, ZCLA_FIXES.FIXUPLIFT
FROM  ZCLA_FIXES , PROJACTS
WHERE 0=0
AND   ZCLA_FIXES.FIXID = PROJACTS.ZCLA_FIX
AND   ZCLA_PLOT = :ELEMENT
;
OPEN @FIX71 ;
GOTO 9999 WHERE :RETVAL = 0 ;
LABEL 5009;
FETCH @FIX71 INTO :FIXID , :FIXUPLIFT ;
GOTO 6009 WHERE :RETVAL = 0 ;
/*
*/
SELECT :FIXID , :FIXUPLIFT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
UPDATE PROJACTS SET
ZCLA_FIXUPLIFT = ( :FIXUPLIFT <> 0 ? 1 + ( :FIXUPLIFT / 100 ) : 1 )
WHERE PROJACT = :FIXID ;
/*
*/
LOOP 5009;
LABEL 6009;
CLOSE @FIX71 ;
LABEL 9999;
