/* */
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_DELPLOTS/STEP50' , :$.DOC
FROM DUMMY 
FORMAT ADDTO :DEBUGFILE ;
/*
*/
DELETE FROM ZCLA_PLOTCUCFG
WHERE CONSUMERUNIT IN (
SELECT CONSUMERUNIT FROM ZCLA_PLOTCU
WHERE PROJACT IN (
SELECT PROJACT 
FROM PROJACTS 
WHERE DOC = :$.DOC ))
;
/*
*/
DELETE FROM ZCLA_PLOTCU
WHERE PROJACT IN (
SELECT PROJACT 
FROM PROJACTS 
WHERE DOC = :$.DOC ) 
;
/*
*/
DELETE FROM ZCLA_PLOTCOMPONENT
WHERE PROJACT IN (
SELECT PROJACT 
FROM PROJACTS 
WHERE DOC = :$.DOC ) 
;
/*
*/
DELETE FROM ZCLA_PLOTATTR
WHERE PROJACT IN (
SELECT PROJACT 
FROM PROJACTS 
WHERE DOC = :$.DOC ) 
;
/*
*/
DELETE FROM ZCLA_PLOTCOMPONENT
WHERE PROJACT IN (
SELECT PROJACT 
FROM PROJACTS 
WHERE DOC = :$.DOC ) 
;
/*
*/
DELETE FROM ZCLA_PLOTELFIX
WHERE PROJACT IN (
SELECT PROJACT 
FROM PROJACTS 
WHERE DOC = :$.DOC ) 
;
/*
*/
DELETE FROM ZCLA_PLOTROOMS
WHERE PROJACT IN (
SELECT PROJACT 
FROM PROJACTS 
WHERE DOC = :$.DOC ) 
;
/*
*/
DELETE FROM PROJACTS
WHERE DOC = :$.DOC 
;
