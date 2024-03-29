/*
:HOUSETYPE = 2 ;
:DOC = 4 ;
Update fix uplift by HOUSETYPE
We MUST Know the :DOC
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'DOCUMENTS_p/ZCLA_CORETYPE' , :HOUSETYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
:FIXID = 0 ;
:POINTS = 0.0 ;
UPDATE ZCLA_HOUSETYPEFIX
SET   ZCLA_NEGPOINT = 0
,     ZCLA_BRUPLIFT = 0
WHERE 0=0
AND   ZCLA_HOUSETYPEFIX.HOUSETYPEID = :HOUSETYPE ;
/*
*/
DECLARE @FIX73 CURSOR FOR
SELECT ZCLA_BRANCHFIX.FIXID, ZCLA_BRANCHFIX.POINTS
FROM   ZCLA_BRANCHFIX
,      ZCLA_HOUSETYPE
,      CUSTOMERS
WHERE 0=0
AND    ZCLA_HOUSETYPE.DOC = CUSTOMERS.CUST
AND    ZCLA_BRANCHFIX.BRANCH = CUSTOMERS.ZCLA_BRANCH
AND    CUSTOMERS.CUST = :DOC
AND    ZCLA_HOUSETYPE.HOUSETYPEID = :HOUSETYPE
AND    ZCLA_BRANCHFIX.FIXID > 0
;
OPEN @FIX73 ;
GOTO 9999 WHERE :RETVAL = 0 ;
LABEL 5009;
FETCH @FIX73 INTO :FIXID  , :POINTS  ;
GOTO 6009 WHERE :RETVAL = 0 ;
/*
*/
SELECT :FIXID  , :POINTS
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
UPDATE ZCLA_HOUSETYPEFIX
SET   ZCLA_NEGPOINT = :FIXUPLIFT
,     ZCLA_BRUPLIFT = :POINTS 
WHERE 0=0
AND   ZCLA_HOUSETYPEFIX.HOUSETYPEID = :HOUSETYPE
AND   ZCLA_HOUSETYPEFIX.FIXID = :FIXID
;
/*
*/
LOOP 5009 ;
LABEL 6009 ;
CLOSE @FIX73 ;
LABEL 9999 ;
