
data out;
	set cert.input44;
	drop=bp_status weight_status smoking_status;
	if cholesterol is not missing then do;
	if cholesterol < 200 then chol_status='Safe';
	else if cholesterol <= 239 then chol_status='High-Borderline';
	else if cholesterol >= 240 then chol_status='High';
run;

proc contents data=out;
run;

proc freq out; 
	table chol_status;
run;

