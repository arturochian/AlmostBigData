proc freq data=Cr.dane2 page;
tables r_os;
run;


proc freq data=Cr.dane2 page;
by r_os;
tables package;
run;

