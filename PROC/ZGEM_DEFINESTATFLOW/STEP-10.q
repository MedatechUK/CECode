/************************************************************/
/**                   Load status flows                    **/
/************************************************************/
/*Contracts, Elements, Fixes*/
/*******************/
/*    Contracts    */
/*******************/
:TYPE = 'ZCLA_CONT' ;
:ENAME = 'ZCLA_CONTRACTS' ;
:FROM = :TO = :FORM = 0 ;
/*Get EXEC ID for form*/
GOSUB 150;
/*Delete existing status flow*/
GOSUB 200;
/*Define new status flow*/
:F = 'Draft' ; :T = 'Quote' ; GOSUB 100 ;
:F = 'Draft' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Quote' ; :T = 'Revision' ; GOSUB 100 ;
:F = 'Quote' ; :T = 'Won' ; GOSUB 100 ;
:F = 'Quote' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Lost' ; :T = 'Revision' ; GOSUB 100 ;
:F = 'Revision' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Revision' ; :T = 'Quote' ; GOSUB 100 ;
:F = 'Won' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Won' ; :T = 'Revision' ; GOSUB 100 ;
:F = 'Won' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Edit' ; :T = 'Active' ; GOSUB 100 ;
:F = 'Edit' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Hold' ; :T = 'Active' ; GOSUB 100 ;
:F = 'Hold' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Hold' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Edit' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Lost' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Amend' ; GOSUB 100 ;
:F = 'Amend' ; :T = 'Ready' ; GOSUB 100 ;
/*******************/
/*    Elements     */
/*******************/
:TYPE = 'ZCLA_EL' ;
:ENAME = 'ZCLA_ELACTSTAT' ;
/*Get EXEC ID for form*/
GOSUB 150;
/*Delete existing status flow*/
GOSUB 200;
/*Define new status flow*/
:F = 'Draft' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Draft' ;GOSUB 100 ;
:F = 'Ready' ; :T = 'Edit' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Extras' ; GOSUB 100 ;
:F = 'Edit' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Extras' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Hold' ; GOSUB 100 ;
:F = 'Hold' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Extras' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Edit' ; GOSUB 100 ;
:F = 'Extras' ; :T = 'Active' ; GOSUB 100 ;
:F = 'Edit' ; :T = 'Active' ; GOSUB 100 ;
:F = 'Active' ; :T = 'Price Edit' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Price Edit' ; GOSUB 100 ;
:F = 'Price Edit' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Price Edit' ; :T = 'Active' ; GOSUB 100 ;
/*******************/
/*     Fixes       */
/*******************/
:TYPE = 'ZCLA_FIX' ;
:ENAME = 'ZCLA_FIXACTSTAT' ;
/*Get EXEC ID for form*/
GOSUB 150;
/*Delete existing status flow*/
GOSUB 200;
/*Define new status flow*/
:F = 'Ready' ; :T = 'Scheduled' ; GOSUB 100 ;
:F = 'Scheduled' ; :T = 'Part Done' ; GOSUB 100 ;
:F = 'Scheduled' ; :T = 'Fix Done' ; GOSUB 100 ;
:F = 'Part Done' ; :T = 'Fix Done' ; GOSUB 100 ;
/*******************/
/*      DNOs       */
/*******************/
:TYPE = 'ZGEM_DNOST' ;
:ENAME = 'ZGEM_SITEDNOS' ;
/*Get EXEC ID for form*/
GOSUB 150;
/*Delete existing status flow*/
GOSUB 200;
/*Define new status flow*/
:F = 'Draft' ; :T = 'In Progress' ; GOSUB 100 ;
:F = 'In Progress' ; :T = 'Draft' ; GOSUB 100 ;
:F = 'Draft' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Draft' ; GOSUB 100 ;
:F = 'Ready' ; :T = 'Submitted' ; GOSUB 100 ;
:F = 'Application Approved' ; :T = 'Work Completed' ; GOSUB 100 ;
:F = 'Submitted' ; :T = 'Application Approved' ; GOSUB 100 ;
:F = 'Submitted' ; :T = 'Re-Apply' ; GOSUB 100 ;
:F = 'Re-Apply' ; :T = 'Ready' ; GOSUB 100 ;
:F = 'Work Completed' ; :T = 'Notification Sent' ; GOSUB 100 ;
/************************************************************/
/**                         SUBs                           **/
/************************************************************/
/*
Insert Status Flow For Form*/
SUB 100 ;
:FROM = 0;
SELECT DOCSTATUS INTO :FROM
FROM DOCSTATUSES
WHERE 0=0
AND   TYPE = :TYPE
AND   STATDES = :F
;
:TO = 0;
SELECT DOCSTATUS INTO :TO
FROM DOCSTATUSES
WHERE 0=0
AND   TYPE = :TYPE
AND   STATDES = :T
;
:LN = 0 ;
SELECT 0 + MAX(KLINE) INTO :LN
FROM BPMLOG WHERE FORM = :FORM ;
INSERT INTO BPMLOG ( FORM , UDATE, USER , FROMSTATUS , TOSTATUS ,
CHANGETYPE , KLINE )
SELECT :FORM
,      SQL.DATE
,      SQL.USER
,      :FROM
,      :TO
,      104
,      :LN + 1
FROM DUMMY ;
RETURN ;
/*
Get EXEC ID for form*/
SUB 150 ;
SELECT EXEC INTO :FORM FROM EXEC
WHERE 0=0
AND   ENAME = :ENAME
AND   TYPE = 'F' ;
RETURN;
/*
Delete existing status flow*/
SUB 200;
DELETE FROM BPMLOG WHERE FORM = :FORM ;
RETURN;
