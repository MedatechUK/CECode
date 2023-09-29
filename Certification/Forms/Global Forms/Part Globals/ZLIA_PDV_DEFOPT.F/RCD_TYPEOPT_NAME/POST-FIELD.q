/*#######################################*/
/*RCD - Residual Current Type Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/RCD_TYPEOPT_NAME/POST-FIELD */
SELECT TYPEOPT_ID INTO :$.RCD_TYPEOPT_ID
FROM ZLIA_PDV_TYPES
WHERE 0=0
AND DEVTYPEID = :$.DEVTYPEID
AND TYPEOPT_ID = :$.OC_TYPEOPT_ID
AND RCD_TYPEOPT_NAME = :$.@;
