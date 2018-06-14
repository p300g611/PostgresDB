/*--organization info
select id, organizationname, displayidentifier, createddate::date, activeflag,
       modifieddate::date, 
	   (select organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	   (select id from organization_parent(o.id) where organizationtypeid=5) st,
	   (select organizationname from organization_parent(o.id) where organizationtypeid =2 ) dis,
	   (select id from organization_parent(o.id) where organizationtypeid =2 ) stn from organization o
	   where displayidentifier ='4_2700'
	   order by displayidentifier, createddate desc;
	   
--two users created for 2016 current active school
select * from usersorganizations where organizationid in (67255,4420); --need activate only one user both are same
select * from aartuser where id in (61311,53563); --same user 
select * from roster where teacherid in (61311,53563) and activeflag is false;  --already active rosters
select * from roster where teacherid  = any(values(61311),(53563));--already active rosters
select * from enrollment where attendanceschoolid =any(values(67255),(4420)); --do not have enrollment
select * from enrollmentsrosters where enrollmentid in (868795,1609870); --do not have enrollment
select * from enrollmentsrosters where rosterid in (357652,336722); --do not have enrollment

*/   
BEGIN;     
DO
$BODY$
DECLARE
  now_date timestamp with time zone;
  row_count integer;
BEGIN
  now_date :=now(); 


--update organization
update organization
set  activeflag = true,
     modifieddate = now_date,
     modifieduser = 12
     where displayidentifier = '4_2700' and activeflag = false;
        row_count := (select count(*) from organization where modifieddate=now_date and modifieduser = 12);
        RAISE NOTICE 'rows updated on organization: %', row_count;
--update aartuser
update aartuser
set  modifieddate = now_date,
     modifieduser = 12,
     uniquecommonidentifier=uniquecommonidentifier||'orphan'
     where id in (53563) and activeflag = false;        
 
--update aartuser
update aartuser
set  activeflag = true,
     modifieddate = now_date,
     modifieduser = 12,
     username=replace(username,'-orphan',''),
     email=replace(email,'-orphan',''),
     uniquecommonidentifier=replace(uniquecommonidentifier,'-orphan','')
     where id in (61311) and activeflag = false;
     row_count := (select count(*) from aartuser where modifieddate=now_date and modifieduser = 12);
         RAISE NOTICE 'rows updated on aartuser: %', row_count;
         
 END;
$BODY$;


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
					   WHERE  upd.displayidentifier in ('4_2700') and curr.schoolid IS NULL and upd.activeflag=true;

COMMIT;