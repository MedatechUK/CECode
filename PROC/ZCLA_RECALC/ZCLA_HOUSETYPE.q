/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_RECLAC/STEP1'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
LINK ZCLA_HOUSETYPE TO :$.PAR;
ERRMSG 1 WHERE :RETVAL = 0 ;
/*
*/
:HOUSETYPE = 0 ;
SELECT HOUSETYPEID 
INTO :HOUSETYPE 
FROM ZCLA_HOUSETYPE
WHERE HOUSETYPEID  <> 0 ;
UNLINK ZCLA_HOUSETYPE
;
#INCLUDE ZCLA_HOUSETYPE/RECALC 
