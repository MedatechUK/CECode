/*
*/
#INCLUDE func/ZCLA_DEBUGUSR
#INCLUDE STATUSTYPES/ZCLA_BUF3
SELECT SQL.TMPFILE
INTO :GEN FROM DUMMY;
:USERLOGIN = '' ;
:POSTNAME = 'PLOT' ;
/*
*/
GOTO 51 WHERE :$.UPD <> 'Y' ;
UPDATE PROJACTS
SET STEPSTATUS = :$.STEPSTATUS
WHERE 0=0
AND   PROJACT = :$.NSCUST
;
LABEL 51;
/*
*/
LABEL 99998 ;
/*
*/
#INCLUDE STATUSTYPES/ZCLA_BUF4