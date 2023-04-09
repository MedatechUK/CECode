/*
Set Multiple finish flag */
UPDATE ZCLA_HOUSETYPE SET ZCLA_MULTIPLEFINISH  = 'N';
UPDATE ZCLA_HOUSETYPE SET ZCLA_MULTIPLEFINISH  = 'Y'
WHERE HOUSETYPEID  IN (
SELECT DISTINCT HOUSETYPEID
FROM ZCLA_HOUSETYPE
WHERE HOUSETYPEID IN (
SELECT DISTINCT ZCLA_HOUSETYPE.HOUSETYPEID
FROM ZCLA_HOUSETYPE , ZCLA_ROOMS
WHERE 0=0
AND   ZCLA_HOUSETYPE.HOUSETYPEID > 0
AND   ZCLA_HOUSETYPE.HOUSETYPEID = ZCLA_ROOMS.HOUSETYPEID
AND   ZCLA_HOUSETYPE.COL <> ZCLA_ROOMS.COL
)
OR HOUSETYPEID IN (
SELECT DISTINCT ZCLA_HOUSETYPE.HOUSETYPEID
FROM ZCLA_HOUSETYPE , ZCLA_ROOMS , ZCLA_COMPONENT
WHERE 0=0
AND   ZCLA_HOUSETYPE.HOUSETYPEID > 0
AND   ZCLA_HOUSETYPE.HOUSETYPEID = ZCLA_ROOMS.HOUSETYPEID
AND   ZCLA_ROOMS.ROOM = ZCLA_COMPONENT.ROOM
AND   ZCLA_HOUSETYPE.COL <> ZCLA_COMPONENT.COL
));
/*
*/
UPDATE ZCLA_ROOMS SET ZCLA_MULTIPLEFINISH  = 'N';
UPDATE ZCLA_ROOMS SET ZCLA_MULTIPLEFINISH  = 'Y'
WHERE ROOM IN (
SELECT DISTINCT ZCLA_ROOMS.ROOM
FROM ZCLA_ROOMS , ZCLA_COMPONENT
WHERE 0=0
AND   ZCLA_ROOMS.ROOM = ZCLA_COMPONENT.ROOM
AND   ZCLA_ROOMS.COL <> ZCLA_COMPONENT.COL
);
