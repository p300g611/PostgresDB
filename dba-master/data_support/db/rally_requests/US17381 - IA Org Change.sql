



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where organizationname ilike '%West Monona Elementary%'
order by displayidentifier , createddate desc;


-- already verified do not have any users (No rosters )
select * from usersorganizations where organizationid=60038;

-- do not have any enrollment also 
 select * from enrollment where attendanceschoolid =60038;


--///////////////update code//////////////////

-- request Info : REMOVE West Monona Elementary School (676987 427)

update organization 
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
	where id =60038; 


	  
	 