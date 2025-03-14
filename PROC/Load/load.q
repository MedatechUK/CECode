:C = :LN = 0 ;
SELECT '' FROM DUMMY
FORMAT '../../ZLIA_GENERALLOAD2.txt'
;
SELECT SQL.TMPFILE INTO :GEN FROM DUMMY;
LINK ZLIA_GENERALLOAD2 TO :GEN;
ERRMSG 99 WHERE :RETVAL = 0 ;
/*
*/
SELECT MIN(LINE) INTO :LN
FROM ZLIA_GENERALLOAD2 ORIG
WHERE 0=0
AND   RECORDTYPE = '1'
AND   LINE > 0 ;
/*
*/
LABEL 10 ;
SELECT MIN(LINE) INTO :C
FROM ZLIA_GENERALLOAD2 ORIG
WHERE 0=0
AND   RECORDTYPE = '1'
AND   LINE > :LN ;
/*
*/
DELETE FROM ZLIA_GENERALLOAD2 ;
DELETE FROM ERRMSGS WHERE USER = SQL.USER ;
INSERT INTO ZLIA_GENERALLOAD2
SELECT * FROM ZLIA_GENERALLOAD2 ORIG
WHERE LINE BETWEEN :LN AND :C -1
;
EXECUTE INTERFACE 'ZLIA_MIG_PLOTEXTS', SQL.TMPFILE, '-L', :GEN ;
/*
*/
DECLARE GL CURSOR FOR SELECT
LINE , LOADED , KEY1 , KEY2
FROM ZLIA_GENERALLOAD2 ;
OPEN
GL;
GOTO 101 WHERE :RETVAL <= 0;
LABEL 100;
:LINE = 0 ; :KEY1 = :KEY2 = '';
:LOADED = '\0';
FETCH GL INTO :LINE , :LOADED , :KEY1 , :KEY2 ;
GOTO 99 WHERE :RETVAL = 0 ;
UPDATE ZLIA_GENERALLOAD2 ORIG
SET LOADED = :LOADED
,   KEY1 = :KEY1
,   KEY2 = :KEY2
WHERE LINE = :LINE ;
LOOP 100 ;
LABEL 99 ;
CLOSE GL ;
LABEL 101;
/*
*/
GOTO 543 WHERE NOT EXISTS(
SELECT * FROM ZLIA_GENERALLOAD2
WHERE 0=0
AND   LINE > 0
AND   LOADED <> 'Y'
);
SELECT :LN AS FROMLINE, :C -1 AS TOLINE
FROM DUMMY
FORMAT ADDTO '../../ZLIA_GENERALLOAD2.txt'
;
SELECT * FROM ZLIA_GENERALLOAD2
FORMAT ADDTO '../../ZLIA_GENERALLOAD2.txt'
;
SELECT * FROM ERRMSGS
WHERE 0=0
AND   USER = SQL.USER
AND   TYPE = 'i'
FORMAT ADDTO '../../ZLIA_GENERALLOAD2.txt'
;
LABEL 543
;
GOTO 999 WHERE EXISTS(
SELECT * FROM ZLIA_GENERALLOAD2
WHERE 0=0
AND   LINE > 0
AND   LOADED <> 'Y'
);
SELECT :C INTO :LN FROM DUMMY ;
LOOP 10 WHERE EXISTS(
SELECT 'x'
FROM ZLIA_GENERALLOAD2 ORIG
WHERE 0=0
AND   RECORDTYPE = '1'
AND   LINE > :LN
);
/*
*/
LABEL 999 ;
UNLINK ZLIA_GENERALLOAD2 ;
