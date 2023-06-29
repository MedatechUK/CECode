/*
Get extras Split by order of precedence */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_ELACT/ZCLA_BUF10' , :ELEMENT
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
*/
:SKIP = 0 ;
SELECT (SUM ( ZCLA_PLOTELFIX.EXTRA ) = 100 ? 0 : 1) INTO :SKIP
FROM ZCLA_FIXES 
,    ZCLA_PLOTELFIX 
,    PROJACTS 
WHERE  0 = 0 
AND    ZCLA_PLOTELFIX.PROJACT = PROJACTS.PROJACT
AND    ZCLA_FIXES.FIXID = ZCLA_PLOTELFIX.FIXID 
AND    ZCLA_FIXES.ISPAYMENT = 'Y'
AND    ZCLA_PLOTELFIX.PROJACT = :ELEMENT ;
GOTO 260601 WHERE :SKIP = 1 ;
/*
Insert Plot EXTRA split */
INSERT INTO ZCLA_SPLIT (FIXID , SPLIT)
SELECT ZCLA_PLOTELFIX.FIXID
,      (ZCLA_PLOTELFIX.EXTRA > 0 ? ( ZCLA_PLOTELFIX.EXTRA / 100 ) : 0 )
FROM ZCLA_FIXES 
,    ZCLA_PLOTELFIX 
,    PROJACTS 
WHERE  0 = 0 
AND    ZCLA_PLOTELFIX.PROJACT = PROJACTS.PROJACT
AND    ZCLA_FIXES.FIXID = ZCLA_PLOTELFIX.FIXID 
AND    ZCLA_FIXES.ISPAYMENT = 'Y'
AND    ZCLA_PLOTELFIX.PROJACT = :ELEMENT ;
GOTO 260609 ;
/*
*/
LABEL 260601 ;
SELECT (SUM ( ZCLA_SITEELFIX.EXTRA ) = 100 ? 0 : 1) INTO :SKIP
FROM  PROJACTS 
,     ZCLA_FIXES 
,     ZCLA_SITEELFIX 
,     ZCLA_HOUSETYPE 
WHERE 0 = 0
AND   ZCLA_FIXES.FIXID = ZCLA_SITEELFIX.FIXID 
AND   ZCLA_SITEELFIX.EL = ZCLA_HOUSETYPE.EL 
AND   PROJACTS.ZCLA_HOUSETYPEID = ZCLA_HOUSETYPE.HOUSETYPEID 
AND   PROJACTS.DOC = ZCLA_SITEELFIX.DOC
AND   ZCLA_FIXES.ISPAYMENT = 'Y'
AND   ZCLA_FIXES.FIXID > 0
AND   PROJACTS.PROJACT = :ELEMENT ;
GOTO 260602 WHERE :SKIP = 1 ;
/*
Insert Site EXTRA split */
INSERT INTO ZCLA_SPLIT (FIXID , SPLIT)
SELECT ZCLA_SITEELFIX.FIXID
,      (ZCLA_SITEELFIX.EXTRA > 0 ? ( ZCLA_SITEELFIX.EXTRA / 100 ) : 0 )
FROM  PROJACTS 
,     ZCLA_FIXES 
,     ZCLA_SITEELFIX 
,     ZCLA_HOUSETYPE 
WHERE 0 = 0
AND   ZCLA_FIXES.FIXID = ZCLA_SITEELFIX.FIXID 
AND   ZCLA_SITEELFIX.EL = ZCLA_HOUSETYPE.EL 
AND   PROJACTS.ZCLA_HOUSETYPEID = ZCLA_HOUSETYPE.HOUSETYPEID 
AND   PROJACTS.DOC = ZCLA_SITEELFIX.DOC
AND   ZCLA_FIXES.ISPAYMENT = 'Y'
AND   ZCLA_FIXES.FIXID > 0
AND   PROJACTS.PROJACT = :ELEMENT ;
GOTO 260609 ;
/*
*/
/*
Insert Default EXTRA split */
LABEL 260602 ;
INSERT INTO ZCLA_SPLIT (FIXID , SPLIT)
SELECT ZCLA_ELEMENTFIX.FIXID
,      (ZCLA_ELEMENTFIX.EXTRA > 0 ? ( ZCLA_ELEMENTFIX.EXTRA / 100 ) : 0 )
FROM   ZCLA_HOUSETYPE 
,      ZCLA_ELEMENTFIX
,      PROJACTS 
,      ZCLA_FIXES
WHERE  0=0
AND    ZCLA_FIXES.FIXID = ZCLA_ELEMENTFIX.FIXID
AND    ZCLA_HOUSETYPE.HOUSETYPEID = PROJACTS.ZCLA_HOUSETYPEID 
AND    ZCLA_HOUSETYPE.EL = ZCLA_ELEMENTFIX.EL
AND    ISPAYMENT = 'Y'
AND    ZCLA_FIXES.FIXID > 0
AND    PROJACTS.PROJACT = :ELEMENT
;
/*
*/
LABEL 260609 ;