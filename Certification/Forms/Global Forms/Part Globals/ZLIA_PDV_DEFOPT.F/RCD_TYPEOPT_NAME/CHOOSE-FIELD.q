/*#######################################*/
/*RCD - Residual Current Type Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/RCD_TYPEOPT_NAME/CHOOSE-FIELD */
SELECT RCD_TYPEOPT_DES, RCD_TYPEOPT_NAME, TYPEOPT_ID
FROM ZLIA_PDV_TYPES
WHERE TYPEOPT_ID <> 0
AND DEVTYPEID = :$.DEVTYPEID
AND TYPEOPT_ID = :$.OC_TYPEOPT_ID
ORDER BY TYPEOPT_ID;
