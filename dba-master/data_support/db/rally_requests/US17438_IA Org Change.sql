



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=5) st,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stn from organization o
where displayidentifier in ( '961638 440')
order by displayidentifier , createddate desc;

 





--///////////////update code//////////////////


-- update status to active and name "John Cline Elementary School" to "Decorah Community School District" and display identifier to "961638 440" to "494041 500"
update organization 
set activeflag=true ,
    modifieddate=now(),
	modifieduser=12
	where id=20983 and activeflag=false;  
