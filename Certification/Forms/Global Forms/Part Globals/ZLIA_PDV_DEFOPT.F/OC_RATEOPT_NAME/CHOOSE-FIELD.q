/*#######################################*/
/*MCB/RCBO - Overcurrent Rating Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/OC_RATEOPT_NAME/CHOOSE-FIELD */
SELECT OC_RATEOPT_DES, OC_RATEOPT_NAME, RATEOPT_ID
FROM ZLIA_PDV_RATES
WHERE RATEOPT_ID <> 0
AND DEVTYPEID = :$.DEVTYPEID
ORDER BY RATEOPT_ID;
