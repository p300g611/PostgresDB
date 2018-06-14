



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('268337','268337001') 
order by displayidentifier , createddate desc;


--///////////////update code//////////////////

--update the org_name "COASTAL LEARNING CENTER- HOWELL (268337)" to "COASTAL LEARNING CENTER- MONMOUTH (268337)" 

update organization 
set organizationname='COASTAL LEARNING CENTER- MONMOUTH (268337)',
    modifieddate=now(),
    modifieduser=12
	where id =53036 and displayidentifier='268337';      


--update the org_name "COASTAL LEARNING CENTER - HOWELL" to "COASTAL LEARNING CENTER - MONMOUTH" 

update organization 
set organizationname='COASTAL LEARNING CENTER - MONMOUTH',
    modifieddate=now(),
    modifieduser=12
	where id =53448 and displayidentifier='268337001';   	

	
	 







