/*ZLIA_CAB_CONFIG/POST-INSERT & POST-UPDATE*/
/*Skip update of cable des if :$.CABTYPENAME <> 'T&E'*/
GOTO 999 WHERE :$.CABTYPENAME <> 'T&E';
/*Skip update of cable des if :$.L_CABSIZE = 'N/A'*/
GOTO 999 WHERE :$.L_CABSIZE = 'N/A';
/*Skip update of cable des if :$.C_CABSIZE = 'N/A'*/
GOTO 999 WHERE :$.C_CABSIZE = 'N/A';
/*Update Description for T&E*/
UPDATE ZLIA_CAB_CONFIG 
SET CABLEDES = STRCAT(:$.L_CABSIZE, 'mm² ', :$.CABTYPENAME, 
' (', :$.C_CABSIZE, 'mm²)')
WHERE CABLEID = :$.CABLEID;
LABEL 999;
