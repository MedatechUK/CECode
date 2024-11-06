GOTO 09102406 WHERE :FORM_INTERFACE_NAME = 'ZLIA_MIG_PROJECTS';
/* */
:UDATE = :TOSTATUS = :CHANGETYPE = :THISSTAT = 0 ;
DELETE FROM ZCLA_NEXTPLOTSTAT
WHERE PROJACT = :$.PROJACT ;
/*
*/
SELECT SQL.TMPFILE
INTO :STK FROM DUMMY;
LINK STACK TO :STK;
ERRMSG 1 WHERE :RETVAL = 0
;
SELECT DOCSTATUS INTO :THISSTAT
FROM STEPSTATUSES , DOCSTATUSES
WHERE 0=0
AND   DOCSTATUSES.TYPE = '<'
AND   ORIGSTATUSID = :$.STEPSTATUS
;
/*
Insert current value */
INSERT INTO ZCLA_NEXTPLOTSTAT ( PROJACT , STATDES , SORT )
SELECT :$.PROJACT , STEPSTATUSDES , 0
FROM STEPSTATUSES
WHERE STEPSTATUS = :$.STEPSTATUS ;
/*
Get proxy form */
:FORM = 0 ;
SELECT EXEC INTO :FORM FROM EXEC
WHERE 0=0
AND   ENAME = 'ZCLA_PLOTACTSTAT'
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
INSERT INTO ZCLA_NEXTPLOTSTAT (PROJACT , STATDES , SORT)
SELECT :$.PROJACT , STATDES , SORT
FROM STACK , DOCSTATUSES
WHERE 0=0
AND   DOCSTATUS = ELEMENT
AND   ELEMENT > 0
AND   DOCSTATUSES.INACTIVE <> 'Y'
;
/*
*/
SELECT * FROM ZCLA_NEXTPLOTSTAT
WHERE PROJACT = :$.PROJACT
FORMAT
;
UNLINK STACK ;
SUB 1104231 ;
/* REPLACED PROJACT WITH ELEMENT 15/1024 ZGCW */
INSERT INTO STACK (ELEMENT)
SELECT :TOSTATUS FROM DUMMY ;
RETURN ;
SUB 1104232 ;
DELETE FROM STACK
/* REPLACED PROJACT WITH ELEMENT 15/1024 ZGCW */
WHERE ELEMENT = :TOSTATUS ;
RETURN ;
LABEL 09102406;
