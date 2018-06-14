



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=5) distid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dist_iden,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stn from organization o
where displayidentifier in ( '500_1500','500_5200','20_5200') 
order by displayidentifier , createddate desc;

 

--///////////////update code//////////////////


-- reactivate the school for this school year in MS,Ms-cpass states. 
update organization 
set activeflag=true ,
    modifieddate=now(),
	modifieduser=12
	where displayidentifier in ('500_1500','500_5200') and activeflag=false; 
	
-- Updated school name old "WILSON ELEMENTARY SCHOOL" new "Virgil Jones, Jr Elementary" in MS,Ms-cpass states
update organization 
set organizationname='Virgil Jones, Jr Elementary' ,
    modifieddate=now(),
	modifieduser=12
	where displayidentifier in ('20_5200');  	 

	
----------------------------------------------------------
/*-- insert actived schools into organizationtreedetail --select refresh_organization_detail();
  INSERT INTO organizationtreedetail(schoolid,
					      schoolname,
					      schooldisplayidentifier,
					      districtid,
					      districtname,                                
					      districtdisplayidentifier,
					      stateid,
					      statename,
					      statedisplayidentifier)
			       SELECT schorg.id                                                                                                      schoolid,
				      schorg.organizationname                                                                                        schoolname,
				      schorg.displayidentifier                                                                                       schooldisplayidentifier, 
				      (SELECT id FROM organization_parent(schorg.id) WHERE organizationtypeid=5 LIMIT 1 )                  districtid,
				      (SELECT organizationname FROM organization_parent(schorg.id) WHERE organizationtypeid=5 LIMIT 1 )    districtname,                                    
				      (SELECT displayidentifier FROM organization_parent(schorg.id) WHERE organizationtypeid=5 LIMIT 1 )   districtdisplayidentifier,
				      (SELECT id FROM organization_parent(schorg.id) WHERE organizationtypeid=2 LIMIT 1 )                  stateid, 
				      (SELECT organizationname FROM organization_parent(schorg.id) WHERE organizationtypeid=2 LIMIT 1 )    statename,
				      (SELECT displayidentifier FROM organization_parent(schorg.id) WHERE organizationtypeid=2 LIMIT 1 )   statedisplayidentifier     
					 FROM organization schorg
					  LEFT OUTER JOIN organizationtreedetail curr
						       ON curr.schoolid=schorg.id
					   WHERE schorg.activeflag=true and schorg.organizationtypeid=7 and schorg.displayidentifier in ('500_1500','500_5200') and curr.schoolid IS NULL;	

*/
					   