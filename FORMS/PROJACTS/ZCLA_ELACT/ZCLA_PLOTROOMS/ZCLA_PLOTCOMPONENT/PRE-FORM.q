:ACTIVATE_POST_FORM = 'Y' ;
GOTO 99 WHERE :FORM_INTERFACE = 1 ;
DELETE FROM ZCLA_USERLOCK
WHERE USER = SQL.USER ;
LABEL 99 ;

