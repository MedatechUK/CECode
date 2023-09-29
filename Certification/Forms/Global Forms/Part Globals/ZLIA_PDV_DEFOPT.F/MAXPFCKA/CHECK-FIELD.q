/*ZLIA_PDV_DEFOPT/MAXPFCKA/CHECK-FIELD*/
GOTO 999 WHERE :$.MAXPFCKA = '6';
GOTO 999 WHERE :$.MAXPFCKA = '10';
GOTO 999 WHERE :$.MAXPFCKA = 'N/A';
ERRMSG 870;
LABEL 999;
ERRMSG 874 WHERE :$.OC_RATEOPT_NAME = '';
ERRMSG 875 WHERE :$.OC_RATEOPT_NAME = 'N/A' AND 
:$.MAXPFCKA <> 'N/A' AND :$.DEVTYPENAME <> 'RCD';
ERRMSG 876 WHERE :$.OC_RATEOPT_NAME <> 'N/A' AND 
:$.MAXPFCKA = 'N/A';
/*#870: Permitted Values are N/A, 6 or 10 (kA).*/
/*#874: The O/C Rating value is not set.*/
/*#875: The O/C Rating value is set to N/A.*/
/*#876: The O/C Rating value is not set to N/A.*/
