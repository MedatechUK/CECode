/*
*/
#INCLUDE func/ZCLA_DEBUGUSR
#INCLUDE STATUSTYPES/ZCLA_BUF3
SELECT SQL.TMPFILE
INTO :GEN FROM DUMMY;
:USERLOGIN = '' ;
:POSTNAME = 'FIX' ;
/*
*/
GOTO 51 WHERE :$.UPD <> 'Y' ;
UPDATE PROJACTS
SET STEPSTATUS = :$.STEPSTATUS
WHERE 0=0
AND   PROJACT = :$.PROJACT
AND   :$.UPD = 'Y'
;
LABEL 51;
/* update date */
GOTO 5201 WHERE :$.STARTDATE = :$1.STARTDATE ;
UPDATE PROJACTS
SET STARTDATE = :$.STARTDATE
WHERE PROJACT = :$.PROJACT
;
LABEL 5201 ;
/*
***************************
Check Activate Contract
************************ */
:NEWSTAT = '' ;
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_CONTRACTSTATUSE, DOCSTATUSES
WHERE  0=0
AND    DOCSTATUSES.ORIGSTATUSID = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND    DOCSTATUSES.TYPE = 'ZCLA_CONT'
AND    DOCSTATUSES.DOCOPENED = 'Y'
AND    EXISTS (
SELECT  'x'
FROM    ZCLA_FIXSTATUSES
WHERE   0=0
AND     STEPSTATUSDES = :$.STATDES
AND     ACTIVE = 'Y'
)
AND     NOT EXISTS(
SELECT  'x'
FROM    ZCLA_CONTRACTS
,       ZCLA_CONTRACTSTATUSE
WHERE 0=0
AND   ZCLA_CONTRACTS.STEPSTATUS = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND   (ZCLA_CONTRACTSTATUSE.ACTIVE = 'Y'
OR    ZCLA_CONTRACTSTATUSE.CANCELFLAG = 'Y')
AND   CONTRACT = :$.CONTRACT
);
/*
*/
GOTO 999 WHERE :NEWSTAT = '' ;
GOSUB 500 ;
/*
Update Contract */
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
,   KEY1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1
)
SELECT SQL.LINE , '1'
,   ITOA( ZCLA_CONTRACTS.CONTRACT )
,   :NEWSTAT
,   STEPSTATUSDES
,   :USERLOGIN
,   SQL.GUID
,   'Y'
FROM    ZCLA_CONTRACTSTATUSE
,       ZCLA_CONTRACTS
,       ZCLA_CONTRACTEL
,       PROJACTS
WHERE   0=0
AND     ZCLA_CONTRACTEL.EL = PROJACTS.ZCLA_EL
AND     ZCLA_CONTRACTS.CONTRACT = ZCLA_CONTRACTEL.CONTRACT
AND     ZCLA_CONTRACTS.DOC = PROJACTS.DOC
AND     ZCLA_CONTRACTSTATUSE.STEPSTATUS = ZCLA_CONTRACTS.STEPSTATUS
AND     PROJACTS.LEVEL = 3
AND     PROJACTS.PROJACT = :$.PROJACT
AND     STEPSTATUSDES <> :NEWSTAT
;
:LOADNAME = 'STATUSMAILZCLA_CONT' ;
GOSUB 600 ;
/*
*/
LABEL 999 ;
/*
***************************************
Check All Fixes Complete
************************************ */
:NEWSTAT = '' ;
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_ELSTATUSES
WHERE 0=0
AND   CLOSEFLAG = 'Y'
AND   EXISTS(
SELECT 'x'
FROM   ZCLA_FIXSTATUSES
WHERE  0=0
AND    ZCLA_FIXSTATUSES.CLOSEFLAG = 'Y'
AND    ZCLA_FIXSTATUSES.STEPSTATUSDES = :$.STATDES
)
AND   NOT EXISTS (
SELECT 'x'
FROM PROJACTS , ZCLA_FIXSTATUSES
WHERE 0=0
AND   PROJACTS.STEPSTATUS = ZCLA_FIXSTATUSES.STEPSTATUS
AND   ZCLA_FIXSTATUSES.CLOSEFLAG <> 'Y'
AND   ZCLA_PLOT IN (
SELECT ZCLA_PLOT
FROM PROJACTS
WHERE 0=0
AND   PROJACT = :$.PROJACT
));
/*
*/
/*
***************************************
Update element to active on FIX active
************************************ */
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_ELSTATUSES
WHERE  0=0
AND    ACTIVE = 'Y'
AND    EXISTS (
SELECT 'x'
FROM   ZCLA_FIXSTATUSES
WHERE  0=0
AND    ZCLA_FIXSTATUSES.ACTIVE = 'Y'
AND    ZCLA_FIXSTATUSES.STEPSTATUSDES = :$.STATDES
)
AND   NOT EXISTS(
SELECT 'x'
FROM   ZCLA_ELACTSTAT , ZCLA_ELSTATUSES
WHERE  0=0
AND   ZCLA_ELACTSTAT.STEPSTATUS = ZCLA_ELSTATUSES.STEPSTATUS
AND   PROJACT = :$.ZCLA_PLOT
AND  ( ZCLA_ELSTATUSES.ACTIVE = 'Y'
OR   ZCLA_ELSTATUSES.CANCELFLAG = 'Y')
);
/*
*/
GOTO 9999 WHERE :NEWSTAT = '' ;
GOSUB 500 ;
/*
Update elact */
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
,   KEY1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1
)
SELECT SQL.LINE , '1'
,   ITOA ( ELACT )
,   :NEWSTAT
,   STEPSTATUSDES
,   :USERLOGIN
,   SQL.GUID
,   'Y'
FROM    ZCLA_ELACTSTAT , ZCLA_ELSTATUSES
WHERE   0=0
AND     ZCLA_ELACTSTAT.STEPSTATUS = ZCLA_ELSTATUSES.STEPSTATUS
AND     PROJACT = :$.ZCLA_PLOT
AND     STEPSTATUSDES <> :NEWSTAT
;
:LOADNAME = 'STATUSMAILZCLA_EL' ;
GOSUB 600 ;
/*
*/
LABEL 9999 ;
/*
*
*
**************************************
On complete - update sibling fixes
************************************ */
/*
Skip if not closing this Fix */
GOTO 99998 WHERE NOT EXISTS (
SELECT 'x'
FROM   ZCLA_FIXSTATUSES
WHERE  0=0
AND    ZCLA_FIXSTATUSES.CLOSEFLAG = 'Y'
AND    ZCLA_FIXSTATUSES.STEPSTATUSDES = :$.STATDES
);
/*
Set OPEN */
:NEWSTAT = '' ;
SELECT STEPSTATUSDES INTO :NEWSTAT
FROM  ZCLA_FIXSTATUSES , DOCSTATUSES
WHERE  0=0
AND    DOCSTATUSES.ORIGSTATUSID = ZCLA_FIXSTATUSES.STEPSTATUS
AND    DOCSTATUSES.TYPE = 'ZCLA_FIX'
AND    DOCSTATUSES.DOCOPENED = 'Y'
;
/*
***************************************
Ready on 1st fix complete
************************************ */
/*
Update Fixes */
GOSUB 500 ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
, KEY1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1 )
SELECT SQL.LINE,  '1'
,  ITOA ( FIXACT )
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
AND   ZCLA_FIXES.ELREADY <> 'Y'
AND   ZCLA_FIXES.LASTREADY <> 'Y'
AND   ZCLA_FIXSTATUSES.CLOSEFLAG <> 'Y'
AND   ZCLA_PLOT = :$.ZCLA_PLOT
AND   PROJACTS.PROJACT <> :$.PROJACT
;
:LOADNAME = 'STATUSMAILZCLA_FIX' ;
GOSUB 600 ;
/*
*/
/*
***************************************
Ready LAST, on All fixes complete
************************************ */
GOTO 99998 WHERE EXISTS (
SELECT 'x'
FROM PROJACTS , ZCLA_FIXACTSTAT , ZCLA_FIXSTATUSES , ZCLA_FIXES
WHERE 0=0
AND   ZCLA_FIXACTSTAT.STEPSTATUS = ZCLA_FIXSTATUSES.STEPSTATUS
AND   ZCLA_FIXES.FIXID = PROJACTS.ZCLA_FIX
AND   PROJACTS.PROJACT =  ZCLA_FIXACTSTAT.PROJACT
AND   ZCLA_PLOT = :$.ZCLA_PLOT
AND   ZCLA_FIXES.LASTREADY <> 'Y'
AND   ZCLA_FIXSTATUSES.CLOSEFLAG <> 'Y'
);
/*
Update Fixes */
GOSUB 500 ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE
, KEY1 , TEXT1 , TEXT3 , TEXT2 , TEXT10 , CHAR1 )
SELECT SQL.LINE,  '1'
,  ITOA( FIXACT )
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
AND   ZCLA_FIXES.LASTREADY = 'Y'
AND   ZCLA_PLOT = :$.ZCLA_PLOT
;
:LOADNAME = 'STATUSMAILZCLA_FIX' ;
GOSUB 600 ;
/*
*/
LABEL 99998 ;
#INCLUDE STATUSTYPES/ZCLA_BUF4
#INCLUDE ZCLA_PDAFIX/BUF1 /*create task when status is scheduled */


UPDATE ZCLA_FIXACTSTAT
SET LASTSTAT = :$1.STATDES
WHERE 0=0
AND   PROJACT = :$.PROJACT
AND   EXISTS (
SELECT 'x'
FROM ZCLA_FIXACTSTAT , ZCLA_FIXSTATUSES
WHERE 0=0
AND   ZCLA_FIXACTSTAT.STEPSTATUS = ZCLA_FIXSTATUSES.STEPSTATUS
AND   HOLD = 'Y'
AND   STEPSTATUSDES = :$.STATDES
);
UPDATE ZCLA_FIXACTSTAT
SET LASTSTAT = ''
WHERE 0=0
AND   PROJACT = :$.PROJACT
AND EXISTS (
SELECT 'x'
FROM ZCLA_FIXACTSTAT , ZCLA_FIXSTATUSES
WHERE 0=0
AND   ZCLA_FIXACTSTAT.STEPSTATUS = ZCLA_FIXSTATUSES.STEPSTATUS
AND   HOLD = 'Y'
AND   STEPSTATUSDES = :$1.STATDES
);
