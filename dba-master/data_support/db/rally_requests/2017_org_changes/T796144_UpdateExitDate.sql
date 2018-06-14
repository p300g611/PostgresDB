/*
-before update 
select * from enrollment where id=2720253;


 exitwithdrawaldate                 │ 2017-01-11 06:00:00+00 
 
 */
 
 
 BEGIN;
 
 update enrollment 
 set    exitwithdrawaldate='2017-01-10 06:00:00+00',
        modifieddate=now(),
        modifieduser =12
		
where id = 2720253;

COMMIT;