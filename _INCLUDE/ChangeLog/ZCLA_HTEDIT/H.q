/*
*************** */ 
/*
House */
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
)
SELECT :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       0 AS ROOM
,       '' AS ROOMDES
,       ZCLA_HOUSETYPE.GUID
,       PROJACTS.ZCLA_GUID AS GUID2
,       'ALT' AS FIELD
,       PROJACTS.ZCLA_ALT AS OLDKEY
,       ZCLA_HOUSETYPE.ALT AS NEWKEY
,       OLDVALUE.NAME AS OLDVALUE
,       NEWVALUE.NAME AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,       '' AS ISDELETED
,       '' AS WASDELETED
FROM ZCLA_ALTMANUF OLDVALUE
,    ZCLA_HOUSETYPE
,    PROJACTS
,    ZCLA_HTEDIT
,    ZCLA_HTEDITLOG
,    ZCLA_ALTMANUF NEWVALUE ?
WHERE 0 = 0
AND   ZCLA_HTEDIT.HTEDIT = ZCLA_HTEDITLOG.HTEDIT
AND   PROJACTS.ZCLA_HOUSETYPEID = ZCLA_HTEDIT.HOUSETYPEID
AND   ZCLA_HOUSETYPE.GUID = ZCLA_HTEDITLOG.GUID
AND   OLDVALUE.ALT = PROJACTS.ZCLA_ALT
AND   ZCLA_HOUSETYPE.ALT = NEWVALUE.ALT 
AND   PROJACTS.PROJACT = :ELEMENT
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT
AND   ZCLA_HTEDITLOG.EDITTYPE = 'H'
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
;