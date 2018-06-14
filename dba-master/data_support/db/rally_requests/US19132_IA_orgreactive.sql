/*--organization info
select id, organizationname, displayidentifier, createddate::date, activeflag,
       modifieddate::date, 
	   (select organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	   (select id from organization_parent(o.id) where organizationtypeid=5) st,
	   (select organizationname from organization_parent(o.id) where organizationtypeid =2 ) dis,
	   (select id from organization_parent(o.id) where organizationtypeid =2 ) stn from organization o
	   where displayidentifier ='501332 418'
	   order by displayidentifier, createddate desc;
	   


*/   
BEGIN;
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
					   WHERE  upd.displayidentifier in ('501332 418') and curr.schoolid IS NULL and upd.organizationtypeid=7 and upd.activeflag=true;

COMMIT;
