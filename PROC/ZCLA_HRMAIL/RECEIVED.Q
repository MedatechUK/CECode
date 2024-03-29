/*
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_RECMAIL' , 'NEW'
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE ;
/*
Set the reply to address */
:_REPLYTOEMAIL = 'jobs@clarksonevans.co.uk';
:ENTMSG = 0 ;
:ENT = 'ZCLA_HRMAIL' ;
:ENTTYPE = 'P' ;
/*
Cursor JOBCANDIDATE not sent REC
*/
DECLARE CAN CURSOR FOR
SELECT JOBCANDIDATE
FROM JOBCANDIDATES
WHERE 0=0
AND   JOBCANDIDATE > 0
AND   JOBCANDIDATES.ZCLA_RECSENT <> 'Y'
;
/*
*/
OPEN CAN ;
GOTO 9 WHERE :RETVAL = 0 ;
LABEL 1 ;
:JC = :ENTMSG = 0 ;
:sendto = :_Subject = :PAR1 = :PAR2 = '' ;
FETCH CAN INTO :JC ;
GOTO 8 WHERE :RETVAL = 0 ;
/*
*/
SELECT ''
,      USERSB.EMAIL
,      'Application'
,      60
,      USERSB.SNAME
,      JOBS.JOBDES
INTO :X
,    :sendto
,    :_Subject
,    :ENTMSG
,    :PAR1
,    :PAR2
FROM JOBCANDIDATES
,   USERSB
,   USERS
,   POSITIONS
,   JOBS
WHERE  (JOBCANDIDATES.JOBCANDIDATE = :JC )
AND   JOBCANDIDATES.CANDIDATE = USERSB.USERB
AND   JOBCANDIDATES.USER = USERS.USER
AND   JOBS.JOB = JOBCANDIDATES.JOB
AND   POSITIONS.POSITION = JOBS.POSITION
;
/*
*/
SELECT :JC
,      :sendto
,      :_Subject
,      :ENTMSG
,      :PAR1
,      :PAR2
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
/*
*/
SELECT STRCAT(SQL.TMPFILE , '.html') INTO :TMPFILE FROM DUMMY ;
#INCLUDE MAILBOX/ZCLA_BUF1
MAILMSG 801 TO EMAIL :sendto DATA :TMPFILE  ;
UPDATE JOBCANDIDATES
SET ZCLA_RECSENT = 'Y'
WHERE  JOBCANDIDATES.JOBCANDIDATE = :JC
;
/*
*/
LOOP 1 ;
LABEL 8 ;
CLOSE CAN ;
LABEL 9 ;
