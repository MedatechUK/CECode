:TYPE = 'ZCLA_CONT' ;
:ENAME = 'ZCLA_CONTRACTS' ;
:FROM = :TO = :FORM = 0 ;

SELECT EXEC INTO :FORM FROM EXEC
WHERE 0=0
AND   ENAME = :ENAME 
AND   TYPE = 'F' ;

DELETE FROM BPMLOG WHERE FORM = :FORM ;

:F = 'Draft' ; :T = 'Quote' ; GOSUB 100 ;
:F = 'Draft' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Quote' ; :T = 'Revision' ; GOSUB 100 ;
:F = 'Quote' ; :T = 'Won' ; GOSUB 100 ;
:F = 'Quote' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Lost' ; :T = 'Revision' ; GOSUB 100 ;
:F = 'Revision' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Revision' ; :T = 'Quote' ; GOSUB 100 ;
:F = 'Won' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Won' ; :T = 'Revision' ; GOSUB 100 ;
:F = 'Won' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Edit' ; :T = 'Active' ; GOSUB 100 ;
:F = 'Edit' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Hold' ; :T = 'Active' ; GOSUB 100 ;
:F = 'Hold' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Hold' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Edit' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Amend' ; GOSUB 100 ;
:F = 'Amend' ; :T = 'Ready' ; GOSUB 100 ;

SELECT * FROM BPMLOG WHERE FORM = :FORM
FORMAT ;

:TYPE = 'ZCLA_EL' ;
:ENAME = 'ZCLA_ELACTSTAT' ;

SELECT EXEC INTO :FORM FROM EXEC
WHERE 0=0
AND   ENAME = :ENAME 
AND   TYPE = 'F' ;

DELETE FROM BPMLOG WHERE FORM = :FORM ;

:F = 'Ready' ; :T = 'Edit' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Extras' ; GOSUB 100 ;
:F = 'Edit' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Extras' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Hold' ; GOSUB 100 ;
:F = 'Hold' ; :T = 'Ready' ; GOSUB 100 ;

SELECT * FROM BPMLOG WHERE FORM = :FORM
FORMAT ;

:TYPE = 'ZCLA_FIX' ;
:ENAME = 'ZCLA_FIXACTSTAT' ;

SELECT EXEC INTO :FORM FROM EXEC
WHERE 0=0
AND   ENAME = :ENAME 
AND   TYPE = 'F' ;

DELETE FROM BPMLOG WHERE FORM = :FORM ;

:F = 'Ready' ; :T = 'Scheduled' ; GOSUB 100 ;
:F = 'Scheduled' ; :T = 'Part Done' ; GOSUB 100 ;
:F = 'Scheduled' ; :T = 'Fix Done' ; GOSUB 100 ;
:F = 'Part Done' ; :T = 'Fix Done' ; GOSUB 100 ;

SELECT * FROM BPMLOG WHERE FORM = :FORM
FORMAT ;

:TYPE = '<' ;
:ENAME = 'ZCLA_PLOTACTSTAT' ;
:FROM = :TO = :FORM = 0 ;

SELECT EXEC INTO :FORM FROM EXEC
WHERE 0=0
AND   ENAME = :ENAME 
AND   TYPE = 'F' ;

DELETE FROM BPMLOG WHERE FORM = :FORM ;

:F = 'Draft' ; :T = 'Canceled' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Canceled' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Hold' ; GOSUB 100 ;
:F = 'In Progress' ; :T = 'Hold' ; GOSUB 100 ;
:F = 'Completed' ; :T = 'Warranty End' ; GOSUB 100 ;

SELECT * FROM BPMLOG WHERE FORM = :FORM
FORMAT ;

SUB 100 ;

SELECT DOCSTATUS INTO :FROM
FROM DOCSTATUSES
WHERE 0=0
AND   TYPE = :TYPE
AND   STATDES = :F
;
SELECT DOCSTATUS INTO :TO
FROM DOCSTATUSES
WHERE 0=0
AND   TYPE = :TYPE
AND   STATDES = :T
;
:LN = 0 ;
SELECT 0 + MAX(KLINE) INTO :LN
FROM BPMLOG WHERE FORM = :FORM ;
INSERT INTO BPMLOG ( FORM , UDATE, USER , FROMSTATUS , TOSTATUS , CHANGETYPE , KLINE )
SELECT :FORM
,      SQL.DATE
,      SQL.USER
,      :FROM
,      :TO
,      104
,      :LN + 1
FROM DUMMY ;
RETURN ;

