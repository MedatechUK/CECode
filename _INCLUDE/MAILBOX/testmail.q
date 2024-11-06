/*
Send external email as unicode HTML body.
*/
:_REPLYTOEMAIL = 'prioritytest@clarksonevans.co.uk' ;
:_Subject = 'Test to gmail.' ;
:sendto = 'prioritytest@clarksonevans.co.uk' ;
/*:sendto = 'gergo@migleczi.co.uk' ;*/
/*
Get the message body from entity
The message body uses standard <P tags. */
:ENT = 'ZCLA_HRMAIL' ;
:ENTTYPE = 'P' ;
:ENTMSG = 30;
:PAR1 = 'Martin' ;
:PAR2 = 'the role' ;

SELECT PARTNAME INTO :PAR1
FROM PART WHERE PART = 123 ;
/*
*/
SELECT STRCAT(SQL.TMPFILE , '.html') INTO :TMPFILE FROM DUMMY ;
#INCLUDE MAILBOX/ZCLA_BUF1
MAILMSG 20 TO EMAIL :sendto DATA :TMPFILE  ;
SLEEP 2 ;
