/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT *
FROM ZCLA_CORETYPE
WHERE 0=0
AND   COPY = 'Y'
AND   USER = SQL.USER
AND   :DEBUG = 1
FORMAT :DEBUGFILE
;
SELECT 40 INTO :$.GO
FROM DUMMY ;
GOTO 100 WHERE NOT EXISTS (
SELECT 'x'
FROM ZCLA_CORETYPE
WHERE 0=0
AND   COPY = 'Y'
AND   USER = SQL.USER
);
SELECT 25 INTO :$.GO
FROM DUMMY ;
LABEL 100 ;
