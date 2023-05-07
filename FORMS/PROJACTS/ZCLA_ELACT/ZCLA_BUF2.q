/* ***********************
Points calc by Element
*********************** */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_ELACT/ZCLA_BUF2' 
FROM DUMMY 
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Reset Modifiers */
UPDATE PROJACTS
SET ZCLA_INITPOINTS = 0
,   ZCLA_TRAVEL = 0
,   ZCLA_MILEAGE = 0
,   ZCLA_PARTSUM = 0
,   ZCLA_SUNDRY = 0
WHERE 0=0
AND PROJACT = :ELEMENT ;
/*
*/
:ZCLA_TIMETOSITE = :FIXID = 0 ;
:ZCLA_MILESTOSITE = :CASHVALUE = :SAFETYMARGIN = :POINTS = 
:MILEAGE = :FULLPOINTS = :TRAVELCOST = 0.0 ;
/*
*/
SELECT ZCLA_MILESTOSITE , ZCLA_TIMETOSITE
INTO :ZCLA_MILESTOSITE , :ZCLA_TIMETOSITE
FROM DOCUMENTS
WHERE 0=0
AND DOCUMENTS.DOC = :DOC ;
/*
Get Travel Constants */
#INCLUDE ZCLA_TRAVELCONST/ZCLA_BUF1
SELECT :SAFETYMARGIN , :ZCLA_MILESTOSITE , :ZCLA_TIMETOSITE
, :MILEAGE , :TRAVELCOST , :FULLPOINTS
FROM DUMMY 
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Build the BoM */
#INCLUDE PARTARC/ZCLA_ELEMREPLACE
:SUNDRYSUM = :PARTSUM = 0.0 ;
/*
*/
DECLARE @INIT CURSOR FOR
SELECT ZCLA_PARTPOINTSPF.FIXID
,   SUM ( ( ZCLA_PARTPOINTSPF.VALUE + (ZCLA_FIXES.FIX = '3' ?
ZCLA_ACCYCOL.POINTS : 0) ) * ZCLA_PLOTCOMPONENT.TQUANT ) / 1000 AS
POINTS
,   MAX(ZCLA_FIXES.CASHVALUE / 100)
FROM  ZCLA_FIXES , PROJACTS , ZCLA_PARTPOINTSPF , ZCLA_ACCYCOL  
,     ZCLA_PLOTROOMS  ,  ZCLA_PLOTCOMPONENT
WHERE 0 = 0
AND   ZCLA_PLOTROOMS.ROOM = ZCLA_PLOTCOMPONENT.ROOM
AND   ZCLA_PLOTROOMS.PROJACT = ZCLA_PLOTCOMPONENT.PROJACT
AND   PROJACTS.ZCLA_FIX = ZCLA_FIXES.FIXID
AND   ZCLA_PLOTROOMS.PROJACT = PROJACTS.ZCLA_PLOT
AND   ZCLA_ACCYCOL.COL = ZCLA_PLOTROOMS.COL
AND   ZCLA_PARTPOINTSPF.PART = ZCLA_PLOTCOMPONENT.PART
AND   ZCLA_PARTPOINTSPF.FIXID = ZCLA_FIXES.FIXID
AND   PROJACTS.ZCLA_PLOT = :ELEMENT
GROUP BY 1 
;
OPEN @INIT ;
GOTO 999 WHERE :RETVAL = 0 ;
LABEL 500;
FETCH @INIT INTO :FIXID , :POINTS, :CASHVALUE ;
GOTO 600 WHERE :RETVAL = 0;
/*
*/
SELECT :FIXID , :POINTS , :CASHVALUE 
FROM DUMMY 
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT :POINTS + SUM(POINT) INTO :POINTS
FROM  ZCLA_ROOMQUOTE , ZCLA_ROOMS , ZCLA_ROOMFIXES 
,     PROJACTS
WHERE 0=0
AND   ZCLA_ROOMQUOTE.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_ROOMFIXES.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_ROOMS.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID 
AND   PROJACT = :ELEMENT
AND   FIX = :FIXID 
;
/*
*/
SELECT SUM(SONQUANT * PRICE) INTO :PARTSUM
FROM ZCLA_PARTARC , PRICELIST , PARTPRICE
WHERE 0=0
AND ZCLA_PARTARC.USER = SQL.USER
AND ZCLA_PARTARC.SON = PARTPRICE.PART
AND PRICELIST.PLIST = PARTPRICE.PLIST
AND PRICELIST.CURRENCY  = PARTPRICE.CURRENCY
AND PRICELIST.PLIST = -1
AND PARTPRICE.CURRENCY = -1
AND QUANT = 1000
AND ZCLA_PARTARC.ZCLA_FIXID = :FIXID
;
/*
*/
SELECT SUM(ZCLA_PARTARC.SONQUANT * PARTARC.SONQUANT *
PARTPRICE.PRICE) INTO :SUNDRYSUM
FROM  ZCLA_PARTARC ,  PARTARC ,  PARTPRICE ,  PRICELIST
WHERE 0=0
AND ZCLA_PARTARC.SON = PARTARC.PART
AND PARTARC.SON = PARTPRICE.PART
AND PARTPRICE.PLIST = PRICELIST.PLIST
AND ZCLA_PARTARC.USER = SQL.USER
AND PRICELIST.CURRENCY  = PARTPRICE.CURRENCY
AND PRICELIST.PLIST = -1
AND PARTPRICE.CURRENCY = -1
AND QUANT = 1000
AND ZCLA_PARTARC.ZCLA_FIXID = :FIXID
;
/*
*/
:TRAVEL = :UPLIFT = :ZCLA_LABOURPOINTS = 0.0 ;
SELECT 1 * ZCLA_FIXUPLIFT * ZCLA_BRUPLIFT  * MOD_HT *
MOD_ST  * MOD_PL
,   :POINTS * ZCLA_FIXUPLIFT * ZCLA_BRUPLIFT * MOD_HT
* MOD_ST  * MOD_PL
INTO :UPLIFT , :ZCLA_LABOURPOINTS 
FROM PROJACTS
WHERE 0=0
AND ZCLA_PLOT = :ELEMENT
AND ZCLA_FIX = :FIXID
;
/*
*/
SELECT  ( ( (:ZCLA_TIMETOSITE * 2) * :TRAVELCOST) * (:ZCLA_LABOURPOINTS
/ :FULLPOINTS ) )
,   ( ( (:ZCLA_MILESTOSITE * 2) * :MILEAGE ) * ( :ZCLA_LABOURPOINTS
/ :FULLPOINTS ) )
INTO :TRAVEL , :MILEAGE
FROM PROJACTS
WHERE 0=0
AND ZCLA_PLOT = :ELEMENT
AND ZCLA_FIX = :FIXID
;
/*
*/
SELECT     :PARTSUM
,    :SUNDRYSUM
,    :TRAVEL
,    :MILEAGE
,    :POINTS AS ZCLA_INITPOINTS
,    :CASHVALUE
,    :ZCLA_LABOURPOINTS AS ZCLA_LABOURPOINTS
,    :UPLIFT AS ZCLA_UPLIFT
,    :TRAVEL AS ZCLA_TRAVEL
,    :MILEAGE AS ZCLA_MILEAGE
,    :PARTSUM  *  :SAFETYMARGIN AS ZCLA_PARTSUM
,    :SUNDRYSUM *  :SAFETYMARGIN AS ZCLA_SUNDRY
,    (( :CASHVALUE * :ZCLA_LABOURPOINTS) + :TRAVEL ) AS
ZCLA_LABTOTAL
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Select the HouseType BY ELEMENT */
:HTYPE = 0 ;
SELECT 0 + ZCLA_HOUSETYPEID
INTO :HTYPE
FROM PROJACTS 
WHERE PROJACT = :ELEMENT 
;
/* Retrieve drill bit multiplier and
monetary value */
:DBMULT = :MONVAL = 0.00;
SELECT DRILLMULTIPLIER
INTO :DBMULT
FROM ZCLA_HTCHARS HT, ZCLA_CHARPERMITVALS CP, ZCLA_UPLIFTSPERFIX UP
WHERE HT.HOUSETYPEID = :HTYPE
AND HT.VALUEID = CP.VALUEID
AND HT.CHARID = 1
AND UP.VALUEID = CP.VALUEID
AND FIXID = :FIXID
;
SELECT MONETARYVALUE
INTO :MONVAL
FROM ZCLA_PLOTELEMENT PE, ZCLA_HOUSETYPE HT
WHERE PE.EL = HT.EL
AND HT.HOUSETYPEID = :HTYPE
;
/*
*/
UPDATE PROJACTS
SET ZCLA_INITPOINTS = :POINTS
,    ZCLA_LABOURPOINTS = :ZCLA_LABOURPOINTS
,    ZCLA_UPLIFT = :UPLIFT
,    ZCLA_TRAVEL = :TRAVEL
,    ZCLA_MILEAGE = :MILEAGE
,    ZCLA_PARTSUM = :PARTSUM  *  :SAFETYMARGIN
,    ZCLA_SUNDRY = :SUNDRYSUM *  :SAFETYMARGIN + (:DBMULT *
:MONVAL)
,    ZCLA_LABTOTAL = (( :CASHVALUE * :ZCLA_LABOURPOINTS) + :TRAVEL )
WHERE 0=0
AND ZCLA_PLOT = :ELEMENT
AND ZCLA_FIX = :FIXID
;
/*
*/
LOOP 500;
LABEL 600;
CLOSE @INIT ;
LABEL 999;
/*
*/
#INCLUDE ZCLA_ELACT/ZCLA_BUF6