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
where displayidentifier in ('299','207','NH71') 
     and (select  displayidentifier from organization_parent(o.id) where organizationtypeid=2) ='NH'
     order by displayidentifier
        ,createddate desc;

--///////////////update code--"Mississippi"//////////////////

select * from organization_parent(79455);

begin;

 update organizationrelation 
 set modifieduser=12,
    modifieddate=now(),
    parentorganizationid=58641
    where organizationid =79455 and parentorganizationid=59411;
     
commit;

