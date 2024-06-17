 /*********************************************************************************************************************
 PROGRAM NAME: 		   RV575 AE-CRF Mock Data Code          
 AUTHOR:               Adam Yates
 DATE WRITTEN:         7/20/22
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
 RELIES ON:          This program uses output from RV575_MockDemogs_AY code file in the mock dataset file for RV575. The systemic and local diary card reactions are used
 						as a seed for the adverse events that will be placed on the AE CRF. Per protocol, events should be placed on the AE CRF if:
 								-they are grade 3+ (usually)
 								-the event extends outside the Diary Card window
 								-the event is 'unsolicited', defined as a symptom or event not included in the diary card.
 					Specifc existing data sets relied on:
 						mddat.diarysystemic 
 						mddat.diarylocal
 						mddat.vac
 RELIED ON BY:          TBD
 SPECIAL INSTRUCTIONS:  
 
 
                        
 MODIFICATION HISTORY:  
 
 
 DATE       MODIFIER    DESCRIPTION/REASON
 ---------- ----------- -----------------------------------------------------------------------------------------------------------------
  


*******************/



/* 


*/

proc format ;
value gendr 1="Male" 2="Female" 3="Transgender";
value sex 1="Male" 2="Female" 3="Undiferentiated";
value agecat 1="18-20" 2="21-24" 3="25-34" 4="35-44" 5="45-55";
value etnc 1="Non-Hispanic/Latino" 2="Hispanic/Latino";
value raceRoot 1="White" 2="Black or African American" 3="Asian" 4="American Indian/Alaska Native" 5="Multi-racial" 6="Native Hawaiian/Pacific Islander" 7="Other, Specify";
value edu 1="Primary Education" 2="Secondary Education" 3="Undergraduate Degree" 4="Graduate Degree" 99="Other,Specify";
value occupat 1="Business" 2="Constrution/Trade" 3="Education" 4="Food/Retail" 5="Government" 6=" Health" 7="Legal"
				8="Science/Research" 9="Student" 10="Transportation" 11="Retired/Not Working";
value lclsymp 1="dclpain" 2="dclitch" 3="dclindur" 4="dcleryth";
run;

libname MDdat "/group/Stat/NEW/RV575/DataLive/MockData";

/*identifying relevant data points from Diary CRFs*/


data AElocA;
set mddat.dcl;
where dclpain>2 or dclitch>2 or dclindur>2 or dcleryth>2 or dclwarm>2  ;
rename dclday=day;
run;

data AElocB;
set mddat.dcl;
where dclday=14 ;
if dclpain<1 and dclitch<1 and dclindur<1 and dcleryth<1 and dclwarm<1 then delete;
rename dclday=day;
run;



data AEsysA;
set mddat.dcs;
where dcsfatigue>2 or dcsheadache>2 or dcsmuscleaches>2 or dcsjointpain>2 or dcsrash>2 or dcschills>2 or dcsnausea>2 or dcsdizzi>2;
rename dcsday=day;
run;

data AEsysB;
set mddat.dcs;
where dcsday=14 ;
if dcsfatigue<1 and dcsheadache<1 and dcsmuscleaches<1 and dcsjointpain<1 and dcsrash<1 and dcschills<1 and dcsnausea<1 and dcsdizzi<1 then delete;
rename dcsday=day;
run;


proc sort data=AElocA; by subjid visit day; run;
proc sort data=AElocB; by subjid visit day; run;
proc sort data=AESysA; by subjid visit day; run;
proc sort data=AESysB; by subjid visit day; run;

/*This dataset incorporates all the qualifying events from the diary card. Final iteration for AE CRF should also include 
		some unsolicited events. The details of these would have to be generated Ad Hoc and integrated with ConMed CRF, so leaving those along for now. 
		*/
data AEbaseA;
retain subjid visit day;
merge AElocA AElocB AESysA AESysB;
by subjid visit day;

run;

/* AE dataset variables from redcap dictionary
var name		description								completed?
________		_________________________			_________________
aevisdat 		ae visit date							???
aenolast		ae at final visit (y/n)
aespid			ae number
aeterm			adverseevent description
aestdat			start date
aeendat			stop date
aeongo			ongoing
aesev			severity
aeout			outcome
aemed			medication taken? 
				(note: if yes, enter on 
				con med form--will 
				need AE number)
aeser			Serious AE?
aesaecod		reason code
aepimmc			potentially immune mediated?
aemaae			medically attended AE?
aemaaevisit		type of maae visit
aemaaevisitsp	specify other
aerel			relationship to study vaccine
aedis			discontinuation of participation
aesum			event summary
adverse_events_complete		form complete? 

*/

/*grabbing vaccination visit date from vac mock crf*/

data eventDateBase;
set mddat.vac;
keep subjid visit vacvisdat;
run;

proc sort data=eventDateBase;
by subjid visit vacvisdat;
run;

data AEbaseB;
retain subjid visit vacvisdat day;
	merge AEbaseA eventDateBase;
	by subjid visit;
	run;

Data AEbaseC;
retain subjid visit vacvisdat day aestdat;
set AEbaseb;
by subjid visit ;
if day=. then delete;
format aestdat mmddyy10.;
if first.visit then do;
	aestdat= intnx('day', vacvisdat, day);
end;



aeendat=.;



/*for current simplicity I'm setting a number of varaibles to 'no' but could refine later or as the PA team wishes*/
aeongo=.;
aedis=.;
aesum=.;
adverse_events_complete=2;

/*dropping some variables becasue I'm not sure they are necessary*/
drop dclfrontindur dclbackindur dclindurcomb dclfronteryth dclbackeryth dclerythcomb;

run;

/*******************************************************************************************************************/
/***********Turning the above program into a macro for concise running. Coppied here rather than altering original*/
/******************************************************************************************************************/

options mlogic mprint  symbolgen mprintnest spool;
%macro AEdates(data= , var= ,aeterm=, st=, ed=);
proc transpose data=&data out=trans&var prefix=&var.day_;
    by subjid visit vacvisdat aestdat ;
    id day;
    var &var;
run;
data process1;
retain subjid  visit vacvisdat aestdat &var.day_1-&var.day_14;
set trans&var;
if &var.day_1 <3 and &var.day_2<3 and &var.day_3<3 and &var.day_4<3 and &var.day_5<3 and &var.day_6<3 and &var.day_7<3 and &var.day_8<3  and
	&var.day_9<3  and &var.day_10<3  and &var.day_11<3  and &var.day_12<3  and &var.day_13<3  and &var.day_14<1   then delflg=1;
if delflg=1 then delete;
drop _name_ delflg;
run;

data enddates&var;
set process1;
array varday [14] &var.day_1-&var.day_14;
array AEsubstart_ [16];
array AEsubend_ [16];

/***********Do loop for generating start dates***************/
do i=1 to dim(varday);
  j=i-1;
  		/*The j value will break if i=1 has an AE, so this loop avoids the 
  			need for a comparison check to j since there can't be an earlier date*/
		if i=1 then do;
			if varday[i] ne . then dayset= input(compress(vname(varday[i]),,'kd'), 6.);
			if varday[i] ne . then AEsubstart_[i]=intnx('day', vacvisdat, dayset);
		end;
		else do;
			if varday[i] ne . then dayset= input(compress(vname(varday[i]),,'kd'), 6.);
			if varday[i] ne . then do;
				if varday[j]=varday[i] then AEsubstart_[i]=AEsubstart_[j];
				else if varday[j] ne varday[i] then	do;/*this accidently sets a stop date to the first occorance of an AE since. Needs to put a varday[j] ne . in here somehow*/
					AEsubstart_[i]=intnx('day', vacvisdat, dayset);
					AEsubend_[j]=AEsubstart_[i]-1;/*<<<<this is what causes the end dates for the 'last nonAE' status. */
					if varday[j]=. and varday[i] ne . then AEsubend_[j]=.;/*Fixes the above issue with the first AE value*/
				end;			
			end;
			if varday[i]=. and varday[j] ne . then do;
				dayset= input(compress(vname(varday[j]),,'kd'), 6.);
				AEsubend_[j]=intnx('day', vacvisdat, dayset);
			end;
			*if varday[i]=. and varday[j]=. then AEsubend_[i]=.;
		end;
	if i=14 then do;
		AEsubend_[i]=intnx('day',AEsubstart_[i],rand('uniform',1,3));
	end;
end;
/*************Do loop for generating End dates*************/
format AEsubstart_1-AEsubstart_16 mmddyy10.;
format AEsubend_1-AEsubend_16 mmddyy10.;
drop  i j dayset ;
run;

proc transpose data=enddates&var out=transback&var;
  by subjid visit;
  var &var.day_1-&var.day_14;
run;

data return&var;
	length AeTerm $20;
  set transback&var (rename=(col1=aeSEV));
  *c=index(_name_,'_')+1;
  day=input(substr(_name_,index(_name_,'_')+1), 5.);/*<-- the day value is taken from the integer from the transformed diary variable. 
  		'_name_' is an automatic varaible from the transform procedure. 
  		This line scans the variable value for the **nth** position and sets the value of the day to this character. 
  		The **nth** postion is set by the index function, which searchers the character string for the '_' character specified and 
  			returns its character position. Since we technically don't know what that day will be (could be 1, could be a 2 or 3 depending on the days in the diary card),
  			its more robust to search for the '_' delimiter and add+1 for the next value. 
  		Thus, the index function returns the (for example) 11+1 position, and the substring function grabs the values starting with the 12th character, which sets 
  				the 'day' value to the numeric characters in the string**/
  		
  drop _name_;
  AeTerm=&AeTerm;
run;

proc transpose data=enddates&var out=transbackstrt&var;
  by subjid visit;
  var AEsubstart_1-AEsubstart_14;
run;

data returnstart&var;
  set transbackstrt&var (rename=(col1=AEstdat));
  day=input(substr(_name_,index(_name_,'_')+1), 5.);/*this is ineligant but don't have the bandwidth to make it more dynamic atm. fix later*/
  drop _name_;
run; 

proc transpose data=enddates&var out=transbackend&var;
  by subjid visit;
  var AEsubend_1-aesubend_14;
run;

data returnend&var;
  set transbackend&var (rename=(col1=AEendat));
  day=input(substr(_name_,index(_name_,'_')+1), 5.);
  drop _name_;
run;

proc sort data=return&var; by subjid visit day;run;
proc sort data=returnstart&var; by subjid visit day;run;
proc sort data=returnend&var; by subjid visit day;run;

data AEdates_&var;
merge return&var returnstart&var returnend&var;
by subjid visit day;
run;

%mend;

%aedates(data=AEbaseC , var=dclpain, AeTerm="Localized Pain");
%aedates(data=AEbaseC , var=dclindur, AeTerm="Induration");
%aedates(data=AEbaseC , var=dclitch, AeTerm="Injection itch");
%aedates(data=AEbaseC , var=dcleryth, AeTerm="Erythmia");
%aedates(data=AEbaseC , var=dclwarm, AeTerm="Local Warm");
%aedates(data=AEbaseC , var=dcsfatigue, AeTerm="Fatigue/Malaise");
%aedates(data=AEbaseC , var=dcsheadache, AeTerm="Head pain");
%aedates(data=AEbaseC , var=dcsmuscleaches, AeTerm="muscleaches");
*%aedates(data=AEbaseC , var=dcsjointpain, AeTerm="Pain in joints,general");
%aedates(data=AEbaseC , var=dcsrash, AeTerm="diffused rash");
%aedates(data=AEbaseC , var=dcschills, AeTerm="Chills");
%aedates(data=AEbaseC , var=dcsnausea, AeTerm="Nausea");
%aedates(data=AEbaseC , var=dcstemp, AeTerm="Fever");
*%aedates(data=AEbaseC , var=dcsdizzi, aeterm="Dizziness");

 proc datasets nolist lib=work;
 delete end: ;    /* all data sets that begin with geomean */
 delete return:;  /* all data sets that begin with out */
 delete trans:;


 
quit;

/*as of now, there are no cases for dizzi, nausea, jointpain so there is no data to generate*/

/********adding a few unsolicited event rows for fengming************/

data unsolic;
set AEbaseB;
where subjid in ('575-0074' '575-0089' '575-0107' '575-0147' '575-0013');
keep subjid visit day vacvisdat ;

run;

data unsolAE;
length AETerm $20;
retain subjid visit day vacvisdat AETerm;
set unsolic;
call streaminit(54321);

array AE [4] _temporary_ (.20 0.30 0.30 .20);
AEstdat=intnx('day', vacvisdat, rand('normal',5,2));
AEendat=intnx('day', AEstdat, rand('poisson',0.3));
day=AEstdat-vacvisdat;
format AEstdat mmddyy10.;
format AEendat mmddyy10.;
aeset=rand('table',of AE[*]);
if aeset=1 then aeTerm='Confusion';
else if aeset in (2) then aeTerm='Agitation';
else if aeset in (3) then aeTerm='Blader Infection';
else if aeset in (4) then aeterm='increased Libido';


run;



data MockAEcomb;
retain subjid visit day aeterm ;
merge aedates_dcleryth aedates_dclindur aedates_dclitch aedates_dclpain aedates_dclwarm aedates_dcsfatigue 
		 aedates_dcsheadache aedates_dcsmuscleaches;
by subjid visit day;


if aeendat=. then delete;





run;

data mockAE;
set mockaecomb;
aespid+1;
by subjid;
if first.subjid then aespid=1;
array coinflp[2] _temporary_ (0.5 0.5);
array coinflp2[7] _temporary_ (0.25 0.25 0.20 0.10 0.10 0.05 0.05);

aeongo=.;

aeout=rand('table',of coinflp[*]);
if aesev in (3 4) then aemed=1;
else aemed=0;

if aesev=4 then aeser=3;
else aeser=rand('table',of coinflp[*]);
if aeser=1 then aeser=0;
 if aeser in ( 2 3) then aeser=1;

if aeser=1 then do;
	if aesev=4 then aesaecod=6;
	if aesev<4 then aesaecod=rand('table',of coinflp[*]);
		if aesaecod=1 then aesaecod=3;
		else if aesaecod=2 then aesaecod=4;
		else if aesaecod=6 then aesaecod=2;
		
		
end;

aepimmc=rand('table',of coinflp[*]);
if aepimmc=1 then aepimmc=0;
else if aepimmc=2 then aepimmc=1;

if aesev=4 then aemaae=1;
else if aesev<4 then do;
	aemaae=rand('table',of coinflp[*]);
	

end;
if aemaae=1 then do;
	if aesev=4 then aemaaevisit=1;
	else if aesev<4 then aemaaevisit=rand('table',of coinflp2[*]);
end;
if aemaae=1 then aemaae=0;
else if aemaae=2 then aemaae=1;

aemaaevisitsp=.;
aerel=rand('poisson',0.5);
aedis=0;
aesum=.;
adverse_events_complete=2;




run;

data mddat.ae;
set mockAE;

run;

/*fixing the output missalignment with the data dictionary for pimmc and aemaae*/

data mddat.ae2;
set mddat.ae;
if aepimmc=1 then aepimmc=0;
else if aepimmc=2 then aepimmc=1;
if aemaae=1 then aemaae=0;
else if aemaae=2 then aemaae=1;
run;




 




/**************************************Code testing pre-macro************/
/*************************************************************************************/

proc transpose data=AEbaseC out=transtst prefix=indurday_;
    by subjid visit vacvisdat aestdat ;
    id day;
    var dclindur;
run;


/******Flags rows with no grade 3 events and removes them, leaving only those with severe+ diary card entrys****/
data transtst2;
retain subjid  visit vacvisdat aestdat indurday_1-indurday_14;
set transtst;
if indurday_1 <3 and indurday_2<3 and indurday_3<3 and indurday_4<3 and indurday_5<3 and indurday_6<3 and  indurday_7<3 and indurday_8<3 and indurday_14<1  then delflg=1;
if delflg=1 then delete;
run;

/*****************Program to create start-date and end-date values by diary card entry days*/
data enddates2;
set transtst2;
array varday [14] indurday_1-indurday_14;
array AEsubstart [16];
array AEsubend [16];


/***********Do loop for generating start dates***************/
do i=1 to dim(varday);
  j=i-1;
  		/*The j value will break if i=1 has an AE, so this loop avoids the 
  			need for a comparison check to j since there can't be an earlier date*/
		if i=1 then do;
			if varday[i] ne . then dayset= input(compress(vname(varday[i]),,'kd'), 6.);
			if varday[i] ne . then AEsubstart[i]=intnx('day', vacvisdat, dayset);
		end;
		else do;
			if varday[i] ne . then dayset= input(compress(vname(varday[i]),,'kd'), 6.);
			if varday[i] ne . then do;
				if varday[j]=varday[i] then aesubstart[i]=aesubstart[j];
				else if varday[j] ne varday[i] then	do;/*this accidently sets a stop date to the first occorance of an AE since. Needs to put a varday[j] ne . in here somehow*/
					AEsubstart[i]=intnx('day', vacvisdat, dayset);
					AEsubend[j]=aesubstart[i]-1;/*<<<<this is what causes the end dates for the 'last nonAE' status. */
					if varday[j]=. and varday[i] ne . then aesubend[j]=.;/*Fixes the above issue with the first AE value*/
				end;			
			end;
			if varday[i]=. and varday[j] ne . then do;
				dayset= input(compress(vname(varday[j]),,'kd'), 6.);
				aesubend[j]=intnx('day', vacvisdat, dayset);;
			end;
			*if varday[i]=. and varday[j]=. then aesubend[i]=.;
		end;
	if i=14 then do;
		aesubend[i]=intnx('day',aesubstart[i],rand('uniform',0,3));
	end;
end;

/*************Do loop for generating End dates*************/


format aesubstart1-aesubstart16 mmddyy10.;
format aesubend1-aesubend16 mmddyy10.;
drop _name_ deflg i j dayset ;
run;
		



proc transpose data=enddates2 out=transbackvar;
  by subjid visit;
  var indurday_1-indurday_14;
run;

data returnVAR;
  set transbackvar (rename=(col1=AEsev));
  day=input(substr(_name_, 10), 5.);
  drop _name_;
  aeterm='dclindur';
run; 


proc transpose data=enddates2 out=transbackstrt;
  by subjid visit;
  var AEsubstart1-aesubstart14;
run;

data returnstart;
  set transbackstrt (rename=(col1=AEstrt));
  day=input(substr(_name_, 11), 5.);
  drop _name_;
run; 

proc transpose data=enddates2 out=transbackend;
  by subjid visit;
  var AEsubend1-aesubend14;
run;

data returnend;
  set transbackend (rename=(col1=AEend));
  day=input(substr(_name_, 9), 5.);
  drop _name_;
run; 

proc sort data=returnvar; by subjid visit day;run;
proc sort data=returnstart; by subjid visit day;run;
proc sort data=returnend; by subjid visit day;run;


data dclindurtest;
merge returnvar returnstart returnend;
by subjid visit day;
run;


data nodiary;
set mddat.dcl;

if dclpain<2 and dclitch<2 and dclindur<2 and dcleryth<2 and dclwarm<2 then delflg=0;
else delflg=1;
rename dclday=day;
run;


proc freq data=nodiary ;
table subjid*delflg/norow nocol nopercent
out=lclfreq
sparse;
run;

















