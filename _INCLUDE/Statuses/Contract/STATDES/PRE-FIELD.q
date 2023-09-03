/* */
:UDATE = :TOSTATUS = :CHANGETYPE = :THISSTAT = 0 ;
DELETE FROM ZCLA_NEXTCONTSTAT
WHERE CONTRACT = :$.CONTRACT ;
/*
*/
SELECT SQL.TMPFILE
INTO :STK FROM DUMMY;
LINK STACK TO :STK;
ERRMSG 1 WHERE :RETVAL = 0
;
SELECT DOCSTATUS INTO :THISSTAT
FROM ZCLA_CONTRACTSTATUSE , DOCSTATUSES
WHERE 0=0
AND   DOCSTATUSES.TYPE ='ZCLA_CONT'
AND   ORIGSTATUSID = STEPSTATUS
AND   STEPSTATUS = :$.STEPSTATUS
;
/*
Insert current value */
INSERT INTO ZCLA_NEXTCONTSTAT  (CONTRACT , STATDES , SORT)
SELECT :$.CONTRACT , :$.STATDES , 0
FROM DUMMY ;
/*
Get proxy form */
:FORM = 0 ;
SELECT EXEC INTO :FORM FROM EXEC
WHERE 0=0
AND   ENAME = 'ZCLA_CONTRACTS'
AND   TYPE = 'F' ;
/**/
DECLARE @GETSTAT CURSOR FOR
SELECT TOSTATUS , CHANGETYPE , UDATE
FROM BPMLOG
WHERE 0=0
AND   FROMSTATUS = :THISSTAT
AND   FORM = :FORM
ORDER BY UDATE ASC;
/*
*/
OPEN @GETSTAT ;
GOTO 9 WHERE :RETVAL = 0 ;
LABEL 1;
FETCH @GETSTAT INTO :TOSTATUS , :CHANGETYPE , :UDATE ;
GOTO 8 WHERE :RETVAL = 0;
GOSUB 1104231 WHERE :CHANGETYPE = 104 ;
GOSUB 1104232 WHERE :CHANGETYPE = 105 ;
LOOP 1 ;
LABEL 8 ;
CLOSE @GETSTAT ;
LABEL 9 ;
/*
*/
INSERT INTO ZCLA_NEXTCONTSTAT  (CONTRACT , STATDES , SORT)
SELECT :$.CONTRACT , STATDES , SORT
FROM STACK , DOCSTATUSES
WHERE 0=0
AND   DOCSTATUS = ELEMENT
AND   ELEMENT > 0
AND   DOCSTATUSES.INACTIVE <> 'Y'
;
/*
*/
UNLINK STACK ;
SUB 1104231 ;
INSERT INTO STACK (ELEMENT)
SELECT :TOSTATUS FROM DUMMY ;
RETURN ;
SUB 1104232 ;
DELETE FROM STACK
WHERE ELEMENT = :TOSTATUS ;
RETURN ;