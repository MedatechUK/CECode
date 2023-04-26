/* Update the total fix1/2 usage of parts
.  where the element is no longer editable
.  (EDITFLAG) but not cancelled, and the
.  fix is started (CLOSEFLAG) but not finished
.  (INITFLAG).
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'STEPSTATUSDES/CHECK-FIELD' , SQL.USER
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE;
/*
*/
:PART = :QUANT = 0 ;
DECLARE @PARTUSE CURSOR FOR
SELECT SONPART
,      SUM(SONQUANT)
FROM   PART
,      ZCLA_FIXES
,      PROJACTTREE
,      ZCLA_ELSTATUSES
,      ZCLA_FIXSTATUSES
,      PROJACTS FIX
,      PROJACTS ELEMENT
WHERE  0=0
AND    FIX.ZCLA_PLOT = ELEMENT.PROJACT
AND    ZCLA_FIXSTATUSES.STEPSTATUS = FIX.STEPSTATUS
AND    ZCLA_ELSTATUSES.STEPSTATUS = ELEMENT.STEPSTATUS
AND    PROJACTTREE.PROJACT = FIX.PROJACT
AND    ZCLA_FIXES.FIXID = FIX.ZCLA_FIX
AND    PART.PART = PROJACTTREE.SONPART
AND    FIX.LEVEL = 3
AND    ELEMENT.LEVEL = 2
AND    ZCLA_ELSTATUSES.EDITFLAG <> 'Y'
AND    ZCLA_ELSTATUSES.CANCELFLAG <> 'Y'
AND    ZCLA_FIXSTATUSES.CLOSEFLAG <> 'Y'
AND    ZCLA_FIXSTATUSES.INITFLAG <> 'Y'
AND    SONPART > 0
GROUP BY 1 ;
/*
*/
OPEN @PARTUSE ;
GOTO 9 WHERE :RETVAL = 0;
LABEL 1 ;
FETCH @PARTUSE INTO :PART , :QUANT ;
GOTO 8 WHERE :RETVAL = 0 ;
/*
*/
UPDATE PART SET ZCLA_MAXORDBOOK = :QUANT
WHERE PART = PART ;
/*
*/
LOOP 1 ;
LABEL 8 ;
CLOSE @PARTUSE ;
LABEL 9 ;