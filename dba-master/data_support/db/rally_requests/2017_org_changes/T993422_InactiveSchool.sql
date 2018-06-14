/*

select id, displayidentifier, organizationname,activeflag
--into temp tmp_activeschool
 from organization 
 where organizationtypeid =7 and id in (select organizationid from organizationrelation where parentorganizationid =69077);
 
 \copy (select * from tmp_activeschool) to 'T993422_schoolbackup.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 
 
*/

BEGIN;

update organization 
set   activeflag =true,
       modifieddate= now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =69077;



update organization 
set    activeflag =true,
       modifieddate= now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where  organizationtypeid =7 and activeflag is false
and  id in (select organizationid from organizationrelation where parentorganizationid =69077 and activeflag is true);


select refresh_organization_detail();


commit;



select count(*) from organizationtreedetail where districtid= 69077;

