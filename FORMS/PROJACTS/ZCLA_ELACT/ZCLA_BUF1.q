/* Update the element rooms, components,
.  subcontract parts, consumer Units and fixes
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT '>>> Reuild Plot' , :ELEMENT, :HOUSETYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
/*
Delete components */
DELETE FROM ZCLA_PLOTCOMPONENT
WHERE PROJACT = :ELEMENT
;
/*
Delete rooms */
DELETE FROM ZCLA_PLOTROOMS
WHERE 0=0
AND   PROJACT = :ELEMENT
;
/*
Delete from Contract parts */
DELETE FROM ZCLA_PQUOTE
WHERE PROJACT = :ELEMENT
;
/* Delete consumer unit config */
DELETE FROM ZCLA_PLOTCUCFG
WHERE CONSUMERUNIT IN (
SELECT CONSUMERUNIT
FROM ZCLA_PLOTCU
WHERE PROJACT = :ELEMENT
);
/*
Delete consumer units */
DELETE FROM ZCLA_PLOTCU
WHERE PROJACT = :ELEMENT
;
/*GergoM | 13.11.23 | Delete Attachments */
DELETE FROM EXTFILES
WHERE IV = :ELEMENT
;
/* Delete Subcontract parts */
DELETE FROM ZCLA_PROJACTQUOTE
WHERE PROJACT = :ELEMENT
;
/* Delete Smallworks parts */
DELETE FROM ZCLA_PROJACTPARTS
WHERE PROJACT = :ELEMENT
;
/* Delete Smallworks points */
DELETE FROM ZCLA_SMALLWORKSPLOT
WHERE PROJACT = :ELEMENT
;
/* Delete Subcontract points */
DELETE FROM ZCLA_PLOTROOMFIXES
WHERE PROJACT = :ELEMENT
;
/*
Insert Rooms */
INSERT INTO ZCLA_PLOTROOMS(GUID , PROJACT , ROOM , COL , ZCLA_STYLE
/*, SUP*/)
SELECT ZCLA_ROOMS.GUID , :ELEMENT , ROOM , COL , ZCLA_ROOMS.STYLE
/*, SUP*/
FROM PROJACTS EL , ZCLA_ROOMS
WHERE 0=0
AND   ZCLA_ROOMS.HOUSETYPEID = EL.ZCLA_HOUSETYPEID
AND   EL.PROJACT = :ELEMENT
;
/*
Insert subcontract parts
*/
INSERT INTO ZCLA_PROJACTQUOTE ( PROF
,    KLINE
,    PLOTROOM
,    PROJACT
,    QUANTITY
,    HOUSETYPEID
,    ZCLA_COST
,    PRICE
,    MARKUP
,    TOTPRICE
,    DOC
,    ORDI
,    PDES
,    DEALI
,    FIXID
,    GUID
,    SUP
)
SELECT  PROF
,       ZCLA_ROOMQUOTE.KLINE
,       ZCLA_ROOMQUOTE.ROOM
,       :ELEMENT
,       ZCLA_ROOMQUOTE.QUANTITY
,       ZCLA_ROOMQUOTE.HOUSETYPEID
,       ZCLA_ROOMQUOTE.ZCLA_COST
,       ZCLA_ROOMQUOTE.PRICE
,       ZCLA_ROOMQUOTE.MARKUP
,       ZCLA_ROOMQUOTE.TOTPRICE
,       ZCLA_ROOMQUOTE.DOC
,       ZCLA_ROOMQUOTE.ORDI
,       ZCLA_ROOMQUOTE.PDES
,       ZCLA_ROOMQUOTE.DEALI
,       ZCLA_ROOMQUOTE.FIXID
,       ZCLA_ROOMQUOTE.GUID
,       ZCLA_ROOMQUOTE.SUP
FROM ZCLA_ROOMQUOTE , PROJACTS
WHERE 0=0
AND   ZCLA_ROOMQUOTE.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   PROJACTS.PROJACT = :ELEMENT
AND   ISDELETED <> 'Y'
;
/* Insert sub contract points */
INSERT INTO ZCLA_PLOTROOMFIXES ( GUID
,     FIX
,     POINT
,     PROJACT
)
SELECT ZCLA_ROOMFIXES.GUID
,      ZCLA_ROOMFIXES.FIX
,      ZCLA_ROOMFIXES.POINT
,      :ELEMENT
FROM   PROJACTS
,      ZCLA_ROOMS
,      ZCLA_ROOMFIXES
,      ZCLA_ROOMQUOTE
WHERE  0=0
AND    PROJACTS.ZCLA_HOUSETYPEID     = ZCLA_ROOMS.HOUSETYPEID
AND    ZCLA_ROOMQUOTE.GUID           = ZCLA_ROOMFIXES.GUID
AND    PROJACTS.PROJACT              = :ELEMENT
AND    NOT ZCLA_ROOMQUOTE.ISDELETED  = 'Y'
AND    NOT ZCLA_ROOMFIXES.GUID       = ''
;
/*
Insert Small Works Parts
*/
INSERT INTO ZCLA_PROJACTPARTS ( GUID
,   FIXID
,   PART
,   ROOM
,   PROJACT
,   TQUANT
,   QPRICE
,   TOTPRICE
,   FIXID
)
SELECT ZCLA_ROOMPARTS.GUID
,   FIXID
,   ZCLA_ROOMPARTS.PART
,   ZCLA_ROOMPARTS.ROOM
,   :ELEMENT
,   ZCLA_ROOMPARTS.TQUANT
,   ZCLA_ROOMPARTS.QPRICE
,   ZCLA_ROOMPARTS.TOTPRICE
,   ZCLA_ROOMPARTS.FIXID
FROM ZCLA_ROOMPARTS , ZCLA_ROOMS , PROJACTS
WHERE 0=0
AND   ZCLA_ROOMS.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_ROOMPARTS.ROOM = ZCLA_ROOMS.ROOM
AND   PROJACTS.PROJACT = :ELEMENT
AND   ISDELETED <> 'Y'
;
/*
Insert Small Works points
*/
INSERT INTO ZCLA_SMALLWORKSPLOT ( FIX
,    SMALLPOINTS
,    ROOM
,    PROJACT
)
SELECT  ZCLA_SMALLWORKSFIX.FIX
,       ZCLA_SMALLWORKSFIX.SMALLPOINTS
,       ZCLA_SMALLWORKSFIX.ROOM
,       :ELEMENT
FROM ZCLA_SMALLWORKSFIX, ZCLA_ROOMS , PROJACTS
WHERE 0=0
AND   ZCLA_ROOMS.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   ZCLA_SMALLWORKSFIX.ROOM = ZCLA_ROOMS.ROOM
AND   PROJACTS.PROJACT = :ELEMENT
;
/*
Insert Components */
INSERT INTO ZCLA_PLOTCOMPONENT( GUID , PROJACT , ROOM , PART
,           TQUANT , COL , STYLE , EXTRA , ISDELETED )
SELECT ZCLA_COMPONENT.GUID
,      :ELEMENT
,      ZCLA_COMPONENT.ROOM
,      ZCLA_COMPONENT.PART
,      ZCLA_COMPONENT.TQUANT
,      ZCLA_COMPONENT.COL
,      ZCLA_COMPONENT.STYLE
,      'N' , 'N'
FROM   PROJACTS
,      ZCLA_COMPONENT
,      ZCLA_ROOMS
WHERE  0=0
AND    ZCLA_COMPONENT.ROOM > 0
AND    PROJACTS.PROJACT = :ELEMENT
AND    ZCLA_COMPONENT.ROOM = ZCLA_ROOMS.ROOM
AND    PROJACTS.ZCLA_HOUSETYPEID = ZCLA_ROOMS.HOUSETYPEID
AND    ZCLA_COMPONENT.TQUANT > 0
AND    ZCLA_COMPONENT.ISDELETED <> 'Y'
;
/*
Add Consumer units */
/*
Declare CUNIT cursor */
/*GergoM | 13.11.23 | CU.ISDELETED -> :CU_ISDELETED*/
DECLARE @ELACT_CUCURSOR CURSOR FOR
SELECT CU.CONSUMERUNIT, CU.ISDELETED
FROM ZCLA_CONSUMERUNITS CU , PROJACTS
WHERE 0=0
AND   CU.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID
AND   PROJACTS.PROJACT = :ELEMENT
;
OPEN @ELACT_CUCURSOR;
GOTO 2710239 WHERE :RETVAL <= 0 ;
LABEL 1212 ;
:CONSUMERUNIT = 0 ;
FETCH @ELACT_CUCURSOR INTO :CONSUMERUNIT, :CU_ISDELETED ;
GOTO 2710238 WHERE :RETVAL <= 0 ;
/*
*/
/*GergoM | 04/12/23 | ZGEM_TQUANT*/
:ROOM = :PART = :ZGEM_TQUANT = 0 ;
:GID = '' ;
SELECT   GUID , PART , ROOM, ZGEM_TQUANT
INTO :GID , :PART , :ROOM, :ZGEM_TQUANT
FROM ZCLA_CONSUMERUNITS
WHERE CONSUMERUNIT = :CONSUMERUNIT
;
/*GergoM | 13.11.23 | ISDELETED <- :CU_ISDELETED*/
INSERT INTO ZCLA_PLOTCU( GUID , PROJACT , PART
, ROOM , ISDELETED, ZGEM_TQUANT)
SELECT :GID , :ELEMENT , :PART
, :ROOM , :CU_ISDELETED, :ZGEM_TQUANT
FROM DUMMY ;
/*
*/
:NEWCU = 0;
SELECT CONSUMERUNIT INTO :NEWCU
FROM ZCLA_PLOTCU
WHERE 0=0
AND   PROJACT = :ELEMENT
AND   GUID = :GID ;
/*
*/
/*GergoM | 13/11/23 | ISDELETED <-- ZCLA_CUNITCONFIG.ISDELETED*/
INSERT INTO ZCLA_PLOTCUCFG ( GUID
,   CONSUMERUNIT
,   RCD
,   KLINE
,   PART
,   DEVICE
,   WAYNO
,   ISDELETED
)
SELECT ZCLA_CUNITCONFIG.GUID
,   :NEWCU
,   ZCLA_CUNITCONFIG.RCD
,   ZCLA_CUNITCONFIG.KLINE
,   PART.PART
,   ZCLA_CUCONFIG_OPT.DEVICE
,   ZCLA_CUNITCONFIG.WAYNO
,   ZCLA_CUNITCONFIG.ISDELETED
FROM  ZLIA_CAB_CONFIG  , ZLIA_PDV_CONFIG  , ZLIA_PDV_DEFOPT
,     PART  , ZCLA_CUCONFIG_OPT  , ZCLA_CUNITCONFIG
WHERE 0=0
AND   ZCLA_CUNITCONFIG.DEVICE = ZCLA_CUCONFIG_OPT.DEVICE
AND   PART.ZLIA_PDV_DEFID = ZLIA_PDV_DEFOPT.PDV_DEFID
AND   ZLIA_PDV_DEFOPT.DEVTYPEID = ZLIA_PDV_CONFIG.DEVTYPEID
AND   PART.ZLIA_CIRCCAB_DEFID = ZLIA_CAB_CONFIG.CABLEID
AND   ZCLA_CUNITCONFIG.PART = PART.PART
AND   ZCLA_CUNITCONFIG.CONSUMERUNIT = 0 + :CONSUMERUNIT
;
/*
*/
LOOP 1212;
LABEL 2710238 ;
CLOSE @ELACT_CUCURSOR;
LABEL 2710239 ;
/*--*/
/*GergoM | 15.11.23 | Attachments*/
/*-----------------------------------------------------*/
/* Find latest attachment for each category */
DECLARE @ZGEM_CATCURSOR CURSOR FOR
SELECT DISTINCT ZCLA_FILECATEGORY
FROM EXTFILES, ZCLA_FILECATEGORIES Z
WHERE IV = :HOUSETYPE
AND EXTFILES.ZCLA_FILECATEGORY = Z.FILECATEGORY
AND   TYPE = '¬'
AND   Z.INTERNALCOPY = 'Y'
AND   ISDELETED <> 'Y'
;
OPEN @ZGEM_CATCURSOR;
GOTO 1711239 WHERE :RETVAL = 0;
LABEL 1711231;
:CAT = 0;
FETCH @ZGEM_CATCURSOR INTO :CAT;
GOTO 1711238 WHERE :RETVAL = 0;
/* Insert attachments */
SELECT  ZCLA_FILECATEGORY
,       EXTFILENUM
,       EXTFILENAME
,       EXTFILEDES
,       GUID
,       CURDATE
INTO :ZGEM_ZCLA_FILECATEGORY
, :ZGEM_EXTFILENUM
, :ZGEM_EXTFILENAME
, :ZGEM_EXTFILEDES
, :ZGEM_GUID
, :ZGEM_CURDATE
FROM EXTFILES
WHERE TYPE = '¬'
AND   IV = :HOUSETYPE
AND   EXTFILES.ZCLA_FILECATEGORY = :CAT
ORDER BY CURDATE DESC
OFFSET 0 FETCH NEXT 1 ROWS ONLY
;
INSERT INTO EXTFILES ( IV
,      TYPE
,      ZCLA_FILECATEGORY
,      EXTFILENUM
,      EXTFILENAME
,      EXTFILEDES
,      GUID
,      CURDATE )
VALUES (:ELEMENT
, 'T'
, :ZGEM_ZCLA_FILECATEGORY
, :ZGEM_EXTFILENUM
, :ZGEM_EXTFILENAME
, :ZGEM_EXTFILEDES
, :ZGEM_GUID
, :ZGEM_CURDATE );
LOOP 1711231;
LABEL 1711238;
CLOSE @ZGEM_CATCURSOR;
LABEL 1711239;
