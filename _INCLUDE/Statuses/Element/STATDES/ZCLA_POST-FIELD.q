GOTO 09102405 WHERE :FORM_INTERFACE_NAME = 'ZLIA_MIG_PROJECTS';
/* Open / close element edit based on status
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_ELACT/STATDES/ZCLA_POST-FIELD' , STRCAT(:$1.@ , ' >> '
, :$.@)
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Open / Close Element edit */
:ISEXTRA = :WASEXTRA = :ISEDIT = :WASEDIT = '\0' ;
/*
*/
SELECT EDITFLAG , EXTRAFLAG INTO :WASEDIT , :WASEXTRA
FROM ZCLA_ELSTATUSES , ZCLA_ELACTSTAT
WHERE 0=0
AND   ZCLA_ELSTATUSES.STEPSTATUS = ZCLA_ELACTSTAT.STEPSTATUS
AND   PROJACT = :$.PROJACT ;
/*
*/
SELECT EDITFLAG , EXTRAFLAG INTO :ISEDIT , :ISEXTRA
FROM ZCLA_ELSTATUSES
WHERE STEPSTATUSDES = :$.@ ;
/*
*/
SELECT 'ZCLA_ELACT/STATDES/ZCLA_POST-FIELD'
,      :ISEXTRA AS ISEXTRA
,      :WASEXTRA AS WASEXTRA
,      :ISEDIT AS ISEDIT
,      :WASEDIT AS WASEDIT
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
/*Only open an edit if there isn't already one open*/
GOSUB 100 WHERE :WASEDIT <> 'Y' AND :ISEDIT ='Y' AND NOT EXISTS (
SELECT EDITID
FROM ZCLA_ELEDIT
WHERE PROJACT = :$.PROJACT
AND CLOSEFLAG <> 'Y'
) ;
/*Close edit*/
GOSUB 200 WHERE :WASEDIT ='Y' AND :ISEDIT <> 'Y' ;
/*
*/
/* Open edit */ SUB 100 ;
SELECT 'ZCLA_ELACT/STATDES/ZCLA_POST-FIELD'
,'OPENEDIT'
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
INSERT INTO ZCLA_ELEDIT ( PROJACT , OPENEDBY , OPENDATE ,
OPEN_TOTCOST, OPEN_TOTPRICE , EXTRA , PACKAGEFLAG , INVSEP )
SELECT PROJACT , SQL.USER , SQL.DATE
,      ZCLA_TOTCOST , ZCLA_TOTPRICE
,     :ISEXTRA , ( :ISEXTRA = 'Y' ? 'N' : 'Y' )
,     ( :ISEXTRA = 'Y' ? 'Y' : 'N' )
FROM PROJACTS
WHERE PROJACT = :$.PROJACT
;
WRNMSG 802 ;
RETURN ;
/*
*/
/* Close Edit */ SUB 200 ;
SELECT 'ZCLA_ELACT/STATDES/ZCLA_POST-FIELD'
, 'CLOSEEDIT'
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
:EDITID = 0 ;
:ZCLA_TOTCOST = :ZCLA_TOTPRICE = 0.0 ;
/*
*/
GOTO 130824092099 WHERE NOT EXISTS (
SELECT 'X'
FROM PROJACTS
WHERE PROJACT = :$.PROJACT
AND (ZCLA_RECALC = 'Y'
OR ZCLA_DOREFRESH = 'Y'
));
/*
*/
:ELEMENT = :$.PROJACT;
#INCLUDE ZCLA_ELACT/RECALC
LABEL 130824092099;
SELECT EDITID , ZCLA_TOTCOST , ZCLA_TOTPRICE
INTO   :EDITID , :ZCLA_TOTCOST , :ZCLA_TOTPRICE
FROM ZCLA_ELEDIT , PROJACTS
WHERE 0=0
AND   ZCLA_ELEDIT.PROJACT = PROJACTS.PROJACT
AND   PROJACTS.PROJACT = :$.PROJACT
AND   CLOSEFLAG <> 'Y'
;
UPDATE ZCLA_ELEDIT
SET CLOSE_TOTCOST = :ZCLA_TOTCOST
,   CLOSE_TOTPRICE = :ZCLA_TOTPRICE
,   CLOSEDATE = SQL.DATE
,   CLOSEFLAG = 'Y'
WHERE EDITID = :EDITID
;
RETURN ;
LABEL 09102405;