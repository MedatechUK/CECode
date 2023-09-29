/*#######################################*/
/*MCB/RCBO - Overcurrent Type Options*/
/*#######################################*/

/*ZLIA_PDV_DEFOPT/OC_TYPEOPT_NAME/POST-FIELD */
SELECT TYPEOPT_ID INTO :$.OC_TYPEOPT_ID
FROM ZLIA_PDV_TYPES
WHERE 0=0
AND DEVTYPEID = :$.DEVTYPEID
AND OC_TYPEOPT_NAME = :$.@;
