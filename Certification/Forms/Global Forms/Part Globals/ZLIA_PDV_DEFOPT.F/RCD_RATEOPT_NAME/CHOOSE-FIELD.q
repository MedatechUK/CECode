/*#######################################*/
/*RCD - Residual Current Rating Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/RCD_RATEOPT_NAME/CHOOSE-FIELD */
SELECT RCD_RATEOPT_DES, RCD_RATEOPT_NAME, RATEOPT_ID
FROM ZLIA_PDV_RATES
WHERE RATEOPT_ID <> 0
AND DEVTYPEID = :$.DEVTYPEID
AND RATEOPT_ID = :$.OC_RATEOPT_ID
ORDER BY RATEOPT_ID;
