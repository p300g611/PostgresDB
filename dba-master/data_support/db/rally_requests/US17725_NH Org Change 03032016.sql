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
where displayidentifier in ('21220','000','279') 
     and (select  displayidentifier from organization_parent(o.id) where organizationtypeid=2) ='NH'
     order by displayidentifier
        ,createddate desc;

--///////////////update code//////////////////
select * from organization_parent(63773);

--moving the "Keene" district to "Out-Of-District" (NOTE: automatically move the region to "Out-Of-District" from  "Keene SAU Office")
begin;

 update organizationrelation 
 set modifieduser=12,
    modifieddate=now(),
    parentorganizationid=69077
     where organizationid=63773 and parentorganizationid=59437;
 

commit;

----------------------------------------------------------
/*
BEGIN;
-- insert actived schools into organizationtreedetail --select refresh_organization_detail()



  update organizationtreedetail
  set districtid=69077,
      districtname='Out-Of-District',
      districtdisplayidentifier='000'
      where schoolid=63773
COMMIT;      
           
*/
	


