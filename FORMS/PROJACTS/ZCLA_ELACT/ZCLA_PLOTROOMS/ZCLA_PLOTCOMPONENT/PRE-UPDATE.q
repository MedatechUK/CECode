ERRMSG 998 WHERE :$$$.EDITFLAG <> 'Y' ;
/*
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_PLOTCOMPONENT/PRE-UPDATE' , :$$$.PROJACT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE;
/*
*/
#INCLUDE ZCLA_PLOTCOMPONENT/ZCLA_BUF4
/*
*/
GOSUB 100 WHERE EXISTS (
SELECT 'x'
FROM ZCLA_PLOTCOMPONENT
WHERE 0=0
AND   PROJACT = :$$$.PROJACT
AND   ROOM = :$.ROOM
AND   PART = :$.PART
AND   EXTRA = :$.EXTRA
AND   ISDELETED <> 'Y'
AND   PLOTCOMPONENT <> :$.PLOTCOMPONENT
);
/*
*/
:DOC = :ELEMENT = 0 ;
SELECT :$$$$$.DOC , :$$$.PROJACT
INTO :DOC , :ELEMENT
FROM DUMMY ;
#INCLUDE PARTARC/ZCLA_ELEMENT
LABEL 999 ;
/*
*/
SUB 100 ;
/*
Get this quantity */
:TQUANT = :TQUANT1 = :MERGE = 0
;
SELECT TQUANT  INTO :TQUANT
FROM ZCLA_PLOTCOMPONENT
WHERE 0=0
AND   PLOTCOMPONENT = :$.PLOTCOMPONENT
;
/*
Merge duplication */
SELECT PLOTCOMPONENT , TQUANT INTO :MERGE , :TQUANT1
FROM ZCLA_PLOTCOMPONENT
WHERE 0=0
AND   PROJACT = :$$$.PROJACT
AND   ROOM = :$.ROOM
AND   PART = :$.PART
AND   EXTRA = :$.EXTRA
AND   ISDELETED <> 'Y'
AND   PLOTCOMPONENT <> :$.PLOTCOMPONENT
;
SELECT :TQUANT + :TQUANT1 INTO :$.TQUANT
FROM DUMMY
;
UPDATE ZCLA_EDITLOG
SET COMPONENT = :$.PLOTCOMPONENT
WHERE COMPONENT = :MERGE
;
DELETE FROM ZCLA_PLOTCOMPONENT
WHERE PLOTCOMPONENT = :MERGE
;
RETURN ;
