/*ZLIA_CUDB_DEFOPT/CUDB_RCDS/CHECK-FIELD*/
GOTO 999 WHERE :$.CUDB_RCDS = '0';
GOTO 999 WHERE :$.CUDB_RCDS = '1';
GOTO 999 WHERE :$.CUDB_RCDS = '2';
ERRMSG 920;
LABEL 999;
/*#920: Permitted Values between 0 and 2.*/