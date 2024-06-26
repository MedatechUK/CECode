/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_OPENEDIT/10'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
LINK ZCLA_HOUSETYPE TO :$.PAR;
ERRMSG 1 WHERE :RETVAL = 0 ;
:HOUSETYPE = 0 ;
SELECT HOUSETYPEID INTO :HOUSETYPE
FROM ZCLA_HOUSETYPE
WHERE HOUSETYPEID > 0
;
UNLINK ZCLA_HOUSETYPE ;
SELECT :HOUSETYPE FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
/*
Skip if there's a open edit */
ERRMSG 801 WHERE EXISTS (
SELECT 'x'
FROM ZCLA_HTEDIT
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   CLOSEFLAG <> 'Y'
);
/* Skip if: "The contract is not locked."
*/
ERRMSG 802 WHERE EXISTS (
SELECT 'x'
FROM   ZCLA_CONTRACTSTATUSE
,      ZCLA_CONTRACTEL
,      ZCLA_HOUSETYPE
,      ZCLA_CONTRACTS
WHERE  0=0
AND    ZCLA_HOUSETYPE.DOC              = ZCLA_CONTRACTS.DOC
AND    ZCLA_CONTRACTEL.CONTRACT        = ZCLA_CONTRACTS.CONTRACT
AND    ZCLA_CONTRACTEL.EL              = ZCLA_HOUSETYPE.EL
AND    ZCLA_CONTRACTSTATUSE.STEPSTATUS = ZCLA_CONTRACTS.STEPSTATUS
AND    ZCLA_HOUSETYPE.HOUSETYPEID      = :HOUSETYPE
AND    ZCLA_CONTRACTSTATUSE.STATLOCK   <> 'Y'
);
SELECT '>> New edit' , :HOUSETYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
INSERT INTO ZCLA_HTEDIT
( HOUSETYPEID , OPENEDBY , OPENDATE , PACKAGEFLAG
, OPEN_TOTPRICE , OPEN_TOTCOST  )
SELECT :HOUSETYPE
,      SQL.USER
,      SQL.DATE
,      'Y'
,      ZCLA_TOTPRICE
,      ZCLA_TOTCOST
FROM ZCLA_HOUSETYPE
WHERE HOUSETYPEID = :HOUSETYPE
;
:OPENEDIT = 0 ;
SELECT HTEDIT INTO :OPENEDIT
FROM ZCLA_HTEDIT
WHERE 0=0
AND   HOUSETYPEID = :HOUSETYPE
AND   CLOSEFLAG <> 'Y'
;
/* Create the edit split */
INSERT INTO ZCLA_HTEDITSPLIT (EDITID , HOUSETYPE , FIXID , SPLIT)
SELECT :OPENEDIT
,      :HOUSETYPE
,      ZCLA_FIXES.FIXID
,     (ZCLA_SITEELFIX.SPLIT > 0
?      ZCLA_SITEELFIX.SPLIT : ZCLA_ELEMENTFIX.SPLIT )
FROM  ZCLA_HOUSETYPE
,     ZCLA_SITEELFIX ?
,     ZCLA_ELEMENTFIX
,     ZCLA_FIXES
WHERE  0=0
AND    ZCLA_SITEELFIX.DOC     = ZCLA_HOUSETYPE.DOC
AND    ZCLA_ELEMENTFIX.EL     = ZCLA_HOUSETYPE.EL
AND    ZCLA_HOUSETYPE.EL      = ZCLA_SITEELFIX.EL
AND    ZCLA_ELEMENTFIX.FIXID  = ZCLA_SITEELFIX.FIXID
AND    ZCLA_ELEMENTFIX.FIXID  = ZCLA_FIXES.FIXID
AND    ZCLA_HOUSETYPE.HOUSETYPEID   = :HOUSETYPE
AND    ZCLA_FIXES.ISPAYMENT   = 'Y'
;
WRNMSG 800 ;
