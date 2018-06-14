



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=2) st,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stn from organization o
where displayidentifier in ( '231082 000')
order by displayidentifier , createddate desc;

 





--///////////////update code//////////////////


-- district name change "Central Clinton Comm School District" to "Central DeWitt Community School District"
update organization 
set organizationname='Central DeWitt Community School District' ,
    modifieddate=now(),
	modifieduser=12
	where id=9724;  
