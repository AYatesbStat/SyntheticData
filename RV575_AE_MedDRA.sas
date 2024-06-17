/*******************************************************************************
PROGRAM NAME:   RV575_AE_MedDRA.sas       
AUTHOR:         FHU       
DATE WRITTEN:   August 2022
REVIEWED BY:
DATE REVIEWED:
WRITTEN FOR:           
PURPOSE:        export Mock AE data to add MedDRA coding for parallel programming 
								and import to create ae_coded.sas7bdat dataset   
OVERVIEW:              
.
INPUT DATA: 
OUTPUT DATA:           
RELIES ON:             
RELIED ON BY:          
SPECIAL INSTRUCTIONS:  

MODIFICATION HISTORY: 
DATE       MODIFIER    DESCRIPTION/REASON
---------- ----------- --------------------------------------------------------

*******************************************************************************/

libname datalive "/group/Stat/NEW/RV575/DataLive/MockData"; 
libname fmtlib   "/group/Stat/NEW/RV575/Formats"; 

data aeterm;
set datalive.ae;
aeterm=upcase(aeterm);
keep aeterm;
run;
proc sort nodupkey data=aeterm out=aetermout; by aeterm; run;
*export for coding;
/*
ods excel file="/group/Stat/NEW/RV575/DataLive/MockData/Mock_AE_Term.xlsx"  
        options(sheet_name="AE" sheet_interval="none"  frozen_headers="Yes" flow="tables");
        proc print data=aetermout noobs ;   
        var aeterm;
		run ; 
ods excel close;
*/
*import coded AE and merge with the AE dataset;
proc import datafile="/group/Stat/NEW/RV575/Processing/MockCode/Mock_AE_Term_coded.xlsx"
 out=meddra_code dbms=xlsx
 replace;
 getnames=Yes;
run;
data ae;
set datalive.ae;
aeterm=upcase(aeterm);
run;
proc sort data=ae; by aeterm subjid; run;
proc sort data=meddra_code; by aeterm; run;

data AE_coded;
	merge ae meddra_code;
	by aeterm;
run;
proc sort data=	AE_coded; by subjid aespid; run;
data datalive.ae_coded;
	set AE_coded;
run;
