/* Save Housetype Edit:
UPDTYPE (CHAR,1,'I/U/D')
.    I(nsert)
.    U(pdate)
.    D(elete)
EDITTYPE (CHAR,1,'W/A/R/S/H/C/P')
.    W(ays)
.    A(ttachment)
.    R(oom)
.    S(ubcontract)
.    H(ouse)
.    C(onsumer unit)
.    P(art)
*/
#INCLUDE func/ZCLA_DEBUGUSR
SELECT 'ZCLA_HTEDIT/ZCLA_BUF3'
, :$$.NSCUST  , :$.EDITTYPE , :UPDTYPE
FROM DUMMY
WHERE :DEBUG = 1
FORMAT ADDTO :DEBUGFILE
;
:HOUSETYPE = 0 ;
SELECT :$$.NSCUST INTO :HOUSETYPE
FROM DUMMY ;
#INCLUDE ZCLA_HTEDIT/ZCLA_BUF4