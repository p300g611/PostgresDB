begin;

select * from aartuser  where id=29989;

update aartuser
set modifieddate=now(),
   modifieduser=174744,
   activeflag= false,
   email='kswearingen@usd232.org_old'
   where id = 29989 and activeflag is true;


select * from userassessmentprogram where aartuserid = 29989 and activeflag is true;

update userassessmentprogram
set modifieddate=now(),
   modifieduser=174744,
   activeflag= false
   where aartuserid = 29989 and activeflag is true;

commit;
