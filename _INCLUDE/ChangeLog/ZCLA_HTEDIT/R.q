/*
*************** */ 
/*
Rooms */ 
/*
SUP */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HTEDIT/R' , :ELEMENT , :HTEDIT , :OPENEDIT 
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
,      TEXT1
,      INT2
)
SELECT :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       ZCLA_ROOMS.ROOM
,       ZCLA_ROOMS.ROOMDES
,       ZCLA_ROOMS.GUID
,       ZCLA_PLOTROOMS.GUID AS GUID2
,       'SUP' AS FIELD
,       ZCLA_PLOTROOMS.SUP AS OLDKEY
,       ZCLA_ROOMS.SUP AS NEWKEY
,       OLDVALUE.SUPDES AS OLDVALUE
,       NEWVALUE.SUPDES AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,       '' AS ISDELETED
,       '' AS WASDELETED
,       ZCLA_ROOMS.COL
,       ZCLA_ROOMS.STYLE
,       NEWVALUE.SUP
FROM SUPPLIERS NEWVALUE
,    PROJACTS
,    ZCLA_ROOMS
,    ZCLA_HTEDIT
,    ZCLA_HTEDITLOG
,    ZCLA_PLOTROOMS ?
,    SUPPLIERS OLDVALUE ?
WHERE 0=0
AND   ZCLA_HTEDIT.HTEDIT = ZCLA_HTEDITLOG.HTEDIT
AND   ZCLA_ROOMS.GUID = ZCLA_HTEDITLOG.GUID
AND   PROJACTS.ZCLA_HOUSETYPEID = ZCLA_HTEDIT.HOUSETYPEID
AND   NEWVALUE.SUP = ZCLA_ROOMS.SUP
AND   ZCLA_PLOTROOMS.SUP = OLDVALUE.SUP
AND   PROJACTS.PROJACT = ZCLA_PLOTROOMS.PROJACT
AND   ZCLA_ROOMS.GUID = ZCLA_PLOTROOMS.GUID
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT
AND   PROJACTS.PROJACT = :ELEMENT
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   ZCLA_HTEDITLOG.EDITTYPE = 'R'
;