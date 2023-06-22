/* ***********************
Points calc by Element
*********************** */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_ELACT/ZCLA_BUF2'
,      :ELEMENT
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
AND ZCLA_PLOT = :ELEMENT ;
/*
*/
:ZCLA_TIMETOSITE = 0 ;
:ZCLA_MILESTOSITE =  :SAFETYMARGIN = 
:DEFEXTRA = :MILEAGE = :FULLPOINTS = :TRAVELCOST = 0.0 ;
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
/*
Get the default value for extra points */
SELECT VALUE INTO :DEFEXTRA
FROM ZCLA_CONST
WHERE 0=0
AND   NAME = 'EXTRAPOINTS'
AND   TYPE = 'FIN' ;
/*
*/
DECLARE @INIT CURSOR FOR
SELECT ZCLA_PARTPOINTSPF.FIXID
,   SUM ( 
( ZCLA_PARTPOINTSPF.VALUE * REALQUANT( ZCLA_PLOTCOMPONENT.TQUANT ) ) 
+ (ZCLA_FIXES.FIX = '3' ? ZCLA_ACCYCOL.POINTS * REALQUANT( ZCLA_PLOTCOMPONENT.TQUANT ) : 0) 
+ ( ZCLA_PLOTCOMPONENT.EXTRA <> 'Y' ? 0 : ( ZCLA_PARTPOINTSPF.EVALUE > 0 ? 
ZCLA_PARTPOINTSPF.EVALUE * REALQUANT( ZCLA_PLOTCOMPONENT.TQUANT ) : :DEFEXTRA )
) ) AS POINTS 
,   MAX(ZCLA_FIXES.CASHVALUE / 100)
FROM  ZCLA_FIXES , PROJACTS , ZCLA_PARTPOINTSPF , ZCLA_ACCYCOL
,     ZCLA_PLOTROOMS  ,  ZCLA_PLOTCOMPONENT
WHERE 0 = 0
AND   ZCLA_PLOTROOMS.ROOM = ZCLA_PLOTCOMPONENT.ROOM
AND   ZCLA_PLOTROOMS.PROJACT = ZCLA_PLOTCOMPONENT.PROJACT
AND   PROJACTS.ZCLA_FIX = ZCLA_FIXES.FIXID
AND   ZCLA_PLOTROOMS.PROJACT = PROJACTS.ZCLA_PLOT
AND   ZCLA_ACCYCOL.COL = ZCLA_PLOTCOMPONENT.COL
AND   ZCLA_PARTPOINTSPF.PART = ZCLA_PLOTCOMPONENT.PART
AND   ZCLA_PARTPOINTSPF.FIXID = ZCLA_FIXES.FIXID
AND   PROJACTS.ZCLA_PLOT = :ELEMENT
AND   ZCLA_PLOTCOMPONENT.ISDELETED <> 'Y'
GROUP BY 1
;
OPEN @INIT ;
GOTO 999 WHERE :RETVAL = 0 ;
LABEL 500;
:FIXID =  0 ;
:SUNDRYSUM = :PARTSUM = :CASHVALUE = :POINTS = 0.0 ; 
FETCH @INIT INTO :FIXID , :POINTS, :CASHVALUE ;
GOTO 600 WHERE :RETVAL = 0;
/*
Add subcontract points */
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
Get price */
SELECT SUM
(   ZCLA_PARTARC.SONQUANT *
(   ZCLA_PARTARC.EXTRA <> 'Y' ? PARTPRICE.PRICE : 
(   EXPARTPRICE.PRICE > 0 ? EXPARTPRICE.PRICE : PARTPRICE.PRICE ) 
) )
INTO :PARTSUM
FROM   ZCLA_PARTARC
,      PRICELIST  
,      PARTPRICE 
,      PRICELIST EXPRICELIST ?
,      PARTPRICE EXPARTPRICE ?
WHERE 0 = 0 
AND   PRICELIST.PLIST = PARTPRICE.PLIST 
AND   PRICELIST.CURRENCY = PARTPRICE.CURRENCY
AND   PARTPRICE.PART = ZCLA_PARTARC.SON
AND   PRICELIST.PLIST = - 1 
AND   PARTPRICE.CURRENCY = - 1 
AND   PARTPRICE.QUANT = 1000 
/* WHERE DOES THE UNPACKAGED EXTRAS COME FROM ? */
AND   EXPRICELIST.CURRENCY = EXPARTPRICE.CURRENCY 
AND   EXPRICELIST.PLIST = EXPARTPRICE.PLIST
AND   EXPARTPRICE.PART = ZCLA_PARTARC.SON
AND   EXPRICELIST.PLIST = - 1 
AND   EXPARTPRICE.CURRENCY = - 1 
AND   EXPARTPRICE.QUANT = 1000
AND   ZCLA_PARTARC.ZCLA_FIXID = :FIXID 
AND   ZCLA_PARTARC.USER = SQL.USER 
;
/*
Get Sundries */
:SUNDRYCREDIT = 0.0 ;
SELECT 1 + VALUE 
INTO :SUNDRYCREDIT
FROM ZCLA_CONST
WHERE NAME = 'SUNDRYCREDIT'
;
SELECT SUM(ZCLA_PARTARC.SONQUANT * PARTARC.SONQUANT *
PARTPRICE.PRICE) 
* (1 + :SUNDRYCREDIT) INTO :SUNDRYSUM
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
:SUBCON = 0.0 ;
SELECT SUM(TOTPRICE) INTO :SUBCON 
FROM ZCLA_ROOMQUOTE
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID
;
/*
*/
:MILEAGECOST = :TRAVEL = :UPLIFT = :ZCLA_LABOURPOINTS = 0.0 ;
SELECT ZCLA_FIXUPLIFT + ZCLA_BRUPLIFT
,   :POINTS * ( 1 + ( ( MOD_HT + MOD_ST + MOD_PL ) / 100 ) )
INTO :UPLIFT , :ZCLA_LABOURPOINTS
FROM PROJACTS
WHERE 0=0
AND ZCLA_PLOT = :ELEMENT
AND ZCLA_FIX = :FIXID
;
/*
*/
SELECT  ( ( (:ZCLA_TIMETOSITE * 2) * :TRAVELCOST) *
(:ZCLA_LABOURPOINTS
/ :FULLPOINTS ) )
,   ( ( (:ZCLA_MILESTOSITE * 2) * :MILEAGE ) * ( :ZCLA_LABOURPOINTS
/ :FULLPOINTS ) )
INTO :TRAVEL , :MILEAGECOST
FROM PROJACTS
WHERE 0=0
AND ZCLA_PLOT = :ELEMENT
AND ZCLA_FIX = :FIXID
;
/*
Select the HouseType BY ELEMENT */
:HTYPE = 0 ;
SELECT 0 + ZCLA_HOUSETYPEID
INTO :HTYPE
FROM PROJACTS
WHERE PROJACT = :ELEMENT
;
/* 
Retrieve drill bit multiplier and
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
SELECT :CASHVALUE * (1 + ((ZCLA_FIXUPLIFT + ZCLA_BRUPLIFT) / 100))
,      :TRAVEL * (1 + ((ZCLA_FIXUPLIFT + ZCLA_BRUPLIFT) / 100))
INTO :CASHVALUE , :TRAVEL
FROM PROJACTS
WHERE 0=0
AND ZCLA_PLOT = :ELEMENT
AND ZCLA_FIX = :FIXID
;
/*
*/
UPDATE PROJACTS
SET ZCLA_INITPOINTS = :POINTS
,    ZCLA_LABOURPOINTS = :ZCLA_LABOURPOINTS
,    ZCLA_POINTVAL = :CASHVALUE
,    ZCLA_UPLIFT = :UPLIFT
,    ZCLA_TRAVEL = :TRAVEL
,    ZCLA_SUNDRY = :SUNDRYSUM + (:DBMULT * :MONVAL)
,    ZCLA_SUBCON = :SUBCON 
,    ZCLA_PARTSUM = :PARTSUM + :SUNDRYSUM + (:DBMULT * :MONVAL)
,    ZCLA_LABTOTAL = (( :CASHVALUE * :ZCLA_LABOURPOINTS) + :TRAVEL ) 
,    ZCLA_MILEAGE = :MILEAGECOST
,    ZCLA_TOTCOST = :PARTSUM + :SUNDRYSUM + (:DBMULT * :MONVAL)
+                   ((( :CASHVALUE * :ZCLA_LABOURPOINTS) + :TRAVEL ) * :SAFETYMARGIN )
+                    :MILEAGECOST
+                   ZCLA_SUBCON
WHERE 0=0
AND ZCLA_PLOT = :ELEMENT
AND ZCLA_FIX = :FIXID ;
/*
*/
SELECT :FIXID
,    ZCLA_INITPOINTS 
,    ZCLA_LABOURPOINTS 
,    ZCLA_POINTVAL 
,    ZCLA_UPLIFT 
,    ZCLA_TRAVEL 
,    ZCLA_SUNDRY 
,    ZCLA_SUBCON 
,    ZCLA_PARTSUM 
,    ZCLA_LABTOTAL 
,    ZCLA_MILEAGE 
,    ZCLA_TOTCOST
FROM PROJACTS
WHERE 0=0
AND   ZCLA_PLOT = :ELEMENT
AND   ZCLA_FIX = :FIXID 
AND   :DEBUG  = 1
FORMAT ADDTO :DEBUGFILE;
/*
*/
LOOP 500;
LABEL 600;
CLOSE @INIT ;
LABEL 999;
/*
*/
SELECT '>>> BEGIN SPLIT'
FROM DUMMY FORMAT ADDTO :DEBUGFILE 
;
/*
Update Housetype PRICE Totals */
SELECT SUM(ZCLA_TOTCOST) INTO :ZCLA_TOTCOST
FROM PROJACTS
WHERE   ZCLA_PLOT = :ELEMENT ;
/*
Get Split and Markup */
SELECT SQL.TMPFILE INTO :SPLIT FROM DUMMY ;
LINK ZCLA_SPLIT TO :SPLIT;
ERRMSG 1 WHERE :RETVAL = 0 ;
/*
Get house type from element */
SELECT ZCLA_HOUSETYPEID 
INTO :HOUSETYPE
FROM PROJACTS 
WHERE PROJACT = :ELEMENT
;
#INCLUDE ZCLA_HOUSETYPE/ZCLA_BUF10
SELECT * FROM ZCLA_SPLIT 
FORMAT ADDTO :DEBUGFILE ;
/*
Does this element have it's own split? */
:ELSPLIT = 0 ;
SELECT ( SUM(SPLIT) = 100 ? 1 : 0 )
INTO   :ELSPLIT
FROM   ZCLA_PLOTELFIX
WHERE 0=0
AND   PROJACT = :ELEMENT
; 
SELECT :ELSPLIT FROM DUMMY
FORMAT ADDTO :DEBUGFILE ;
/*
Override the site split with the element split */
GOTO 230523 WHERE :ELSPLIT = 0 ;
DELETE FROM ZCLA_SPLIT ;
INSERT INTO ZCLA_SPLIT (FIXID , SPLIT)
SELECT  FIXID 
,       (SPLIT > 0 ? ( SPLIT / 100 ) : 0 )
FROM ZCLA_PLOTELFIX
WHERE 0=0
AND   PROJACT = :ELEMENT
;
SELECT * FROM ZCLA_SPLIT 
FORMAT ADDTO :DEBUGFILE ;
LABEL 230523 ;
/* 
*/
DECLARE @PRICE CURSOR FOR
SELECT FIXID
,   (:ZCLA_TOTCOST * SPLIT) * :MARKUP
FROM   ZCLA_SPLIT
;
OPEN @PRICE;
GOTO 25239 WHERE :RETVAL = 0 ;
LABEL 25231 ;
:FIXACT = 0 ;
:ZCLA_TOTPRICE = 0.0 ;
FETCH @PRICE INTO :FIXACT , :ZCLA_TOTPRICE ;
GOTO 25238 WHERE :RETVAL = 0 ;
/*
*/
SELECT 'PRICE>>'
, :ELEMENT , :FIXACT , :ZCLA_TOTPRICE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
UPDATE PROJACTS
SET ZCLA_TOTPRICE = :ZCLA_TOTPRICE
WHERE 0=0
AND   ZCLA_FIX = :FIXACT
AND   ZCLA_PLOT = :ELEMENT ;
/*
*/
LOOP 25231 ;
LABEL 25238 ;
CLOSE @PRICE ;
LABEL 25239 ;
/*
*/
UNLINK ZCLA_SPLIT ;
/*
*/
/*
Set the extras fix */
:EFIX = 0 ;
SELECT FIXID INTO :EFIX 
FROM ZCLA_FIXES WHERE FIX = '99' ;
/*
*/
:SUMPACKAGES = 0.0 ;
SELECT SUM( PACKAGECOST ) INTO :SUMPACKAGES
FROM ZCLA_ELEDIT WHERE EDITID IN (
SELECT DISTINCT ZCLA_PARTARC.EDITID 
FROM ZCLA_PARTARC , ZCLA_ELEDIT
WHERE 0=0
AND   ZCLA_PARTARC.EDITID = ZCLA_ELEDIT.EDITID
AND   ZCLA_PARTARC.USER = SQL.USER 
AND   ZCLA_PARTARC.EXTRA = 'Y'
AND   ZCLA_ELEDIT.PACKAGEFLAG = 'Y'
) ;
/*
*/
UPDATE PROJACTS
SET    ZCLA_PARTCOST = :SUMPACKAGES
WHERE 0=0
AND   ZCLA_PLOT = :ELEMENT
AND   ZCLA_FIX = :EFIX ;
/*
*/
#INCLUDE ZCLA_ELACT/ZCLA_BUF6
