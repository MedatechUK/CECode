/*#######################################*/
/*Certification Tables*/
/*#######################################*/
/****/
/*Used in Froms and Reports*/
CREATE TABLE ZLIA_HT_SCHEDULE 'Default Circuit Schedule 2' 0
SCHEDLINE (INT,13,'Schedule Line (ID)')
CONSUMERUNIT (INT,13,'Consumer Unit (ID)')
USER (INT,13,'User (ID)')
CABLEID (INT,13,'Cable (ID)')
PDV_DEFID (INT,13,'Prot.Device (ID)')
CUNITCONFIG (INT,13,'Config (ID)')
CIRCUITNO (CHAR,3,'Circuit Number')
CIRC_WIRETYPID (INT,13,'Circuit WireType(ID)')
CIRC_REFMETHID (INT,13,'Circuit Ref.Meth(ID)')
CIRC_DISCTIMEID (INT,13,'Circuit Max.Disc(ID)')
CIRC_DESC (CHAR,50,'Circuit Description')
CIRC_MAXZS (CHAR,5,'Max Permitted Zs (?)')
UNIQUE (SCHEDLINE,CONSUMERUNIT,USER)
;
/****/
/*#######################################*/
/*Menu: ALLCONST/ZCLA_GLOBALS/ZLIA_CERTGLOBALS*/
/*#######################################*/
/*ZLIA_CERTTYPE_OPT.F*/
CREATE TABLE ZLIA_CERTTYPE_OPT 'Certificate Types' 2
CERTTYPE (INT,13,'Certificate Type(ID)')
TYPENAME (CHAR,8,'Certificate Type')
AUTOUNIQUE (CERTTYPE)
UNIQUE (TYPENAME)
;
/****/
/*ZLIA_CERTSTAT_OPT.F*/
CREATE TABLE ZLIA_CERTSTAT_OPT 'Certificate Status' 2
CERTSTATUS (INT,13,'Cert Status (ID)')
STATNAME (CHAR,8,'Status')
AUTOUNIQUE (CERTSTATUS)
UNIQUE (STATNAME)
;
/****/
/*#######################################*/
/*Menu: RESOURCES--Project Management*/
/*#######################################*/
/*New table and options for certificates and storing certification #INCLUDE*/
/*ZLIA_COMMISSIONING.F*/
CREATE TABLE ZLIA_COMMISSIONING 'Plot Commissioning' 0
CERT (INT,13,'Certificate (ID)')
CERTNAME (CHAR,16,'Certificate No.')
CERTTYPE (INT,13,'Cert Type (ID)')
CERTSTAT (INT,13,'Cert Status (ID)')
CURDATE (DATE,14,'Last Act Date')
COMPLETE (CHAR,1,'Complete?')
PROJACT (INT,13,'Activity Plan (ID)')
AUTOUNIQUE (CERT)
UNIQUE (CERTNAME)
;
/****/