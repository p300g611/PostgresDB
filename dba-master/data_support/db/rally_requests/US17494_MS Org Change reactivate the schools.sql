



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=5) distid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dist_iden,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stn from organization o
where displayidentifier in ( '20_2400','500_2560') 
order by displayidentifier , createddate desc;

 
-- Note:I did not find the " Mississippi-cPass" for school "500_2560" 

-- select * from organization_children(66660);


--///////////////update code//////////////////


-- reactivate the school for this school year. 
update organization 
set activeflag=true ,
    modifieddate=now(),
	modifieduser=12
	where displayidentifier in ( '20_2400','500_2560') and activeflag=false;  

	
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
					   WHERE schorg.activeflag=true and schorg.organizationtypeid=7 and schorg.displayidentifier in ('20_2400','500_2560') and curr.schoolid IS NULL;	

*/
					   