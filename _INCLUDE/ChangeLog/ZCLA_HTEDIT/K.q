/*
*************** */ 
/*
Small Works Parts */ 
/*
Part */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HTEDIT/K' , :ELEMENT , :HTEDIT , :OPENEDIT 
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
)
SELECT  :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       ZCLA_ROOMS.ROOM
,       ZCLA_ROOMS.ROOMDES
,       ZCLA_ROOMPARTS.GUID
,       ZCLA_PROJACTPARTS.GUID AS GUID2	
,       'PART' AS FIELD
,       ZCLA_PROJACTPARTS.PART AS OLDKEY
,       ZCLA_ROOMPARTS.PART AS NEWKEY
,       OLDVALUE.PARTNAME AS OLDVALUE
,       NEWVALUE.PARTNAME AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,	    ZCLA_ROOMPARTS.ISDELETED AS ISDELETED
,	    ZCLA_PROJACTPARTS.ISDELETED AS WASDELETED
,       ZCLA_ROOMPARTS.PART
,       ZCLA_ROOMPARTS.TQUANT
FROM PART OLDVALUE
,    PART NEWVALUE
,    ZCLA_PROJACTPARTS ?
,    ZCLA_ROOMPARTS 
,    PROJACTS 
,    ZCLA_HTEDIT
,    ZCLA_HTEDITLOG
,    ZCLA_ROOMS
WHERE 0=0
AND   OLDVALUE.PART = ZCLA_PROJACTPARTS.PART
AND   ZCLA_HTEDIT.HTEDIT = ZCLA_HTEDITLOG.HTEDIT
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_ROOMPARTS.HOUSETYPEID = ZCLA_HTEDIT.HOUSETYPEID
AND   ZCLA_CONSUMERUNITS.GUID = ZCLA_HTEDITLOG.GUID
AND   NEWVALUE.PART = ZCLA_ROOMPARTS.PART
AND   ZCLA_ROOMPARTS.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_PROJACTPARTS.PROJACT = PROJACTS.PROJACT
AND   ZCLA_PROJACTPARTS.GUID = ZCLA_ROOMPARTS.GUID 
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT 
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   ZCLA_HTEDITLOG.EDITTYPE = 'K'
AND   PROJACTS.PROJACT = :ELEMENT
;
/*
TQUANT */
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
)
SELECT  :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       ZCLA_ROOMS.ROOM
,       ZCLA_ROOMS.ROOMDES
,       ZCLA_ROOMPARTS.GUID
,       ZCLA_PROJACTPARTS.GUID AS GUID2	
,       'TQUANT' AS FIELD
,       ZCLA_PROJACTPARTS.TQUANT AS OLDKEY
,       ZCLA_ROOMPARTS.TQUANT AS NEWKEY
,       ITOA(ZCLA_PROJACTPARTS.TQUANT / 1000 ) AS OLDVALUE
,       ITOA(ZCLA_ROOMPARTS.TQUANT / 1000 ) AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,	    ZCLA_ROOMPARTS.ISDELETED AS ISDELETED
,	    ZCLA_PROJACTPARTS.ISDELETED AS WASDELETED
,       ZCLA_ROOMPARTS.PART
,       ZCLA_ROOMPARTS.TQUANT
FROM PART OLDVALUE
,    PART NEWVALUE
,    ZCLA_PROJACTPARTS ?
,    ZCLA_ROOMPARTS 
,    PROJACTS 
,    ZCLA_HTEDIT
,    ZCLA_HTEDITLOG
,    ZCLA_ROOMS
WHERE 0=0
AND   OLDVALUE.PART = ZCLA_PROJACTPARTS.PART
AND   ZCLA_HTEDIT.HTEDIT = ZCLA_HTEDITLOG.HTEDIT
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_ROOMPARTS.HOUSETYPEID = ZCLA_HTEDIT.HOUSETYPEID
AND   ZCLA_CONSUMERUNITS.GUID = ZCLA_HTEDITLOG.GUID
AND   NEWVALUE.PART = ZCLA_ROOMPARTS.PART
AND   ZCLA_ROOMPARTS.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_PROJACTPARTS.PROJACT = PROJACTS.PROJACT
AND   ZCLA_PROJACTPARTS.GUID = ZCLA_ROOMPARTS.GUID 
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT 
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   ZCLA_HTEDITLOG.EDITTYPE = 'K'
AND   PROJACTS.PROJACT = :ELEMENT
;
/*
QPRICE  */
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
)
SELECT  :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       ZCLA_ROOMS.ROOM
,       ZCLA_ROOMS.ROOMDES
,       ZCLA_ROOMPARTS.GUID
,       ZCLA_PROJACTPARTS.GUID AS GUID2	
,       'QPRICE' AS FIELD
,       0 AS OLDKEY
,       0 AS NEWKEY
,       RTOA(ZCLA_PROJACTPARTS.QPRICE) AS OLDVALUE
,       RTOA(ZCLA_ROOMPARTS.QPRICE) AS NEWVALUE
,       ZCLA_PROJACTPARTS.QPRICE AS OLDPRICE
,       ZCLA_ROOMPARTS.QPRICE AS NEWPRICE
,	    ZCLA_ROOMPARTS.ISDELETED AS ISDELETED
,	    ZCLA_PROJACTPARTS.ISDELETED AS WASDELETED
,       ZCLA_ROOMPARTS.PART
FROM PART OLDVALUE
,    PART NEWVALUE
,    ZCLA_PROJACTPARTS ?
,    ZCLA_ROOMPARTS 
,    PROJACTS 
,    ZCLA_HTEDIT
,    ZCLA_HTEDITLOG
,    ZCLA_ROOMS
WHERE 0=0
AND   OLDVALUE.PART = ZCLA_PROJACTPARTS.PART
AND   ZCLA_HTEDIT.HTEDIT = ZCLA_HTEDITLOG.HTEDIT
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_ROOMPARTS.HOUSETYPEID = ZCLA_HTEDIT.HOUSETYPEID
AND   ZCLA_CONSUMERUNITS.GUID = ZCLA_HTEDITLOG.GUID
AND   NEWVALUE.PART = ZCLA_ROOMPARTS.PART
AND   ZCLA_ROOMPARTS.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_PROJACTPARTS.PROJACT = PROJACTS.PROJACT
AND   ZCLA_PROJACTPARTS.GUID = ZCLA_ROOMPARTS.GUID 
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT 
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   ZCLA_HTEDITLOG.EDITTYPE = 'K'
AND   PROJACTS.PROJACT = :ELEMENT
;
/*
TOTPRICE  */
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
)
SELECT  :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       ZCLA_ROOMS.ROOM
,       ZCLA_ROOMS.ROOMDES
,       ZCLA_ROOMPARTS.GUID
,       ZCLA_PROJACTPARTS.GUID AS GUID2	
,       'TOTPRICE' AS FIELD
,       0 AS OLDKEY
,       0 AS NEWKEY
,       RTOA(ZCLA_PROJACTPARTS.TOTPRICE) AS OLDVALUE
,       RTOA(ZCLA_ROOMPARTS.TOTPRICE) AS NEWVALUE
,       ZCLA_PROJACTPARTS.TOTPRICE AS OLDPRICE
,       ZCLA_ROOMPARTS.TOTPRICE AS NEWPRICE
,	    ZCLA_ROOMPARTS.ISDELETED AS ISDELETED
,	    ZCLA_PROJACTPARTS.ISDELETED AS WASDELETED
,       ZCLA_ROOMPARTS.PART
FROM PART OLDVALUE
,    PART NEWVALUE
,    ZCLA_PROJACTPARTS ?
,    ZCLA_ROOMPARTS 
,    PROJACTS 
,    ZCLA_HTEDIT
,    ZCLA_HTEDITLOG
,    ZCLA_ROOMS
WHERE 0=0
AND   OLDVALUE.PART = ZCLA_PROJACTPARTS.PART
AND   ZCLA_HTEDIT.HTEDIT = ZCLA_HTEDITLOG.HTEDIT
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_ROOMPARTS.HOUSETYPEID = ZCLA_HTEDIT.HOUSETYPEID
AND   ZCLA_CONSUMERUNITS.GUID = ZCLA_HTEDITLOG.GUID
AND   NEWVALUE.PART = ZCLA_ROOMPARTS.PART
AND   ZCLA_ROOMPARTS.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_PROJACTPARTS.PROJACT = PROJACTS.PROJACT
AND   ZCLA_PROJACTPARTS.GUID = ZCLA_ROOMPARTS.GUID 
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT 
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   ZCLA_HTEDITLOG.EDITTYPE = 'K'
AND   PROJACTS.PROJACT = :ELEMENT
;
/*
FIXID */
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
SELECT  :OPENEDIT
,       PROJACTS.PROJACT
,       ZCLA_HTEDITLOG.UPDTYPE
,       ZCLA_HTEDITLOG.EDITTYPE
,       ZCLA_ROOMS.ROOM
,       ZCLA_ROOMS.ROOMDES
,       ZCLA_ROOMPARTS.GUID
,       ZCLA_PROJACTPARTS.GUID AS GUID2	
,       'FIXID' AS FIELD
,       ZCLA_PROJACTPARTS.FIXID AS OLDKEY
,       ZCLA_ROOMPARTS.FIXID AS NEWKEY
,       ZCLA_FIXES.DESCRIPTION AS OLDVALUE
,       ZCLA_FIXES.DESCRIPTION AS NEWVALUE
,       0 AS OLDPRICE
,       0 AS NEWPRICE
,	    ZCLA_ROOMPARTS.ISDELETED AS ISDELETED
,	    ZCLA_PROJACTPARTS.ISDELETED AS WASDELETED
FROM PART OLDVALUE
,    PART NEWVALUE
,    ZCLA_PROJACTPARTS ?
,    ZCLA_ROOMPARTS 
,    PROJACTS 
,    ZCLA_HTEDIT
,    ZCLA_HTEDITLOG
,    ZCLA_ROOMS
WHERE 0=0
AND   OLDVALUE.PART = ZCLA_PROJACTPARTS.PART
AND   ZCLA_HTEDIT.HTEDIT = ZCLA_HTEDITLOG.HTEDIT
AND   ZCLA_HTEDIT.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_ROOMPARTS.HOUSETYPEID = ZCLA_HTEDIT.HOUSETYPEID
AND   ZCLA_CONSUMERUNITS.GUID = ZCLA_HTEDITLOG.GUID
AND   NEWVALUE.PART = ZCLA_ROOMPARTS.PART
AND   ZCLA_ROOMPARTS.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_PROJACTPARTS.PROJACT = PROJACTS.PROJACT
AND   ZCLA_PROJACTPARTS.GUID = ZCLA_ROOMPARTS.GUID 
AND   ZCLA_HTEDIT.HTEDIT = :HTEDIT 
AND   ZCLA_HTEDIT.CLOSEFLAG <> 'Y'
AND   ZCLA_HTEDITLOG.EDITTYPE = 'K'
AND   PROJACTS.PROJACT = :ELEMENT
;