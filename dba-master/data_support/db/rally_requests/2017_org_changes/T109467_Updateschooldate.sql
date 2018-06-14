begin;
update enrollment 
set schoolentrydate = '2016-07-18 05:00:00+00',
 exitwithdrawaldate = '2016-07-18 05:00:00+00', 
 modifieddate = now(),
 modifieduser = 174744 
 where id = 2799865;
 
 
 update enrollment 
 set schoolentrydate = '2011-09-11 05:00:00+00',
 modifieddate = now(), 
 modifieduser = 174744 
 where id = 2799346;
 
 
 
 update enrollment 
 set schoolentrydate = '2011-02-27 06:00:00+00', 
 exitwithdrawaldate = '2011-02-27 06:00:00+00', 
 modifieddate = now(), 
 modifieduser = 174744 
 where id = 2892573;
 
 commit;