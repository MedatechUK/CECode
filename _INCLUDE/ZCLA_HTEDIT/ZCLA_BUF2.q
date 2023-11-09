/*
Populate GUID for replication */
SELECT SQL.GUID INTO :$.GUID
FROM DUMMY
WHERE :$.GUID = '' ;
