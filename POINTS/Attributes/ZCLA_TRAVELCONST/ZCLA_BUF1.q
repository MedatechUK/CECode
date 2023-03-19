/* 
Get Travel Constants 
*/
:SAFETYMARGIN = :MILEAGE = :FULLPOINTS = :TRAVELCOST = 0.0 ;
SELECT VALUE INTO :MILEAGE
FROM ZCLA_CONST
WHERE 0=0
AND   TYPE = 'TRAVEL'
AND   NAME = 'MILEAGE'
;
SELECT VALUE INTO :FULLPOINTS
FROM ZCLA_CONST
WHERE 0=0
AND   TYPE = 'TRAVEL'
AND   NAME = 'FULLPOINTS'
;
SELECT VALUE INTO :TRAVELCOST
FROM ZCLA_CONST
WHERE 0=0
AND   TYPE = 'TRAVEL'
AND   NAME = 'TRAVELCOST'
;
SELECT 1 + VALUE INTO :SAFETYMARGIN
FROM ZCLA_CONST
WHERE 0=0
AND TYPE = 'FIN'
AND NAME = 'SAFETYMARGIN'
;