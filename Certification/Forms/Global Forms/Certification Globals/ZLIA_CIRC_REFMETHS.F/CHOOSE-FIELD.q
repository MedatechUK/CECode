/*ZLIA_CIRC_REFMETHS/Form Level/CHOOSE-FIELD*/
SELECT CIRC_REFMETHDES, CIRC_REFMETHNAME, CIRC_REFMETHID
FROM ZLIA_CIRC_REFMETHS
WHERE CIRC_REFMETHID <> 0
ORDER BY CIRC_REFMETHID;
