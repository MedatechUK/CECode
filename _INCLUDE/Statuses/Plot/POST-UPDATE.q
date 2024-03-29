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
/*
************************
Set child element Status
********************* */
:NEWSTAT = '' ;
/*
Set Cancel */
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_ELSTATUSES
WHERE 0=0
AND    CANCELFLAG = 'Y'
AND    EXISTS (
SELECT 'x'
FROM STEPSTATUSES
WHERE  0=0
AND    STEPSTATUSDES = :$.STATDES
AND    CANCELFLAG = 'Y'
);
/*
Set HOLD */
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_ELSTATUSES
WHERE 0=0
AND   HOLD = 'Y'
AND   EXISTS (
SELECT 'x'
FROM STEPSTATUSES
WHERE  0=0
AND   STEPSTATUSDES = :$.STATDES
AND   ZCLA_HOLD = 'Y'
);
/*
Quit where no NEWSTAT */
GOTO 999 WHERE :NEWSTAT = '' ;
GOSUB 500 ;
/*
Update Elements status */
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
, INT1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1 )
SELECT SQL.LINE
, '1'
, ZCLA_ELACTSTAT.ELACT
, :NEWSTAT
, ZCLA_ELSTATUSES.STEPSTATUSDES
, :USERLOGIN
, SQL.GUID
, 'Y'
FROM   PROJACTS , ZCLA_ELACTSTAT , ZCLA_ELSTATUSES
WHERE 0=0
AND   ZCLA_ELSTATUSES.STEPSTATUS = ZCLA_ELACTSTAT.STEPSTATUS
AND   ZCLA_ELACTSTAT.PROJACT = PROJACTS.PROJACT
AND   PROJACTS.LEVEL = 2
AND   ZCLA_PLOT = :$.NSCUST 
AND   ZCLA_ELSTATUSES.STEPSTATUSDES <> :NEWSTAT
;
:LOADNAME = 'STATUSMAILZCLA_EL' ;
GOSUB 600 ;
LABEL 999 ;
/*
************************
Set child fix Status
********************* */
:NEWSTAT = '' ;
/*
Set Cancel */
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_FIXSTATUSES
WHERE 0=0
AND    CANCELFLAG = 'Y'
AND    EXISTS (
SELECT 'x'
FROM STEPSTATUSES
WHERE  0=0
AND    STEPSTATUSDES = :$.STATDES
AND    CANCELFLAG = 'Y'
);
/*
Set HOLD */
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_FIXSTATUSES
WHERE 0=0
AND   HOLD = 'Y'
AND   EXISTS (
SELECT 'x'
FROM STEPSTATUSES
WHERE  0=0
AND   STEPSTATUSDES = :$.STATDES
AND   ZCLA_HOLD = 'Y'
);
/*
Quit where no NEWSTAT */
GOTO 9999 WHERE :NEWSTAT = '' ;
GOSUB 500 ;
/*
Update Fixes */
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
, INT1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1 )
SELECT SQL.LINE
,  '1'
,  FIXACT
,  :NEWSTAT
,  STEPSTATUSDES
,  :USERLOGIN
,  SQL.GUID
,  'Y'
FROM PROJACTS , ZCLA_FIXACTSTAT , ZCLA_FIXSTATUSES , ZCLA_FIXES
WHERE 0=0
AND   ZCLA_FIXACTSTAT.STEPSTATUS = ZCLA_FIXSTATUSES.STEPSTATUS
AND   ZCLA_FIXES.FIXID = PROJACTS.ZCLA_FIX
AND   PROJACTS.PROJACT =  ZCLA_FIXACTSTAT.PROJACT
AND   LEVEL = 3
AND   STEPSTATUSDES <> :NEWSTAT
AND   ZCLA_PLOT IN (
SELECT PROJACT FROM PROJACTS WHERE ZCLA_PLOT = :$.NSCUST 
);
:LOADNAME = 'STATUSMAILZCLA_FIX' ;
GOSUB 600 ;
LABEL 9999 ;
/*
*/
/*
*
*
Was on Hold ? ************ */
:HOLD = :ACTIVE = '\0' ;
SELECT ZCLA_HOLD INTO :HOLD
FROM STEPSTATUSES
WHERE  0=0
AND   STEPSTATUSDES = :$.STATDES1 
;
GOTO 99998 WHERE NOT ( :HOLD = 'Y' );
/*
Update Elements status */
GOSUB 500 ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
, INT1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1 )
SELECT SQL.LINE
, '1'
, ZCLA_ELACTSTAT.ELACT
, ZCLA_ELACTSTAT.LASTSTAT
, STEPSTATUSDES
, :USERLOGIN
, SQL.GUID
, 'Y'
FROM  PROJACTS , ZCLA_ELACTSTAT , ZCLA_ELSTATUSES
WHERE 0=0
AND   ZCLA_ELSTATUSES.STEPSTATUS = ZCLA_ELACTSTAT.STEPSTATUS
AND   ZCLA_ELACTSTAT.PROJACT = PROJACTS.PROJACT
AND   PROJACTS.LEVEL = 2
AND   ZCLA_PLOT = :$.NSCUST 
;
:LOADNAME = 'STATUSMAILZCLA_EL' ;
GOSUB 600 ;
/*
*/
/*
Update Fixes */
GOSUB 500 ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
, INT1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1 )
SELECT SQL.LINE
,  '1'
,  FIXACT
,  ZCLA_FIXACTSTAT.LASTSTAT
,  STEPSTATUSDES
,  :USERLOGIN
,  SQL.GUID
,  'Y'
FROM PROJACTS , ZCLA_FIXACTSTAT , ZCLA_FIXSTATUSES
WHERE 0=0
AND   ZCLA_FIXACTSTAT.STEPSTATUS = ZCLA_FIXSTATUSES.STEPSTATUS
AND   PROJACTS.PROJACT =  ZCLA_FIXACTSTAT.PROJACT
AND   LEVEL = 3
AND   ZCLA_PLOT IN (
SELECT PROJACT FROM PROJACTS WHERE ZCLA_PLOT = :$.NSCUST 
);
:LOADNAME = 'STATUSMAILZCLA_FIX' ;
GOSUB 600 ;
/*
/*
*/
LABEL 99998 ;
/*
*/
#INCLUDE STATUSTYPES/ZCLA_BUF4
