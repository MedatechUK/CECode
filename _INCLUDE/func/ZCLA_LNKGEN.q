:LN = 0 ;
SELECT SQL.TMPFILE
INTO :GEN FROM DUMMY;
LINK GENERALLOAD TO :GEN;
ERRMSG 1 WHERE :RETVAL = 0 ;