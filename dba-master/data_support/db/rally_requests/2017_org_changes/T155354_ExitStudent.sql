BEGIN;

update student 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser= 12
where id in (403563,1108688);


update enrollment
set   activeflag =false,
      exitwithdrawaltype =10,
	  exitwithdrawaldate=now(),
	  modifieddate = now(),
	  modifieduser=12
where id in (2447715,1972689);



END;
