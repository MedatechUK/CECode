/*ZLIA_CUDB_DEFOPT/CUDB_WAYS/CHECK-FIELD*/
GOTO 999 WHERE :$.CUDB_WAYS BETWEEN 0 AND 20;
ERRMSG 900;
LABEL 999;
/*#900: Permitted Values are numbers between 1 and 20.*/
