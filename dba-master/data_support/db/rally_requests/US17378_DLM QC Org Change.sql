



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('01 DEMO DISTRICT') 
order by displayidentifier , createddate desc;


--///////////////update code//////////////////

-- NOTE:: user story reguested  for delete the org

update organization 
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
	where id =79423 and activeflag=true;  
