/*--///////////////validation//////////////////
-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('500_4000') 
order by displayidentifier , createddate desc;
*/
--///////////////update code//////////////////
begin;

update organization 
set activeflag=true,
    modifieddate=now(),
    modifieduser=12
	where displayidentifier in ('500_4000') and activeflag=false;  

-- refresh org tree 
	   INSERT INTO organizationtreedetail(schoolid,
					      schoolname,
					      schooldisplayidentifier,
					      districtid,
					      districtname,                                
					      districtdisplayidentifier,
					      stateid,
					      statename,
					      statedisplayidentifier,
					      createddate)
			       SELECT upd.id                schoolid,
				      upd.organizationname  schoolname,
				      upd.displayidentifier schooldisplayidentifier,
				      (select id from organization_parent(upd.id) where organizationtypeid=5 limit 1) districtid,
				      (select organizationname from organization_parent(upd.id) where organizationtypeid=5 limit 1) districtname,                                
				      (select displayidentifier from organization_parent(upd.id) where organizationtypeid=5 limit 1) districtdisplayidentifier,
				      (select id from organization_parent(upd.id) where organizationtypeid=2 limit 1) stateid,
				      (select organizationname from organization_parent(upd.id) where organizationtypeid=2 limit 1) statename,
				      (select displayidentifier from organization_parent(upd.id) where organizationtypeid=2 limit 1) statedisplayidentifier,
				      now() createddate
					 FROM organization upd
					  LEFT OUTER JOIN organizationtreedetail curr
						       ON curr.schoolid=upd.id
					   WHERE  upd.displayidentifier in ('500_4000') and curr.schoolid IS NULL and upd.activeflag=true;	

commit;