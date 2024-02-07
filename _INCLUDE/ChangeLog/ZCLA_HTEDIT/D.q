/*
-------------------------------
DELETE */
SUB 5112330 ;
SELECT 'SYNC: DELETE'
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
SELECT 'ZCLA_HTEDIT/D -- RUN', SQL.DATE
FROM DUMMY
FORMAT ADDTO '../../GergoM.txt'
;
/* */
GOSUB 5112331 WHERE :EDITTYPE ='W' ;
GOSUB 5112332 WHERE :EDITTYPE ='A' ;
GOSUB 5112333 WHERE :EDITTYPE ='R' ;
GOSUB 5112334 WHERE :EDITTYPE ='S' ;
/* GOSUB 5112335 WHERE :EDITTYPE ='H' ;
Cannot delete house type */
GOSUB 5112336 WHERE :EDITTYPE ='C' ;
GOSUB 5112337 WHERE :EDITTYPE ='P' ;
GOSUB 5112338 WHERE :EDITTYPE ='K' ;
RETURN
;
SUB 5112331 ; /*  DELETE ='W' ; */
/*--*/
UPDATE ZCLA_PLOTCUCFG
SET    ISDELETED = 'Y'
WHERE  0=0
AND    GUID = :GUID
AND    CONSUMERUNIT IN (
SELECT CONSUMERUNIT
FROM   ZCLA_PLOTCU
WHERE  PROJACT = :ELEMENT
) ;
RETURN ;
SUB 5112332 ; /*  DELETE ='A' ; */
UPDATE EXTFILES
SET    ISDELETED = 'Y'
WHERE 0=0
AND   TYPE = 'T'
AND   GUID = :GUID
AND   IV = :ELEMENT
;
RETURN ;
SUB 5112333 ; /*  DELETE ='R' ; */
UPDATE ZCLA_PLOTROOMS
SET    ISDELETED = 'Y'
WHERE 0=0
AND   GUID = :GUID
AND   PROJACT = :ELEMENT
;
RETURN ;
SUB 5112334 ; /*  DELETE ='S' ; */
UPDATE ZCLA_PLOTQUOTE
SET    ISDELETED = 'Y'
WHERE 0=0
AND   GUID = :GUID
AND   PROJACT = :ELEMENT
;
RETURN ;
SUB 5112336 ; /*  DELETE ='C' ; */
UPDATE ZCLA_PLOTCU
SET    ISDELETED = 'Y'
WHERE 0=0
AND   GUID = :GUID
AND   PROJACT = :ELEMENT
;
RETURN ;
SUB 5112337 ; /*  DELETE ='P' ; */
UPDATE ZCLA_PLOTCOMPONENT
SET    ISDELETED = 'Y'
WHERE 0=0
AND   GUID = :GUID
AND   PROJACT = :ELEMENT
;
RETURN ;
SUB 5112338 ; /*  DELETE ='K' ; */
UPDATE ZCLA_PROJACTPARTS
SET    ISDELETED = 'Y'
WHERE 0=0
AND   GUID = :GUID
AND   PROJACT = :ELEMENT
;
RETURN ;
