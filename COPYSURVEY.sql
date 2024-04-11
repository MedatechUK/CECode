SET IDENTITY_INSERT QUESTFORM oN
insert into QUESTFORM (QUESTFCODE 
,    QUESTFDES 
,    QUESTF 
,    T$USER 
,    UDATE 
,    WEBFLAG 
,    TYPE 
,    CURDATE 
,    EXTFILENAME 
,    SOF_SIGN 
,    ZCLA_CUSTNOTE 
,    ZCLA_FORMATCODE 
,    ZGEM_QUESTTYPE 
,    PRTSIGN 
,    ZCLA_PERCENTAGE 
,    ZCLA_TLUSER 
,    ZGEM_OPENNEW )
SELECT QUESTFCODE 
,    QUESTFDES 
,    QUESTF 
,    T$USER 
,    UDATE 
,    WEBFLAG 
,    TYPE 
,    CURDATE 
,    EXTFILENAME 
,    SOF_SIGN 
,    ZCLA_CUSTNOTE 
,    ZCLA_FORMATCODE 
,    ZGEM_QUESTTYPE 
,    PRTSIGN 
,    ZCLA_PERCENTAGE 
,    ZCLA_TLUSER 
,    ZGEM_OPENNEW 
FROM [CE-AZ-UK-S-PRIO\TST].qa4.dbo.QUESTFORM where QUESTFCODE like 'F01'

SET IDENTITY_INSERT QUESTIONS oN
INSERT INTO QUESTIONS(QUESTF     
,    QUESTNUM     
,    QUESTDES     
,    COUNTER     
,    QGROUP     
,    SORT     
,    ATYPE     
,    MANDATORY     
,    INACTIVE     
,    MANAGERONLY     
,    SOF_CONTQUEST     
,    ZCLA_PLOTCOMPONENT     
,    ZCLA_ORIGQTY     
,    FOLLOWQUESTFLAG     
,    FOLLOWQUESTNUM     
)
SELECT QUESTF     
,    QUESTNUM     
,    QUESTDES     
,    COUNTER     
,    QGROUP     
,    SORT     
,    ATYPE     
,    MANDATORY     
,    INACTIVE     
,    MANAGERONLY     
,    SOF_CONTQUEST     
,    ZCLA_PLOTCOMPONENT     
,    ZCLA_ORIGQTY     
,    FOLLOWQUESTFLAG     
,    FOLLOWQUESTNUM     
FROM [CE-AZ-UK-S-PRIO\TST].qa4.dbo.QUESTIONS WHERE QUESTF = 129

insert into ANSWERS(QUESTF 
,    QUESTNUM 
,    ANSNUM 
,    ANSDES 
,    COUNTER 
,    ADCDEFAULT 
,    SOF_NEXTNUM 
,    ZCLA_ANSDES 
,    ZCLA_PARTNAME 
,    FOLLOWQUESTNUM )
SELECT QUESTF 
,    QUESTNUM 
,    ANSNUM 
,    ANSDES 
,    COUNTER 
,    ADCDEFAULT 
,    SOF_NEXTNUM 
,    ZCLA_ANSDES 
,    ZCLA_PARTNAME 
,    FOLLOWQUESTNUM 
FROM [CE-AZ-UK-S-PRIO\TST].qa4.dbo.ANSWERS WHERE QUESTF = 129

SET IDENTITY_INSERT QUESTIONGROUP on
insert into QUESTIONGROUP( QGROUP     
,       QGROUPDES     
,       SORT   
)
SELECT QGROUP     
,       QGROUPDES     
,       SORT     
FROM [CE-AZ-UK-S-PRIO\TST].qa4.dbo.QUESTIONGROUP  
where QGROUP in (select QGROUP FROM [CE-AZ-UK-S-PRIO\TST].qa4.dbo.QUESTIONS WHERE QUESTF = 129)
SET IDENTITY_INSERT QUESTIONGROUP OFF