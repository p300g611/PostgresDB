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
					   WHERE  curr.schoolid IS NULL and upd.organizationtypeid=7 and upd.activeflag=true;

COMMIT;
