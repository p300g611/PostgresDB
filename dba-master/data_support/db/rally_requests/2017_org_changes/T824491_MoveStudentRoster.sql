BEGIN;

update testsession 
set    rosterid = 1077349,
       modifieddate = now(),
	   modifieduser=12
where id  = 3878831;

update testsession 
set    rosterid = 1073235,
       modifieddate = now(),
	   modifieduser=12
where id  in (3838550,3830960,3836992,3837442,3837462,3837474,3838543);


update testsession 
set    rosterid = 1095882,
       modifieddate = now(),
	   modifieduser=12
where id  = 3836917;


update ititestsessionhistory
set    rosterid = 1095882,
       modifieddate =now(),
	   modifieduser =12
	where id = 543013;
	
update ititestsessionhistory
set    rosterid = 1073235,
       modifieddate =now(),
	   modifieduser =12
	where id in(560708,561239,570246,570402,570437,572030,572048);
	
update ititestsessionhistory
set    rosterid = 1077349,
       modifieddate =now(),
	   modifieduser =12
	where id = 562241;

update testsession 
set    rosterid = 1095882,
       modifieddate = now(),
	   modifieduser=12
where id  = 3818991;

update ititestsessionhistory
set    rosterid = 1095882,
       modifieddate =now(),
	   modifieduser =12
	where id = 543066;

COMMIT;


