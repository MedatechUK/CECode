/*#######################################*/
/*ZLIA_COMMISSIONING/form-level/INCLUDE*/
/*#######################################*/
/*Clear the Circuit Schedule for User*/
/*
DELETE Rows for USER from ZLIA_HT_SCHEDULE*/
DELETE FROM ZLIA_HT_SCHEDULE
WHERE 0=0
AND   USER = SQL.USER
;
