/*********************************************************************************************************************
 PROGRAM NAME: 		   RV575 Mock Data Code          
 AUTHOR:               Misti Paudel
 DATE WRITTEN:         10May2022
 REVIEWED BY:		
 DATE REVIEWED:		
 WRITTEN FOR:          RV575 
 PURPOSE:              To develop a mock data set for RedCAP output that can be used by programming team to derive SDTM data sets 
 OVERVIEW:             This study is designed to identify the minimal optimal dose (dose de-escalation) for ALFQ adjuvant in HIV 
 					   vaccines to maintain safety outcomes, and reduce costs of production in future vaccine development, since 
 					   production can be complex and expensive and could greatly impact vaccine supply.  Therefore, this study is 
 					   designed to evaluate outcomes of safety, tolerability and immunogenicity of three different dose levels of 
 					   ALFQ in a population of healthy adults without HIV. 
                                          
 INPUT DATA:          Not applicable  
 OUTPUT DATA:         Datalive/MockData   
 RELIES ON:             
 RELIED ON BY:          
 SPECIAL INSTRUCTIONS:  
                        
 MODIFICATION HISTORY:  
 DATE       MODIFIER    DESCRIPTION/REASON
 ---------- ----------- -----------------------------------------------------------------------------------------------------------------
05/10/2022	MLP 		Set up files and start generating some data 
06/01/2022  MLP			Dusting this off, integrate Adam's gender flag for N=60 randomized, construct the sentinel group, 
						Finish constructing datasets: ;
06/03/2022	MLP			Mocking up some figures for SMC TLFs
06/07/2022	MLP			Import datasets Suteera constructed and convert to SAS files
06/08/2022	MLP			Working on inclusion criteria, noticed some issues with randomization file, not sure why 
06/09/2022  MLP 		Debugging randomization file - need to comment out code once i run it or it will cause problems
06/10/2022	MLP			Finished inclusion, exclusion, enrollment files and uploaded Systemic reactions (IRS)
6/22/2022	MLP			Construct Participant Status Change file 
07/06/2022	MLP			Review and fix inconsistencies with local reactions file 
08/29/2022	MLP			Randomization file - make randgroup numeric; demographics rename dmdat
09/27/2022	MLP			Request from Fengming to create some controlled havoc in chemistry and hematology datasets 
 *************************************************************************************************************************************/
libname Mockdata "/group/Stat/NEW/RV575/DataLive/MockData";                                 
libname datalive "/group/Stat/NEW/RV575/DataLive";
libname myfile "C:/Users/mpaudel/OneDrive - Henry M. Jackson Foundation for the Advancement of Military Medicine/Desktop/RV575";
libname formats "/group/Stat/NEW/RV575/Formats/RV575_Formats"; 
run;

*************************************************************************************
SMC requested three figures be added to the TLF file, so I am mocking up some 
data to generate those figures
************************************************************************************;
*Import mock file for Figure 1; 
/*
FILENAME f1'/group/Stat/NEW/RV575/DataLive/MockData/Table1_fig1.xlsx';

PROC IMPORT DATAFILE=f1
	DBMS=XLSX
	OUT=mockdata.f1;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.f1; RUN;

data mockdata.f1; set mockdata.f1;
  countn = input(count, 8.);
  run;

Proc format ;
	value a 0='Pre-vac'
			  1='Post-vac'
			  2='Day 1'
			  3='Day 2'
			  4='Day 3'
			  5='Day 4'
			  6='Day 5'
			  7='Day 6'
			  8='Day 7'
			  9='Day 8'
			  10='Day 9'
			  11='Day 10'
			  12='Day 11'
			  13='Day 12'
			  14='Day 13'
			  15='Day 14';
	
	value b 1='Injection 1 (N= )'
			2='Injection 2 (N= )'
			3='Injection 3 (N= )';
	
	Run;


proc SGPANEL data=mockdata.f2; 
   PANELBY injection / ROWS=1 COLUMNS=3 sort=data; 
   styleattrs datacolors=(yellow orange red); 
   hbar day / response=count group = severity ; 
   colaxis min=0 max=100 LABEL="Percentage of Participants"; 
   rowaxis LABEL="Study Day";
   format day a. ; 
Run;


FILENAME f2b'/group/Stat/NEW/RV575/DataLive/MockData/table2_fig2.xlsx';

PROC IMPORT DATAFILE=f2b
	DBMS=XLSX
	OUT=mockdata.f2b;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.f2b; RUN;

proc SGPLOT data=mockdata.f2b; 
   styleattrs datacolors=(yellow orange red); 
   hbar symptoms / response=count group = severity ; 
   xaxis min=0 max=100 LABEL="Percentage of Participants"; 
   yaxis LABEL="Symptoms";
Run;

FILENAME f3'/group/Stat/NEW/RV575/DataLive/MockData/table3_fig3.xlsx';

PROC IMPORT DATAFILE=f3
	DBMS=XLSX
	OUT=mockdata.f3;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.f3; RUN;

options orientation=landscape;
proc SGPANEL data=mockdata.f3; 
   PANELBY day / ROWS=2 sort=data onepanel ; 
   styleattrs datacolors=(yellow orange red); 
   hbar lab / response=count group = severity datalabelfitpolicy=none;
   colaxis min=0 max=100 LABEL="Percentage of Participants"; 
   rowaxis LABEL="Laboratory Parameters" display=ALL;
 Run;

*****************************************************************************************;
*Import data files Suteera constructed and convert to SAS datasets
******************************************************************************************;

FILENAME irl '/group/Stat/NEW/RV575/DataLive/MockData/irl.xls';
PROC IMPORT DATAFILE=irl
	DBMS=XLS
	OUT=mockdata.irl;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.irl; RUN;

FILENAME lbchm '/group/Stat/NEW/RV575/DataLive/MockData/lbchm.xls';
PROC IMPORT DATAFILE=lbchm
	DBMS=XLS
	OUT=mockdata.lbchm;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.lbchm; RUN;

FILENAME lbhem '/group/Stat/NEW/RV575/DataLive/MockData/lbhem.xls';
PROC IMPORT DATAFILE=lbhem
	DBMS=XLS
	OUT=mockdata.lbhem;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.lbhem; RUN;
Proc tabulate data=mockdata.lbhem_orig; 
var lbrbc lbwbc lbhgb lbhct lbmcv lbmch lbmchc lbrdw lbplt lbmpv lbneutpct lblympct lbmonopct lbeospct lbbasopct; 
table lbrbc lbwbc lbhgb lbhct lbmcv lbmch lbmchc lbrdw lbplt lbmpv lbneutpct lblympct lbmonopct lbeospct lbbasopct, 
n nmiss min median max ; 
run; 

FILENAME lbhep '/group/Stat/NEW/RV575/DataLive/MockData/lbhep.xls';
PROC IMPORT DATAFILE=lbhep
	DBMS=XLS
	OUT=mockdata.lbhep;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.lbhep; RUN;
Proc freq data=mockdata.lbhep; 
tables enr*(hbv_lborres hcv_lborres hcv_conf_lborres)/missing; 
where visit=0;
run; 

FILENAME lbhiv '/group/Stat/NEW/RV575/DataLive/MockData/lbhiv.xls';
PROC IMPORT DATAFILE=lbhiv
	DBMS=XLS
	OUT=mockdata.lbhiv;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.lbhiv; RUN;
Proc freq data=mockdata.lbhiv; tables enr*lbhivstat lbrnapcr /missing; 
where visit=0; run;

FILENAME vac '/group/Stat/NEW/RV575/DataLive/MockData/vac.xls';
PROC IMPORT DATAFILE=vac
	DBMS=XLS
	OUT=mockdata.vac;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.vac; RUN;


FILENAME irs '/group/Stat/NEW/RV575/DataLive/MockData/irs.xls';
PROC IMPORT DATAFILE=irs
	DBMS=XLS
	OUT=mockdata.irs;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.irs; RUN;
*/
*******************************************************************************************;
************************************************************************************************
*Generate a list of ids for 150 potential patients who will be screened
************************************************************************************************;
/*
data id; 
call streaminit(123);   
do i = 1 to 150; 
	study = "575"; 
	i2 = put(i, z4.);   *create a new ID variable that adds leading zeros, 4 digits;
	subjid = put(study,3.) || '-' || Put(i2,4.);
	x = rand("Uniform");   *creating a random number between 0 and 1 that i can use later on to cut variables; 
	output;
end;
drop i i2 study; 
run; 
*/

******************************************************************************************************************************************************
Generate Informed Consent "CO" Dataset
******************************************************************************************************************************************************;
*Generate a date of consent, and get a little fancy to make sure algorithm is picking only weekdays, and excluding Holidays; 
/*
data consent_date; 
start = '01JUN2022'd; 
end= '31OCT2022'd; 
interval=end - start;
hi='04JUL2022'd; *independence day;
hl='05SEP2022'd; *Labor day;
hc='10OCT2022'd; *Columbus Day;
 
do i= 1 to 150; 
	covisdat1 = start + floor(ranuni(123) * interval);  *Consent date generated based on uniform distribution, floor 
	needed to make it pick whole days;
	day=weekday(covisdat1); 
	output;
end;
format start date9. end date9. hi date9. hl date9. hc date9. covisdat1 date9.; 
run; 

data consent_date1; set consent_date; 
*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day=7 then covisdat2=covisdat1 - 1; 
	else if day=1 then covisdat2 = covisdat1 + 1; 
	else covisdat2=covisdat1; 
*Three holidays occurr during time period, all are on Mondays, push these an additional day.  If people are getting pushed forward to
Holiday due to weekend recode above, they get pushed an additional day; 
if covisdat2=hi|covisdat2=hl|covisdat2=hc then covisdat=covisdat2 + 1;  
	else covisdat=covisdat2;
day2= weekday(covisdat);
format covisdat date9.;
drop start end interval hi hl hc day i covisdat1 covisdat2 day2; 
run; 
proc sort data=consent_date1; by covisdat; run;
 

data ic_a; merge id consent_date1; 
redcap_event_name = "screening_visit_arm_1"; 
codat=covisdat;      *assumption that consent signed same date as consent visit;

*Consent for future use of samples, assume 1% say no; 
cofutsample= .; 
	if x GE 0.99 then cofutsample = 0; else cofutsample=1; 

*Consent for future genetic testing of samples, assume 1.5% say no; 
cofutgenetic = .;
	if x GE 0.985 then cofutgenetic=0; else cofutgenetic=1; 

*Informed consent complete, we don't need it, set to missing;
informed_consent_complete = .; 
	
format codat mmddyy10. covisdat mmddyy10.; 
 
run; 
proc freq data=ic_a; tables cofutsample*cofutgenetic*informed_consent_complete/missing list ; run; 

*Save as a permanent dataset; 
/*
data mockdata.co; set ic_a;
drop x; 
run;  
*/
******************************************************************************************************************************************************
Generate Randomization Data 
N=60, randomized 1:1:1

Originally this code was run to create the file and then the file was passed to Adam and Suteera for construction of other datasets. 
Unfortunately somehow this code got rerun again and messed up, and fixing it now would cause a big problem.  
Taking the randomized ID's from Adam and Suteera and populating a new file.  
My saving grace is that I downloaded a copy of the visit dates file to Hansen.  Will upload and use that to recreate the files;
******************************************************************************************************************************************************;
/*  *importing and reconstructing visit dates file in order to recreate randomization file; 
FILENAME vdates '/group/Stat/NEW/RV575/DataLive/MockData/visitdates2.xlsx';
PROC IMPORT DATAFILE=vdates
	DBMS=XLSX
	OUT=mockdata.visitdates2;
	GETNAMES=YES;
RUN;
PROC print DATA=mockdata.visitdates2; RUN;
*/

*Randomize sentinel group;
proc plan seed= 12345678;
factors
strat=1 ordered  /*Strata*/
blocks=1 ordered /*Number of times blocks required to achieve total sample size*/
bsize=6 ordered /*Block size. This number matches the treatment number, so that every treatment is represented in
each block*/;
treatments trt=6;  *I'm being lazy - 4 of these treatments are active, and one is placebo;
output out=rlist1a;
run; quit;

*Randomize rebalancing group; 
proc plan seed= 12345678;
factors
strat=1 ordered  /*Strata*/
blocks=1 ordered /*Number of times blocks required to achieve total sample size*/
bsize=9 ordered /*Block size. This number matches the treatment number, so that every treatment is represented in
each block*/;
treatments trt=9;  *I'm being lazy - 4 of these treatments are active, and one is placebo;
output out=rlist1b;
run; quit;

*Randomize remaining participants;
proc plan seed= 12345678;
factors
strat=1 ordered  /*Strata*/
blocks=15 ordered /*Number of times blocks required to achieve total sample size*/
bsize=3 ordered /*Block size. This number matches the treatment number, so that every treatment is represented in
each block*/;
treatments trt=3;  *I'm being lazy - 4 of these treatments are active, and one is placebo;
output out=rlist2;
run; quit;

*clean up output, Sentinel group;
data random1a;
length treatment $ 11 stratification $ 11;
set rlist1a;
If trt in (1) then randgroup = 'Group 1';
ELSE if trt in (2) then randgroup = 'Group 1';
else if trt in (3) then randgroup = 'Group 1'; 
else if trt in (4) then randgroup = 'Group 1';
else if trt in (5) then randgroup = 'Group 2';
else if trt in (6) then randgroup = 'Group 3';
run;

*clean up output, rebalancing group;
data random1b;
length treatment $ 11 stratification $ 11;
set rlist1b;
If trt in (1) then randgroup = 'Group 1';
ELSE if trt in (2) then randgroup = 'Group 2';
else if trt in (3) then randgroup = 'Group 2'; 
else if trt in (4) then randgroup = 'Group 2';
else if trt in (5) then randgroup = 'Group 2';
else if trt in (6) then randgroup = 'Group 3';
else if trt in (7) then randgroup = 'Group 3';
else if trt in (8) then randgroup = 'Group 3';
else if trt in (9) then randgroup = 'Group 3';
run;
*clean up output;
data random2;
length treatment $ 11 stratification $ 11;
set rlist2;
If trt in (1) then randgroup = 'Group 1';
ELSE if trt in (2) then randgroup = 'Group 2';
else if trt in (3) then randgroup = 'Group 3'; 
run;

Proc append base=random1a data=random1b ; run;
proc freq data=random1a; tables randgroup; run;
proc append base=random1a data=random2; run;
proc freq data=random1a; tables randgroup; run;
 
data rand0; set random1a(keep=randgroup); run; 
data rand1; set mockdata.visitdates2 (keep=subjid covisdat randdat );
where randdat ne .;  *subset to N=60;
randelig = 1; 
run; 

data rand3; merge rand1 rand0; 
*randomly assign a time of randomization;
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are randomizing between 8-4 business hours; 
randtim = start_time + RAND('uniform')*timeinterval; 
format start_time time5. randtim time5.; 
run;

data all; set mockdata.visitdates2 (keep=subjid covisdat randdat);
run; 
data randomization; merge rand3 all; by subjid; 
randomization_complete=2; 
randvisdat = randdat; 
drop covisdat start_time timeinterval; 
run;

*Save permanately; 
/*
data mockdata.randomization; set randomization; 
run;
*/

*********************************************************************************************************************************
Make randgroup numeric instead of character:  8/29/2022 MLP
*********************************************************************************************************************************; 

data mockdata.randomization; set mockdata.randomization; 
rename randgroup = randgroup_old; 
run;

data mockdata.randomization; set mockdata.randomization;
if randgroup_old = "Group 1" then randgroup=1; else
if randgroup_old = "Group 2" then randgroup=2; else 
if randgroup_old = "Group 3" then randgroup=3; else randgroup=.; 
drop randgroup_old;
run;
/*proc freq data=rand; tables randgroup_old*randgroup/missing; run; */



/*
data rand1; merge id (keep=subjid x) mockdata.co (keep=subjid covisdat);
by subjid; 
if x LE 0.46 then randomized=1; else randomized=0;  /*Subset to my target population of 60 enrolled individuals
run;
data rand1; set rand1; 
where randomized=1; 
randelig = 1; 

/*Randomization is 1:1:1, ignoring sentinel group and all that for now
if 0 <= x < 0.118 then randgroup="Group 1"; else
if 0.118 <= x < 0.307 then randgroup="Group 2"; else
if x >= 0.307 then randgroup="Group 3";

*Randomization date is 3 - 30 days after screening; 
interval2 = 30 - 3 + 1; 
randdat1 = covisdat + 3 + floor(RAND('uniform') * interval2);  
dayr=weekday(randdat1);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if dayr=7 then randdat2=randdat1 - 1; 
	else if dayr=1 then randdat2=randdat1 + 1; 
	else randdat2=randdat1; 
*Five federal holidays occur during time period, three are on Mondays, push these an additional day.  If people are getting pushed forward to
Holiday due to weekend recode above, they get pushed an additional day; 
hi='04JUL2022'd; *independence day, falls on a MOnday, push forward;
hl='05SEP2022'd; *Labor day, falls on a Monday, push forward*
hc='10OCT2022'd; *Columbus Day, Falls on a Monday, push forward*
hv='11NOV2022'd; *Veteran's Day, Falls on a Friday, push back to Thursday*
ht='24NOV2022'd; *Thanksgiving Day, Falls on a Thursday, push forward*

if randdat2=hi|randdat2=hl|randdat2=hc|randdat2=ht then randdat=randdat2 + 1; 
	else if randdat2=hv then randdat = randdat2 - 1;  
	else randdat=randdat2;
	
dayr2= weekday(randdat);
datediff = randdat - covisdat; 
format randdat date9.;

*randomly assign a time of randomization;
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are randomizing between 8-4 business hours; 
randtim = start_time + RAND('uniform')*timeinterval; 
format start_time time5. randtim time5.; 
run;
proc freq data=rand1; tables x randgroup randelig dayr dayr2; run;
Proc tabulate data=rand1; 
var datediff  ;
table datediff, 
	n nmiss mean std median p25 p75 min max ; 
run;
*/
/*
*Save a permanent dataset; 
data mockdata.rand; set rand1;
drop covisdat x interval2 randdat1 start_time timeinterval datediff dayr dayr2 randdat2 hi hl hc hv ht ; 
run;  
*/

data rand1; set mockdata.demogsim (keep=subjid randdat); 
randelig = 1; 
rename randdat=randdat1; 
/*Randomization is 1:1:1, ignoring sentinel group and all that for now
if 0 <= x < 0.118 then randgroup="Group 1"; else
if 0.118 <= x < 0.307 then randgroup="Group 2"; else
if x >= 0.307 then randgroup="Group 3"; */

run; 

data check; merge rand1 mockdata.visitdates; by subjid; 
run;

******************************************************************************************************************************************************
Generate Visit dates to be used across other databases
Start by creating a wide dataset and then we can convert to long if we need to
******************************************************************************************************************************************************;

/*
data visitdates; merge rand1 (keep=subjid randdat) ic_a (keep= subjid covisdat) ;
by subjid; 

*Generate visit 2 date, 15 days post randomization +/- 3 days; 
intervalv2 = 6; 
visitdat2a = randdat + 12 + floor(RAND('uniform') * intervalv2);  
day=weekday(visitdat2a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day=7 then visitdat2b=visitdat2a - 1; 
	else if day=1 then visitdat2b=visitdat2a + 1; 
	else visitdat2b=visitdat2a; 
	
*Five federal holidays occur during time period, three are on Mondays, push these an additional day.  If people are getting pushed forward to
Holiday due to weekend recode above, they get pushed an additional day; 
hi='04JUL2022'd; /*independence day, falls on a MOnday, push forward 
hl='05SEP2022'd; /*Labor day, falls on a Monday, push forwar
hc='10OCT2022'd; /*Columbus Day, Falls on a Monday, push forward
hv='11NOV2022'd; /*Veteran's Day, Falls on a Friday, push back to Thursday
ht='24NOV2022'd; /*Thanksgiving Day, Falls on a Thursday, push forward
hc='26DEC2022'd; /*Christmas Day observed, falls on a Monday
hny='02JAN2023'd; /*New Years Day Observed, Falls on a MOnday
hmlk='16JAN2023'd; /*MLK day, falls on a Monday
hp='20FEB2023'd; /*Presidents day, falls on a Monday
hmd='29MAY2023'd; /*Memorial day, falls on a Monday
hj='19JUN2023'd; /*Juneteenth, falls on a Monday
hi2='04JUL2023'd; /*independence day, falls on a Tuesday, push forward 
hl2='04SEP2023'd; /*Labor day, falls on a Monday, push forward
hc2='9OCT2023'd; /*Columbus Day, Falls on a Monday, push forward
hv2='10NOV2023'd; /*Veteran's Day, Falls on a Friday, push back to Thursday
ht2='23NOV2023'd; /*Thanksgiving Day, Falls on a Thursday, push forward
hc2='25DEC2023'd; /*Christmas Day , falls on a Monday

if visitdat2b=hi|visitdat2b=hl|visitdat2b=hc|visitdat2b=ht then visitdat2=visitdat2b + 1; 
	else if visitdat2b=hv then visitdat2 = visitdat2b - 1;  
	else visitdat2=visitdat2b;
	
day2= weekday(visitdat2);
datediff = visitdat2 - randdat; 

*Generate Visit 3 date, 29 days +/7 from randomization; 
intervalv3 = 14; 
visitdat3a = randdat + 22 + floor(RAND('uniform') * intervalv3);  
day3=weekday(visitdat3a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day3=7 then visitdat3b=visitdat3a - 1; 
	else if day3=1 then visitdat3b=visitdat3a + 1; 
	else visitdat3b=visitdat3a; 

if visitdat3b=hi|visitdat3b=hl|visitdat3b=hc|visitdat3b=ht then visitdat3=visitdat3b + 1; 
	else if visitdat3b=hv then visitdat3 = visitdat3b - 1;  
	else visitdat3=visitdat3b;
	
day3r= weekday(visitdat3);
datediff3 = visitdat3 - randdat;

*Generate Visit 4 date, 43 days +/6 from randomization; 
intervalv4 = 6; 
visitdat4a = randdat + 43 + floor(RAND('uniform') * intervalv4);  
day4=weekday(visitdat4a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day4=7 then visitdat4b=visitdat4a - 1; 
	else if day4=1 then visitdat4b=visitdat4a + 1; 
	else visitdat4b=visitdat4a; 

if visitdat4b=hi|visitdat4b=hl|visitdat4b=hc|visitdat4b=ht|visitdat4b=hc|visitdat4b=hny|visitdat4b=hmlk then visitdat4=visitdat4b + 1; 
	else if visitdat4b=hv then visitdat4 = visitdat4b - 1;  
	else visitdat4=visitdat4b;
	
day4r= weekday(visitdat4);
datediff4 = visitdat4 - randdat;

*Generate Visit 5 date, 57 days +/-7 from randomization; 
intervalv5 = 14; 
visitdat5a = randdat + 50 + floor(RAND('uniform') * intervalv5);  
day5=weekday(visitdat5a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day5=7 then visitdat5b=visitdat5a - 1; 
	else if day5=1 then visitdat5b=visitdat5a + 1; 
	else visitdat5b=visitdat5a; 

if visitdat5b=hi|visitdat5b=hl|visitdat5b=hc|visitdat5b=ht|visitdat5b=hc|visitdat5b=hny|visitdat5b=hmlk then visitdat5=visitdat5b + 1; 
	else if visitdat5b=hv then visitdat5 = visitdat5b - 1;  
	else visitdat5=visitdat5b;
	
day5r= weekday(visitdat5);
datediff5 = visitdat5 - randdat;

*Generate Visit 6 date, 58-59 days from randomization; 
intervalv6 = 1; 
visitdat6a = randdat + 58 + floor(RAND('uniform') * intervalv6);  
day6=weekday(visitdat6a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day6=7 then visitdat6b=visitdat6a - 1; 
	else if day6=1 then visitdat6b=visitdat6a + 1; 
	else visitdat6b=visitdat6a; 

if visitdat6b=hi|visitdat6b=hl|visitdat6b=hc|visitdat6b=ht|visitdat6b=hc|visitdat6b=hny|visitdat6b=hmlk then visitdat6=visitdat6b + 1; 
	else if visitdat6b=hv then visitdat6 = visitdat6b - 1;  
	else visitdat6=visitdat6b;
	
day6r= weekday(visitdat6);
datediff6 = visitdat6 - randdat;

*Generate Visit 7 date, 64 days from randomization, +/- 3d; 
intervalv7 = 6; 
visitdat7a = randdat + 61 + floor(RAND('uniform') * intervalv7);  
day7=weekday(visitdat7a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day7=7 then visitdat7b=visitdat7a - 1; 
	else if day7=1 then visitdat7b=visitdat7a + 1; 
	else visitdat7b=visitdat7a; 

if visitdat7b=hi|visitdat7b=hl|visitdat7b=hc|visitdat7b=ht|visitdat7b=hc|visitdat7b=hny|visitdat7b=hmlk then visitdat7=visitdat7b + 1; 
	else if visitdat7b=hv then visitdat7 = visitdat7b - 1;  
	else visitdat7=visitdat7b;
	
day7r= weekday(visitdat7);
datediff7 = visitdat7 - randdat;

*Generate Visit 8 date, 71 days from randomization, +/- 3d; 
intervalv8 = 6; 
visitdat8a = randdat + 68 + floor(RAND('uniform') * intervalv8);  
day8=weekday(visitdat8a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day8=7 then visitdat8b=visitdat8a - 1; 
	else if day8=1 then visitdat8b=visitdat8a + 1; 
	else visitdat8b=visitdat8a; 

if visitdat8b=hi|visitdat8b=hl|visitdat8b=hc|visitdat8b=ht|visitdat8b=hc|visitdat8b=hny|visitdat8b=hmlk then visitdat8=visitdat8b + 1; 
	else if visitdat8b=hv then visitdat8 = visitdat8b - 1;  
	else visitdat8=visitdat8b;
	
day8r= weekday(visitdat8);
datediff8 = visitdat8 - randdat;

*Generate Visit 9 date, 169 days from randomization, +/- 7d; 
intervalv9 = 14; 
visitdat9a = randdat + 162 + floor(RAND('uniform') * intervalv9);  
day9=weekday(visitdat9a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day9=7 then visitdat9b=visitdat9a - 1; 
	else if day9=1 then visitdat9b=visitdat9a + 1; 
	else visitdat9b=visitdat9a; 

if visitdat9b=hi|visitdat9b=hl|visitdat9b=hc|visitdat9b=ht|visitdat9b=hc|visitdat9b=hny|visitdat9b=hmlk then visitdat9=visitdat9b + 1; 
	else if visitdat9b=hv then visitdat9 = visitdat9b - 1;  
	else visitdat9=visitdat9b;
	
day9r= weekday(visitdat9);
datediff9 = visitdat9 - randdat;

*Generate Visit 10/EXIT date, 337 days from randomization, +/- 7d; 
intervalv10 = 14; 
visitdat10a = randdat + 330 + floor(RAND('uniform') * intervalv10);  
day10=weekday(visitdat10a);

*if a saturday date was randomly selected, push back to Friday, if sunday was selected push forward to Monday; 
if day10=7 then visitdat10b=visitdat10a - 1; 
	else if day10=1 then visitdat10b=visitdat10a + 1; 
	else visitdat10b=visitdat10a; 

if visitdat10b=hi|visitdat10b=hl|visitdat10b=hc|visitdat10b=ht|visitdat10b=hc|visitdat10b=hny|visitdat10b=hmlk|visitdat10b=hp|
visitdat10b=hmd|visitdat10b=hj|visitdat10b=hi2|visitdat10b=hl2|visitdat10b=hc2 then visitdat10=visitdat10b + 1; 
	else if visitdat10b=hv then visitdat10 = visitdat10b - 1;  
	else visitdat10=visitdat10b;
	
day10r= weekday(visitdat10);
datediff10 = visitdat10 - randdat;

format visitdat2 date9. visitdat3 date9. visitdat4 date9. visitdat5 date9. visitdat6 date9. visitdat7 date9. visitdat8 date9. visitdat9 date9. visit10 date9.;
run;
Proc freq data=visitdates; tables day2 day3r day4r day5r day6r day7r day8r day9r day10r; run; 
proc means data=visitdates min median max; var datediff datediff3 datediff4 datediff5 datediff6 datediff7 datediff8 datediff9 datediff10; run;

proc tabulate data=visitdates;
var covisdat randdat visitdat2 visitdat3 visitdat4 visitdat5 visitdat6 visitdat7 visitdat8 visitdat9 visitdat10;
table covisdat randdat visitdat2 visitdat3 visitdat4 visitdat5 visitdat6 visitdat7 visitdat8 visitdat9 visitdat10,
 n nmiss (min median max)*f=date9. range;
run; 

*Save as a permanent dataset; 
data mockdata.visitdates; set visitdates; 
keep subjid covisdat randdat visitdat2 visitdat3 visitdat4 visitdat5 visitdat6 visitdat7 visitdat8 visitdat9 visitdat10;
format visitdat10 date9.; 
run;

*Output some excel files for Suteera;
proc export data=mockdata.visitdates
outfile='/group/Stat/NEW/RV575/DataLive/MockData/visitdates.xlsx'  
dbms=xlsx replace;
run;
*/

*****************************************************************************************************************************************************
Recode Demographics file, constructed by Adam
*****************************************************************************************************************************************************;
/*
data mockdata.dm; set mockdata.demogsim; 

*reset randomization date to demdat;
demdat=randdat;

*Adam coded gender identity as 1,2,3,  need to recode as 0=Male,1=Female,2=Transgender;
if gender=1 then gender=0; else 
if gender=2 then gender=1; else
if gender=3 then gender=2; 

if biosex=1 then sex=0; else
if biosex=2 then sex=1; else 
if biosex=3 then sex=2; 

if ethnic= 1 then ethnic=0; else
if ethnic= 2 then ethnic=1; 

if race=7 then race=99; else race=race; 

drop biosex agecat ; 
run;
proc freq data=mockdata.dm; 
tables gender sex ethnic race race1 race2 race3 race4 race5 edlevel_scorres occup/missing;
run;
*/

*rename demdat to dmdat, 8/29/2022 MLP; 
data mockdata.dm; set mockdata.dm; 
rename demdat = dmdat;
run; 

******************************************************************************************************************************************************
Generate Inclusion Criteria "IC" Dataset
******************************************************************************************************************************************************;
*Inclusion criteria assessed at screening, same date;
data dem; set mockdata.dm (keep = subjid sex age ); run; /*N=60 ids*/
proc means data=dem min median max; var age; run;
proc freq data=dem; tables sex; run; 
data vdates; set mockdata.visitdates2 (keep= subjid covisdat ); run;  /*N = 150 ids*/
data hiv ; set mockdata.lbhiv (keep=subjid lbhivstat visit enr); where visit=0; run;
data hcv; set mockdata.lbhep (keep=subjid hbv_lborres hcv_lborres visit enr); where visit=0; run;
data rand; set mockdata.randomization (keep=subjid randdat randelig); run; 

data ic_c; merge vdates (in=a) dem hiv hcv rand; by subjid; 
if a; 
rename covisdat = icvisdat; 

/*Generate a random number for ID's that don't end up getting enrolled - going to use that to parse out values below
Tricky bit is that I didn't set a seed for original random number, so this wont align well*/
if randelig=. then x = rand("Uniform");  

*for inclusion criteria, I'm going to leave about 20% in to be excluded with exclusion criteria;  

*Generate an age variable and sex variable for those not enrolled in the study; 
*age, I want 15% to be excluded due to age outside of the range; 
if randelig NE 1 & 0.70 <= x < 0.85 then age= rand("Integer", 56, 75); else 
if randelig NE 1 & x<0.70|x>=0.85 then age=rand("Integer", 18, 55); 

*Age eligible, 1=Yes, 0=No, currently all enrolled patients meet age criteria, 
but among those that don't qualify, I assume 15% are not age eligible; 
icage=.; 
if age GT 55|age LT 18 then icage = 0; else icage=1; 

*Generate a value for sex for ineligible persons.  Assume 43% male, 46% female, and 1% trans; 
if 0< x <=0.43 then sex = 0; else 
if 0.43 < x <0.98 then sex=1; else 
if x>=0.98 then sex=2; 

*Low risk for HIV, 1= yes, 0=no, Assume 25% of ineligible population are NOT low risk of HIV; 
ichivrisk = .; 
if . <= x < 0.75 then ichivrisk=1; else ichivrisk=0; 

*Informed consent, 1=yes, 0=no, Assume 5% don't provide informed consent; 
icinfcon = .; 
if .<= x < 0.85 | 0.90 <= x < 1.0 then icinfcon=1; else icinfcon=0; 

*Assume same people who can't provide consent also don't comply; 
iccomply = icinfcon; 

*Assume 10% don't agree to refrain from blood donation; 
icblooddon = .;  
if . <= x < 0.75 | 0.85 <= x < 1.0 then icblooddon=1; else icblooddon=0; 

*Assume 3% don't meet weight criteria; 
icweight = .; 
if 0.60 <= x < 0.64 then icweight=0; else icweight=1; 

*Exclusion criteria due to labs needs to align with file that Suteera constructed.
For ease, I'm going to assume nobody gets excluded due to labs; 
  
*Hemoglobin; 
ichgb = 1; 

*WBC count criteria; 
icwbc = 1;

*platelets; 
icplt = 1; 

*ALT; 
icalt = 1; 

*Creatinine; 
iccreatin = 1; 

*HIV negative, align with HIV lab flag constructed by Suteera in the HIV results file; 
icneghiv = .; 
if lbhivstat = 0 then icneghiv=1; else if lbhivstat=1 then icneghiv=0; 

*HepB and C negative, with alignment with labs ; 
hepbc= hbv_lborres + hcv_lborres; 
if hepbc=0 then ichbsaghepc = 1; else 
if hepbc in (1,2,3) then ichbsaghepc=0;

*Females must meet criteria of no reproductive potential due to menopause or hysterectomy; 
if sex in (0,2) then icpostmenop=98; else 
if sex=1 & age GE 50 then icpostmenop=1; else 
if sex=1 & age LT 50 & randelig=1 then icpostmenop=1; else
if sex=1 & age LT 50 & randelig=0 & 0<=x<0.50 then icpostmenop=1; else
if sex=1 & age LT 50 & randelig=0 & x>=0.50 then icpostmenop=0;
 
if sex in(0,2) then iccontracep=98; else
if sex=1 & age LT 50 then iccontracep=1; else
if sex=1 & age GE 50 & randelig=1 then iccontracep=1; else 
if sex=1 & age GE 50 & randelig=0 & 0<=x<0.50 then iccontracep=1; else
if sex=1 & age GE 50 & randelig=0 & x>=0.50 then iccontracep=0;

icsafesex=1; 

if sex in(0,2) then icnegbhcg=98; else
if sex=1 & randelig=1 then icnegbhcg=1; else
if sex=1 & randelig=. & age LT 50 then icnegbhcg=1; else
if sex=1 & randelig=. & age GE 50 then icnegbhcg=0; 

ictravel=1;
ictou=1; 

if icage = 0 or ichivrisk = 0 or icinfcon = 0 or iccomply = 0 or icblooddon = 0 or icweight = 0 or ichgb= 0 or 
icwbc = 0 or icplt = 0 or icalt = 0 or iccreatin = 0 or icneghiv = 0 or ichbsaghepc = 0 or icpostmenop = 0 or 
iccontracep = 0 or icsafesex = 0 or icnegbhcg = 0 or ictravel = 0 or ictou= 0 then icdesctxt ="Not eligible";

icsigndat = covisdat; 

inclusion_criteria_complete=2; 

drop age enr hepbc hbv_lborres hcv_lborres lbhivstat randdat randelig sex visit x ; 
run; 

*Save permanently; 
/*
data mockdata.ic; set ic_c; run; 
*/

proc means data=ic_c min median max; class icage; var age; run; 
proc freq data=ic_c; tables randelig*icage randelig*sex/missing; run; 
proc freq data=ic_c; 
tables randelig*(icage ichivrisk icinfcon iccomply icblooddon icweight ichgb icwbc icplt icalt iccreatin)/missing; 
 run;
proc freq data=ic_c; 
tables randelig*(icneghiv ichbsaghepc icpostmenop iccontracep icsafesex icnegbhcg ictravel ictou)/missing;
run;
proc freq data=ic_c; tables ictou icdesctxt /missing;
where randelig=.; run;
proc freq data=ic_c; 
tables randelig*icage*ichivrisk*icinfcon*iccomply*icblooddon*icweight*ichgb*icwbc*icplt*icalt*iccreatin*icneghiv
*ichbsaghepc*icpostmenop*iccontracep*icsafesex*icnegbhcg*ictravel*ictou*icdesctxt/missing list;
run;

***************************************************************************************************************************************************
Generate Exclusion Criteria "EC" Dataset
******************************************************************************************************************************************;
data rand; set mockdata.randomization (keep=subjid randdat randelig); run; 
data ec_a; merge mockdata.ic (keep=subjid icvisdat icdesctxt) rand; by subjid; 
rename icvisdat = ecvisdat; 

call streaminit(12345); 
if randelig=. then x = rand("Uniform");  

*receipt of any investigational HIV vaccine or adjuvant;  
If x GE 0.94 then echivvax=1; else echivvax=0;

*Received an investigational product or vaccine in past 30 days;
if x GE 0.92 then ecinvestvax=1; else ecinvestvax=0; 

*Concurrent participation in another study; 
if x GE 0.97 then ecanotherstudy=1; else ecanotherstudy=0; 

*Any serious medical illness or condition;
if x GE 0.75 then ecmedcond=1; else ecmedcond=0; 

*Receipt of immunoglobulins; 
ecimmunoglob=0;

*hx of analyphylaxis;
ecanaphylaxis=0; 

*History of sickle cell trait;
if 0.32 < x <=0.37 then ecsicklecell=1; else ecsicklecell=0; 

*Pregnancy/lactation; 
eclactation=0;

*Cancer; 
if age GE 50 & randelig=. & 0.56 < x <=0.62 then eccancer=1; else eccancer=0; 

*History of autoimmune diseases; 
if 0.23 < x <=0.32 then ecautoimmune=1; else ecautoimmune=0;

*Hx of potentially immune-Mediated Medical conditions;
ecpimmc=0; 

*Alcohol or drug abuse; 
if 0.65 < x < 0.8 then ecalcoholdrug=1; else ecalcoholdrug=0; 

*any other significant disease; 
if 0.88 < x < 0.95 then ecsigdisease=1; else ecsigdisease=0; 

*History of splenectomy;
ecsplenectomy=0; 

*Confirmed or suspected immunodeficiency; 
if 0.20 < x <= 0.40 then ecimmunodef=1; else ecimmunodef=0; 

*History of hereditary angioedema; 
if age GE 50 & 0.36 < x <0.53 then ecangioedema=1; else ecangioedema=0; 

*History of asthma; 
if 0.15 <= x <= 0.25 then ecasthma=1; else ecasthma=0; 

*Diabetes;
if age GE 40 & 0.22 <= x <= 0.44 then ecdiabetes=1; else ecdiabetes=0; 

*Thyroid; 
if age GE 40 & 0.26 < x <= 0.34 then ecthyroid=1; else ecthyroid=0; 

*idiopathic urticaria; 
if 0 <= x <= 0.15 then ecurticaria=1; else ecurticaria=0; 

*Hypertension; 
if age GE 50 & 0.30 < x <0.75 then echypertension=1; else echypertension=0; 

*Bleeding disorder;
ecbleeding=0; 

*Neurologic disease, migraines, seizures; 
if 0.10 < x <= 0.3 then ecneurodisease=1; else ecneurodisease=0; 

*Systemic immunosuppressive medications; 
if 0.26 < x <= 0.35 then ecimmunosup=1; else ecimmunosup=0; 

*Treatment with known immunomodulators;
if 0.30 < x <= 0.35 then ecimmunomod=1; else ecimmunomod=0; 

*Live attenuated vaccines in past 30 days;
ecattenuatedvax=0; 

*Vaccines in past 2 weeks;
ecsubunit=0; 

*Arthritis, not osteo;
if 0.20 < x <= 0.3 then ecarthritis=1; else ecarthritis=0; 

*Rheumatoid arthritis;
if 0.25 < x <= 0.3 then ecrheumatoid=1; else ecrheumatoid=0; 

if echivvax=1|ecinvestvax=1|ecanotherstudy=1|ecmedcond=1|ecimmunoglob=1|ecanaphylaxis=1|ecsicklecell=1|eclactation=1|eccancer=1|ecautoimmune=1
	|ecpimmc=1|ecalcoholdrug=1|ecsigdisease=1|ecsplenectomy=1|ecimmunodef=1|ecangioedema=1|ecasthma=1|ecdiabetes=1|ecthyroid=1|ecurticaria=1
	|echypertension=1|ecbleeding=1|ecneurodisease=1|ecimmunosup=1|ecimmunomod=1|ecattenuatedvax=1|ecsubunit=1|ecarthritis=1|ecrheumatoid=1 
	then ecdesctxt="NOT ELIGIBLE"; 

ecillnessfever=0; 

ecsigndat = icvisdat;

exclusion_criteria_complete = 2; 
format ecsigndat date9.; 
run; 
proc freq data=ec_a; tables randelig*icdesctxt/missing; run;
Proc freq data=ec_a; tables randelig*echivvax*ecinvestvax*ecanotherstudy*ecmedcond*ecimmunoglob*ecanaphylaxis*ecsicklecell*eclactation*eccancer*ecautoimmune
	*ecpimmc*ecalcoholdrug*ecsigdisease*ecsplenectomy*ecimmunodef*ecangioedema*ecasthma*ecdiabetes*ecthyroid*ecurticaria
	*echypertension*ecbleeding*ecneurodisease*ecimmunosup*ecimmunomod*ecattenuatedvax*ecsubunit*ecarthritis*ecrheumatoid*ecdesctxt/missing list; 
	run; 
	
proc print data=ec_a; where randelig=. & ecdesctxt=""; run;


*Save permanently;
/*
data mockdata.ec; set ec_a; 
drop x icdesctxt randdat randelig ; 
run; 
*/

***************************************************************************************************************************************************
Generate Enrollment Dataset
******************************************************************************************************************************************;
data rand; set mockdata.randomization (keep=subjid randdat randelig); run; 
data incl; set mockdata.ic (keep=subjid icvisdat icdesctxt icage ichivrisk icinfcon iccomply icblooddon icweight ichgb icwbc icplt icalt  
	iccreatin icneghiv ichbsaghepc icpostmenop iccontracep icsafesex icnegbhcg ictravel ictou); run;
data excl; set mockdata.ec (keep=subjid ecdesctxt echivvax ecinvestvax ecanotherstudy ecmedcond ecimmunoglob ecanaphylaxis ecsicklecell 
	 eclactation eccancer ecautoimmune ecpimmc ecalcoholdrug ecsigdisease ecsplenectomy ecimmunodef ecangioedema ecasthma ecdiabetes 
	 ecthyroid ecurticaria echypertension ecbleeding ecneurodisease ecimmunosup ecimmunomod ecattenuatedvax ecsubunit ecarthritis  
	 ecrheumatoid); run;
data en_a; merge incl rand excl; by subjid;
envisdat=randdat; 

*Meet all inclusion and exclusion criteria;
if randelig=1 then ieyn=1; else ieyn=0; 

*If no, what was the category of criterion?;
if randelig=. & icdesctxt = "NOT ELIGIBLE" then iecat___1 = 1; 
if randelig=. & ecdesctxt = "NOT ELIGIBLE" then iecat___2 = 1; 

*what was the identifiers of the inclusion criteria the participant did not meet or the exclusion criteria the partipant met?;
IC01 = icage;
IC02 = ichivrisk;
IC03 = icinfcon;
IC04 = iccomply;
IC05 = icblooddon;
IC06 = icweight;
IC07 = ichgb;
IC08 = icwbc;
IC09 = icplt;
IC10 = icalt;
IC11 = iccreatin;
IC12 = icneghiv;
IC13 = ichbsaghepc;
IC14 = icpostmenop;
IC15 = iccontracep;
IC16 = icsafesex;
IC17 = icnegbhcg;
IC18 = ictravel;
IC19 = ictou;
EC01 = echivvax;
EC02 = ecinvestvax;
EC03 = ecanotherstudy;
EC04 = ecmedcond;
EC05 = ecimmunoglob;
EC06 = ecanaphylaxis;
EC07 = ecsicklecell;
EC08 = eclactation;
EC09 = eccancer;
EC10 = ecautoimmune; 
EC11 = ecpimmc;
EC12 = ecalcoholdrug;
EC13 = ecsigdisease;
EC14 = ecsplenectomy;
EC15 = ecimmunodef;
EC16 = ecangioedema;
EC17 = ecasthma;
EC18 = ecdiabetes;
EC19 = ecthyroid;
EC20 = ecurticaria;
EC21 = echypertension;
EC22 = ecbleeding;
EC23 = ecneurodisease;
EC24 = ecimmunosup;
EC25 = ecimmunomod;
EC26 = ecattenuatedvax;
EC27 = ecsubunit;
EC28 = ecarthritis;
EC29 = ecrheumatoid;

*Is the participant eligible for enrollment?;
if randelig=1 then eneligible=1; else eneligible=0; 

*is participant enrolled?  WE assumed anyone eligible is enrolled - this can be changed later; 
if randelig=1 then enrolled=1; 

notenrolledreason=.; 
enrolldat=randdat; 
enrollment_complete=2; 

Run; 

*save permanently;
/*
data mockdata.en; set en_a; 
drop randdat randelig icvisdat icdesctxt icage ichivrisk icinfcon iccomply icblooddon icweight ichgb icwbc icplt icalt  
	iccreatin icneghiv ichbsaghepc icpostmenop iccontracep icsafesex icnegbhcg ictravel ictou ecdesctxt echivvax ecinvestvax 
	ecanotherstudy ecmedcond ecimmunoglob ecanaphylaxis ecsicklecell eclactation eccancer ecautoimmune ecpimmc ecalcoholdrug 
	ecsigdisease ecsplenectomy ecimmunodef ecangioedema ecasthma ecdiabetes ecthyroid ecurticaria echypertension ecbleeding 
	ecneurodisease ecimmunosup ecimmunomod ecattenuatedvax ecsubunit ecarthritis ecrheumatoid;
	run;
	*/
	
***************************************************************************************************************************************************
Generate Participant Status Change Dataset (SC)
For ease in generating mock data, we have assumed no early terminations and full study completion
******************************************************************************************************************************************;
data vdates; set mockdata.visitdates2 (keep= subjid randdat visitdat10); run;

data sc_a; set vdates; 
where randdat NE .; 
scvisdat=visitdat10; 

*Date of participant change status; 
scdat=visitdat10; 

*Reason for participant change status;
screasn=1; 

screceivedoes=.; 
scnumvaxreceive = .;
scdiscduringvax = .; 
scvaxinvial=.; 
scfutsample=.;
scfinalvisit=10;
sctermreasn=.; 
scdeathdat =.;
schivdiadat=.;
sctermreasnsp="";
sccomnt = "";

format scvisdat date9. scdat date9. scdeathdat date9. schivdiadat date9.; 
drop visitdat10 randdat; 
run; 
proc print data=sc_a; run; 

/*Save permanently
data mockdata.sc; set sc_a; run; 
*/

***************************************************************************************************************************************************
Explore and evaluate Adam's local diary card assessment data 
Rechecked and run on 7/21/2022
******************************************************************************************************************************************;
data diaryl; set mockdata.diarylocal; 
rename day= dclday; 
*Vaccinations happened at visits 1, 3, 5, so recode; 
if visit = 1 then visit = 1; else
if visit = 2 then visit = 3; else
if visit = 3 then visit = 5;  
run;
data vax; set mockdata.vac (keep=subjid visit vacvisdat vaclocation);
rename vaclocation = dclinjsite; 
rename vacvisdat = dclvisdat; 
run; 
proc sort data=vax; by subjid visit; run;
proc sort data=diaryl; by subjid visit ; run;

data local_diary; merge diaryl vax; 
by subjid visit; 

*fix itch variables;
if dclitch in (5,6) then dclitch=4; else dclitch=dclitch; 

*Fix induration variable;
if dclindur=5 then dclindur=4; else dclindur=dclindur; 

*fix combined induration variables;
dclindurdim = dclindurcomb; 

*Fix combined redness variable;
dclerythdim = dclerythcomb; 

*Set comments to blank;
dclcomnt=""; 

*Fix missing warmth observations - set to zero; 
if dclwarm=. then dclwarm=0; else dclwarm = dclwarm; 
run;

data local_diary; set local_diary;
if dclindurdim GT . then dclindurcomb=1; 
if dclerythdim GT . then dclerythcomb=1; 

*No reaction flag;
if dclpain=0 & dclitch=0 & dclindur=0 & dcleryth=0 & dclwarm=0 then dclnoreactdata=1; else dclnoreactdata=0; 
run;

/*
*Save permanently;
data mockdata.dcl; set local_diary; 
run; 
*/
/*I need to make a 'no reactions' flag*/
proc freq data=local_diary; tables visit*dclday*dclnoreactdata dclnoreactdata/list missing; run;
*Pain data looks good;  
proc freq data=local_diary; tables visit*dclday*dclpain dclpain/list missing; run; 
*Itch, only values 0-4 and 97=unknown allowed, adam has values of 5,6;
proc freq data=local_diary; tables visit*dclday*dclitch dclitch/list missing; run; 
*Induration, only values 0-4 and 97 allowed.  Adam has some fives; 
proc freq data=local_diary; tables visit*dclday*dclindur dclindur/list missing; run; 
proc freq data=local_diary; tables dclindur*dclfrontindur*dclbackindur*dclindurcomb*dclindurdim/list missing; run; 
*Redness;
proc freq data=local_diary; tables dcleryth*dclfronteryth*dclbackeryth*dclerythcomb*dclerythdim dcleryth dclerythcomb/list missing; run; 
proc means data=local_diary; var dclerythdim; run; 
*warmth;
proc freq data=local_diary; tables dclwarm dclcomnt/missing; run; 

*Put it all together to figure out 'no reactions'; 
proc freq data=local_diary; tables dclpain*dclitch*dclindur*dcleryth*dclwarm/missing list; run; 

******************************************************************************************************************************************
Explore and evaluate Adam's systemic diary card assessment data 
******************************************************************************************************************************************;
data diarys; set mockdata.diarysystemic; 
rename day= dcsday; 

dcsnoinject=.;  *Injection not administered, all set to missing; 
*Vaccinations happened at visits 1, 3, 5, so recode; 
if visit = 1 then visit = 1; else
if visit = 2 then visit = 3; else
if visit = 3 then visit = 5;  

drop dcstempu; 
run;

data vax; set mockdata.vac (keep=subjid visit vacvisdat vaclocation);
rename vaclocation = dclinjsite; 
rename vacvisdat = dclvisdat; 
run; 

*Unit for temperature only appears for the first day of each visit; 
data tempu; set mockdata.diarysystemic (keep=subjid visit dcstempu); 
*Vaccinations happened at visits 1, 3, 5, so recode; 
if visit = 1 then visit = 1; else
if visit = 2 then visit = 3; else
if visit = 3 then visit = 5;
run;
proc sort data=tempu nodupkey ; by subjid visit; run; 
proc print data=tempu; run;
proc freq data=tempu; tables visit*dcstempu/missing; run; 

proc sort data=vax; by subjid visit; run;
proc sort data=diarys; by subjid visit dcsday; run;
proc sort data=tempu; by subjid visit; run; 
data sys_diary; merge diarys vax tempu ; 
by subjid visit; 

*fix headache, joint pain, dizziness - recode value of five to unknown;
if dcsheadache=5 then dcsheadache=97; else dcsheadache=dcsheadache;  
if dcsjointpain=5 then dcsjointpain=97; else dcsjointpain=dcsjointpain;
if dcsdizzi=5 then dcsdizzi=97; else dcsdizzi=dcsdizzi;  

*Constructing comment fields for completeness, but setting them to missing; 
dcsrashcomnt=""; 
dcscomnt="";

/*****AY update Aug,9,2022: per Fengming's comments that the programmers will
	compute dcsfever based on DAIDS criteria, I'm leaving this in here for the "took med" 
	calculation but then will be dropping dcsfever. */
/*constructing a flag for fever.  Using CDC definition of 100.4 F or higher, or 38 C or higher; */
/*AY update 8/9/22 Altering this to read numeric inputs requested by PAs*/
if dcstempu=/*"F"*/2 & dcstemp GE 100.4 then dcsfever=1; else 
if dcstempu=/*"C"*/1 & dcstemp GE 38.0 then dcsfever=1; else dcsfever=0;  

*No reactions;
if /*dcsfever=0 &*/ dcsfatigue=0 & dcsheadache=0 & dcsmuscleaches=0 & dcsjointpain=0 & dcsrash=0 & dcschills=0 & dcsnausea=0 & dcsdizzi=0 then
 	dcsnoreactdata=1; else dcsnoreactdata=1; 

*Took med for fever or to reduce symptoms;
*Construct a random number to assign people with warm and fever to taking medications; 
x = rand("Uniform"); 
if dcsfever=1 & x GE 0.8 then dcstookmed=1; else
if dcsfever=0 & dcschills=1 & x GE 0.5 then dcstookmed=1; else
if dcsfever=0 & dcschills=0 & (dcsmuscleaches=1|dcsjointpain=1|dcsheadache=1) & x GE 0.5 then dcstookmed=1; else 
dcstookmed=0; 

drop x dcsfever; 
run; 

proc means data=sys_diary min p25 median p75 max; class dcsfever; var dcstemp; where dcstempu="F"; run;
proc means data=sys_diary min p25 median p75 max; class dcsfever; var dcstemp; where dcstempu="C"; run;

proc means data=sys_diary min p25 median p75 max; class dcstempu; var dcstemp; run;
proc freq data=sys_diary; 
tables dcstempu dcsfatigue dcsheadache dcsmuscleaches dcsjointpain dcsrash dcschills dcsnausea dcsdizzi dcsfever dcsnoreactdata dcstookmed/missing; 
run; 

proc freq data=sys_diary; 
tables dcsfever*dcsfatigue*dcsheadache*dcsmuscleaches*dcsjointpain*dcsrash*dcschills*dcsnausea*dcsdizzi*dcsfever/missing list; 
run; 
proc freq data=sys_diary; tables dcsnoreactdata/missing; run; 

proc sort data=diarys; by subjid visit day; run; 
proc print data=sys_diary (obs=60); run;

data mockdata.dcs_updateCHK;
set sys_diary;
run;
/*
*Save permanently;
data mockdata.dcs; set sys_diary; 
run; 
*/
***************************************************************************************************************************************************
Construct Medical History dataset 
******************************************************************************************************************************************;
*First, explore whether I can just import and adapt a file from RV464;  
libname rv464 "/group/Stat/NEW/RV464/DataLive"; run;
data mh_oth; set rv464.mh; 
call streaminit(54321);
x = rand("Uniform");
if x <= 0.45 then select=1;  /*select 60 observations at random*/
run;
proc freq data=mh_oth; tables select/missing; run;
proc print data=mh_oth; run; 
/*N=113 observations*/ 
proc freq data=mh_oth; tables past_current_mh general describe_general heent describe_heent/missing; run;  
proc freq data=mh_oth; tables cardio describe_cardio respiratory describe_respiratory gastro describe_gastro /missing; run;  
proc freq data=mh_oth; tables genito describe_genito musculo describe_musculo neuro describe_neuro /missing; run;  
proc freq data=mh_oth; tables endoc describe_endoc psych describe_psych hem_lym describe_hem_lym/missing; run;  

Data mh_othb; set mh_oth; 
where select=1; 
drop record_id redcap_event_name mh_visit_date x; 
run;

data rand; set mockdata.randomization (keep=subjid randdat randelig); 
where randelig=1; 
run; 

Data MH_1; merge rand mh_othb; 

rename randdat = mhdat; 
x = rand("Uniform"); 

rename past_current_mh = mhyn; 

rename general = gen_mhoccur;
rename describe_general = gen_mhsig; 
rename year_general = gen_mhstdat; 
rename resolved_general___1 = gen_mhrslv; 

rename heent = heent_mhoccur; 
rename describe_heent = heent_mhsig; 
rename year_heent = heent_mhstdat; 
rename resolved_heent___1 = heent_mhrslv;

rename cardio = cardio_mhoccur; 
rename describe_cardio = cardio_mhsig; 
rename year_cardio = cardio_mhstdat; 
rename resolved_cardio___1 = cardio_mhrslv;

rename respiratory = resp_mhoccur; 
rename describe_respiratory = resp_mhsig; 
rename year_respiratory = resp_mhstdat; 
resp_mhrslv = .;

rename gastro = gastro_mhoccur; 
rename describe_gastro = gastro_mhsig; 
rename year_gastro = gastro_mhstdat; 
rename resolved_gastro___1 = gastro_mhrslv; 

rename genito = genito_mhoccur; 
rename describe_genito = genito_mhsig; 
rename year_genito = genito_mhstdat; 
rename resolved_genito___1 = genito_mhrslv; 

rename musculo = ms_mhoccur; 
rename describe_musculo = ms_mhsig; 
rename year_musculo = ms_mhstdat; 
rename resolved_musculo___1 = ms_mhrslv; 

rename neuro = neuro_mhoccur; 
rename describe_neuro = neuro_mhsig; 
rename year_neuro = neuro_mhstdat; 
rename resolved_neuro___1 = neuro_mhrslv; 

rename endoc = endo_mhoccur; 
rename describe_endoc = endo_mhsig; 
rename year_endoc = endo_mhstdat; 
rename resolved_endoc___1 = endo_mhrslv; 

rename psych = psyc_mhoccur; 
rename describe_psych = psyc_mhsig; 
rename year_psych = psyc_mhstdat; 
rename resolved_psych___1 = psyc_mhrslv; 

rename hem_lym = hem_mhoccur; 
rename describe_hem_lym = hem_mhsig; 
rename year_hem_lym = hem_mhstdat; 
rename resolved_hem_lym___1 = hem_mhrslv; 

rename meta = metab_mhoccur; 
rename describe_meta = metab_mhsig; 
rename year_meta = metab_mhstdat; 
rename resolved_meta___1 = metab_mhrslv;

rename allergy = allergy_mhoccur; 
rename describe_allergy = allergy_mhsig; 
rename year_allergy = allergy_mhstdat; 
rename resolved_allergy___1 = allergy_mhrslv;

rename other_1 = oth1_mhoccur; 
rename describe_other_1 = oth1_mhsig; 
rename year_other_1 = oth1_mhstdat; 
rename resolved_other_1___1 = oth1_mhrslv;

rename other_2 = oth2_mhoccur; 
rename describe_other_2 = oth2_mhsig; 
rename year_other_2 = oth2_mhstdat; 
rename resolved_other_2___1 = oth2_mhrslv;

rename other_3 = oth3_mhoccur; 
rename describe_other_3 = oth3_mhsig; 
rename year_other_3 = oth3_mhstdat; 
rename resolved_other_3___1 = oth3_mhrslv;

drop x; 
run; 

*I noticed a lot of missing observations in the flags, so I am resetting missing to a value of zero; 
data mh_1; set mh_1; 
if mhyn=. then mhyn=0; else mhyn=mhyn; 
if gen_mhoccur=. then gen_mhoccur=0; else gen_mhoccur=gen_mhoccur;
if heent_mhoccur=. then heent_mhoccur=0; else heent_mhoccur=heent_mhoccur; 
if cardio_mhoccur=. then cardio_mhoccur=0; else cardio_mhoccur=cardio_mhoccur;
if resp_mhoccur=. then resp_mhoccur=0; else resp_mhoccur=resp_mhoccur; 
if gastro_mhoccur=. then gastro_mhoccur=0; else gastro_mhoccur=gastro_mhoccur; 
if genito_mhoccur=. then genito_mhoccur=0; else genito_mhoccur=genito_mhoccur; 
if ms_mhoccur=. then ms_mhoccur=0; else ms_mhoccur=ms_mhoccur;
if neuro_mhoccur=. then neuro_mhoccur=0; else neuro_mhoccur=neuro_mhoccur;
if endo_mhoccur=. then endo_mhoccur=0; else endo_mhoccur=endo_mhoccur;
if psyc_mhoccur=. then psyc_mhoccur=0; else psyc_mhoccur=psyc_mhoccur; 
if hem_mhoccur=. then hem_mhoccur=0; else hem_mhoccur=hem_mhoccur; 
if metab_mhoccur=. then metab_mhoccur=0; else metab_mhoccur=metab_mhoccur;
if allergy_mhoccur=. then allergy_mhoccur=0; else allergy_mhoccur=allergy_mhoccur; 
if oth1_mhoccur=. then oth1_mhoccur=0; else oth1_mhoccur=oth1_mhoccur;
if oth2_mhoccur=. then oth2_mhoccur=0; else oth2_mhoccur=oth2_mhoccur; 
if oth3_mhoccur=. then oth3_mhoccur=0; else oth3_mhoccur=oth3_mhoccur; 

run; 
proc freq data=mh_1; 
tables mhyn gen_mhoccur heent_mhoccur cardio_mhoccur resp_mhoccur gastro_mhoccur genito_mhoccur ms_mhoccur neuro_mhoccur endo_mhoccur
	psyc_mhoccur hem_mhoccur metab_mhoccur allergy_mhoccur oth1_mhoccur oth2_mhoccur oth3_mhoccur/missing; 
run; 


*Pull in and check gender and age for inconsistencies; 
data dem; set mockdata.dm (keep=subjid age gender); run;
data mh_2; merge mh_1 dem; by subjid; 
	birth_yr = 2022 - age; 
	
	*Correcting for patients getting diseases prior to birthyear; 
	if resp_mhstdat	NE 2020 then resp_mhstdat=resp_mhstdat + 10; else resp_mhstdat	=resp_mhstdat; 
	if gastro_mhstdat < 1996 then gastro_mhstdat = gastro_mhstdat + 25; else gastro_mhstdat=gastro_mhstdat; 
	if ms_mhstdat <1987 then ms_mhstdat = ms_mhstdat + 25; else ms_mhstdat=ms_mhstdat;
	if hem_mhstdat <2000 then hem_mhstdat=hem_mhstdat+20; else hem_mhstdat=hem_mhstdat;
	if allergy_mhstdat	<1980 then allergy_mhstdat=allergy_mhstdat	+ 40; else allergy_mhstdat=allergy_mhstdat	;
	if oth1_mhstdat	< 2000 then oth1_mhstdat = oth1_mhstdat	+ 20; else oth1_mhstdat	= oth1_mhstdat	; 
	
	*reset to missing because this patient is recorded as a man, and data talks about endometriosis; 
	if subjid="575-0149" then oth1_mhsig="";
	if subjid="575-0149" then oth2_mhsig="" ;
	if subjid="575-0096" then hem_mhsig="";
	if subjid="575-0089" then gastro_mhsig="Gastritis";
	
metab_mhsig=""; 

	run;

/*
data mockdata.mh; set mh_2;
drop age gender birth_yr select;
run; 
*/
/*
proc print data=mh_2; 
	var subjid age birth_yr gen_mhstdat heent_mhstdat cardio_mhstdat resp_mhstdat gastro_mhstdat genito_mhstdat ms_mhstdat neuro_mhstdat endo_mhstdat psyc_mhstdat
		hem_mhstdat allergy_mhstdat oth1_mhstdat oth2_mhstdat oth3_mhstdat; run; 
*/

proc print data=mh_2; var subjid age gender gastro_mhsig resp_mhsig cardio_mhsig heent_mhsig gen_mhsig; run;
proc print data=mh_2; var subjid age gender endo_mhsig neuro_mhsig ms_mhsig genito_mhsig; run; 
Proc print data=mh_2; var subjid age gender psyc_mhsig hem_mhsig allergy_mhsig; run; 
Proc print data=mh_2; var subjid age gender oth1_mhsig oth2_mhsig; run; 

proc freq data=mh_2; tables mhyn gen_mhoccur gen_mhsig gen_mhstdat gen_mhrslv/missing; run; 
proc freq data=mh_2; tables heent_mhoccur heent_mhsig heent_mhstdat heent_mhrslv/missing; run; 
proc freq data=mh_2; tables cardio_mhoccur cardio_mhsig cardio_mhstdat cardio_mhrslv/missing; run;
proc freq data=mh_2; tables resp_mhoccur resp_mhsig resp_mhstdat resp_mhrslv/missing; run;
proc freq data=mh_2; tables gastro_mhoccur gastro_mhsig gastro_mhstdat gastro_mhrslv/missing; run;
proc freq data=mh_2; tables genito_mhoccur genito_mhsig genito_mhstdat genito_mhrslv/missing; run;
proc freq data=mh_2; tables ms_mhoccur ms_mhsig ms_mhstdat ms_mhrslv/missing; run;
proc freq data=mh_2; tables neuro_mhoccur neuro_mhsig neuro_mhstdat neuro_mhrslv/missing; run;
proc freq data=mh_2; tables endo_mhoccur endo_mhsig endo_mhstdat endo_mhrslv/missing; run;
proc freq data=mh_1; tables psyc_mhoccur psyc_mhsig psyc_mhstdat psyc_mhrslv/missing; run;
proc freq data=mh_1; tables hem_mhoccur hem_mhsig hem_mhstdat hem_mhrslv/missing; run;
proc freq data=mh_1; tables metab_mhoccur metab_mhsig metab_mhstdat metab_mhrslv/missing; run;
proc freq data=mh_1; tables allergy_mhoccur allergy_mhsig allergy_mhstdat allergy_mhrslv/missing; run;
proc freq data=mh_2; tables oth1_mhoccur oth1_mhsig oth1_mhstdat oth1_mhrslv/missing; run;
proc freq data=mh_2; tables oth2_mhoccur oth2_mhsig oth2_mhstdat oth2_mhrslv/missing; run;
proc freq data=mh_2; tables oth3_mhoccur oth3_mhsig oth3_mhstdat oth3_mhrslv/missing; run;

***************************************************************************************************************************************************
Construct Vaccination visit vital signs dataset, 7/21/2022  
******************************************************************************************************************************************;
*Pull in relevant variables from vaccination file; 
data vax; set mockdata.vac (keep=subjid visit vacvisdat vactim);
where visit=1; *start out with first visit; 

rename vacvisdat = vvsvisdat; 
vvsndpr=.; 
vvsreasndpr="";
vvstimpr=input(cats(vactim,"00"),time5.);

format vvstimpr time5.;
run;

data vax2; set vax; 
*generate a random number between 0 & 100;
call streaminit(54321); 
x=rand('uniform'); 

*body weight in lbs, min 110, max 300;  
do i = 1 to 60;  
 vvsweightpr = rand('GAMMA', 150); 
 if x <=0.9 then vvstemppr = rand('uniform', 96.2,98.7); else 
 if x GT 0.9 then vvstemppr = rand('uniform', 36.0,37.1);
 vvspulsepr = rand('uniform', 40, 120);
 vvsresppr = rand('uniform', 10,40);
 vvssysbppr = rand('uniform', 90, 170); 
 vvsdiabppr = rand('uniform', 50, 100);
 *assessment has to be at least 30 minutes after vaccination. I added additional variability of another 30 mins;  
 vvstimpo = vvstimpr + 1800 + rand('uniform',0,1800);  
  end;
 
vvsweightndpr=.; 

*temperature method, assuming majority of patients will get thermal scanner;
if x <0.20 then vvstempmethpr=1; else 
if 0.20 <= x <0.25 then vvstempmethpr=2; else
if 0.25 <= x <0.4 then vvstempmethpr=3; else
vvstempmethpr=4; 

*Temp units assume 90% are taken in F; 
if x <=0.9 then vvstempupr=2; else vvstempupr=1; 
*units of temp after vaccination, assume same as before vax;
vvstempmethopo = vvstempupr; 
vvstempupo = vvstempupr; 

*temperature after vax, assume some random variation of no change, up to a half a degree;
if vvstempupo = 2 then vvstemppo = vvstemppr + rand('uniform', 0, 0.5); else
if vvstempupo = 1 then vvstemppo = vvstemppr + rand('uniform', 0, 0.2);

*sitting for at least five mins before measurements;
vvssitpr = 1; 
vvsndpo=.;
vvsreasndpo = ""; 

*pulse, resp, and bp after vax; 
vvssitpo = 1; 
vvspulsepo = vvspulsepr + rand('uniform', -(vvspulsepr*0.10), (vvspulsepr*0.10));
vvsresppo = vvsresppr + rand('uniform', -(vvsresppr*0.10), (vvsresppr*0.10));
vvssysbppo = vvssysbppr + rand('uniform', -(vvssysbppr*0.10), (vvssysbppr*0.10));
vvsdiabppo = vvsdiabppr + rand('uniform', -(vvsdiabppr*0.10), (vvsdiabppr*0.10));

format vvstimpo time5. vvspulsepr 3. vvspulsepo 3. vvsresppr 3. vvsresppo 3. vvssysbppr 3. vvssysbppo 3. vvsdiabppr 3. vvsdiabppo 3.; 
run; 
proc print data=vax2; var vvspulsepr vvspulsepo vvsresppr vvsresppo vvssysbppr vvssysbppo vvsdiabppr vvsdiabppo; run;


*Now I need to repeat for Visit 2, but I'm going to pull in some of the V1 metrics as a starting point; 
data vax2a; set vax2 (keep= subjid vvsweightpr vvstemppr vvspulsepr vvsresppr vvssysbppr vvsdiabppr vvstempmethpr vvstempupr);
*renaming variables from V1 because I want to reconstruct them; 
rename vvsweightpr = vvsweightpr1;
rename vvstemppr = vvstemppr1;
rename vvspulsepr = vvspulsepr1;
rename vvsresppr = vvsresppr1;
rename vvssysbppr = vvssysbppr1;
rename vvsdiabppr = vvsdiabppr1;
run;

*First grab what I need from vaccine file for V2; 
data vax3; set mockdata.vac (keep=subjid visit vacvisdat vactim ); 
where visit=3; 
rename vacvisdat = vvsvisdat; 
vvsndpr=.; 
vvsreasndpr="";
vvstimpr=input(cats(vactim,"00"),time5.);
format vvstimpr time5.;
run;

data vax3a; merge vax3 vax2a; by subjid;
visit = 3; 

*assessment has to be at least 30 minutes after vaccination. I added additional variability of another 30 mins;  
vvstimpo = vvstimpr + 1800 + rand('uniform',0,1800);  
 
*Using v1 measure to construct V2 measures, building in variability;  
vvstemppr = vvstemppr1 + rand('uniform', -(vvstemppr1*0.01), (vvstemppr1*0.01));
vvsweightpr = vvsweightpr1 + rand('uniform', -(vvsweightpr1*0.05), (vvsweightpr1*0.05));
vvspulsepr = vvspulsepr1 + rand('uniform', -(vvspulsepr1*0.10), (vvspulsepr1*0.10));
vvsresppr = vvsresppr1 + rand('uniform', -(vvsresppr1*0.10), (vvsresppr1*0.10));
vvssysbppr = vvssysbppr1 + rand('uniform', -(vvssysbppr1*0.10), (vvssysbppr1*0.10));
vvsdiabppr = vvsdiabppr1 + rand('uniform', -(vvsdiabppr1*0.10), (vvsdiabppr1*0.10));

vvstemppo = vvstemppr + rand('uniform', -(vvstemppr*0.01), (vvstemppr*0.01));
vvspulsepo = vvspulsepr + rand('uniform', -(vvspulsepr*0.10), (vvspulsepr*0.10));
vvsresppo = vvsresppr + rand('uniform', -(vvsresppr*0.10), (vvsresppr*0.10));
vvssysbppo = vvssysbppr + rand('uniform', -(vvssysbppr*0.10), (vvssysbppr*0.10));
vvsdiabppo = vvsdiabppr + rand('uniform', -(vvsdiabppr*0.10), (vvsdiabppr*0.10));

vvsweightndpr=.;
vvssitpr = 1; 
vvsndpo=.;
vvsreasndpo = ""; 
vvssitpo = 1; 

*units of temp after vaccination, assume same as before vax;
vvstempmethopo = vvstempupr; 
vvstempupo = vvstempupr; 

format vvstimpo time5.;
drop vvstemppr1 vvsweightpr1 vvspulsepr1 vvsresppr1 vvssysbppr1 vvsdiabppr1; 
run; 
proc print data=vax3a; 
var vvstemppr vvstemppo vvsweightpr vvspulsepr vvspulsepo vvsresppr vvsresppo vvssysbppr vvssysbppo vvsdiabppr vvsdiabppo; 
run;


*Now repeat for final vaccination visit;

*First grab what I need from vaccine file for V3; 
data vax5; set mockdata.vac (keep=subjid visit vacvisdat vactim ); 
where visit=5; 
rename vacvisdat = vvsvisdat; 
vvsndpr=.; 
vvsreasndpr="";
vvstimpr=input(cats(vactim,"00"),time5.);
format vvstimpr time5.;
run;

data vax5a; merge vax5 vax2a; by subjid;

*assessment has to be at least 30 minutes after vaccination. I added additional variability of another 30 mins;  
vvstimpo = vvstimpr + 1800 + rand('uniform',0,1800);  
 
*Using v1 measure to construct V2 measures, building in variability;  
vvstemppr = vvstemppr1 + rand('uniform', -(vvstemppr1*0.01), (vvstemppr1*0.01));
vvsweightpr = vvsweightpr1 + rand('uniform', -(vvsweightpr1*0.05), (vvsweightpr1*0.05));
vvspulsepr = vvspulsepr1 + rand('uniform', -(vvspulsepr1*0.10), (vvspulsepr1*0.10));
vvsresppr = vvsresppr1 + rand('uniform', -(vvsresppr1*0.10), (vvsresppr1*0.10));
vvssysbppr = vvssysbppr1 + rand('uniform', -(vvssysbppr1*0.10), (vvssysbppr1*0.10));
vvsdiabppr = vvsdiabppr1 + rand('uniform', -(vvsdiabppr1*0.10), (vvsdiabppr1*0.10));

vvstemppo = vvstemppr + rand('uniform', -(vvstemppr*0.01), (vvstemppr*0.01));
vvspulsepo = vvspulsepr + rand('uniform', -(vvspulsepr*0.10), (vvspulsepr*0.10));
vvsresppo = vvsresppr + rand('uniform', -(vvsresppr*0.10), (vvsresppr*0.10));
vvssysbppo = vvssysbppr + rand('uniform', -(vvssysbppr*0.10), (vvssysbppr*0.10));
vvsdiabppo = vvsdiabppr + rand('uniform', -(vvsdiabppr*0.10), (vvsdiabppr*0.10));

vvsweightndpr=.;
vvssitpr = 1; 
vvsndpo=.;
vvsreasndpo = ""; 
vvssitpo = 1; 

*units of temp after vaccination, assume same as before vax;
vvstempmethopo = vvstempupr; 
vvstempupo = vvstempupr; 

format vvstimpo time5.;
drop vvstemppr1 vvsweightpr1 vvspulsepr1 vvsresppr1 vvssysbppr1 vvsdiabppr1; 
run; 
proc print data=vax5a; 
var vvstemppr vvstemppo vvsweightpr vvspulsepr vvspulsepo vvsresppr vvsresppo vvssysbppr vvssysbppo vvsdiabppr vvsdiabppo; 
run;

*Putting everything together; 
data vvs; merge vax2 vax3a vax5a; 
by subjid visit; 
drop x i; 
run;

/*
*Save permanently;
data mockdata.vvs; set vvs;
run; 
*/

**********************************************************************************************
Construct mock Physical Exam (PE) File 
PE completed at each study visit
**********************************************************************************************;
*Going to start by generating data for screening visit first.
Pull in relevant variables from screening visit; 
data pe_a; set mockdata.sc (keep= subjid scvisdat) ;
rename scvisdat = pevisdat;  
pend=.; 
pereasnd = ""; 

visit="SC";

*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 

call streaminit(54322); 
x=rand('uniform'); 

petestgen=.;
if 0.6<= x <0.8 then petestgen=1; *abnormal; else petestgen=0; 
if petestgen=1 then pedescgen="abnormal result"; else pedescgen="";

petestextrem=.;
if x <0.09 then petestextrem=1; *abnormal; else petestextrem=0; 
if petestextrem=1 then pedescextrem="abnormal result"; else pedescextrem="";

petestheent=.;
if 0.09<= x <0.3 then petestheent=1; *abnormal; else petestheent=0; 
if petestheent=1 then pedescheent="abnormal result"; else pedescheent="";

petestlymph=0; 
pedesclymph="";

petestresp=0; 
pedescresp="";

petestcardio=0; 
pedesccardio="";

petestabdom =.;
if 0.25<= x <0.4 then petestabdom=1; *abnormal; else petestabdom=0; 
if petestabdom=1 then pedescabdom="abnormal result"; else pedescabdom="";

petestskin =.;
if 0.35<= x <0.5 then petestskin=1; *abnormal; else petestskin=0; 
if petestskin=1 then pedescskin="abnormal result"; else pedescskin="";

petestbreast=0; 
pedescbreast="";

petestgenito=0;
pedescgenito="";

petestrectal=0;
pedescrectal="";

petestneuro=0;
pedescneuro="";

petestgastro =.;
if 0.75<= x <0.85 then petestgastro=1; *abnormal; else petestgastro=0; 
if petestgastro=1 then pedescgastro="abnormal result"; else pedescgastro="";

petestinjectsite=91;
pedescinjectsite="";

petestoth1=.; 
peoth1sp="";
pedescoth1="";

petestoth2=.; 
peoth2sp="";
pedescoth2="";

format petim time5.; 
drop start_time timeinterval x; 
run;
proc freq data=pe_a; 
tables petestgen petestextrem petestheent petestlymph petestresp petestcardio 
petestabdom petestskin petestbreast petestgenito petestrectal petestneuro petestgastro; 
run; 

*construct data for additional visits; 
data pe_template; set pe_a (drop=visit pevisdat petim ); run; 
data vax; set mockdata.vac (keep=subjid visit vacvisdat vactim); run;

*Visit 1, 3, 5, vaccination;  
data pe_vtemp; merge pe_template vax; by subjid; run; 
data pe_v1a; set pe_vtemp; 
rename vacvisdat = pevisdat; 
*recalculate PE time to be between 45 mins to 1.25 hr prior to vaccination with some variability; 
petim = vactim - rand('uniform',2700,4500); 
*Reformat visit to be characteric; 
if visit=1 then visitn="1"; else 
if visit=3 then visitn="3"; else
if visit=5 then visitn="5"; 
drop visit vactim; 
format petim time5.; 
run; 
data pe_v1b; set pe_v1a;
rename visitn = visit; 
run;

*Visit 2; 
data vd; set mockdata.visitdates2 (keep=subjid visitdat2); where visitdat2 ne .; run; 
data pe_v2; merge pe_template vd; by subjid; 
rename visitdat2=pevisdat; 
call streaminit(54323); 
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 
visit="2"; 
format petim time5.;
drop start_time timeinterval; 
run; 

*Visit 4;
data vd4; set mockdata.visitdates2 (keep=subjid visitdat4); where visitdat4 ne .; run; 
data pe_v4; merge vd4 pe_template; by subjid;
rename visitdat4=pevisdat; 
call streaminit(54324); 
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 
visit="4"; 
format petim time5.;
drop start_time timeinterval; 
run; 
 
*Visit 6; 
data vd6; set mockdata.visitdates2 (keep=subjid visitdat6); where visitdat6 ne .; run;
data pe_v6; merge vd6 pe_template; by subjid; 
rename visitdat6=pevisdat; 
call streaminit(54326); 
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 
visit="6"; 
format petim time5.;
drop start_time timeinterval; 
run; 

*Visit 7; 
data vd7; set mockdata.visitdates2 (keep=subjid visitdat7); where visitdat7 ne .; run;
data pe_v7; merge vd7 pe_template; by subjid;
rename visitdat7=pevisdat; 
call streaminit(54327); 
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 
visit="7"; 
format petim time5.;
drop start_time timeinterval; 
run; 

*Visit 8; 
data vd8; set mockdata.visitdates2 (keep=subjid visitdat8); where visitdat8 ne .; run;
data pe_v8; merge vd8 pe_template; by subjid;
rename visitdat8=pevisdat; 
call streaminit(54328); 
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 
visit="8"; 
format petim time5.;
drop start_time timeinterval; 
run; 

*Visit 9; 
data vd9; set mockdata.visitdates2 (keep=subjid visitdat9); where visitdat9 ne .; run;
data pe_v9; merge vd9 pe_template; by subjid;  
rename visitdat9=pevisdat; 
call streaminit(54329); 
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 
visit="9"; 
format petim time5.;
drop start_time timeinterval; 
run; 

*Visit 10; 
data vd10; set mockdata.visitdates2 (keep=subjid visitdat10); where visitdat10 ne .; run;
data pe_v10; merge vd10 pe_template; by subjid; 
rename visitdat10=pevisdat; 
call streaminit(54330); 
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
petim = start_time + RAND('uniform')*timeinterval; 
visit="10"; 
format petim time5.;
drop start_time timeinterval; 
run; 

*Merge together; 
data pe; set pe_a pe_v1b pe_v2 pe_v4 pe_v6 pe_v7 pe_v8 pe_v9 pe_v10;
run; 
proc sort data=pe; by subjid pevisdat; run;

*permanently save;
data mockdata.pe; set pe; run; 

*****************************************************************************************************************************************************
9/12/2022 Converting character to numeric data IRL and IRS files 
*****************************************************************************************************************************************************;
 *Start with IRL File; 
 data irl2; set mockdata.irl; 
  
 rename visit = visitnum;
 
   irlpainpr2 = input(irlpainpr, 2.);
  	 drop irlpainpr;
  	 rename irlpainpr2 = irlpainpr; 
  
  irlitchpr2 = input(irlitchpr, 2.);
  	 drop irlitchpr;
  	 rename irlitchpr2 = irlitchpr; 
 
   irlwarmpr2 = input(irlwarmpr, 2.);
  	 drop irlwarmpr;
  	 rename irlwarmpr2 = irlwarmpr; 
 
  irlindurpr2 = input(irlindurpr, 2.);
  	 drop irlindurpr;
  	 rename irlindurpr2 = irlindurpr; 
  	 
  irlfrontindurpr2 = input(irlfrontindurpr, 2.);
  	 drop irlfrontindurpr;
  	 rename irlfrontindurpr2 = irlfrontindurpr;
  	 
  irlbackindurpr2 = input(irlbackindurpr, 2.);
  	 drop irlbackindurpr;
  	 rename irlbackindurpr2 = irlbackindurpr; 
  	 
  irlindurcombpr2 = input(irlindurcombpr, 2.);
  	 drop irlindurcombpr;
  	 rename irlindurcombpr2 = irlindurcombpr; 
  	 
  irlindurdimpr2 = input(irlindurdimpr, 2.);
  	 drop irlindurdimpr;
  	 rename irlindurdimpr2 = irlindurdimpr; 
  	 
  irlerythpr2 = input(irlerythpr, 2.);
  	 drop irlerythpr;
  	 rename irlerythpr2 = irlerythpr; 
 
  irlfronterythpr2 = input(irlfronterythpr, 2.);
  	 drop irlfronterythpr;
  	 rename irlfronterythpr2 = irlfronterythpr; 
 
  irlbackerythpr2 = input(irlbackerythpr, 2.);
  	 drop irlbackerythpr;
  	 rename irlbackerythpr2 = irlbackerythpr; 
 
  irlerythcombpr2 = input(irlerythcombpr, 2.);
  	 drop irlerythcombpr;
  	 rename irlerythcombpr2 = irlerythcombpr; 
  
  irlerythdimpr2 = input(irlerythdimpr, 2.);
  	 drop irlerythdimpr;
  	 rename irlerythdimpr2 = irlerythdimpr; 
  
  irlfrontindurpo2 = input(irlfrontindurpo, 2.);
  	 drop irlfrontindurpo;
  	 rename irlfrontindurpo2 = irlfrontindurpo;
 
    irlbackindurpo2 = input(irlbackindurpo, 2.);
  	 drop irlbackindurpo;
  	 rename irlbackindurpo2 = irlbackindurpo;
 
     irlindurcombpo2 = input(irlindurcombpo, 2.);
  	 drop irlindurcombpo;
  	 rename irlindurcombpo2 = irlindurcombpo;
 
     irlindurdimpo2 = input(irlindurdimpo, 2.);
  	 drop irlindurdimpo;
  	 rename irlindurdimpo2 = irlindurdimpo;
 
     irlerythcombpo2 = input(irlerythcombpo, 2.);
  	 drop irlerythcombpo;
  	 rename irlerythcombpo2 = irlerythcombpo;
  	 
  	 irlerythdimpo2 = input(irlerythdimpo, 2.);
  	 drop irlerythdimpo;
  	 rename irlerythdimpo2 = irlerythdimpo;

num_irltimpr=input(irltimpr,time5.);
drop irltimpr; 
Format num_irltimpr time5. ;
rename num_irltimpr = irltimpr;

num_irltimpo=input(irltimpo,time5.);
drop irltimpo; 
Format num_irltimpo time5.;
*Format num_irltimpr time5. num_irltimpo time5.;
rename num_irltimpo = irltimpo; 
 run;
 
proc contents data=irl2; run;

data mockdata.irl; set irl2; run;
 
*********************************************************************************************;
*IRS File; 
proc contents data=mockdata.irs; run; 
 data irs2; set mockdata.irs; 
  
 visitnum = input(visit, 2.);
     drop visit;
 
 irsnoinject2 = input(irsnoinject, 2.);
  	 drop irsnoinject;
  	 rename irsnoinject2 = irsnoinject; 
 
 num_irstimpr=input(irstimpr,time5.);
	drop irstimpr; 
	Format num_irstimpr time5. ;
	rename num_irstimpr = irstimpr;

  irsfeverpr2 = input(irsfeverpr, 2.);
  	 drop irsfeverpr;
  	 rename irsfeverpr2 = irsfeverpr; 
 
  irsmyalgiapr2 = input(irsmyalgiapr, 2.);
  	 drop irsmyalgiapr;
  	 rename irsmyalgiapr2 = irsmyalgiapr; 
 
 irsarthralgiapr2 = input(irsarthralgiapr, 2.);
  	 drop irsarthralgiapr;
  	 rename irsarthralgiapr2 = irsarthralgiapr; 
  	 
   irsheadachepr2 = input( irsheadachepr, 2.);
  	 drop  irsheadachepr;
  	 rename  irsheadachepr2 =  irsheadachepr;
  	 
  irsfatiguepr2 = input(irsfatiguepr, 2.);
  	 drop irsfatiguepr;
  	 rename irsfatiguepr2 = irsfatiguepr; 
  	 
  irschillspr2 = input(irschillspr, 2.);
  	 drop irschillspr;
  	 rename irschillspr2 = irschillspr; 
  	 
  irsnauseapr2 = input(irsnauseapr, 2.);
  	 drop irsnauseapr;
  	 rename irsnauseapr2 = irsnauseapr; 
  	 
   irsdizzipr2 = input( irsdizzipr, 2.);
  	 drop  irsdizzipr;
  	 rename  irsdizzipr2 =  irsdizzipr; 
 
  irsrashpr2 = input(irsrashpr, 2.);
  	 drop irsrashpr;
  	 rename irsrashpr2 = irsrashpr; 
 
  irsrashdimpr2 = input(irsrashdimpr, 2.);
  	 drop irsrashdimpr;
  	 rename irsrashdimpr2 = irsrashdimpr; 
 
 num_irstimpo=input(irstimpo,time5.);
	drop irstimpo; 
	Format num_irstimpo time5.;
	rename num_irstimpo = irstimpo; 
	
 run;
 
 data mockdata.irs; set irs2; run;
 
 *Visit num got dropped or incorrectly created because I am an idiot :); 
 data fixirs; set mockdata.irs (drop= visitnum);  run;
 
 data fixme; set mockdata.irsfix2 (keep=subjid visit irsvisdat); 
 proc sort fixme; by subjid irsvisdat; run;
 proc sort fixirs; by subjid irsvisdat; 
 
 data irs_f; merge fixme fixirs; by subjid irsvisdat; 
 rename visit = visitnum; 
 run;
 
 data mockdata.irs; set irs_f; run;
 
 *****************************************************************************************************************************
 Converting visit to visitnum and SC visit to visitnum=0
 9/14/2022  MLP
 *****************************************************************************************************************************;
 data mockdata.lbchm; set mockdata.lbchm; 
 rename visit = visitnum; 
 *Already seeing visitnum=0 for screening, so we are set; 
 run;
 
 data mockdata.lbhem; set mockdata.lbhem;
 rename visit = visitnum; 
 run; 
 
 data mockdata.lbhep; set mockdata.lbhep; 
 rename visit = visitnum;
 run;
 
 data mockdata.lbhiv; set mockdata.lbhiv; 
 rename visit = visitnum;
 run;
 
 data mockdata.pe; set mockdata.pe;
 if visit="SC" then visit=0; else visit = visit; 
 visitnum = input(visit,2.);
 drop visit; 
 run; 
 proc sort data=mockdata.pe; by subjid visitnum; run; 
 
 data mockdata.vac; set mockdata.vac; 
 rename visit = visitnum;
 run;
 proc sort data=mockdata.vac; by subjid visitnum; run; 
 
 data mockdata.vvs; set mockdata.vvs; 
 rename visit = visitnum;
 run;
 proc sort data=mockdata.vvs; by subjid visitnum; run; 
 
 *need to merge in and incorporate a visitnum into the following files; 
data vd_co; set mockdata.visitdates2 (keep=subjid covisdat); 
visitnum=0; 
run;
data co; merge mockdata.co vd_co; by subjid covisdat; run; 
proc print data=co; var subjid covisdat visitnum; run;  
data mockdata.co; set co; run; 

data mockdata.ic; set mockdata.ic; 
	visitnum = 0; 
	run;
	
data mockdata.ec; set mockdata.ec; 
	visitnum = 0; 
	run;

data mockdata.en; set mockdata.en; 
	visitnum = 1; 
	run;

data mockdata.dm; set mockdata.dm; 
	visitnum = 1; 
	run;

data mockdata.mh; set mockdata.mh; 
	visitnum = 0; 
	run;

data mockdata.dcl; set mockdata.dcl; 
	rename visit = visitnum;  
	run;

data mockdata.dcs; set mockdata.dcs; 
	rename visit = visitnum;  
	run;
	
************************************************************************************************************************
Operation Mischief Managed, or "I solemnly swear I am up to (requested) no good in the Chemistry and Hematology datasets"

Request from Fengming on 09/27/2022: 
   1.  Have a few samples not collected
   2.  Have a few samples collected but with 1-2 tests missing 
   3.  Create a few grade 3 and 4 labs

Lab data files are organized as long datasets, with repeated rows by ID, and by visit
Note that we have not aligned with AE file, which may have some lab-based AE's.
************************************************************************************************************************;
*rename original labs, so that we don't lose them; 
data mockdata.lbchm_orig; set mockdata.lbchm; 
run; 

*Start with chemistry dataset; 
data lbchm; set mockdata.lbchm (drop = lbchmtim);
call streaminit(54322); 
X = rand('integer', 1, 30);

*noticed time collected was all blank, and a couple of variables were missing;
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
lbchmtim = start_time + RAND('uniform')*timeinterval; 
 format lbchmtim time5.; 
 
lbaltorres=0;  
lbcreatinorres= 0; 

drop start_time timeinterval; 
run;

data lbchm2; merge mockdata.dm(keep=subjid sex) lbchm; by subjid;

*set a few ID's to 'no labs collected';
if X = 18 then do; 
	lbchmperf = 0;   
    lbchmreasnd = "labs not done";  
    lbchmdat = . ;
    lbchmtim = . ;
    lbchmlabcode= .;
    lbalt=.;
	lbaltorres=9; 
	lbcreatin = .;
	lbcreatinorres=9; 
  end;
  
 *Set lab values to missing for a few ID's with completed labs; 
if X = 8 then do; 
	lbalt=.;
	lbcreatin = .;
	end; 

*Create a few grade 3/4 labs
  For ALT, Grade 3 would be values that are 5 - 10 x upper limit of normal (46 if male, 29 if female)
           Grade 4 would be values more than 10x upper limit of normal (46 if male, 29 if female) ;

if X = 1 & sex = 0 then do; 
	lbalt= 240 ;   /*should be a grade 3*/
	lbaltorres= 1; 
	lbcreatin = 4.8;  /*should be a grade 4*/
	lbcreatinorres=1; 
  end; 
  
 if X = 1 & sex = 1 then do; 
	lbalt= 294;   /*should be a grade 4*/
	lbaltorres= 1; 
	lbcreatin = 2.2;  /*should be a grade 3*/
	lbcreatinorres=1; 
  end; 
  
drop X sex; 
run;

data mockdata.lbchm; set lbchm2; run; 

proc tabulate data=lbchm2 ; class visitnum; var lbalt lbcreatin; table (lbalt lbcreatin)*(N MIN MEDIAN MAX), visitnum all; run;

proc print data=lbchm2; var subjid visitnum lbchmperf lbchmdat lbchmtim lbchmlabcode lbalt lbaltorres lbcreatin lbcreatinorres;  run; 
proc freq data=lbchm2; tables visitnum*X/missing; run; 
proc freq data=lbchm; tables lbchmperf*visitnum lbchmreasnd/missing; run; 
proc print data=mockdata.lbchm; var subjid visitnum lbchmdat lbchmtim lbchmlabcode lbalt lbaltorres lbcreatin lbcreatinorres; run;
proc print data=lbchm2; var subjid visitnum; where X = 1; run; 

*Hematology dataset - Going to only code WBC, Platelets and hemoglobin;
*rename original labs, so that we don't lose them; 
data mockdata.lbhem_orig; set mockdata.lbhem; 
run; 
proc contents data=mockdata.lbhem; run;

data lbhem; set mockdata.lbhem (drop = lbhemtim);
call streaminit(54322); 
X = rand('integer', 1, 30);

*noticed time collected was all blank, and a couple of variables were missing;
*time collected; 
start_time = '8:00:00't;   
timeinterval= 28800; *Assume we are assigning between 8-4 business hours; 
lbhemtim = start_time + RAND('uniform')*timeinterval; 
 format lbhemtim time5.; 
 
lbwborres=0;  
lbwbcorres= 0; 
lbhgborres = 0; 
lbpltorres = 0; 
lbneutorres = 0;
lblymporres = 0; 
lbmonoorres = 0; 
lbeosorres = 0; 
lbbasoorres = 0; 
 
drop enr start_time timeinterval lbrbcnd lbwbcnd lbpltnd lbrbc lbhct lbhgbnd lbhctnd lbmcv lbmcvnd lbmch lbmchnd lbmchc lbmchcnd lbrdw lbrdwnd
	lbmpv lbmpvnd lbclsigneut lbclsiglymp lbclsigmono lbclsigeos lbclsigbaso; 
run;

proc freq data=lbhem; tables visitnum*X; run;

data lbhem2; merge mockdata.dm(keep=subjid sex) lbhem; by subjid;

*set a few ID's to 'no labs collected';
if X = 18 then do; 
	lbhemperf = 0;   
    lbhemreasnd = "labs not done";  
    lbhemdat = . ;
    lbhemtim = . ;
    lbhemlabcode= .;
    lbwbc=.;
	lbwbcorres=9; 
	lbhgb = .;
	lbhgborres=9; 
	lbplt = .;
	lbpltorres = 9; 
	lbneutpct = .;
	lbneutorres = 9;
	lblympct = .;
	lblymporres = 9; 
	lbmonopct = .;
	lbmonoorres = 9; 
	lbeospct = .;
	lbeosorres = 9;
	lbbasopct = .;
	lbbasoorres = 9; 
	hematology_complete = 0; 
  end;
  
*Set lab values to missing for a few ID's with completed labs; 
if X = 8 then do;
    lbwbc=.;
	lbhgb = .;
	lbplt = .;
	lbneutpct = .;
	lblympct = .;
	lbmonopct = .;
	lbeospct = .;
	lbbasopct = .;
	end;
 
*Create a few grade 3/4 labs;
*WBC:  Grade 3 is 1.0 to 1.4999, Grade 4 is <1.0;  
if X = 1 then do;
	lbwbc = round(rand('uniform', 0.1, 1.4999), 0.001); 
	lbplt = rand('integer', 1, 49); 
	lbhgb = round(rand('uniform', 0.1, 9.0), 0.1);
	lbwbcorres = 1; 
	lbpltorres = 1; 
	lbhgborres = 1; 
   end; 
drop X sex; 
 run;

data mockdata.lbhem; set lbhem2; 
run;
 
 proc print data=lbhem2; run;
 
