/*--*/
/*Inserting all Child Parts into ZCLA_PROJACTTREE*/
/*
INPUT: :ELEMENT
, :FIX
, :DOC
, :IGNORE_ROOM (BOOL)(0/1)(0 = no / 1 = yes)
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZGEM_BOMROOM/BOMSUNPARTS'
, SQL.USER
, :ELEMENT
, :FIX
, :DOC
, :IGNORE_ROOM
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*Delete from ZCLA_PROJACTTREE*/
DELETE FROM ZCLA_PROJACTTREE
WHERE USER = SQL.USER
;
/*Fix ------------------------------------------*/
:FIXMIN = (:FIX = -99 ? -99 : :FIX);
:FIXMAX = (:FIX = -99 ? 99 : :FIX);
#INCLUDE ZGEM_BOMROOM/KLINE
/*Room Components | C |------------------------------------------*/
/*--*/
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   USER
,   UDATE
,   DUEDATE
,   KLINE
,   PROJACT
,   DOC
,   PART
,   SONPART
,   FREEREAL1
,   SONQUANT
,   WASTAGE
,   ZCLA_ROOM
,   WHITE
,   COL
,   STYLE
,   ISEXTRA
,   ORIGIN
,   FIXID
,   RATIO
,   PURCHASEPRICE
/*,   FREEREAL2*/
,   PARTNAME
)
SELECT
SQL.USER
, SQL.USER
, SQL.DATE
, SQL.DATE
, SQL.LINE + :KLINE
, :ELEMENT
, :DOC
, C.PART
, A.SON
, SUM(A.SONQUANT * C.TQUANT/1000)
, SUM(A.SONQUANT * C.TQUANT/1000)
* ( 1 + ( P.ZCLA_WASTAGE / 100 )) * 1000
, P.ZCLA_WASTAGE / 100
, (:IGNORE_ROOM = 1 ? 0 : C.ROOM)
, A.ZCLA_WHITE
, C.COL
, C.STYLE
, (C.EXTRA <> 'Y' ? 'N' : 'Y')
, 'C'
, A.ZCLA_FIXID
, CQUANT.TQUANT/1000
, ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
/*
, (SUM(A.SONQUANT * C.TQUANT/1000) = 0 ? 0 :
(:IGNORE_ROOM = 1 ? (
ROUND(SUM(A.SONQUANT * C.TQUANT/1000) * ( 1 + ( P.ZCLA_WASTAGE / 100
))) = 0 ?
1 : ROUND(SUM(A.SONQUANT * C.TQUANT/1000) * ( 1 + ( P.ZCLA_WASTAGE /
100 ))))
:
SUM(A.SONQUANT * C.TQUANT/1000) * ( 1 + ( P.ZCLA_WASTAGE / 100 ))))
* ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
*/
, P.PARTNAME
FROM ZCLA_PLOTCOMPONENT C
, ZCLA_PLOTCOMPONENT CQUANT
, PART P, PARTARC A
, ZCLA_ROOMS R
, PARTPRICE PRICE ?
WHERE CQUANT.PLOTCOMPONENT = C.PLOTCOMPONENT
AND C.PROJACT = :ELEMENT
AND C.PART = A.PART
AND A.SON = P.PART
AND P.PART = PRICE.PART
AND C.ROOM = R.ROOM
AND A.ZCLA_FIXID >= :FIXMIN
AND A.ZCLA_FIXID <= :FIXMAX
AND C.ISDELETED  <> 'Y'
GROUP BY 1,2,3,4,5,6,7,8,9,12,13,14,15,16,17,18,19,20,21,22
;
/*--*/
:WHITECOLID = 0;
SELECT COL INTO :WHITECOLID
FROM ZCLA_ACCYCOL
WHERE NAME = 'White'
;
#INCLUDE ZGEM_BOMROOM/KLINE
/*Consumer Unit Config | CU |---------------------------------*/
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   USER
,   UDATE
,   DUEDATE
,   KLINE
,   PROJACT
,   DOC
,   PART
,   SONPART
,   FREEREAL1
,   SONQUANT
,   WASTAGE
,   ZCLA_ROOM
,   WHITE
,   COL
,   STYLE
,   ORIGIN
,   FIXID
,   RATIO
,   PURCHASEPRICE
/*,   FREEREAL2*/
,   PARTNAME
,   ISEXTRA
)
SELECT
SQL.USER
, SQL.USER
, SQL.DATE
, SQL.DATE
, SQL.LINE + :KLINE
, :ELEMENT
, :DOC
, CC.PART
, A.SON
, SUM(A.SONQUANT * CU.ZGEM_TQUANT)
, SUM(A.SONQUANT * CU.ZGEM_TQUANT)
* ( 1 + ( P.ZCLA_WASTAGE / 100 ) ) * 1000
, P.ZCLA_WASTAGE / 100
, (:IGNORE_ROOM = 1 ? 0 : CU.ROOM)
, A.ZCLA_WHITE
, :WHITECOLID
, 'White'
, 'CU'
, A.ZCLA_FIXID
, CUQUANT.ZGEM_TQUANT
, ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
/*
, (SUM(A.SONQUANT * CU.ZGEM_TQUANT) = 0 ? 0 :
(:IGNORE_ROOM = 1 ? (
ROUND(SUM(A.SONQUANT * CU.ZGEM_TQUANT) * ( 1 + ( P.ZCLA_WASTAGE /
100 ))) = 0 ?
1 : ROUND(SUM(A.SONQUANT * CU.ZGEM_TQUANT) * ( 1 + ( P.ZCLA_WASTAGE
/ 100 ))))
: SUM(A.SONQUANT * CU.ZGEM_TQUANT) * ( 1 + ( P.ZCLA_WASTAGE / 100
))))
* ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
*/
, P.PARTNAME
, 'N' /*EXTRA FLAG*/
FROM ZCLA_PLOTCU CU
,ZCLA_PLOTCU CUQUANT
, ZCLA_PLOTCUCFG CC
, PARTARC A
, PART P
, ZCLA_ROOMS R
, PARTPRICE PRICE ?
WHERE CU.CONSUMERUNIT = CUQUANT.CONSUMERUNIT
AND CU.PROJACT = :ELEMENT
AND CU.CONSUMERUNIT = CC.CONSUMERUNIT
AND CC.PART = A.PART
AND A.SON = P.PART
AND P.PART = PRICE.PART
AND CU.ROOM = R.ROOM
AND A.ZCLA_FIXID >= :FIXMIN
AND A.ZCLA_FIXID <= :FIXMAX
AND CC.ISDELETED  <> 'Y'
GROUP BY 1,2,3,4,5,6,7,8,9,12,13,14,15,16,17,18,19,20,21,22
;
/*--*/
#INCLUDE ZGEM_BOMROOM/KLINE
/*Consumer Unit BOM | CU |---------------------------------*/
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   USER
,   UDATE
,   DUEDATE
,   KLINE
,   PROJACT
,   DOC
,   PART
,   SONPART
,   FREEREAL1
,   SONQUANT
,   WASTAGE
,   ZCLA_ROOM
,   WHITE
,   COL
,   STYLE
,   ORIGIN
,   FIXID
,   RATIO
,   PURCHASEPRICE
/*,   FREEREAL2*/
,   PARTNAME
,   ISEXTRA
)
SELECT
SQL.USER
, SQL.USER
, SQL.DATE
, SQL.DATE
, SQL.LINE + :KLINE
, :ELEMENT
, :DOC
, CU.PART
, A.SON
, SUM(A.SONQUANT * CU.ZGEM_TQUANT)
, SUM(A.SONQUANT * CU.ZGEM_TQUANT)
* ( 1 + ( P.ZCLA_WASTAGE / 100 ) ) * 1000
, P.ZCLA_WASTAGE / 100
, (:IGNORE_ROOM = 1 ? 0 : CU.ROOM)
, A.ZCLA_WHITE
, :WHITECOLID
,'White'
, 'CU'
, A.ZCLA_FIXID
, CUQUANT.ZGEM_TQUANT
, ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
/*
, (SUM(A.SONQUANT * CU.ZGEM_TQUANT) = 0 ? 0 :
(:IGNORE_ROOM = 1 ? (
ROUND(SUM(A.SONQUANT * CU.ZGEM_TQUANT) * ( 1 + ( P.ZCLA_WASTAGE /
100 ))) = 0 ?
1 : ROUND(SUM(A.SONQUANT * CU.ZGEM_TQUANT) * ( 1 + ( P.ZCLA_WASTAGE
/ 100 ))))
: SUM(A.SONQUANT * CU.ZGEM_TQUANT) * ( 1 + ( P.ZCLA_WASTAGE / 100
))))
* ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
*/
, P.PARTNAME
, 'N' /*EXTRA FLAG*/
FROM ZCLA_PLOTCU CU
, ZCLA_PLOTCU CUQUANT
, PARTARC A
, PART P
, ZCLA_ROOMS R
, PARTPRICE PRICE ?
WHERE CU.CONSUMERUNIT = CUQUANT.CONSUMERUNIT
AND CU.PROJACT = :ELEMENT
AND CU.PART = A.PART
AND A.SON = P.PART
AND P.PART = PRICE.PART
AND CU.ROOM = R.ROOM
AND A.ZCLA_FIXID >= :FIXMIN
AND A.ZCLA_FIXID <= :FIXMAX
AND CU.ISDELETED  <> 'Y'
GROUP BY 1,2,3,4,5,6,7,8,9,12,13,14,15,16,17,18,19,20,21,22
;
/*Consumer Unit Blanks | CU
|------------------------------------------*/
GOTO 88801 WHERE :FIX <> 2;
#INCLUDE ZGEM_BOMROOM/BLANKS
LABEL 88801;
/*Small Work Parts | SWP
|------------------------------------------*/
#INCLUDE ZGEM_BOMROOM/KLINE
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   USER
,   UDATE
,   DUEDATE
,   KLINE
,   PROJACT
,   DOC
,   PART
,   RATIO
,   SONPART
,   FREEREAL1
,   SONQUANT
,   WASTAGE
,   ZCLA_ROOM
,   WHITE
,   COL
,   STYLE
,   ORIGIN
,   FIXID
,   PURCHASEPRICE
/*,   FREEREAL2*/
,   PARTNAME
,   ISEXTRA
)
SELECT DISTINCT
SQL.USER
, SQL.USER
, SQL.DATE
, SQL.DATE
, SQL.LINE + :KLINE
, :ELEMENT
, :DOC
, PP.PART /*Copmonent*/
, PP.TQUANT
, PP.PART /*P2/P9 part*/
, PP.TQUANT
, PP.TQUANT
* ( 1 + ( P.ZCLA_WASTAGE / 100 ) ) * 1000
, P.ZCLA_WASTAGE / 100
, (:IGNORE_ROOM = 1 ? 0 : PR.ROOM)
, ''
, :WHITECOLID
, ''
, 'SWP'
, PP.FIXID
, ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
/*
, (PP.TQUANT = 0 ? 0 :
(:IGNORE_ROOM = 1 ? (
ROUND(PP.TQUANT * ( 1 + ( P.ZCLA_WASTAGE / 100 ))) = 0 ?
1 : ROUND(PP.TQUANT * ( 1 + ( P.ZCLA_WASTAGE / 100 ))))
: PP.TQUANT * ( 1 + ( P.ZCLA_WASTAGE / 100 ))))
* ROUND(((ABSR(PRICE.PRICE) / P.CONV)) * 100000) / 100000.0
*/
, P.PARTNAME
, 'N' /*EXTRA FLAG*/
FROM  ZCLA_PROJACTPARTS PP
, PART P
, ZCLA_PLOTROOMS PR
, PARTPRICE PRICE ?
WHERE 0 = 0
AND  PP.PART = P.PART
AND P.PART = PRICE.PART
AND  PP.ROOM = PR.ROOM
AND  PR.PROJACT = :ELEMENT
AND    PP.FIXID >= :FIXMIN
AND    PP.FIXID <= :FIXMAX
;
/*Sub-Contract Parts | SCP
|------------------------------------------*/
#INCLUDE ZGEM_BOMROOM/KLINE
INSERT INTO ZCLA_PROJACTTREE ( COPYUSER
,   USER
,   UDATE
,   DUEDATE
,   KLINE
,   PROJACT
,   DOC
,   PART
,   RATIO
,   SONPART
,   FREEREAL1
,   SONQUANT
,   WASTAGE
,   ZCLA_ROOM
,   WHITE
,   COL
,   STYLE
,   ORIGIN
,   FIXID
,   PURCHASEPRICE
,   FREEREAL2
,   PARTNAME
,   ISEXTRA
)
SELECT
SQL.USER
, SQL.USER
, SQL.DATE
, SQL.DATE
, SQL.LINE + :KLINE
, :ELEMENT
, :DOC
, PPR.PART /*Component*/
, ROUND(REALQUANT(PPR.QUANT) * PQ.QUANTITY)
, PPR.PART /*P2/P9 Parts*/
, REALQUANT(PPR.QUANT) * PQ.QUANTITY
, REALQUANT(PPR.QUANT) * PQ.QUANTITY * 1000
, 0
, (:IGNORE_ROOM = 1 ? 0 : PR.ROOM)
, ''
, 0
, ''
, 'SCP'
, PQ.FIXID
, PQ.ZCLA_COST
, PQ.TOTPRICE
, PQ.PDES
, 'N' /*EXTRA FLAG*/
FROM PPROFITEMS PPR
,    ZCLA_PROJACTQUOTE PQ
,    ZCLA_PLOTROOMS PR
,    PART P
, PARTPRICE PRICE ?
WHERE  0 = 0
AND    PPR.KLINE = PQ.KLINE
AND    PPR.PROF = PQ.PROF
AND    PR.PROJACT = :ELEMENT
AND    PQ.ROOM  = PR.ROOM
AND    PPR.PART = P.PART
AND    P.PART = PRICE.PART
AND    PQ.ISDELETED <> 'Y'
AND    PQ.FIXID >= :FIXMIN
AND    PQ.FIXID <= :FIXMAX
;
/*Sheathing*/
:IGNOREROOM = :IGNORE_ROOM;
#INCLUDE PARTARC/ZCLA_TSHEATHING
/*--*/
UPDATE ZCLA_PROJACTTREE
SET FREEREAL1 = SONQUANT
WHERE USER = SQL.USER
AND FREEREAL1 = 0.0
;
/*--*/
SELECT 'BEFORE_REPLACE-BOM'
,   KLINE
,   PROJACT
,   DOC
,   PART
,   RATIO
,   SONPART
,   PARTNAME
,   FREEREAL1
,   SONQUANT
,   WASTAGE
,   ZCLA_ROOM
,   WHITE
,   COL
,   STYLE
, FREECHAR1
, FREECHAR2
, ISEXTRA
, ORIGIN
, FIXID
,   PURCHASEPRICE
,   FREEREAL2
FROM ZCLA_PROJACTTREE
WHERE USER = SQL.USER
FORMAT ADDTO :DEBUGFILE;
