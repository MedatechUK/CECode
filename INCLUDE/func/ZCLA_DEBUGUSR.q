/* Set Debug Flag */
:DEBUG = 0; :DEBUGFILE = '';
SELECT (DEBUGUSER = 'Y' ? 1 : 0)
INTO :DEBUG FROM ZCLA_USERSB
WHERE USER = SQL.USER;
SELECT STRCAT('../../', USERLOGIN, '.txt')
INTO :DEBUGFILE FROM USERS
WHERE USER = SQL.USER;
