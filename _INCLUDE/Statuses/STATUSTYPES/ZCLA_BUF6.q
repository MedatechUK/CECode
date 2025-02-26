/*
This selection statement sets the project status based on contracts. It retrieves the value of the variable DOCSTAT from the table DOCSTATS based on different conditions. The value of DOCSTAT is then used to update the ASSEMBLYSTATUS column in the table DOCUMENTSA.

The selection is performed in the following steps:
1. Set the initial value of DOCSTAT to 0.
2. Retrieve the value of DOCSTAT from DOCSTATS where the TYPE is 'p' and ZCLA_ACTIVEFLAG is 'Y', and there exists a record in ZCLA_CONTRACTS and ZCLA_CONTRACTSTATUSE tables that matches the conditions.
3. Retrieve the value of DOCSTAT from DOCSTATS where the TYPE is 'p' and ZCLA_WONFLAG is 'Y', and there exists a record in ZCLA_CONTRACTS and ZCLA_CONTRACTSTATUSE tables that matches the conditions.
4. Retrieve the value of DOCSTAT from DOCSTATS where the TYPE is 'p' and ZCLA_TENDERFLAG is 'Y', and there exists a record in ZCLA_CONTRACTS and ZCLA_CONTRACTSTATUSE tables that matches the conditions.
5. Retrieve the value of DOCSTAT from DOCSTATS where the TYPE is 'p' and FINALFLAG is 'Y', and there does not exist a record in ZCLA_CONTRACTS and ZCLA_CONTRACTSTATUSE tables that matches the conditions.
6. Retrieve the value of DOCSTAT from DOCSTATS where the TYPE is 'p' and CANCELFLAG is 'Y', and there does not exist a record in ZCLA_CONTRACTS and ZCLA_CONTRACTSTATUSE tables that matches the conditions.
7. Retrieve the value of DOCSTAT from DOCSTATS where the TYPE is 'p' and INITSTATFLAG is 'Y', and there does not exist a record in ZCLA_CONTRACTS and ZCLA_CONTRACTSTATUSE tables that matches the conditions.
8. Update the ASSEMBLYSTATUS column in DOCUMENTSA table with the value of DOCSTAT where the DOC matches the value of :$$.DOC.
*/
/* *******************************
Set Project Status based on Contracts
******************************** */
:DOCSTAT = 0 ;
SELECT DOCSTAT INTO :DOCSTAT
FROM DOCSTATS
WHERE 0=0
AND   TYPE = 'p'
AND   ZCLA_ACTIVEFLAG = 'Y'
AND   EXISTS(
SELECT 'x'
FROM ZCLA_CONTRACTS , ZCLA_CONTRACTSTATUSE
WHERE 0=0
AND   ZCLA_CONTRACTS.STEPSTATUS = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND   DOC = ( :$$.DOC )
AND   INITFLAG <> 'Y'
);
SELECT DOCSTAT INTO :DOCSTAT
FROM DOCSTATS
WHERE 0=0
AND   TYPE = 'p'
AND   ZCLA_WONFLAG = 'Y'
AND   EXISTS(
SELECT 'x'
FROM ZCLA_CONTRACTS , ZCLA_CONTRACTSTATUSE
WHERE 0=0
AND   ZCLA_CONTRACTS.STEPSTATUS = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND   DOC = ( :$$.DOC )
AND   WONFLAG = 'Y'
);
SELECT DOCSTAT INTO :DOCSTAT
FROM DOCSTATS
WHERE 0=0
AND   TYPE = 'p'
AND   ZCLA_TENDERFLAG = 'Y'
AND   EXISTS(
SELECT 'x'
FROM ZCLA_CONTRACTS , ZCLA_CONTRACTSTATUSE
WHERE 0=0
AND   ZCLA_CONTRACTS.STEPSTATUS = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND   DOC = ( :$$.DOC )
AND   TENDERFLAG = 'Y'
);
SELECT DOCSTAT INTO :DOCSTAT
FROM DOCSTATS
WHERE 0=0
AND   TYPE = 'p'
AND   FINALFLAG = 'Y'
AND   NOT EXISTS(
SELECT 'x'
FROM ZCLA_CONTRACTS , ZCLA_CONTRACTSTATUSE
WHERE 0=0
AND   ZCLA_CONTRACTS.STEPSTATUS = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND   DOC = ( :$$.DOC )
AND   CLOSEFLAG <> 'Y'
);
SELECT DOCSTAT INTO :DOCSTAT
FROM DOCSTATS
WHERE 0=0
AND   TYPE = 'p'
AND   CANCELFLAG  = 'Y'
AND   NOT EXISTS(
SELECT 'x'
FROM ZCLA_CONTRACTS , ZCLA_CONTRACTSTATUSE
WHERE 0=0
AND   ZCLA_CONTRACTS.STEPSTATUS = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND   DOC = ( :$$.DOC )
AND   CANCELFLAG <> 'Y'
);
SELECT DOCSTAT INTO :DOCSTAT
FROM DOCSTATS
WHERE 0=0
AND   TYPE = 'p'
AND   INITSTATFLAG = 'Y'
AND   NOT EXISTS(
SELECT 'x'
FROM ZCLA_CONTRACTS , ZCLA_CONTRACTSTATUSE
WHERE 0=0
AND   ZCLA_CONTRACTS.STEPSTATUS = ZCLA_CONTRACTSTATUSE.STEPSTATUS
AND   DOC = ( :$$.DOC )
AND   INITFLAG <> 'Y'
);
UPDATE DOCUMENTSA
SET ASSEMBLYSTATUS = :DOCSTAT
WHERE DOC = :$$.DOC ;
