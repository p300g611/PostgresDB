



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,organizationtypeid,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('494041 500','284043 000','494041 000') 
order by displayidentifier , createddate desc;


 
--///////////////update code//////////////////

   -- moving the  "284043 000" to "494041 000" ( moving dist  "Maquoketa Valley Comm School District"(9765)  to " Maquoketa Comm School District" (9703))
   
	update organizationrelation
	set parentorganizationid=9703,
	   modifieduser=12,
	   modifieddate=now()
	where organizationid=58725 and parentorganizationid=9765; 

	

	
	 







