/*ZLIA_CUDB_DEFOPT/SPHASE/CHECK-FIELD*/
GOTO 999 WHERE :$.SPHASE = 'Single';
GOTO 999 WHERE :$.SPHASE = 'Three';
ERRMSG 890;
LABEL 999;
/*#890: Permitted Values are Single or Three.*/
