/*ZLIA_CUDB_DEFOPT/PRE-INSERT + PRE-UPDATE*/

/*Has RCD=0 with RCD default option selected*/
ERRMSG 950 WHERE :$.CUDB_RCDS = '0' AND :$.RCD_PDV_DEFOPT > 0;
/*#950: Default RCD allocated where No.of RCDs = 0.*/

/*Has RCD>0 with no RCD default option selected*/
ERRMSG 951 WHERE :$.CUDB_RCDS = '1' AND :$.RCD_PDV_DEFOPT = 0;
ERRMSG 951 WHERE :$.CUDB_RCDS = '2' AND :$.RCD_PDV_DEFOPT = 0;
/*#951: No default RCD selected.*/

/*Has SPD='Yes' with no SPD default option selected*/
ERRMSG 952 WHERE :$.CUDB_SPD = 'Yes' AND :$.SPD_PDV_DEFOPT = 0;
/*#952: No default SPD selected.*/

/*Has SPD='No' with SPD default option selected*/
ERRMSG 953 WHERE :$.CUDB_SPD = 'No' AND :$.SPD_PDV_DEFOPT > 0;
/*#953: Default SPD allocated where no SPD.*/
