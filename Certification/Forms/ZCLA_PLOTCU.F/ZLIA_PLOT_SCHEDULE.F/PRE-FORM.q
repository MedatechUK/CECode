/*ZLIA_PLOT_SCHEDULE/PRE-FORM*/
:ACTIVATE_POST_FORM = 'Y' ;
/**/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZLIA_PLOT_SCHEDULE/PRE-FORM' , SQL.USER
FROM DUMMY FORMAT ADDTO :DEBUGFILE ;
:ELEMENT = 0 ;
SELECT :$$$$.PROJACT INTO :ELEMENT
FROM DUMMY ;
:PART = :$$.PART ;
:CUNIT = :$$.CONSUMERUNIT;
:TYPE = :$$$$$.TYPE ;
:CUST = :$$$$$.CUST ;
:DOC = :$$$$$.DOC ;
#INCLUDE ZCLA_ALTMANUF/ZCLA_ELEMENT
#INCLUDE PARTARC/ZCLA_PARTREPLACE
#INCLUDE ZLIA_COMMISSIONING/ZLIA_CLR_CIRCSCHED
#INCLUDE ZLIA_COMMISSIONING/ZLIA_PRE_CIRCSCHED
#INCLUDE ZLIA_COMMISSIONING/ZLIA_CIRCSCHED_EL
