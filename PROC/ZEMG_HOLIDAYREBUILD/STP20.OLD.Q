/*
** Recalculate length of service for all users
** 19/09/24 @Si
*/
:DT = 1/1/88;
UPDATE ZCLA_USERS SET SERVICELEN = 0;
SELECT MIN(STARTDATE) INTO :DT 
FROM ZCLA_USERS ;
LABEL 10 ;
SELECT :DT + 1440 INTO :DT FROM DUMMY;
UPDATE ZCLA_USERS SET SERVICELEN = SERVICELEN + 1
WHERE 0=0
AND   DTOA(:DT , 'DD') = '01'
AND   DTOA(:DT , 'MM') = '01'
AND   STARTDATE < :DT
AND   USERS IN ( SELECT USER FROM USERSB WHERE EMPINACTIVE <> 'Y' ) 
;
LOOP 10 WHERE :DT < SQL.DATE;
/*
** Recalculate Holiday table for all users
*/
:i_HOLDEBUG = 0;
SELECT SQL.DATE FROM DUMMY WHERE :i_HOLDEBUG = 1
FORMAT '../../ZEMG_HOLDEBUG.TXT';
/*
** Declare Cursor for all Users
*/
:USERSCNT = 0;
DECLARE USER_CUR CURSOR FOR
SELECT USERS.USER
FROM USERS, USERSB
WHERE USERLOGIN <> 'WEB'
AND USERSB.EMPINACTIVE <> 'Y'
AND USERSB.USER = USERS.USER
AND USERS.USER <> 0;
/* Open cursor */
OPEN USER_CUR;
GOTO 8103 WHERE :RETVAL <= 0; /* Treat as if no records found */
/*
** Start of cursor loop
*/
LABEL 8100;
/* Initialise variables */
:i_USER = 0;
/* Get next record from cursor */
FETCH USER_CUR INTO :i_USER;
GOTO 8102 WHERE :RETVAL <= 0;
#INCLUDE ZCLA_PAYCODES/ZCLA_BUF2
/*
** Add annual Holiday Extras for this User/Year
*/
/**/
:USERSCNT = :USERSCNT + 1;
/*
** End of cursor loop
*/
LOOP 8100;
/*
** End Processing lines
*/
LABEL 8102;
/* Clean up */
CLOSE USER_CUR;
/*
** End of processing
*/
LABEL 8103;
/**/
:PAR1 = '';
:PAR1 = ITOA(:USERSCNT);
