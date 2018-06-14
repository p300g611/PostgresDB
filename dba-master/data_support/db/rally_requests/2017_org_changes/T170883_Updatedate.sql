/*
-before update 
select exitwithdrawaldate from enrollment where id =2475388;

 exitwithdrawaldate │ 2017-01-25 06:00:00+00 │
 
 */
 
 
 BEGIN;
 
 update enrollment 
 set    exitwithdrawaldate='2017-01-24 06:00:00+00',
        modifieddate=now(),
        modifieduser =12
		
where id = 2475388;

COMMIT;

