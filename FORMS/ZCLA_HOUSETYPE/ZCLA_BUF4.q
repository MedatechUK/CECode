/* ***********************
Points calc by HouseType
*********************** */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HOUSETYPE/ZCLA_BUF4'
,      :HOUSETYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Reset Modifiers */
UPDATE ZCLA_HOUSETYPEFIX
SET ZCLA_INITPOINTS = 0
,   ZCLA_TRAVEL = 0
,   ZCLA_MILEAGE = 0
,   ZCLA_PARTSUM = 0
,   ZCLA_SUNDRY = 0
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE ;
/*
Get Travel Constants */
:SAFETYMARGIN = :FULLPOINTS = :TRAVELCOST = 0.0 ;
#INCLUDE ZCLA_TRAVELCONST/ZCLA_BUF1
SELECT :SAFETYMARGIN , :ZCLA_MILESTOSITE , :ZCLA_TIMETOSITE
, :MILEAGE , :TRAVELCOST , :FULLPOINTS
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Build the BoM */
#INCLUDE PARTARC/ZCLA_HTREPLACE
/*
*/
DECLARE @INIT CURSOR FOR
SELECT ZCLA_PARTPOINTSPF.FIXID
,   SUM ( 
( ZCLA_PARTPOINTSPF.VALUE * (ZCLA_COMPONENT.TQUANT / 1000) 
) + (ZCLA_FIXES.FIX = '3' ?
/* !!TODO!!
a - WHITE STD - 0
b - PUSH ON - 3
c - coloured screw 6 >> d 9 (where site property "temp-fit")
a/b/c against the P2
*/
ZCLA_ACCYCOL.POINTS * (ZCLA_COMPONENT.TQUANT / 1000) : 0) ) AS POINTS 
,   MAX(ZCLA_FIXES.CASHVALUE / 100)
FROM  ZCLA_ACCYCOL , ZCLA_PARTPOINTSPF , ZCLA_ROOMS , ZCLA_COMPONENT
, ZCLA_HOUSETYPE , ZCLA_FIXES
WHERE 0=0
AND   ZCLA_FIXES.FIXID = ZCLA_PARTPOINTSPF.FIXID
AND   ZCLA_ROOMS.ROOM = ZCLA_COMPONENT.ROOM
AND   ZCLA_ROOMS.HOUSETYPEID = ZCLA_HOUSETYPE.HOUSETYPEID
AND   ZCLA_PARTPOINTSPF.PART = ZCLA_COMPONENT.PART
AND   ZCLA_ACCYCOL.COL = ZCLA_COMPONENT.COL
AND   ZCLA_HOUSETYPE.HOUSETYPEID = :HOUSETYPE
GROUP BY ZCLA_PARTPOINTSPF.FIXID
;
OPEN @INIT ;
GOTO 2203239 WHERE :RETVAL = 0 ;
LABEL 2203235;
:FIXID =  0 ;
:SUNDRYSUM = :PARTSUM = :CASHVALUE = :POINTS = 0.0 ;
FETCH @INIT INTO :FIXID , :POINTS , :CASHVALUE ;
GOTO 2203236 WHERE :RETVAL = 0;
/*
*/
SELECT :POINTS + SUM(POINT) INTO :POINTS
FROM  ZCLA_ROOMQUOTE , ZCLA_ROOMS , ZCLA_ROOMFIXES
WHERE 0=0
AND   ZCLA_ROOMQUOTE.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_ROOMFIXES.ROOM = ZCLA_ROOMS.ROOM
AND   ZCLA_ROOMS.HOUSETYPEID = :HOUSETYPE
AND   FIX = :FIXID ;
/*
*/
:SUNDRYSUM = :PARTSUM = 0.0 ;
SELECT SUM(SONQUANT * PRICE) INTO :PARTSUM
FROM ZCLA_PARTARC , PRICELIST , PARTPRICE
WHERE 0=0
AND   ZCLA_PARTARC.USER = SQL.USER
AND   ZCLA_PARTARC.SON = PARTPRICE.PART
AND   PRICELIST.PLIST = PARTPRICE.PLIST
AND   PRICELIST.CURRENCY  = PARTPRICE.CURRENCY
AND   PRICELIST.PLIST = -1
AND   PARTPRICE.CURRENCY = -1
AND   QUANT = 1000
AND   ZCLA_PARTARC.ZCLA_FIXID = :FIXID ;
/*
Get Sundries */
:SUNDRYCREDIT = 0.0 ;
SELECT 1 + VALUE 
INTO :SUNDRYCREDIT
FROM ZCLA_CONST
WHERE NAME = 'SUNDRYCREDIT'
;
SELECT SUM(ZCLA_PARTARC.SONQUANT * PARTARC.SONQUANT *
PARTPRICE.PRICE) * (:SUNDRYCREDIT) INTO :SUNDRYSUM
FROM  ZCLA_PARTARC ,  PARTARC ,  PARTPRICE ,  PRICELIST
WHERE 0=0
AND   ZCLA_PARTARC.SON = PARTARC.PART
AND   PARTARC.SON = PARTPRICE.PART
AND   PARTPRICE.PLIST = PRICELIST.PLIST
AND   ZCLA_PARTARC.USER = SQL.USER
AND   PRICELIST.CURRENCY  = PARTPRICE.CURRENCY
AND   PRICELIST.PLIST = -1
AND   PARTPRICE.CURRENCY = -1
AND   QUANT = 1000
AND   ZCLA_PARTARC.ZCLA_FIXID = :FIXID
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
,   :POINTS * (1 + ((MOD_HT + MOD_ST) / 100 ))
INTO :UPLIFT , :ZCLA_LABOURPOINTS 
FROM ZCLA_HOUSETYPEFIX
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID ;
/*
*/
SELECT ( ( (:ZCLA_TIMETOSITE * 2) * :TRAVELCOST) * (:ZCLA_LABOURPOINTS
/ :FULLPOINTS ) )
,   ( ( (:ZCLA_MILESTOSITE * 2) * :MILEAGE ) * ( :ZCLA_LABOURPOINTS
/ :FULLPOINTS ) )
INTO :TRAVEL , :MILEAGECOST
FROM ZCLA_HOUSETYPEFIX
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID ;
/* 
Retrieve drill bit multiplier and
monetary value */
:DBMULT = :MONVAL = 0.00;
SELECT DRILLMULTIPLIER
INTO :DBMULT
FROM ZCLA_HTCHARS HT, ZCLA_CHARPERMITVALS CP, ZCLA_UPLIFTSPERFIX UP
WHERE HOUSETYPEID = :HOUSETYPE
AND HT.VALUEID = CP.VALUEID
AND HT.CHARID = 1
AND UP.VALUEID = CP.VALUEID
AND FIXID = :FIXID
;
SELECT MONETARYVALUE
INTO :MONVAL
FROM ZCLA_PLOTELEMENT PE, ZCLA_HOUSETYPE HT
WHERE PE.EL = HT.EL
AND HT.HOUSETYPEID = :HOUSETYPE
;
/*
*/
SELECT :CASHVALUE * (1 + ((ZCLA_FIXUPLIFT + ZCLA_BRUPLIFT) / 100))
,      :TRAVEL * (1 + ((ZCLA_FIXUPLIFT + ZCLA_BRUPLIFT) / 100))
INTO :CASHVALUE , :TRAVEL
FROM ZCLA_HOUSETYPEFIX
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID 
;
/*
*/
SELECT :DBMULT , :MONVAL
FROM DUMMY
FORMAT ADDTO :DEBUGFILE
;
UPDATE ZCLA_HOUSETYPEFIX
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
+                   :MILEAGECOST
+                   ZCLA_SUBCON
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID ;
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
FROM ZCLA_HOUSETYPEFIX
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID 
AND   :DEBUG  = 1
FORMAT ADDTO :DEBUGFILE;
/*
*/
LOOP 2203235 ;
LABEL 2203236 ;
CLOSE @INIT ;
LABEL 2203239 ;
/*
*/
SELECT '>>> BEGIN SPLIT'
FROM DUMMY FORMAT ADDTO :DEBUGFILE 
;
/*
Update Housetype PRICE Totals */
SELECT SUM(ZCLA_TOTCOST) INTO :ZCLA_TOTCOST
FROM ZCLA_HOUSETYPEFIX
WHERE   HOUSETYPEID = :HOUSETYPE
;
/*
Get Split and Markup */
SELECT SQL.TMPFILE INTO :SPLIT FROM DUMMY ;
LINK ZCLA_SPLIT TO :SPLIT;
ERRMSG 1 WHERE :RETVAL = 0 ;
#INCLUDE ZCLA_HOUSETYPE/ZCLA_BUF10
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
, :HOUSETYPE , :FIXACT , :ZCLA_TOTPRICE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE 
;
UPDATE ZCLA_HOUSETYPEFIX 
SET ZCLA_TOTPRICE = :ZCLA_TOTPRICE
WHERE 0=0
AND   FIXID = :FIXACT 
AND   HOUSETYPEID = :HOUSETYPE ;
/*
*/
LOOP 25231;
LABEL 25238 ;
CLOSE @PRICE ;
LABEL 25239 ;
/*
*/
UNLINK ZCLA_SPLIT ;
/*
*/
#INCLUDE ZCLA_HOUSETYPE/ZCLA_BUF5