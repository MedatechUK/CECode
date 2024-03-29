/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'PARTARC/ZCLA_SHEATHING'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Select *CABLE PROTECTION room id */
:ROOM = 0;
SELECT ROOM INTO :ROOM FROM ZCLA_ROOMS
WHERE ROOMDES = '_SHEATHING' ;
/*
Select sheathing value from siteattribs */
:SHEATHINGTYPE = '';
SELECT VALUE
INTO :SHEATHINGTYPE
FROM ZCLA_SITECHARS , ZCLA_SITEATTRIB , ZCLA_SITEPERMITVALS
WHERE 0=0
AND   ZCLA_SITECHARS.CHARID = ZCLA_SITEATTRIB.CHARID
AND   ZCLA_SITEPERMITVALS.VALUEID = ZCLA_SITEATTRIB.VALUEID
AND   ZCLA_SITECHARS.INACTIVE <> 'Y'
AND   ZCLA_SITEATTRIB.DOC  = :DOC
AND   CHARNAME = 'Sheathing' ;
/*
Skip all code if sheathing is '' or none */
GOTO 9955 WHERE
:SHEATHINGTYPE = '' OR
:SHEATHINGTYPE = 'None';
/*
*/
:FIX = :PART = 0 ;
SELECT PA.PART , PA.ZCLA_FIXID
INTO :PART , :FIX
FROM ZCLA_PARTARC PA, PART PARENT, PART CHILD
WHERE 0=0
AND   PA.PART = PARENT.PART
AND   PA.SON = CHILD.PART
AND   CHILD.ZCLA_THICKNESS > 0
AND   PA.USER = SQL.USER ;
/*
*/
:MM25QUANT = :MM38QUANT = 0.0;
SELECT SUM(SONQUANT) * 0.05
INTO :MM25QUANT
FROM ZCLA_PARTARC , PART
WHERE 0=0
AND   ZCLA_PARTARC.SON = PART.PART
AND   PART.ZCLA_THICKNESS > 0
AND   ZCLA_PARTARC.USER = SQL.USER
;
SELECT 'ZCLA_THICKNESS > 0' , PART.PARTNAME , SONQUANT
FROM ZCLA_PARTARC , PART
WHERE 0=0
AND   ZCLA_PARTARC.SON = PART.PART
AND   PART.ZCLA_THICKNESS > 0
AND   ZCLA_PARTARC.USER = SQL.USER
AND   :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT SUM(SONQUANT) * 0.05 + 1
INTO :MM38QUANT
FROM ZCLA_PARTARC , PART
WHERE 0=0
AND   ZCLA_PARTARC.SON = PART.PART
AND   PART.ZCLA_THICKNESS = 2.5
AND   ZCLA_PARTARC.USER = SQL.USER
;
SELECT 'ZCLA_THICKNESS = 2.5' , PART.PARTNAME , SONQUANT
FROM ZCLA_PARTARC , PART
WHERE 0=0
AND   ZCLA_PARTARC.SON = PART.PART
AND   PART.ZCLA_THICKNESS = 2.5
AND   ZCLA_PARTARC.USER = SQL.USER
AND   :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
SELECT :MM25QUANT , :MM38QUANT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
#INCLUDE PART/ZCLA_BUF1
SELECT :MM25PART , :MM38PART
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Insert into ZCLA_PARTARC for 25mm sheathing*/
/*GergoM | 30/11/23 | Insert ROOM = 0*/
INSERT INTO ZCLA_PARTARC ( USER
,   ROOM
,   PART
,   SON
,   ACT
,   VAR
,   OP
,   COEF
,   SONACT
,   SCRAP
,   SONQUANT
,   ISSUEONLY
,   FROMDATE
,   TILLDATE
,   RVFROMDATE
,   RVTILLDATE
,   INFOONLY
,   SONPARTREV
,   SETEXPDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
,   EXTRA
)
SELECT SQL.USER
,   0
,   :PART
,   :MM25PART
,   ACT
,   VAR
,   OP
,   :MM25QUANT
,   SONACT
,   SCRAP
,   :MM25QUANT
,   ISSUEONLY
,   FROMDATE
,   TILLDATE
,   RVFROMDATE
,   RVTILLDATE
,   INFOONLY
,   SONPARTREV
,   SETEXPDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
,   'N'
FROM ZCLA_PARTARC
WHERE 0=0
AND   USER = SQL.USER
AND   PART = :PART
AND   ZCLA_FIXID = :FIX ;
/*
Insert into ZCLA_PARTARC for 38mm sheathing*/
INSERT INTO ZCLA_PARTARC ( USER
,   ROOM
,   PART
,   SON
,   ACT
,   VAR
,   OP
,   COEF
,   SONACT
,   SCRAP
,   SONQUANT
,   ISSUEONLY
,   FROMDATE
,   TILLDATE
,   RVFROMDATE
,   RVTILLDATE
,   INFOONLY
,   SONPARTREV
,   SETEXPDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
,   EXTRA
)
SELECT SQL.USER
,   0
,   PART
,   :MM38PART
,   ACT
,   VAR
,   OP
,   :MM38QUANT
,   SONACT
,   SCRAP
,   :MM38QUANT
,   ISSUEONLY
,   FROMDATE
,   TILLDATE
,   RVFROMDATE
,   RVTILLDATE
,   INFOONLY
,   SONPARTREV
,   SETEXPDATE
,   ZCLA_FIXID
,   ZCLA_WHITE
,   'N'
FROM ZCLA_PARTARC
WHERE 0=0
AND   USER = SQL.USER
AND   PART = :PART
AND   ZCLA_FIXID = :FIX ;
/*
*/
LABEL 9955;
