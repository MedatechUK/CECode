/*#######################################*/
/*RCD - Residual Current Rating Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/RCD_RATEOPT_NAME/POST-FIELD */
SELECT RATEOPT_ID INTO :$.RCD_RATEOPT_ID
FROM ZLIA_PDV_RATES
WHERE 0=0
AND DEVTYPEID = :$.DEVTYPEID
AND RATEOPT_ID = :$.OC_RATEOPT_ID
AND RCD_RATEOPT_NAME = :$.@;
