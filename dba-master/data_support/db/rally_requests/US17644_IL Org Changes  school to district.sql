--///////////////validation//////////////////

-- organization info 
select id
      ,organizationname
      ,displayidentifier
      ,organizationtypeid
      ,activeflag
      ,modifieddate::date
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae
      ,(select  id from organization_parent(o.id) where organizationtypeid=5) dtid
      ,(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname
      ,(select  id from organization_parent(o.id) where organizationtypeid=2) stid 
from  organization o
where displayidentifier in ('34049044Z010000','IL') 
order by displayidentifier
        ,createddate desc;

 select * from organization_parent(57265);
--///////////////update code//////////////////

--update the org_name "HAWTHORNE COUNTRY DAY SCHOOL" to "Hawthorne CtryDaySch–NY" 
begin;

update organization 
set organizationtypeid =5
   ,modifieddate=now()
   ,modifieduser=12
where displayidentifier in ('34049044Z010000'); 


 update organizationrelation 
 set modifieduser=12,
    modifieddate=now(),
    parentorganizationid=9632
     where organizationid=57265 and parentorganizationid=56138;
 

commit;

----------------------------------------------------------
/*
-- insert actived schools into organizationtreedetail --select refresh_organization_detail()
*/
	


