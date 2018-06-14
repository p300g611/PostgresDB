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
where displayidentifier in ('188304001') 
order by displayidentifier
        ,createddate desc;

 select * from organization_parent(57265);
--///////////////update code//////////////////

--update the org_name "CONCORDIA LEARNING CENTER" to "St. Joseph’s School for the Blind" 
begin;

update organization 
set organizationname ='St. Joseph''s School for the Blind'
   ,modifieddate=now()
   ,modifieduser=12
where displayidentifier in ('188304001'); 


commit;

----------------------------------------------------------
/*
-- insert actived schools into organizationtreedetail --select refresh_organization_detail()
*/
	


