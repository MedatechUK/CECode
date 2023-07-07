/*
Send external email as unicode HTML body.
*/
:_REPLYTOEMAIL = 'hr@clarksonevans.co.uk' ;
:_Subject = 'Bad news about your application for <P1>.' ;
:sendto = 'gergo@migleczi.co.uk' ;
/*
Get the message body from entity
The message body uses standard <P tags. */
:ENT = 'ZCLA_HRMAIL' ;
:ENTTYPE = 'P' ;
:ENTMSG = 10;
:PAR1 = 'the role' ;
:PAR2 = '' ;
:PAR3 = 'Gergo Migleczi' ;
/*
*/
SELECT STRCAT(SQL.TMPFILE,'.html') INTO :TMPFILE FROM DUMMY ;
#INCLUDE MAILBOX/ZCLA_BUF1
MAILMSG 20 TO EMAIL :sendto DATA :TMPFILE  ;
SLEEP 2 ;
