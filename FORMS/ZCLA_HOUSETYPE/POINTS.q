/************************
Points calc by HouseType
************************/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HOUSETYPE/POINTS'
,      :HOUSETYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/************************
Reset Modifiers
************************/
UPDATE ZCLA_HOUSETYPEFIX
SET ZCLA_INITPOINTS = 0
,      ZCLA_TRAVEL = 0
,      ZCLA_MILEAGE = 0
,      ZCLA_PARTSUM = 0
,      ZCLA_SUNDRY = 0
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE ;
/************************
Get Constants
************************/
#INCLUDE ZCLA_HOUSETYPE/ZGEM_GETCONSTANTS
/********************************
Profit Margin
*********************************/
#INCLUDE ZCLA_HOUSETYPE/ZGEM_PROFITMARGIN
/**************************
Build BOM
**************************/
:ZGEM_IROOM = 'Y';
:ROOM = 0;
#INCLUDE PARTARC/ZCLA_HTREPLACE
/**************************
Link CALCTMP table
**************************/
SELECT SQL.TMPFILE INTO :TMP
FROM DUMMY ;
LINK ZCLA_CALCTMP TO :TMP ;
ERRMSG 1 WHERE :RETVAL = 0 ;
DELETE FROM ZCLA_CALCTMP ;
/**************************
Get Component & Part Points
**************************/
SELECT SQL.TMPFILE INTO :PNT
FROM DUMMY ;
LINK ZCLA_POINTTMP TO :PNT ;
ERRMSG 1 WHERE :RETVAL = 0 ;
DELETE FROM ZCLA_POINTTMP ;
/*--*/
#INCLUDE ZCLA_HOUSETYPE/ZCLA_PNTCALC
/**************************
Point Value & Uplift
**************************/
#INCLUDE ZCLA_HOUSETYPE/ZGEM_POINTVAL_UPLIFT
/**************************
Part Points
**************************/
DECLARE @INIT CURSOR FOR
SELECT FIXID
,      ROOM
,      PART
,      SUM( POINTS )
,      SUM( ABSR(PRICE) )
,      (TYPE = 'P' ? 'C' : TYPE)
FROM  ZCLA_POINTTMP
GROUP BY FIXID
,      ROOM
,      PART
,      6
;
OPEN @INIT ;
GOTO 2203239 WHERE :RETVAL = 0 ;
LABEL 2203235;
:PTYPE = '\0';
:ROOM = :PART = :FIXID =  0 ;
:SUNDRYSUM = :PARTSUM = :ZCLA_POINTVAL = :POINTS = :ZCLA_UPLIFT =
0.0 ;
:POINTMOD = 0.0;
FETCH @INIT INTO :FIXID , :ROOM , :PART , :POINTS,
:PARTSUM , :PTYPE;
GOTO 2203236 WHERE :RETVAL = 0;
/*
Point Value & Uplift */
SELECT ZCLA_POINTVAL, ZCLA_UPLIFT
INTO :ZCLA_POINTVAL , :ZCLA_UPLIFT
FROM ZCLA_CALCTMP
WHERE FIXID = :FIXID
AND ROOM = -59999
;
/*Point Modifiers*/
SELECT 1 + (
(MOD_HT = 0.0 ? 0.0 : MOD_HT - 1)
+
(MOD_ST = 0.0 ? 0.0 : MOD_ST - 1))
INTO :POINTMOD
FROM ZCLA_HOUSETYPEFIX
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID ;
/**************************
:PARTSUM & :SUNDRYSUM
**************************/
#INCLUDE ZCLA_HOUSETYPE/ZGEM_PARTSUM
/**************************
Round Part Quantities By Fix
**************************/
#INCLUDE ZCLA_HOUSETYPE/ZGEM_ROUNDQUANTS
/**************************
Calculate Costs
**************************/
/*
Labour Points*/
:ZCLA_LABOURPOINTS = :ZCLA_SUBCON = :DBMULT = :MONVAL = 0.0;
#INCLUDE ZCLA_ELACT/ZGEM_CALCVARIABLES
/**************************
Insert into ZCLA_CALCTMP
**************************/
INSERT INTO ZCLA_CALCTMP (FIXID , ROOM , PART)
SELECT :FIXID , :ROOM , :PART
FROM DUMMY
;
UPDATE ZCLA_CALCTMP
SET ZCLA_INITPOINTS = :POINTS
,      ZCLA_LABOURPOINTS = :POINTS * :CASHVALUE ;
,      ZCLA_POINTVAL = :ZCLA_POINTVAL
,      ZCLA_UPLIFT = :ZCLA_UPLIFT
,      ZCLA_TRAVEL = :TRAVEL
,      ZCLA_SUNDRY = :SUNDRYSUM
,      ZCLA_PARTSUM = :PARTSUM
,      ZCLA_LABTOTAL = :ZCLA_LABTOTAL
,      ZCLA_MILEAGE = :MILEAGECOST
,      ZCLA_TOTCOST = :ZCLA_TOTCOST
WHERE 0=0
AND   FIXID = :FIXID
AND   ROOM = :ROOM
AND   PART = :PART ;
/*--*/
LOOP 2203235 ;
LABEL 2203236 ;
/*--*/
CLOSE @INIT ;
LABEL 2203239
;
/**************************
Debug ZCLA_CALCTMP table
**************************/
SELECT (ROOM = -800000 ? 'B | PART' : 
(       ROOM = -900000 ? 'C | SUNDRY' :
(       ROOM < 0 ? 'Z | POINT VALUE & UPLIFT' : 'A | COMPONENT'
)))
, FIXID
, ROOM
, PART
, ZCLA_INITPOINTS
, ZCLA_LABOURPOINTS
, ZCLA_POINTVAL
, ZCLA_UPLIFT
, ZCLA_TRAVEL
, ZCLA_SUNDRY
, ZCLA_SUBCON
, ZCLA_PARTSUM
, ZCLA_LABTOTAL
, ZCLA_MILEAGE
, ZCLA_TOTCOST
, EXTRA
FROM ZCLA_CALCTMP
WHERE :DEBUG = 1
ORDER BY 1, 2, 4
FORMAT ADDTO :DEBUGFILE
;
/**************************
Update Components & Cunits
**************************/
DECLARE @INITCO CURSOR FOR
SELECT ROOM , PART
,      SUM( ZCLA_PARTSUM )
,      SUM( ZCLA_LABTOTAL )
,      SUM( ZCLA_SUNDRY )
,      SUM( ZCLA_TOTCOST )
FROM ZCLA_CALCTMP
WHERE ROOM > 0
GROUP BY ROOM , PART
;
OPEN @INITCO ;
GOTO 1011139 WHERE :RETVAL = 0 ;
LABEL 1011131 ;
:ROOM = :PART = 0 ;
:PCOST = :LCOST = :SCOST = :COST = 0.0 ;
FETCH @INITCO INTO :ROOM , :PART
,      :PCOST , :LCOST , :SCOST , :COST ;
GOTO 1011138 WHERE :RETVAL = 0 ;
/*
Update Component*/
UPDATE ZCLA_COMPONENT
SET    PRICE    = :COST * :ZGEM_FINALMARGIN
,      COST     = :COST
,      PARTSUM  = :PCOST
,      LABSUM   = :LCOST
,      SUNDRY   = :SCOST
WHERE COMPONENT IN (
SELECT COMPONENT
FROM ZCLA_COMPONENT , ZCLA_ROOMS
WHERE 0=0
AND   ZCLA_COMPONENT.ROOM = ZCLA_ROOMS.ROOM
AND   HOUSETYPEID = :HOUSETYPE
AND   ZCLA_ROOMS.ROOM = :ROOM
AND   ZCLA_COMPONENT.PART = :PART
);
/*
Update Cunit*/
UPDATE ZCLA_CONSUMERUNITS
SET PRICE       = :COST * :ZGEM_FINALMARGIN
,      COST     = :COST
,      PARTSUM  = :PCOST
,      LABSUM   = :LCOST
,      SUNDRY   = :SCOST
WHERE PART = :PART
AND ROOM = :ROOM
AND HOUSETYPEID = :HOUSETYPE
;
/*--*/
LOOP 1011131 ;
LABEL 1011138 ;
/*--*/
CLOSE @INITCO ;
LABEL 1011139 ;
/**************************
Update Rooms
**************************/
DECLARE @INITRO CURSOR FOR
SELECT ZCLA_CALCTMP.ROOM
,      SUM( ZCLA_CALCTMP.ZCLA_PARTSUM )
,      SUM( ZCLA_CALCTMP.ZCLA_LABTOTAL )
,      SUM( ZCLA_CALCTMP.ZCLA_SUNDRY )
,      SUM( ZCLA_CALCTMP.ZCLA_TOTCOST )
FROM ZCLA_CALCTMP
WHERE ZCLA_CALCTMP.PART NOT IN (
SELECT PART
FROM ZCLA_CONSUMERUNITS
WHERE HOUSETYPEID = :HOUSETYPE
)
AND ZCLA_CALCTMP.ROOM > 0
GROUP BY ZCLA_CALCTMP.ROOM
;
OPEN @INITRO ;
GOTO 1011039 WHERE :RETVAL = 0 ;
LABEL 1011031 ;
:ROOM = 0 ;
:PCOST = :LCOST = :SCOST = :COST = 0.0 ;
FETCH @INITRO INTO :ROOM
,      :PCOST , :LCOST , :SCOST , :COST
;
GOTO 1011038 WHERE :RETVAL = 0 ;
/*--*/
UPDATE ZCLA_ROOMS
SET    PRICE    = :COST * :ZGEM_FINALMARGIN
,      COST     = :COST
,      PARTSUM  = :PCOST
,      LABSUM   = :LCOST
,      SUNDRY   = :SCOST
WHERE  0=0
AND    ROOM = :ROOM
AND    HOUSETYPEID = :HOUSETYPE
;
/*--*/
LOOP 1011031 ;
LABEL 1011038 ;
/*--*/
CLOSE @INITRO ;
LABEL 1011039 ;
/**************************
Update House Type Fixes
**************************/
:DBMULTOTAL = 0.0;
:SUNDRYTOTAL = 0.0;
:ZCLA_PRICETOTAL = 0.0;
:ZCLA_TOTCOSTTOTAL = 0.0;
:LABOURTOTAL = 0.0;
:MILEAGETOTAL = 0.0;
:TRAVELTOTAL = 0.0;
DECLARE @INITFI CURSOR FOR
SELECT FIXID
,      SUM(ZCLA_INITPOINTS )
,      SUM(ZCLA_LABOURPOINTS )
,      MAX(ZCLA_POINTVAL )
,      MAX(ZCLA_UPLIFT )
,      SUM(ZCLA_SUBCON)
FROM ZCLA_CALCTMP
WHERE ROOM <> -900000
AND ROOM <> -800000
GROUP BY FIXID
;
OPEN @INITFI ;
GOTO 9910119 WHERE :RETVAL = 0 ;
LABEL 9910111 ;
:FIXID = 0 ;
:ZCLA_INITPOINTS = :ZCLA_LABOURPOINTS = :ZCLA_POINTVAL =
:ZCLA_UPLIFT = :ZCLA_TRAVEL = :ZCLA_SUBCON =
:ZCLA_LABTOTAL = :ZCLA_MILEAGE = :ZCLA_TOTCOST
= 0.0 ;
/*--*/
FETCH @INITFI INTO :FIXID
,      :ZCLA_INITPOINTS
,      :ZCLA_LABOURPOINTS
,      :ZCLA_POINTVAL
,      :ZCLA_UPLIFT
,      :ZCLA_SUBCON
;
GOTO 9910118 WHERE :RETVAL = 0 ;
/**************************
Get Drillbit & Monetary Val
**************************/
#INCLUDE ZCLA_HOUSETYPE/ZGEM_GETDRILLBIT
:DBMULTOTAL = :DBMULTOTAL + :DBMULT;
/**************************
Cost of Rounded Sundries & Parts
**************************/
:SUNDRYSUM = 0.0;
SELECT SUM(ZCLA_TOTCOST)
INTO :SUNDRYSUM
FROM ZCLA_CALCTMP
WHERE ROOM = -900000
AND FIXID = :FIXID
;
:PARTSUM = 0.0;
SELECT SUM(ZCLA_TOTCOST)
INTO :PARTSUM
FROM ZCLA_CALCTMP
WHERE ROOM = -800000
AND FIXID = :FIXID
;
/**************************
Calculate Costs
**************************/
#INCLUDE ZCLA_ELACT/ZGEM_CALCVARIABLES
/*TOTAL SUMS*/
:SUNDRYTOTAL = :SUNDRYTOTAL + :SUNDRYSUM;
:PARTSUMTOTAL = :PARTSUMTOTAL + :PARTSUM;
:MILEAGETOTAL = :MILEAGETOTAL + :MILEAGECOST;
:TRAVELTOTAL = :TRAVELTOTAL + :TRAVEL;
:LABOURTOTAL = :LABOURTOTAL + :ZCLA_LABTOTAL;
:ZCLA_TOTCOSTTOTAL = :ZCLA_TOTCOSTTOTAL + :ZCLA_TOTCOST;
:ZCLA_PRICETOTAL = :ZCLA_PRICETOTAL + :ZCLA_PRICE;
/*--*/
UPDATE ZCLA_HOUSETYPEFIX
SET ZCLA_INITPOINTS     = :ZCLA_INITPOINTS
,      ZCLA_LABOURPOINTS  = :ZCLA_LABOURPOINTS + :ZCLA_SUBCON
,      ZCLA_POINTVAL      = :ZCLA_POINTVAL
,      ZCLA_UPLIFT        = :ZCLA_UPLIFT
,      ZCLA_TRAVEL        = :TRAVEL
,      ZCLA_SUNDRY        = :SUNDRYSUM
,      ZGEM_DRILLBIT      = (:DBMULT * :MONVAL)
,      ZCLA_PARTSUM       = :PARTSUM
,      ZCLA_LABTOTAL      = :ZCLA_LABTOTAL
,      ZCLA_MILEAGE       = :MILEAGECOST
,      ZCLA_TOTCOST       = :ZCLA_TOTCOST
,      ZCLA_TOTPRICE      = :ZCLA_PRICE
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID ;
/*--*/
LOOP 9910111 ;
LABEL 9910118 ;
/*--*/
CLOSE @INITFI ;
LABEL 9910119 ;
/**************************
Update House Type
**************************/
:ZCLA_INITPOINTS = :ZCLA_POINTVAL = :ZCLA_UPLIFT = :ZCLA_SUBCON =
0.0;
SELECT SUM(ZCLA_INITPOINTS )
,      SUM(ZCLA_LABOURPOINTS )
,      MAX(ZCLA_POINTVAL )
,      MAX(ZCLA_UPLIFT )
,      SUM(ZCLA_SUBCON )
INTO  :ZCLA_INITPOINTS
,      :ZCLA_LABOURPOINTS
,      :ZCLA_POINTVAL
,      :ZCLA_UPLIFT
,      :ZCLA_SUBCON
FROM ZCLA_CALCTMP
WHERE ROOM <> -900000
AND ROOM <> -800000
;
UPDATE ZCLA_HOUSETYPE
SET    PARTCOST         = :ZCLA_PARTSUM + :SUNDRYTOTAL
+                         (:DBMULTOTAL * :MONVAL)
,      LABCOST          = :LABOURTOTAL
,      MILEAGECOST      = :MILEAGETOTAL
,      ZCLA_TOTCOST     = :ZCLA_TOTCOSTTOTAL
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
;
/**************************
Debug Total Cost & Price
**************************/
SELECT 'HT-TOTCOST', :ZCLA_TOTCOSTTOTAL, :ZCLA_PRICETOTAL,
:ZCLA_TOTCOSTTOTAL * :ZGEM_FINALMARGIN
FROM ZCLA_HOUSETYPE
WHERE HOUSETYPEID = :HOUSETYPE
AND :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
/**************************
Update NoPack IF not locked
**************************/
SELECT 'Update NOPACK: ' , :ZCLA_PRICETOTAL
FROM ZCLA_HOUSETYPE WHERE :DEBUG = 1
AND   (:UPDATENOPACK = 1 OR ZCLA_NOPACK = 0.0)
AND   HOUSETYPEID = :HOUSETYPE 
FORMAT ADDTO :DEBUGFILE 
;
UPDATE ZCLA_HOUSETYPE
SET ZCLA_NOPACK = :ZCLA_PRICETOTAL
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE 
AND   (:UPDATENOPACK = 1 OR ZCLA_NOPACK = 0.0)
;
UNLINK ZCLA_CALCTMP ;
/*
medatech.si. 7/3/2024 */
UPDATE ZCLA_HOUSETYPEFIX
SET PACKAGE = 0.0
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
;
DECLARE @PACKAGES CURSOR FOR
SELECT ZCLA_HOUSETYPE.HOUSETYPEID
,      ZCLA_HTEDITSPLIT.FIXID
,      SUM(ZCLA_HTEDIT.PACKAGEPRICE * (ZCLA_HTEDITSPLIT.SPLIT /
100)) AS PRICE
FROM   ZCLA_HTEDITSPLIT
,      ZCLA_HTEDIT
,      ZCLA_HOUSETYPE
WHERE  0=0
AND    ZCLA_HTEDIT.HOUSETYPEID    = ZCLA_HOUSETYPE.HOUSETYPEID
AND    ZCLA_HTEDITSPLIT.HOUSETYPE = ZCLA_HOUSETYPE.HOUSETYPEID
AND    ZCLA_HTEDIT.CLOSEFLAG      = 'Y'
AND    ZCLA_HTEDITSPLIT.SPLIT     > 0
GROUP  BY 1,2
HAVING ZCLA_HOUSETYPE.HOUSETYPEID = :HOUSETYPE
;
OPEN @PACKAGES ;
GOTO 1502249 WHERE :RETVAL = 0 ;
LABEL 1502241 ;
:HOUSETYPE = :FIXID = 0 ;
:PRICE = 0.0 ;
FETCH @PACKAGES INTO :HOUSETYPE  , :FIXID , :PRICE ;
GOTO 1502248 WHERE :RETVAL = 0 ;
SELECT :HOUSETYPE  , :FIXID , :PRICE
FROM DUMMY FORMAT ;
/**/
UPDATE ZCLA_HOUSETYPEFIX
SET PACKAGE = :PRICE
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   FIXID = :FIXID
;
/**/
LOOP 1502241 ;
LABEL 1502248 ;
CLOSE @PACKAGES ;
LABEL 1502249 ;
/*--*/
:ELTOT = 0.0 ;
SELECT SUM( PACKAGE ) INTO :ELTOT
FROM ZCLA_HOUSETYPEFIX
WHERE HOUSETYPEID = :HOUSETYPE
;
/**************************
Update House Type Price
**************************/
UPDATE ZCLA_HOUSETYPE
SET ZCLA_PACKAGEPRICE = :ELTOT
,   ZCLA_TOTPRICE = ZCLA_NOPACK + :ELTOT
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
;
