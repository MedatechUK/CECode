/*
Copy Room */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_COPYROOM/STEP20' FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Link the current record */
LINK ZCLA_ROOMS TO :$.PAR;
ERRMSG 1 WHERE :RETVAL <= 0;
/*
Get linked values */
:HOUSETYPE = :ROOM = :COL = :SORT = 0 ;
SELECT HOUSETYPEID , ROOM , COL , SORT
INTO :HOUSETYPE , :ROOM , :COL , :SORT
FROM ZCLA_ROOMS
WHERE 0=0
AND   ROOM > 0 ;
/*
Unlink */
UNLINK ZCLA_ROOMS ;
/*  
*/
:PAR1 = '' ;
SELECT :$.RM INTO :PAR1 
FROM DUMMY ;
ERRMSG 800 WHERE EXISTS (
SELECT 'x'
FROM ZCLA_ROOMS 
WHERE 0=0    
AND   TOLOWER(ROOMDES) = TOLOWER(:$.RM)
AND   HOUSETYPEID = :HOUSETYPE
);
/* Link GENERALLOAD
*/
SELECT SQL.TMPFILE
INTO :GEN FROM DUMMY;
LINK GENERALLOAD TO :GEN;
ERRMSG 1 WHERE :RETVAL = 0 ;
/*
*/
:LN = 0 ;
/* insert Proj line */
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, KEY1)
SELECT :LN , '1' , ITOA(DOC)
FROM ZCLA_HOUSETYPE 
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
;
/* insert Housetype line */
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, KEY1)
SELECT :LN , '2' , ITOA(:HOUSETYPE)
FROM DUMMY
;
/* Insert room
*/
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, TEXT1 , INT1 , INT2 )
SELECT :LN , '3'
,   :$.RM
,   :SORT
,   :COL
FROM DUMMY
;
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, INT1 , INT2 , INT3 )
SELECT :LN + SQL.LINE , '4'
,   PART
,   TQUANT
,   COL
FROM ZCLA_COMPONENT
WHERE 0=0
AND   ROOM = :ROOM
;
/*
*/
#INCLUDE func/ZCLA_RESETERR
EXECUTE INTERFACE 'ZCLA_COPYSITEHT', SQL.TMPFILE, '-L', :GEN ;
:i_LOGGEDBY = 'ZCLA_COPYHT';
#INCLUDE func/ZEMG_ERRMSGLOG
SELECT LINE, RECORDTYPE , KEY1 , LOADED , INT1, INT2, INT3, INT4 ,
CHAR1 , CHAR2 , TEXT1, TEXT2 , CHAR3
FROM GENERALLOAD FORMAT ADDTO :DEBUGFILE ;
#INCLUDE func/ZCLA_ERRMSG
UNLINK GENERALLOAD ;
