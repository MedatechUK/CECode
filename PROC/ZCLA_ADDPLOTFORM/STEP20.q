/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_ADDPLOTFORM/STEP20' FROM DUMMY
FORMAT ADDTO :DEBUGFILE ;
/* vars
*/
:P = :LN = 0 ;
:HOUSETYPEID = :DOC = :EL = 0 ;
:ISHOUSE = :CORE = '' ;
/*
*/
LINK DOCUMENTS TO :$.PAR;
ERRMSG 1 WHERE :RETVAL <= 0;
SELECT DOC INTO :DOC
FROM DOCUMENTS
WHERE 0=0
AND   DOC > 0 ;
UNLINK DOCUMENTS ;
/*
*/
SELECT 'Adding plots', PLOT , HOUSETYPEID
FROM ZCLA_USERADDPLOT
WHERE 0=0
AND   :DEBUG = 1
AND   USER = SQL.USER
FORMAT ADDTO :DEBUGFILE ;
/* Link General load table
*/
:LN = 0 ;
SELECT SQL.TMPFILE
INTO :GEN FROM DUMMY;
LINK GENERALLOAD TO :GEN;
ERRMSG 1 WHERE :RETVAL = 0 ;
SELECT MAX(PROJACTUID) INTO :P FROM PROJACTS ;
/*
*/
/* Start Cursor
*/
/*GergoM | 28/11/23 | APF_ Cursor pre fix*/
DECLARE APF_E97 CURSOR FOR
SELECT PLOT , HOUSETYPEID FROM ZCLA_USERADDPLOT
WHERE 0=0
AND   PLOT > 0
AND   USER = SQL.USER
;
OPEN APF_E97 ;
GOTO 403239 WHERE :RETVAL = 0 ;
LABEL 403231 ;
:PLOT = :HOUSETYPE = 0 ;
FETCH APF_E97 INTO :PLOT , :HOUSETYPE ;
GOTO 403238 WHERE :RETVAL = 0 ;
/*
*/
SELECT ISHOUSE , ZCLA_PLOTELEMENT.EL
INTO :ISHOUSE , :EL
FROM ZCLA_HOUSETYPE
,    ZCLA_PLOTELEMENT
WHERE 0=0
AND   ZCLA_HOUSETYPE.EL = ZCLA_PLOTELEMENT.EL
AND   ZCLA_HOUSETYPE.HOUSETYPEID = :HOUSETYPE
;
/* insert Proj line
*/
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, KEY1)
SELECT :LN , '1' , ITOA(:DOC)
FROM DUMMY ;
/* insert Projact line
*/
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD ;
GOTO 50 WHERE EXISTS (
SELECT 'x'
FROM PROJACTS
WHERE 0=0
AND   DOC = :DOC
AND   LEVEL = 1
AND   WBS = ITOA(:PLOT)
);
/* Create New plot
*/
SELECT :P + 1 INTO :P FROM DUMMY ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, TEXT1, TEXT2 , INT1 ,
INT2, INT3)
SELECT :LN
,    '2'
,    STRCAT('Plot ' , ITOA(:PLOT))
,    ITOA(:PLOT)
,    :P
,    -1
,    (:ISHOUSE = 'Y' ? :HOUSETYPE : 0)
FROM DUMMY
;
GOTO 99 ;
LABEL 50 ;
/* Use existing plot
*/
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD ;
GOTO 80 WHERE :ISHOUSE = 'Y' ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, KEY1 )
SELECT :LN
,    '2'
,    ITOA( PROJACT )
FROM PROJACTS
WHERE 0=0
AND   DOC = :DOC
AND   WBS = ITOA(:PLOT)
;
GOTO 90 ;
LABEL 80 ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, KEY1 , INT3)
SELECT :LN
,    '2'
,    ITOA( PROJACT )
,    :HOUSETYPE
FROM PROJACTS
WHERE 0=0
AND   DOC = :DOC
AND   WBS = ITOA(:PLOT)
;
LABEL 90;
LABEL 99 ;
/*GergoM | 16/11/23 |
The insert element line was below the atachments
This cause a sequence error at the loading stage
*/
/* Check exists
*/
GOSUB 1000 WHERE EXISTS (
SELECT 'x'
FROM PROJACTS
WHERE 0=0
AND   DOC = :DOC
AND   WBS = STRCAT(ITOA(:PLOT) , '.' , ITOA(:EL))
);
/*
Get Status */
SELECT * FROM ZCLA_ELSTATUSES
FORMAT ADDTO :DEBUGFILE
;
:STATUS = 0 ;
:STEPSTATUSDES = '' ;
SELECT STEPSTATUS , STEPSTATUSDES INTO :STATUS, :STEPSTATUSDES
FROM ZCLA_ELSTATUSES WHERE INITFLAG = 'Y'
;
SELECT :STATUS, :STEPSTATUSDES
FROM DUMMY
FORMAT ADDTO :DEBUGFILE
;
/*
insert Element line */
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD ;
SELECT :P + 1 INTO :P FROM DUMMY ;
INSERT INTO GENERALLOAD (LINE , RECORDTYPE, INT1, INT2, INT3, INT4,
INT5 , INT6 , INT7, TEXT2 , TEXT3 , TEXT1)
SELECT :LN
,   '3'
,   EL
,   HOUSETYPEID
,   COL
,   -1
,   :P
,   ALT
,   :STATUS
,   :STEPSTATUSDES
,   STYLE
,   GUID
FROM ZCLA_HOUSETYPE
WHERE HOUSETYPEID = :HOUSETYPE
;
/*
*/
/*
ATTACHMENTS FROM HOUSETYPE
*/
/*GergoM | 16/11/23 | WRONG VARIABLE WAS USED
:HOUSETYEID was used instead of :HOUSETPE
*/
/* Find latest attachment for each category */
DECLARE APF_CATCURSOR  CURSOR FOR
SELECT DISTINCT ZCLA_FILECATEGORY
FROM EXTFILES, ZCLA_FILECATEGORIES Z
WHERE IV = :HOUSETYPE
AND EXTFILES.ZCLA_FILECATEGORY = Z.FILECATEGORY
AND   TYPE = '¬'
AND   Z.INTERNALCOPY = 'Y'
;
OPEN APF_CATCURSOR ;
GOTO 8081 WHERE :RETVAL = 0;
LABEL 111;
:CAT = 0;
FETCH APF_CATCURSOR  INTO :CAT;
GOTO 8080 WHERE :RETVAL = 0;
/* Insert attachments */
:EXTFILENUM = :CURDATE = 0;
:EXTFILEDES = :EXTFILENAME = :CATEGORYNAME = '';
SELECT EXTFILENUM, EXTFILEDES, EXTFILENAME, CATEGORYNAME, CURDATE ,
GUID
INTO :EXTFILENUM, :EXTFILEDES, :EXTFILENAME, :CATEGORYNAME, :CURDATE
, :GUID
FROM ZCLA_FILECATEGORIES, EXTFILES
WHERE TYPE = '¬'
AND   IV = :HOUSETYPE
AND   ZCLA_FILECATEGORIES.FILECATEGORY = EXTFILES.ZCLA_FILECATEGORY
AND   EXTFILES.ZCLA_FILECATEGORY = :CAT
ORDER BY CURDATE DESC
OFFSET 0 FETCH NEXT 1 ROWS ONLY
;
/*--------*/
SELECT MAX(LINE) + 1 INTO :LN FROM GENERALLOAD;
INSERT INTO GENERALLOAD(LINE, RECORDTYPE, INT1, TEXT1, TEXT2, TEXT3,
DATE1 , TEXT4)
VALUES(:LN + 1, '7', :EXTFILENUM, :EXTFILEDES, :EXTFILENAME,
:CATEGORYNAME, :CURDATE , :GUID)
;
LOOP 111;
LABEL 8080;
CLOSE APF_CATCURSOR ;
LABEL 8081;
SELECT :LN + 1 INTO :LN FROM DUMMY;
LOOP 403231 ;
LABEL 403238 ;
CLOSE APF_E97 ;
LABEL 403239 ;
/* Loading
*/
#INCLUDE func/ZCLA_RESETERR
EXECUTE INTERFACE 'ZCLA_LOADPLOT', SQL.TMPFILE, '-L', :GEN ;
/* Log to file
*/
SELECT LINE , RECORDTYPE, LOADED, KEY1, INT1, INT2, INT3, INT4
,      INT5 , INT6 , INT7, TEXT2
FROM GENERALLOAD
FORMAT ADDTO :DEBUGFILE ;
#INCLUDE func/ZCLA_ERRMSG
/*GergoM | 28/11/23 | Recalc element */
DECLARE ELUPD CURSOR FOR
SELECT ATOI(KEY1)
FROM GENERALLOAD
WHERE RECORDTYPE = '3'
AND LOADED = 'Y'
;
OPEN ELUPD ;
GOTO 2201249 WHERE :RETVAL = 0 ;
LABEL 2201241 ;
:ELEMENT = 0;
FETCH ELUPD INTO :ELEMENT ;
GOTO 2201248 WHERE :RETVAL = 0 ;
#INCLUDE ZCLA_ELACT/RECALC
LOOP 2201241;
LABEL 2201248 ;
CLOSE ELUPD ;
LABEL 2201249 ;
/* END Recalc element */
UNLINK AND REMOVE GENERALLOAD ;
#INCLUDE STATUSTYPES/ZCLA_BUF5
/* Error Handler
*/
SUB 1000 ;
SELECT STRCAT('Plot ' , ITOA(:PLOT)) INTO :PAR1
FROM DUMMY ;
SELECT ELDES INTO :PAR2
FROM ZCLA_PLOTELEMENT
WHERE 0=0
AND   EL = :EL ;
ERRMSG 500 ;
RETURN ;
