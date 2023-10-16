data SheepNumbers; 
 length Country $25. Year 4. Number 8.; 
 infile cards; 
 input @1Country $ & @26Year @31Number; 
cards; 
Australia                2007 85711187 
Australia                 2006 91028408 
Australia                2005 101124891 
Canada                   2007 879100 
Canada                   2006 893800 
Canada                   2005 977600 
China                    2007 146018203 
China                    2006 151337202 
China                    2005 152035223 
India                    2007 64269000 
India                    2006 63558000 
India                    2005 62854000 
New Zealand              2007 38460477 
New Zealand              2006 40098191 
New Zealand              2005 39879660 
South Africa             2007 25082100 
South Africa             2006 24982996 
South Africa             2005 25334000 
United Kingdom           2007 33946000 
United Kingdom           2006 34722000 
United Kingdom           2005 35253048 
United States of America 2007 6165000 
United States of America 2006 6230000 
United States of America 2005 6135000 
; 
run;

proc sort data=SheepNumbers;
 by Country DESCENDING Year Number;/*ascending country
 descending year ascending number*/
 run;
 ** Set up standard titles and footnotes; 
 title1 "Sheep Numbers in Select Countries, 
 By Year"; 

 footnote1 "Note: Numbers for India are FAO Estimate"; 
 footnote2 "Source: UNData, 03Nov2010";
 
 
 proc print data=SheepNumbers; 
 var Country Year Number;
 title "a";
 title5 "Sheep Numbers in Select Countries,By Year";  
 title1 "(Basic Output)";
 footnote1 "Note: Numbers for India are FAO Estimate"; 
 footnote2 "Source: UNData, 03Nov2010";
 /*MAXIMUM title and footnote is 10*/
 run; 
 
 
  proc print data=SheepNumbers  noobs label ;/*noobs-no obs column*/ 
 var Country Year Number; 
 label Country='Country' Year='Year' Number='Reported Number'; 
title2 "(Something a Little Better)";
 Run;
 
 proc print data=SheepNumbers obs='id' label double split='*' ; 
 var Country Year Number; 
 label Country='Country*aus*,us,' Year='Year*2001' 
 Number='Reported*Number'; 
title2 "(Something a Little Better)";
 Run;
 
 proc print data=SheepNumbers label;
 by Country; 
 id Country; 
 var Year Number;
  
 format Number comma12.; 
 label Country='Country' Year='Year' Number='Reported Number'; 
 title2 "(Something even better, with BY and ID)";
 Run;
 
 
 proc printto print='/home/wyniap0/sasuser.v94/carrs/C2.txt' new;
 run; 
 proc print data=SheepNumbers label split='!';
 by Country;
 id Country;
 var Year Number;
 format Number comma12.; 
label Country='Country!££££££££££££££££££££££££' NESUG 2011 DATA Step 
Programming Year='Year!£' 
Number='Reported!Number!££££££££££££';
 title2 "(Something even better, 
 with what looks like the HEADLINE option in PROC REPORT)";
 run;
 proc printto; 
 run;
 
 
 
 proc printto log='/home/wyniap0/sasuser.v94/carrs/C2log.txt' new;
 run; 
 proc print data=SheepNumbers label split='!';
 by Country;
 id Country;
 var Year Number;
 format Number comma12.; 
label Country='Country!££££££££££££££££££££££££' NESUG 2011 DATA Step 
Programming Year='Year!£' 
Number='Reported!Number!££££££££££££';
 title2 "(Something even better, 
 with what looks like the HEADLINE option in PROC REPORT)";
 run;
 proc printto; 
 run;
 
 proc print data=SheepNumbers
 label n;
 title2 "(Output using the SUM Statement)"; 
 by Country;
 id Country; 
 var Year Number; 
 format Number comma18.;
 label Country='Country' Year='Year' Number='Reported Number';
 sum number;
 run;
 
 
 
 ods listing close; /*output delivery system*/
 ods html file='/home/wyniap0/sasuser.v94/carrs/odscnt.html' 
 style=meadow;
 proc print data=SheepNumbers
 label split='!' sumlabel='total' 
 grandtotal_label='Grand Total' ; 
 by Country;
 id Country/style(col)=[backgroundcolor=yellow]; 
 var Year /style=[cellwidth=0.5in just=c]; 
 var Number /style=[cellwidth=1.0in] ;
 sum number /style(grandtotal)=[backgroundcolor=green]; 
 format Number comma20.  ; 
 label Country='Country!cnt' Year='Year' Number='Reported!Number';
 
 title2 "(HTML 
 Output, Using Custom Termplate)";
 run; 
 ods html close;
 ods listing; run;
 
 
 
 ods pdf file='/home/wyniap0/sasuser.v94/carrs/odscnt.pdf' 
 style=festival;
 proc print data=SheepNumbers
 label split='!' sumlabel='total' 
 grandtotal_label='Grand Total' ; 
 by Country;
 id Country/style(col)=[backgroundcolor=yellow]; 
 var Year /style=[cellwidth=0.5in just=c]; 
 var Number /style=[cellwidth=1.0in] ;
 sum number /style(grandtotal)=[backgroundcolor=green]; 
 format Number comma20.  ; 
 label Country='Country!cnt' Year='Year' Number='Reported!Number';
 
 title2 "(pdf
 Output, Using Custom Termplate)";
 run; 
 ods pdf close;
 
 
 ods rtf file='/home/wyniap0/sasuser.v94/carrs/odscnt.rtf' 
 ;
 proc print data=SheepNumbers
 label split='!' sumlabel='total' 
 grandtotal_label='Grand Total' ; 
 by Country;
 id Country/style(col)=[backgroundcolor=yellow]; 
 var Year /style=[cellwidth=0.5in just=c]; 
 var Number /style=[cellwidth=1.0in] ;
 sum number /style(grandtotal)=[backgroundcolor=green]; 
 format Number comma20.  ; 
 label Country='Country!cnt' Year='Year' Number='Reported!Number';
 
 
 run; 
 ods rtf close;
 
 
 
 ods excel file='/home/wyniap0/sasuser.v94/carrs/odscnt.xls' /*use extension xls csv xlsx*/
 ;
 proc print data=SheepNumbers
 label split='!' sumlabel='total' 
 grandtotal_label='Grand Total' ; 
 by Country;
 id Country/style(col)=[backgroundcolor=yellow]; 
 var Year /style=[cellwidth=0.5in just=c]; 
 var Number /style=[cellwidth=1.0in] ;
 sum number /style(grandtotal)=[backgroundcolor=green]; 
 format Number comma20.  ; 
 label Country='Country!cnt' Year='Year' Number='Reported!Number';
 
 
 run; 
 ods excel close;
 
 
 
  ods powerpoint file='/home/wyniap0/sasuser.v94/carrs/odscnt.ppt'
 ;
 proc print data=SheepNumbers
 label split='!' sumlabel='total' 
 grandtotal_label='Grand Total' ; 
 by Country;
 id Country/style(col)=[backgroundcolor=yellow]; 
 var Year /style=[cellwidth=0.5in just=c]; 
 var Number /style=[cellwidth=1.0in] ;
 sum number /style(grandtotal)=[backgroundcolor=green]; 
 format Number comma20.  ; 
 label Country='Country!cnt' Year='Year' Number='Reported!Number';
 
 
 run; 
 ods powerpoint close;
 
 
 
 
 ods rtf file='/home/wyniap0/sasuser.v94/carrs/ship.doc'; 
 
 proc print data=SheepNumbers
 label split='!'; 
 by Country;
 id Country; 
 var Year /style=[cellwidth=0.5in just=c]; 
 var Number /style=[cellwidth=1.0in]; 
 format Number comma12.; 
 label Country='Country!cnt' Year='Year' Number='Reported!Number'; 
 title2 "(excel
 Output, Using Custom Termplate)";
 run; 
 ods rtf close;
 
 proc print data=sheepnumbers (firstobs=2 obs=8 );
 run;
 
 
 proc print data=sheepnumbers (firstobs=2 obs=11);
 run;
 
 options pageno /*nodate number pageno pagesize=n */;
 proc print data=sheepnumbers;
 run;
 ods pdf file='/home/wyniap0/sasuser.v94/carrs/shee.pdf';
 options pageno=2 pagesize=25 nodate;
 proc print data=sheepnumbers ;
 by country;
 pageby country;
 run;
 ods pdf close;
 
 /*nodate- will not print current date time
 number - print accumulative page number on each page
 pageno- where you want SAS to start numbering 
 your output
 pagesize- 15 to 32767 how many lines each page*/
 
 
 