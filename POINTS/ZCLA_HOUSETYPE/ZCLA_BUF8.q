/*
Update screen values */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HOUSETYPE/ZCLA_BUF8' , :$.HOUSETYPEID
FROM DUMMY
WHERE :DEBUG = 2
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT PARTCOST , LABCOST , MILEAGECOST 
,      ZCLA_MISSINGREPL , ZCLA_SUNDRY
FROM ZCLA_HOUSETYPE
WHERE 0=0
AND   HOUSETYPEID = :$.HOUSETYPEID
AND   :DEBUG = 2
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT PARTCOST , LABCOST , MILEAGECOST 
,      ZCLA_MISSINGREPL , ZCLA_SUNDRY
INTO :$.PARTCOST ,    :$.LABCOST
,    :$.MILEAGECOST , :$.ZCLA_MISSINGREPL
,    :$.ZCLA_SUNDRY
FROM ZCLA_HOUSETYPE
WHERE 0=0
AND   HOUSETYPEID = :$.HOUSETYPEID ;
