/*
*/
SELECT 'ZCLA_HTEDIT/ZCLA_BUF5'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE;
/*
Iterate change @LOG */
DECLARE @LOG CURSOR FOR
SELECT EDITID
,     PROJACT
,     UPDTYPE
,     EDITTYPE
,     ROOM
,     ROOMDES
,     GUID
,     GUID2
,     FIELD
,     OLDKEY
,     NEWKEY
,     OLDVALUE
,     NEWVALUE
,     OLDPRICE
,     NEWPRICE
,     ISDELETED
,     WASDELETED
,     INT1
,     INT2
,     INT3
,     INT4
,     TEXT1
,     TEXT2
,     TEXT3
,     REAL1
,     REAL2
,     REAL3
,     INT4
,     REAL4
,     DATE1
,     DATE2
,     KEY1
,     KEY2
,     PARENT
FROM ZCLA_ELEDITLOG
WHERE EDITID = :OPENEDIT ;
OPEN @LOG ;
GOTO 511239 WHERE :RETVAL = 0 ;
LABEL 511231 ;
:EDITID = :PROJACT = :ROOM = 0 ;
:UPDTYPE = :EDITTYPE = :ISDELETED = :WASDELETED = '\0' ;
:ROOMDES = :GUID = :GUID2 = :PARENT = :FIELD = '' ;
:OLDKEY = :NEWKEY = 0 ;
:OLDVALUE = :NEWVALUE = '' ;
:OLDPRICE = :NEWPRICE = 0.0 ;
:INT1 = :INT2 = :INT3 = :INT4 = 0 ;
:TEXT1 = :TEXT2 = :TEXT3  = '' ;
:REAL1 = :REAL2 = :REAL3 = :REAL4 = 0.0 ;
:DATE1 = :DATE2 = :KEY1 = :KEY2 = 0 ;
FETCH @LOG INTO :EDITID
,    :PROJACT
,    :UPDTYPE
,    :EDITTYPE
,    :ROOM
,    :ROOMDES
,    :GUID
,    :GUID2
,    :FIELD
,    :OLDKEY
,    :NEWKEY
,    :OLDVALUE
,    :NEWVALUE
,    :OLDPRICE
,    :NEWPRICE
,    :ISDELETED
,    :WASDELETED
,    :INT1
,    :INT2
,    :INT3
,    :INT4
,    :TEXT1
,    :TEXT2
,    :TEXT3
,    :REAL1
,    :REAL2
,    :REAL3
,    :INT4
,    :REAL4
,    :DATE1
,    :DATE2
,    :KEY1
,    :KEY2
,    :PARENT
;
GOTO 511238 WHERE :RETVAL = 0
;
SELECT :EDITID
,    :PROJACT
,    :UPDTYPE
,    :EDITTYPE
,    :ROOM
,    :ROOMDES
,    :GUID
,    :GUID2
,    :FIELD
,    :OLDKEY
,    :NEWKEY
,    :OLDVALUE
,    :NEWVALUE
,    :OLDPRICE
,    :NEWPRICE
,    :ISDELETED
,    :WASDELETED
,    :INT1
,    :INT2
,    :INT3
,    :INT4
,    :TEXT1
,    :TEXT2
,    :TEXT3
,    :REAL1
,    :REAL2
,    :REAL3
,    :INT4
,    :REAL4
,    :DATE1
,    :DATE2
,    :KEY1
,    :KEY2
,    :PARENT
FROM DUMMY
WHERE 0=0
AND   :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
GOSUB 5112310 WHERE :UPDTYPE = 'I' ;
GOSUB 5112320 WHERE :UPDTYPE = 'U' ;
GOSUB 5112330 WHERE :UPDTYPE = 'D' ;
/*
*/
LOOP 511231 ;
LABEL 511238 ;
CLOSE @LOG ;
LABEL 511239 ;
/*
*/
SELECT 'ZCLA_HTEDIT/ZCLA_BUF5/END'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE;
