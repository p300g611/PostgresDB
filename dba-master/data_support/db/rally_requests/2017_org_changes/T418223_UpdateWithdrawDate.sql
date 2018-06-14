/*
-before update 
select exitwithdrawaldate from enrollment where id =2668725;

 exitwithdrawaldate │ 2017-01-03 06:00:00+00 │
 
 */
 
 
 BEGIN;
 
 update enrollment 
 set    exitwithdrawaldate='2017-01-02 06:00:00+00',
        modifieddate=now(),
        modifieduser =12
		
where id = 2668725;

COMMIT;