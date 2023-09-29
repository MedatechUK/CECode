/*#######################################*/
/*MCB/RCBO - Overcurrent Rating Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/OC_RATEOPT_NAME/POST-FIELD */
SELECT RATEOPT_ID INTO :$.OC_RATEOPT_ID
FROM ZLIA_PDV_RATES
WHERE 0=0
AND DEVTYPEID = :$.DEVTYPEID
AND OC_RATEOPT_NAME = :$.@;
