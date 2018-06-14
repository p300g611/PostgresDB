/*--organization info
select id, organizationname, displayidentifier, createddate::date, activeflag,
       modifieddate::date, 
	   (select organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	   (select id from organization_parent(o.id) where organizationtypeid=5) st,
	   (select organizationname from organization_parent(o.id) where organizationtypeid =2 ) dis,
	   (select id from organization_parent(o.id) where organizationtypeid =2 ) stn from organization o
	   where displayidentifier ='6_5720'
	   order by displayidentifier, createddate desc;	   

*/   
BEGIN;
-- organization dist to school
update organization
set  activeflag = true,
     modifieddate = now(),
     modifieduser = 12,
     organizationtypeid=7
     where displayidentifier = '6_5720';

      
 
--update organizationrelation 
update organizationrelation
set  parentorganizationid = 4018,
     modifieddate = now(),
     modifieduser = 12
     where organizationid =79478 and parentorganizationid=3907;


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
					   WHERE  upd.displayidentifier in ('6_5720') and curr.schoolid IS NULL and upd.activeflag=true;

COMMIT;