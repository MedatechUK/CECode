/* ZLIA_COMMISSIONING/TYPENAME/CHOOSE-FIELD */
SELECT '', TYPENAME 
FROM ZLIA_CERTTYPE_OPT
WHERE CERTTYPE <> 0
ORDER BY CERTTYPE;
