:ACTIVATE_POST_FORM = 'Y';
/* Create the edit split */
GOTO 210224 WHERE EXISTS (
SELECT 'x' FROM ZCLA_ELEDITSPLIT WHERE EDITID = :$$.EDITID
);
INSERT INTO ZCLA_ELEDITSPLIT (EDITID , PROJACT , FIXID , SPLIT)
SELECT :$$.EDITID
,      :$$.PROJACT
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
AND    ZCLA_FIXES.ISPAYMENT   = 'Y'
;
LABEL 210224 ;
