/*ZLIA_PDV_DEFOPT/RCD_OPERATINGC/CHECK-FIELD*/
GOTO 999 WHERE :$.RCD_OPERATINGC = '30';
GOTO 999 WHERE :$.RCD_OPERATINGC = 'N/A';
ERRMSG 880;
LABEL 999;
ERRMSG 891 WHERE :$.RCD_RATEOPT_NAME = '';
ERRMSG 890 WHERE :$.RCD_RATEOPT_NAME = 'N/A' AND 
:$.RCD_OPERATINGC <> 'N/A';
ERRMSG 892 WHERE :$.RCD_RATEOPT_NAME <> 'N/A' AND 
:$.RCD_OPERATINGC = 'N/A';
/*#880: Permitted Values are N/A or 30 (mA).*/
/*#890: The RCD Rating value is set to N/A.*/
/*#891: The RCD Rating value is not set.*/
/*#892: The RCD Rating value is not set to N/A.*/
