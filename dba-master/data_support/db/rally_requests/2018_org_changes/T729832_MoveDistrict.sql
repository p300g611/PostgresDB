--move organization to new region

begin;
update organizationrelation
set    parentorganizationid=86430,
       modifieddate=now(),
	   modifieduser= (select id from aartuser where email='ats_dba_team@ku.edu')
	   where organizationid in (59463);
	   
commit;

