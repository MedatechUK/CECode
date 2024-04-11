/*
Calculate Uplifts by HOUSETYPE */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HOUSETYPE/RECALC' , :HOUSETYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
:DOC = :ZCLA_TIMETOSITE =  0 ;
:ZCLA_MILESTOSITE = 0.0 ;
:TEMPKIT = '\0';
/*
*/
SELECT DOC
INTO :DOC
FROM ZCLA_HOUSETYPE
WHERE  HOUSETYPEID = :HOUSETYPE
;
SELECT :DOC , :HOUSETYPE
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
/*
Update fix and house type modifiers */
#INCLUDE ZCLA_FIXES/ZCLA_HOUSETYPE
#INCLUDE ZCLA_CHARACTERISTIC/ZCLA_HOUSETYPE
/*
Is it a project ? */
GOTO 2550 WHERE EXISTS (
SELECT 'x' FROM ZCLA_HOUSETYPE
WHERE 0=0
AND   CORE = 'Y'
AND   HOUSETYPEID = :HOUSETYPE
);
/*
Get site modifiers */
#INCLUDE ZCLA_SITECHARS/ZCLA_HOUSETYPE
#INCLUDE DOCUMENTS_p/ZCLA_HOUSETYPE
/*
Select :TEMPKIT value from siteattribs */
SELECT 'Y'
INTO :TEMPKIT
FROM ZCLA_SITECHARS , ZCLA_SITEATTRIB , ZCLA_SITEPERMITVALS
WHERE 0=0
AND   ZCLA_SITECHARS.CHARID = ZCLA_SITEATTRIB.CHARID
AND   ZCLA_SITEPERMITVALS.VALUEID = ZCLA_SITEATTRIB.VALUEID
AND   ZCLA_SITECHARS.INACTIVE <> 'Y'
AND   ZCLA_SITEATTRIB.DOC  = :DOC
AND   CHARNAME = 'Temp Kit' 
AND   VALUE = 'Yes'
;
/*
Set Travel Values for site */
SELECT ZCLA_MILESTOSITE , ZCLA_TIMETOSITE
INTO :ZCLA_MILESTOSITE , :ZCLA_TIMETOSITE
FROM DOCUMENTS
WHERE 0=0
AND   DOCUMENTS.DOC = :DOC ;
SELECT 'ZCLA_HOUSETYPE/ZCLA_RECALC'
,      :ZCLA_MILESTOSITE
,      :ZCLA_TIMETOSITE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
GOTO 2590 ;
LABEL 2550 ;
/*
It's a core, so set site modifiers to 1 */
#INCLUDE DOCUMENTS_p/ZCLA_CORETYPE
UPDATE ZCLA_HOUSETYPEFIX
SET   ZCLA_NEGPOINT = 0
,     MOD_ST = 1
WHERE 0=0
AND   ZCLA_HOUSETYPEFIX.HOUSETYPEID = :HOUSETYPE ;
LABEL 2590 ;
/*
Calculate points */
#INCLUDE ZCLA_HOUSETYPE/POINTS
/*
Set Flags */
#INCLUDE ZCLA_HOUSETYPE/ZCLA_BUF9
#INCLUDE PARTARC/ZCLA_HOUSETYPE
/**/
#INCLUDE ZCLA_HOUSETYPE/ZGEM_BUF11
/*
Reset refresh flag */
UPDATE ZCLA_HOUSETYPE
SET   DOREFRESH = '\0'
,     WASRECALC  = 'Y'
WHERE   HOUSETYPEID = :HOUSETYPE
;
