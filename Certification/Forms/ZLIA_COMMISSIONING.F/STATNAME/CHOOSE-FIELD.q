/* ZLIA_COMMISSIONING/STATNAME/CHOOSE-FIELD */
SELECT '', STATNAME 
FROM ZLIA_CERTSTAT_OPT
WHERE CERTSTATUS <> 0
ORDER BY CERTSTATUS;
