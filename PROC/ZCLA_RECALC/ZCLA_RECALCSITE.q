/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_RECLAC/ZCLA_SITE'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
LINK DOCUMENTS TO :$.PAR;
ERRMSG 1 WHERE :RETVAL = 0 ;
/*
*/
:DOC = 0 ;
SELECT DOC
INTO :DOC
FROM DOCUMENTS
WHERE DOC <> 0 ;
UNLINK DOCUMENTS
;
/*
*/
DECLARE PLOTEL CURSOR FOR
SELECT  PROJACT
FROM    PROJACTS
WHERE   0=0
AND     LEVEL = 2
AND     DOC = :DOC
;
OPEN PLOTEL ;
GOTO 1110239 WHERE :RETVAL <= 0 ;
LABEL 1110231;
FETCH PLOTEL INTO :ELEMENT ;
GOTO 1110238 WHERE :RETVAL <= 0 ;
/*
*/
#INCLUDE ZCLA_ELACT/RECALC
/*
*/
LOOP 1110231 ;
LABEL 1110238 ;
CLOSE PLOTEL ;
LABEL 1110239 ;
