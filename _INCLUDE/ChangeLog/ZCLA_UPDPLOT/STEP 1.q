/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_UPDPLOT-STEP1'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
LINK ZCLA_HOUSETYPE TO :$.PAR;
ERRMSG 1 WHERE :RETVAL = 0 ;
/*
*/
/*GergoM | 13.11.23 | ALT -> :ALT */
:DOC = :HOUSETYPE = :ALT = 0 ;
:MISSING = '\0' ;
SELECT HOUSETYPEID , DOC , ZCLA_MISSINGREPL, ALT
INTO :HOUSETYPE , :DOC , :MISSING, :ALT
FROM ZCLA_HOUSETYPE
WHERE HOUSETYPEID <> 0 ;
UNLINK ZCLA_HOUSETYPE
;
ERRMSG 801 WHERE :MISSING = 'Y' ;
/*
Quit if the contract is locked */
ERRMSG 897 WHERE EXISTS (
SELECT 'x'
FROM ZCLA_CONTRACTS
,    ZCLA_CONTRACTSTATUSE
,    ZCLA_CONTRACTEL
,    ZCLA_HOUSETYPE
WHERE 0=0
AND  ZCLA_CONTRACTS.STEPSTATUS  =  ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND  ZCLA_HOUSETYPE.EL = ZCLA_CONTRACTEL.EL
AND  ZCLA_CONTRACTEL.CONTRACT = ZCLA_CONTRACTS.CONTRACT
AND  ZCLA_CONTRACTS.DOC = :DOC
AND  ZCLA_HOUSETYPE.HOUSETYPEID = :HOUSETYPE
AND  ZCLA_CONTRACTSTATUSE.STATLOCK = 'Y'
);
/*
*/
DECLARE ELSEL CURSOR FOR
SELECT SITE.DOC AS SITE
,   PLOT.PROJACT AS PLOT
,   EL.PROJACT AS EL
FROM PROJACTS EL , PROJACTS PLOT , DOCUMENTS SITE , ZCLA_ELSTATUSES
WHERE 0 = 0
AND   SITE.DOC > 0
AND   EL.ZCLA_PLOT = PLOT.PROJACT
AND   PLOT.DOC = SITE.DOC
AND   EL.ZCLA_HOUSETYPEID = :HOUSETYPE
AND   EL.STEPSTATUS = ZCLA_ELSTATUSES.STEPSTATUS
;
OPEN ELSEL ;
:N = :RETVAL; :I = 0;
GOTO 1511239 WHERE :N <= 0;
LABEL 1511231;
:DOC = :PLOT = :ELEMENT = 0;
FETCH ELSEL INTO :DOC , :PLOT , :ELEMENT ;
GOTO 1511238 WHERE :RETVAL <= 0 ;
:I = :I + 1;
DISPLAY :I OF :N;
/*
Copy coponents */
SELECT 'Rebuilding >>' , :DOC , :PLOT , :ELEMENT , :ALT
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
#INCLUDE ZCLA_ELACT/ZCLA_BUF1
/*GergoM | 15.11.23 | Update Element*/
UPDATE PROJACTS
SET ZCLA_ALT = :ALT
WHERE PROJACT = :ELEMENT
;
/*--*/
/*GergoM | 15.11.23 | Attachments*/
/*-----------------------------------------------------*/
/* Find latest attachment for each category */
DECLARE ZGEM_CATCURSOR CURSOR FOR
SELECT DISTINCT ZCLA_FILECATEGORY
FROM EXTFILES, ZCLA_FILECATEGORIES Z
WHERE IV = :HOUSETYPE
AND EXTFILES.ZCLA_FILECATEGORY = Z.FILECATEGORY
AND   TYPE = '¬'
AND   Z.INTERNALCOPY = 'Y'
AND   ISDELETED <> 'Y'
;
OPEN ZGEM_CATCURSOR;
GOTO 1711239 WHERE :RETVAL = 0;
LABEL 1711231;
:CAT = 0;
FETCH ZGEM_CATCURSOR INTO :CAT;
GOTO 1711238 WHERE :RETVAL = 0;
/* Insert attachments */
SELECT  ZCLA_FILECATEGORY
,       EXTFILENUM
,       EXTFILENAME
,       EXTFILEDES
,       GUID
,       CURDATE
INTO :ZGEM_ZCLA_FILECATEGORY
, :ZGEM_EXTFILENUM
, :ZGEM_EXTFILENAME
, :ZGEM_EXTFILEDES
, :ZGEM_GUID
, :ZGEM_CURDATE
FROM EXTFILES
WHERE TYPE = '¬'
AND   IV = :HOUSETYPE
AND   EXTFILES.ZCLA_FILECATEGORY = :CAT
ORDER BY CURDATE DESC
OFFSET 0 FETCH NEXT 1 ROWS ONLY
;
INSERT INTO EXTFILES ( IV
,      TYPE
,      ZCLA_FILECATEGORY
,      EXTFILENUM
,      EXTFILENAME
,      EXTFILEDES
,      GUID
,      CURDATE )
VALUES (:ELEMENT
, 'T'
, :ZGEM_ZCLA_FILECATEGORY
, :ZGEM_EXTFILENUM
, :ZGEM_EXTFILENAME
, :ZGEM_EXTFILEDES
, :ZGEM_GUID
, :ZGEM_CURDATE );
LOOP 1711231;
LABEL 1711238;
CLOSE ZGEM_CATCURSOR;
LABEL 1711239;
/*-----------------------------------------------------*/	
/*
Run calculation */
SELECT 'Recalc >>' , :DOC , :PLOT , :ELEMENT
FROM DUMMY WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
#INCLUDE ZCLA_ELACT/RECALC
/*
*/
LOOP 1511231 ;
LABEL 1511238 ;
CLOSE ELSEL ;
LABEL 1511239 ;
/*GergoM | 11.13.23 | Close HT edit */
UPDATE ZCLA_HTEDIT
SET CLOSEFLAG = 'Y'
,   CLOSEDATE = SQL.DATE
WHERE 0=0
AND CLOSEFLAG <> 'Y'
;