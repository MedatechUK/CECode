/*PRE-INSERT and PRE-UPDATE to ensure Config CONFIG.PDVSELECT = PART.PDVTYPE*/
GOTO 999 WHERE :$.PDVSELECT = :$.PDVCONFIRM;
ERRMSG 900;
LABEL 999;
/*900: Invalid Configuration Option for Selected Circuit*/
