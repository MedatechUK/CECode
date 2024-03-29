/****/
/* Add Columns to PART Table*/
FOR TABLE PART INSERT ZLIA_PDV_DEFID (INT,13, 'Prot.Device (ID)');
FOR TABLE PART INSERT ZLIA_CUDB_DEFID (INT,13,'CU/DB (ID)');
FOR TABLE PART INSERT ZLIA_CIRCCAB_DEFID (INT,13,'Circuit Cable (ID)');
FOR TABLE PART INSERT ZLIA_CIRC_DISCTIMEID (INT,13, 'Circuit Max.Disc(ID)');
FOR TABLE PART INSERT ZLIA_CIRC_WIRETYPID (INT,13, 'Circuit WireType(ID)');
FOR TABLE PART INSERT ZLIA_CIRC_REFMETHID (INT,13, 'Circuit Ref.Meth(ID)');
/****/
/* Add Column to ZCLA_CUNITCONFIG Table*/
FOR TABLE ZCLA_CUNITCONFIG INSERT WAYNO (INT,2,'Way No.');
/****/
/* Add Columns to ZCLA_PLOTCUCFG Table*/
FOR TABLE ZCLA_PLOTCUCFG INSERT DEVICE (INT,13,'Device (ID)');
FOR TABLE ZCLA_PLOTCUCFG INSERT WAYNO (INT,2,'Way No.');
/****/
/* Add Column to ZCLA_CUCONFIG_OPT Table*/
FOR TABLE ZCLA_CUCONFIG_OPT INSERT PDVSELECT (INT,13,'PDV Selection (ID)');
/****/
