/*
*************** */ 
/*
Attachments */ 
/*
EXTFILENAME */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HTEDIT/A' , :ELEMENT , :HTEDIT , :OPENEDIT 
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
INSERT INTO ZCLA_ELEDITLOG ( EDITID
,      PROJACT
,      UPDTYPE
,      EDITTYPE
,      ROOM
,      ROOMDES
,      GUID
,      GUID2
,      FIELD
,      OLDKEY
,      NEWKEY
,      OLDVALUE
,      NEWVALUE
,      OLDPRICE
,      NEWPRICE
,      ISDELETED
,      WASDELETED
,      INT1
,      INT2
,      TEXT1
,      DATE1
)
SELECT :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       0 AS ROOM
,       '' AS ROOMDES
,       HTFILES.GUID
,       PLFILES.GUID AS GUID2
,       'EXTFILENAME' AS FIELD
,       0 AS OLDKEY
,       0 AS NEWKEY
,       PLFILES.EXTFILENAME AS OLDVALUE
,       HTFILES.EXTFILENAME AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,       PLFILES.ISDELETED 
,       HTFILES.ISDELETED AS WASDELETED
,       HTFILES.ZCLA_FILECATEGORY
,       HTFILES.EXTFILENUM
,       HTFILES.EXTFILENAME
,       HTFILES.CURDATE
FROM ZCLA_HTEDITLOG
,    ZCLA_HTEDIT
,    PROJACTS
,    EXTFILES HTFILES
,    EXTFILES PLFILES ?
WHERE 0 = 0
AND   ZCLA_HTEDITLOG.HTEDIT = ZCLA_HTEDIT.HTEDIT  
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_HTEDITLOG.GUID = HTFILES.GUID
AND   PROJACTS.PROJACT = PLFILES.IV
AND   HTFILES.GUID = PLFILES.GUID 
AND   PROJACTS.PROJACT = :ELEMENT
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT
AND   ZCLA_HTEDITLOG.EDITTYPE = 'A'
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   HTFILES.TYPE = '¬'
AND   PLFILES.TYPE = 'T'
; 
/*
EXTFILEDES */
INSERT INTO ZCLA_ELEDITLOG ( EDITID
,      PROJACT
,      UPDTYPE
,      EDITTYPE
,      ROOM
,      ROOMDES
,      GUID
,      GUID2
,      FIELD
,      OLDKEY
,      NEWKEY
,      OLDVALUE
,      NEWVALUE
,      OLDPRICE
,      NEWPRICE
,      ISDELETED
,      WASDELETED
,      INT1
,      INT2
,      TEXT1
,      DATE1
)
SELECT :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       0 AS ROOM
,       '' AS ROOMDES
,       HTFILES.GUID
,       PLFILES.GUID AS GUID2
,       'EXTFILEDES' AS FIELD
,       0 AS OLDKEY
,       0 AS NEWKEY
,       PLFILES.EXTFILEDES AS OLDVALUE
,       HTFILES.EXTFILEDES AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,       HTFILES.ISDELETED
,       PLFILES.ISDELETED AS WASDELETED
,       HTFILES.ZCLA_FILECATEGORY
,       HTFILES.EXTFILENUM
,       HTFILES.EXTFILENAME
,       HTFILES.CURDATE
FROM ZCLA_HTEDITLOG
,    ZCLA_HTEDIT
,    PROJACTS
,    EXTFILES HTFILES
,    EXTFILES PLFILES ?
WHERE 0 = 0
AND   ZCLA_HTEDITLOG.HTEDIT = ZCLA_HTEDIT.HTEDIT  
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_HTEDITLOG.GUID = HTFILES.GUID
AND   PROJACTS.PROJACT = PLFILES.IV
AND   HTFILES.GUID = PLFILES.GUID 
AND   PROJACTS.PROJACT = :ELEMENT
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT
AND   ZCLA_HTEDITLOG.EDITTYPE = 'A'
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   HTFILES.TYPE = '¬'
AND   PLFILES.TYPE = 'T'
; 
/*
ZCLA_FILECATEGORY */
INSERT INTO ZCLA_ELEDITLOG ( EDITID
,      PROJACT
,      UPDTYPE
,      EDITTYPE
,      ROOM
,      ROOMDES
,      GUID
,      GUID2
,      FIELD
,      OLDKEY
,      NEWKEY
,      OLDVALUE
,      NEWVALUE
,      OLDPRICE
,      NEWPRICE
,      ISDELETED
,      WASDELETED
,      INT1
,      INT2
,      TEXT1
,      DATE1
)
SELECT :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       0 AS ROOM
,       '' AS ROOMDES
,       HTFILES.GUID
,       PLFILES.GUID AS GUID2
,       'ZCLA_FILECATEGORY' AS FIELD
,       PLFILES.ZCLA_FILECATEGORY AS OLDKEY
,       HTFILES.ZCLA_FILECATEGORY AS NEWKEY
,       OLDVALUE.CATEGORYNAME AS OLDVALUE
,       NEWVALUE.CATEGORYNAME AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,       HTFILES.ISDELETED
,       PLFILES.ISDELETED AS WASDELETED
,       HTFILES.ZCLA_FILECATEGORY
,       HTFILES.EXTFILENUM
,       HTFILES.EXTFILENAME
,       HTFILES.CURDATE
FROM ZCLA_HTEDITLOG
,    ZCLA_HTEDIT
,    PROJACTS
,    EXTFILES HTFILES
,    EXTFILES PLFILES ?
,    ZCLA_FILECATEGORIES OLDVALUE ?
,    ZCLA_FILECATEGORIES NEWVALUE
WHERE 0 = 0
AND   HTFILES.ZCLA_FILECATEGORY = NEWVALUE.FILECATEGORY
AND   PLFILES.ZCLA_FILECATEGORY = OLDVALUE.FILECATEGORY
AND   ZCLA_HTEDITLOG.HTEDIT = ZCLA_HTEDIT.HTEDIT
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_HTEDITLOG.GUID = HTFILES.GUID
AND   PROJACTS.PROJACT = PLFILES.IV
AND   HTFILES.GUID = PLFILES.GUID 
AND   PROJACTS.PROJACT = :ELEMENT
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT
AND   ZCLA_HTEDITLOG.EDITTYPE = 'A'
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   HTFILES.TYPE = '¬'
AND   PLFILES.TYPE = 'T'
; 