/*ZLIA_CAB_TYPES/CABCOATING/CHECK-FIELD*/
GOTO 999 WHERE :$.CABCOATING = 'Thermoplastic';
GOTO 999 WHERE :$.CABCOATING = 'Thermosetting';
GOTO 999 WHERE :$.CABCOATING = 'N/A';
ERRMSG 853;
LABEL 999;
/*#853: Please select Thermoplastic or Thermosetting or N/A.*/
