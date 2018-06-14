



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('500_0900')
order by displayidentifier , createddate desc;


--///////////////update code//////////////////


-- update inactive Mississippi & Mississippi-cPass  org's to active status
update organization 
set activeflag=true ,
    modifieddate=now(),
    modifieduser=12
	where displayidentifier in ('500_0900')  and activeflag=false;  
