/* Set default values from the
.  housetype on insert
*/
/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_FIXACT/POST-INSERT'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/* */
SELECT :$$.ZCLA_HOUSETYPEID ,  ATOI( :$.ZCLA_FIXNAME )
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
:ZCLA_SITEUPLIFT  =  :ZCLA_FIXUPLIFT  =  :ZCLA_BRUPLIFT  =
:ZCLA_UPLIFT  =  :ZCLA_TRAVEL  =  :ZCLA_LABTOTAL  =
:ZCLA_PARTSUM  =  :ZCLA_MILEAGE  =  :ZCLA_SUNDRY  =
:ZCLA_NEGPOINT  = :MOD_HT = :MOD_ST = :MOD_PL =
:ZCLA_LABOURPOINTS = 0.0
;
SELECT ZCLA_INITPOINTS
,   ZCLA_SITEUPLIFT
,   ZCLA_FIXUPLIFT
,   ZCLA_BRUPLIFT
,   ZCLA_UPLIFT
,   ZCLA_TRAVEL
,   ZCLA_LABTOTAL
,   ZCLA_PARTSUM
,   ZCLA_MILEAGE
,   ZCLA_SUNDRY
,   ZCLA_NEGPOINT
,   ZCLA_LABOURPOINTS
,   MOD_HT
,   MOD_ST
,   1.0
FROM ZCLA_HOUSETYPEFIX
WHERE 0=0
AND   HOUSETYPEID = :$$.ZCLA_HOUSETYPEID
AND   FIXID = ATOI( :$.ZCLA_FIXNAME )
AND   :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT ZCLA_INITPOINTS
,   ZCLA_SITEUPLIFT
,   ZCLA_FIXUPLIFT
,   ZCLA_BRUPLIFT
,   ZCLA_UPLIFT
,   ZCLA_TRAVEL
,   ZCLA_LABTOTAL
,   ZCLA_PARTSUM
,   ZCLA_MILEAGE
,   ZCLA_SUNDRY
,   ZCLA_NEGPOINT
,   ZCLA_LABOURPOINTS
,   MOD_HT
,   MOD_ST
,   1.0
INTO :ZCLA_INITPOINTS
,   :ZCLA_SITEUPLIFT
,   :ZCLA_FIXUPLIFT
,   :ZCLA_BRUPLIFT
,   :ZCLA_UPLIFT
,   :ZCLA_TRAVEL
,   :ZCLA_LABTOTAL
,   :ZCLA_PARTSUM
,   :ZCLA_MILEAGE
,   :ZCLA_SUNDRY
,   :ZCLA_NEGPOINT
,   :ZCLA_LABOURPOINTS
,   :MOD_HT
,   :MOD_ST
,   :MOD_PL
FROM ZCLA_HOUSETYPEFIX
WHERE 0=0
AND   HOUSETYPEID = :$$.ZCLA_HOUSETYPEID
AND   FIXID = ATOI( :$.ZCLA_FIXNAME )
;
UPDATE PROJACTS
SET ZCLA_INITPOINTS = :ZCLA_INITPOINTS
,   ZCLA_SITEUPLIFT = :ZCLA_SITEUPLIFT
,   ZCLA_FIXUPLIFT = :ZCLA_FIXUPLIFT
,   ZCLA_BRUPLIFT = :ZCLA_BRUPLIFT
,   ZCLA_UPLIFT = :ZCLA_UPLIFT
,   ZCLA_TRAVEL = :ZCLA_TRAVEL
,   ZCLA_LABTOTAL = :ZCLA_LABTOTAL
,   ZCLA_PARTSUM = :ZCLA_PARTSUM
,   ZCLA_MILEAGE = :ZCLA_MILEAGE
,   ZCLA_SUNDRY = :ZCLA_SUNDRY
,   ZCLA_NEGPOINT = :ZCLA_NEGPOINT
,   ZCLA_LABOURPOINTS = :ZCLA_LABOURPOINTS
,   MOD_HT = :MOD_HT
,   MOD_ST = :MOD_ST
,   MOD_PL = :MOD_PL
WHERE 0=0
AND   ZCLA_PLOT = :$$.PROJACT
;
/*
*/
SELECT SQL.TMPFILE
INTO :GEN FROM DUMMY;
LINK GENERALLOAD TO :GEN;
ERRMSG 1 WHERE :RETVAL = 0 ;
#INCLUDE ZCLA_FIXACT/ZCLA_BUF2