/* Save Housetype Edit:
UPDTYPE (CHAR,1,'I/U/D')
.    I(nsert)
.    U(pdate)
.    D(elete)
EDITTYPE (CHAR,1,'W/O/R/K/S/H/P/A/C/E')
.    (W)ays
.    Small Works P(O)ints 
.    (R)ooms
.    Small Wor(K)s
.    Out(S)ouced Parts
.    (H)ouse
.    (P)arts
.    (A)ttachment
.    (C)onsumer unit
.    Outsouc(E)d Part Points
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HTEDIT/ZCLA_BUF1'
, :$.HOUSETYPE  , :$.EDITTYPE , :UPDTYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
:HOUSETYPE = 0 ;
SELECT :$.HOUSETYPE INTO :HOUSETYPE
FROM DUMMY ;
/*
GergoM | 11/12/23 |
si: Error if it is not under any plots
*/
ERRMSG 902 WHERE NOT EXISTS (
SELECT PROJACT, DOC
FROM PROJACTS
WHERE ZCLA_HOUSETYPEID = :HOUSETYPE
);
#INCLUDE ZCLA_HTEDIT/ZCLA_BUF4