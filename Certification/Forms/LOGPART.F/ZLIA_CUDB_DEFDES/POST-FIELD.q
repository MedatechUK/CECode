/*LOGPART/ZLIA_CUDB_DEFDES/POST-FIELD */
SELECT CUDB_DEFID INTO :$.ZLIA_CUDB_DEFID
FROM ZLIA_CUDB_DEFOPT
WHERE 0=0
AND CUDB_DEFDES = :$.@;
