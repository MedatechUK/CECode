/*#######################################*/
/*MCB/RCBO - Overcurrent Type Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/OC_TYPEOPT_NAME/CHOOSE-FIELD */
SELECT OC_TYPEOPT_DES, OC_TYPEOPT_NAME, TYPEOPT_ID
FROM ZLIA_PDV_TYPES
WHERE TYPEOPT_ID <> 0
AND DEVTYPEID = :$.DEVTYPEID
ORDER BY TYPEOPT_ID;
