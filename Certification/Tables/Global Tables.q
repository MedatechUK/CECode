/*#######################################*/
/*Global Certification Tables*/
/*Menu: ALLCONST/ZCLA_GLOBALS/ZLIA_CERTGLOBALS*/
/*#######################################*/
/****/
/*ZLIA_PDV_BSENS.F*/
CREATE TABLE ZLIA_PDV_BSENS 'BS(EN) Options' 2
BSEN_ID (INT,13,'BS(EN) (ID)')
BSEN_NAME (CHAR,10,'BS(EN)')
BSEN_DES (CHAR,15,'BS(EN) Full')
OC_PROT (CHAR,1,'Overcurrent?')
RCD_PROT (CHAR,1,'Residual Current?')
SPD_PROT (CHAR,1,'Overvoltage?')
AUTOUNIQUE(BSEN_ID)
UNIQUE (BSEN_NAME)
;
/*ZLIA_PDV_BSENSTEXT Sub-Level to ZLIA_PDV_BSENS*/
CREATE TABLE ZLIA_PDV_BSENSTEXT 'BSEN Info' 2
BSEN_ID (INT,13,'BS(EN) (ID)')
TEXT (CHAR,68,'Comment')
TEXTLINE (INT,8,'TEXTLINE')
TEXTORD (INT,8,'TEXTORD')
UNIQUE (BSEN_ID,TEXTLINE)
;
/****/
/*ZLIA_PDV_CONFIG.F*/
CREATE TABLE ZLIA_PDV_CONFIG 'Prot.Device Options' 2
DEVTYPEID (INT,13,'Device Type (ID)')
DEVTYPENAME (CHAR,5,'Device Type Name')
OC_BSEN_ID (INT,13,'O/C BS(EN) (ID)')
RCD_BSEN_ID (INT,13,'RCD BS(EN) (ID)')
MCBWAY_D (CHAR,1,'MCB Way?')
AUTOUNIQUE(DEVTYPEID)
UNIQUE (DEVTYPENAME)
;
/*ZLIA_PDV_TYPES.F Sub-Level to ZLIA_PDV_CONFIG*/
CREATE TABLE ZLIA_PDV_TYPES 'Prot.Device Types' 2
TYPEOPT_ID (INT,13,'Device Type Opt (ID)')
DEVTYPEID (INT,13,'Device Type (ID)')
OC_TYPEOPT_NAME (CHAR,3,'O/C Type')
OC_TYPEOPT_DES (CHAR,8,'O/C Type Desc')
RCD_TYPEOPT_NAME (CHAR,3,'RCD Type')
RCD_TYPEOPT_DES (CHAR,8,'RCD Type Desc')
SPD_TYPEOPT_NAME (CHAR,3,'SPD Type')
SPD_TYPEOPT_DES (CHAR,8,'SPD Type Desc')
AUTOUNIQUE(TYPEOPT_ID)
UNIQUE (DEVTYPEID,OC_TYPEOPT_NAME,RCD_TYPEOPT_NAME,SPD_TYPEOPT_NAME)
;
/*ZLIA_PDV_RATES.F Sub-Level to ZLIA_PDV_CONFIG*/
CREATE TABLE ZLIA_PDV_RATES 'Prot.Device Ratings' 2
RATEOPT_ID (INT,13,'Device Rate Opt (ID)')
DEVTYPEID (INT,13,'Device Type (ID)')
OC_RATEOPT_NAME (CHAR,3,'O/C Rating (A)')
OC_RATEOPT_DES (CHAR,4,'O/C Rating Desc')
RCD_RATEOPT_NAME (CHAR,3,'RCD Rating (A)')
RCD_RATEOPT_DES (CHAR,4,'RCD Rating Desc')
AUTOUNIQUE(RATEOPT_ID)
UNIQUE (DEVTYPEID,OC_RATEOPT_NAME,RCD_RATEOPT_NAME)
;
/****/
/*ZLIA_CAB_TYPES.F*/
CREATE TABLE ZLIA_CAB_TYPES 'Cable Types' 2
CABTYPEID (INT,13,'Cable Type (ID)')
CABTYPENAME (CHAR,5,'Cable Type Code')
CABTYPEDES (CHAR,20,'Cable Type Desc')
CABCOATING (CHAR,15,'Cable Coating')
AUTOUNIQUE (CABTYPEID)
UNIQUE (CABTYPENAME)
;
/****/
/*ZLIA_CABCON_SIZES.F*/
CREATE TABLE ZLIA_CABCON_SIZES 'Cable Conductor Sizes' 2
CONSIZEID (INT,13,'Conductor Size (ID)')
CONSIZE (CHAR,4,'Conductor Size mm²')
AUTOUNIQUE (CONSIZEID)
UNIQUE (CONSIZE)
;
/****/
/*ZLIA_CAB_CONFIG.F*/
CREATE TABLE ZLIA_CAB_CONFIG 'Default Cable Options' 2
CABLEID (INT,13,'Cable (ID)')
CABTYPEID (INT,13,'Cable Type (ID)')
CABCOLID_O (INT,13,'Outer Color (ID)')
L_CABSIZEID (INT,13,'Live Conductor mm²')
C_CABSIZEID (INT,13,'CPC Conductor mm²')
CABLECORES (INT,2,'No.of Cores')
CABLEDES (CHAR,50,'Cable Desc')
CERTDEFAULT (CHAR,1,'EIC Default?')
AUTOUNIQUE (CABLEID)
UNIQUE (CABTYPEID,L_CABSIZEID,C_CABSIZEID)
;
/****/
/*ZLIA_CIRC_DISCTIMES.F*/
CREATE TABLE ZLIA_CIRC_DISCTIMES 'Circuit Max.Disconnect Times' 2
CIRC_DISCTIMEID (INT,13,'Circuit MaxDisc (ID)')
CIRC_DISCTIME_D (CHAR,3,'Max.Disconnection(s)')
AUTOUNIQUE (CIRC_DISCTIMEID)
UNIQUE (CIRC_DISCTIME_D)
;
/****/
/*ZLIA_CIRC_WIRETYPES.F*/
CREATE TABLE ZLIA_CIRC_WIRETYPES 'Circuit Type of Wiring Options' 2
CIRC_WIRETYPID (INT,13,'Wiring Type (ID)')
CIRC_WIRETYPNAME (CHAR,3,'Type of Wiring')
CIRC_WIRETYPDES (CHAR,70,'Type of Wiring Desc')
AUTOUNIQUE (CIRC_WIRETYPID)
UNIQUE (CIRC_WIRETYPNAME)
;
/****/
/*ZLIA_CIRC_REFMETHS.F*/
CREATE TABLE ZLIA_CIRC_REFMETHS 'Circuit Ref Method Options' 2
CIRC_REFMETHID (INT,13,'Ref.Method (ID)')
CIRC_REFMETHNAME (CHAR,3,'Reference Method')
CIRC_REFMETH_TE (CHAR,1,'T&E Only?')
CIRC_REFMETHDES (CHAR,120,'Reference Method Des')
AUTOUNIQUE (CIRC_REFMETHID)
UNIQUE (CIRC_REFMETHNAME)
;
/****/
/*#######################################*/
/*Global Part Tables*/
/*Menu: ALLCONST/ZCLA_GLOBALS/ZLIA_PARTGLOBALS*/
/*#######################################*/
/****/
/*ZLIA_PDV_DEFOPT.F*/
CREATE TABLE ZLIA_PDV_DEFOPT 'Default Prot.Device Options' 2
PDV_DEFID (INT,13,'Prot.Device (ID)')
DEVTYPEID (INT,13,'Device Type (ID)')
OC_TYPEOPT_ID (INT,13,'O/C Type (ID)')
OC_RATEOPT_ID (INT,13,'O/C Rating (ID)')
MAXPFCKA (CHAR,3,'Max PFC (kA)')
MAXPERMZS (REAL,6,2,'Max Permitted Zs')
RCD_TYPEOPT_ID (INT,13,'RCD Type (ID)')
RCD_RATEOPT_ID (INT,13,'RCD Rating (ID)')
RCD_OPERATINGC (CHAR,3,'RCD Oper.Curr (mA)')
PDV_DEFDES (CHAR,20,'Prot.Device Desc')
CU_OPT (CHAR,1,'CU Option?')
EIC_OPT (CHAR,1,'EIC Option?')
AUTOUNIQUE(PDV_DEFID)
UNIQUE (DEVTYPEID,OC_TYPEOPT_ID,OC_RATEOPT_ID,MAXPFCKA,RCD_TYPEOPT_ID,RCD_RATEOPT_ID,RCD_OPERATINGC)
;
/****/
CREATE TABLE ZLIA_CUDB_DEFOPT 'Default CU/DB Options' 2
CUDB_DEFID (INT,13,'CU/DB (ID)')
SPHASE (CHAR,6,'Phase')
CUDB_WAYS (INT,2,'No.of Ways')
CUDB_RCD (INT,1,'No.of RCDs')
RCD_PDV_DEFOPT (INT,13,'RCD Prot.Device (ID)')
CUDB_SPD (CHAR,3,'Has SPD?')
SPD_PDV_DEFOPT (INT,13,'SPD Prot.Device (ID)')
CUDB_DEFDES (CHAR,50,'CU/DB Description')
CUDB_RCDS (CHAR,1,'No of RCDs')
RCD_PDV_CHAR (CHAR,3,'RCD Prot.Dev (CHAR)')
AUTOUNIQUE (CUDB_DEFID)
UNIQUE (SPHASE,CUDB_WAYS,CUDB_RCDS,RCD_PDV_CHAR,CUDB_SPD)
;
/****/