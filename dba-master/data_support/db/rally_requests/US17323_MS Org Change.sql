



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=5) st,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stn from organization o
where displayidentifier in ( '92_1700','500_2520')
order by displayidentifier , createddate desc;

 
-- two user created for 2016 current active scholl
select * from usersorganizations where organizationid=79421;

-- do not have any enrollment ,roster 
 select * from enrollment where attendanceschoolid =79421;
 select * from roster where teacherid in (151105,151104);






--///////////////update code//////////////////

--moving the user to inactive organization.
update usersorganizations 
set organizationid =58408
where organizationid=79421;

-- update inactive Mississippi & Mississippi-cPass  org's to active status
update organization 
set activeflag=true ,
    modifieddate=now(),
	modifieduser=12
	where displayidentifier in ( '92_1700','500_2520') and id in (66719,58408,67024,4398) and activeflag=false;  

--update active org for Mississippi that created on jan 25th,2016 to inactive status
update organization 
set activeflag=false,
    modifieddate=now(),
	modifieduser=12
	where displayidentifier in ('500_2520') and id=79421  and activeflag=true; 