/*ZLIA_CUDB_DEFOPT/SPD_PDV_DEFDES/POST-FIELD */
SELECT PDV_DEFID INTO :$.SPD_PDV_DEFOPT
FROM ZLIA_PDV_DEFOPT
WHERE 0=0
AND PDV_DEFDES = :$.@;
