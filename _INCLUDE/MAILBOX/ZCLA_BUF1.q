SELECT '<html>'
FROM DUMMY
ASCII UNICODE :TMPFILE
;
SELECT STRCAT('<head><title>' , :_Subject , '</title></head>')
FROM DUMMY
ASCII UNICODE ADDTO :TMPFILE
;
SELECT '<body>'
FROM DUMMY
ASCII UNICODE ADDTO :TMPFILE
;
DECLARE @C CURSOR FOR
SELECT MESSAGE , TEXT
FROM EXTMSG , EXEC , EXTMSGTEXT
WHERE 0=0
AND   EXTMSG.EXEC = EXEC.EXEC
AND   EXEC.EXEC = EXTMSGTEXT.EXEC
AND   EXTMSG.NUM = EXTMSGTEXT.NUM
AND   ENAME = :ENT
AND   TYPE = :ENTTYPE
AND   EXTMSG.NUM = :ENTMSG
ORDER BY TEXTORD
;
OPEN @C;
GOTO 707239 WHERE :RETVAL = 0 ;
:FIRST = 1 ;
LABEL 707231 ;
:MESSAGE = :TEXT = '' ;
:I = 0 ;
FETCH @C INTO :MESSAGE , :TEXT , :I;
GOTO 707238 WHERE :RETVAL = 0 ;
/*
*/
GOTO 7072310 WHERE :FIRST = 0 ;
SELECT :MESSAGE FROM DUMMY
ASCII UNICODE ADDTO :TMPFILE
;
:FIRST = 0 ;
LABEL 7072310 ;
SELECT :TEXT FROM DUMMY
ASCII UNICODE ADDTO :TMPFILE
;
/*
*/
LOOP 707231 ;
LABEL 707238 ;
CLOSE @C ;
LABEL 707239
;
SELECT '</body>'
FROM DUMMY
ASCII UNICODE ADDTO :TMPFILE
;
SELECT '</html>'
FROM DUMMY
ASCII UNICODE ADDTO :TMPFILE
;
EXECUTE FILTER '-replace' 
,              '<P1>' , :PAR1 
,              '<P2>' , :PAR2 
,              '<P3>' , :PAR3 
,              '<P4>' , :PAR4 
,              '<P5>' , :PAR5 
,              '<P6>' , :PAR6 
,              :TMPFILE , :TMPFILE
;