
data groups;
set cert.input48;
if upcase(cvar) in ('A','B','C','D','E','F','G') then group=1;
else if upcase(cvar) in ('H','I','J','K','L','M','N') then group=2;
else group=3;
run;

/* Calculate the average of X and Y by Group */
/* What is the average of X and Y for Group 2? */

proc means data=groups average maxdec=2;
class group;
var x y;
if group=2;
run;



