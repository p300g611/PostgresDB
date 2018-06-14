



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('050160650616100','190220200636300' )
order by displayidentifier , createddate desc;


-- find the schools under this district
--'050160650616100'
select * from organization_children(56000);--no schools
select * from organization_children(45489);
--190220200636300
select * from organization_children(56021);--no schools
select * from organization_children(45538);


--///////////////update code//////////////////

-- request Info : REMOVE West Monona Elementary School (676987 427)

update organization 
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
	where id in (56000,56021) and activeflag =true ; 


	  
	 