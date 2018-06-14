do
$BODY$ 
DECLARE                                                                                                                                              
                 storgtypeid bigint;                                                                                                                          
                 dtorgtyoeid bigint;                                                                                                                          
                 schorgtypeid bigint;                                                                                                                                        
  BEGIN                                                                                                                                                
                 SELECT INTO storgtypeid  (SELECT id FROM organizationtype  WHERE typecode='ST'  AND activeflag is true);                                        
                 SELECT INTO dtorgtyoeid  (SELECT id FROM organizationtype  WHERE typecode='DT'  AND activeflag is true);                                        
                 SELECT INTO schorgtypeid (SELECT id FROM organizationtype  WHERE typecode='SCH' AND activeflag is true);                                      

       -- CREATE TEMPORARY TABLE
       IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_organizationtreedetail' and table_type='LOCAL TEMPORARY')
                THEN DROP TABLE IF EXISTS tmp_organizationtreedetail; END IF;
       create temp table tmp_organizationtreedetail (schoolid bigint NOT NULL,
						  schoolname character varying(200) NOT NULL,
						  schooldisplayidentifier character varying(100) NOT NULL,
						  districtid bigint,
						  districtname character varying(200),
						  districtdisplayidentifier character varying(100),
						  stateid bigint,
						  statename character varying(200),
						  statedisplayidentifier character varying(100),
						  createddate timestamp with time zone NOT NULL DEFAULT now());
       insert into tmp_organizationtreedetail						  
       SELECT schorg.id                                                                                                      schoolid,
              schorg.organizationname                                                                                        schoolname,
              schorg.displayidentifier                                                                                       schooldisplayidentifier, 
              (SELECT id FROM organization_parent(schorg.id) WHERE organizationtypeid=dtorgtyoeid LIMIT 1 )                  districtid,
              (SELECT organizationname FROM organization_parent(schorg.id) WHERE organizationtypeid=dtorgtyoeid LIMIT 1 )    districtname,                                    
              (SELECT displayidentifier FROM organization_parent(schorg.id) WHERE organizationtypeid=dtorgtyoeid LIMIT 1 )   districtdisplayidentifier,
              (SELECT id FROM organization_parent(schorg.id) WHERE organizationtypeid=storgtypeid LIMIT 1 )                  stateid, 
              (SELECT organizationname FROM organization_parent(schorg.id) WHERE organizationtypeid=storgtypeid LIMIT 1 )    statename,
              (SELECT displayidentifier FROM organization_parent(schorg.id) WHERE organizationtypeid=storgtypeid LIMIT 1 )   statedisplayidentifier,
              now()                                                                                                          createddate
                           FROM organization schorg
			     WHERE schorg.activeflag=true 
			       AND schorg.organizationtypeid=schorgtypeid;
			       

       -- DELETE FOR INACTIVE ORGANIZATION    
            DELETE  from organizationtreedetail curr
		 WHERE NOT EXISTS ( SELECT 1 FROM tmp_organizationtreedetail upd
				              WHERE curr.schoolid=upd.schoolid);    
       -- UPDATE FOR RECENT CHANGE ORGANIZATION    
	     UPDATE organizationtreedetail curr
		 SET    schoolname=upd.schoolname ,          
			schooldisplayidentifier=upd.schooldisplayidentifier,
			districtid=upd.districtid,
			districtname=upd.districtname   ,         
			districtdisplayidentifier=upd.districtdisplayidentifier,
			stateid=upd.stateid,
			statename=upd.statename,
			statedisplayidentifier=upd.statedisplayidentifier,
			createddate=upd.createddate
		   FROM tmp_organizationtreedetail upd 
		      WHERE  curr.schoolid=upd.schoolid
				  AND(     COALESCE(curr.schoolname,'')<>COALESCE(upd.schoolname,'')           
					OR COALESCE(curr.schooldisplayidentifier,'') <>COALESCE(upd.schooldisplayidentifier,'') 
					OR COALESCE(curr.districtid,0) <>COALESCE(upd.districtid,0) 
					OR COALESCE(curr.districtname,'') <>COALESCE(upd.districtname,'')             
					OR COALESCE(curr.districtdisplayidentifier,'') <>COALESCE(upd.districtdisplayidentifier,'') 
					OR COALESCE(curr.stateid,0) <>COALESCE(upd.stateid,0) 
					OR COALESCE(curr.statename,'') <>COALESCE(upd.statename,'') 
					OR COALESCE(curr.statedisplayidentifier,'') <>COALESCE(upd.statedisplayidentifier,'') );	
        -- INSERT FOR NEW ORGANIZATION ADDED 
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
			       SELECT upd.schoolid,
				      upd.schoolname,
				      upd.schooldisplayidentifier,
				      upd.districtid,
				      upd.districtname,                                
				      upd.districtdisplayidentifier,
				      upd.stateid,
				      upd.statename,
				      upd.statedisplayidentifier,
				      upd.createddate
					 FROM tmp_organizationtreedetail upd
					  LEFT OUTER JOIN organizationtreedetail curr
						       ON curr.schoolid=upd.schoolid						       
					   WHERE curr.schoolid IS NULL;	
       IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_organizationtreedetail' and table_type='LOCAL TEMPORARY')
                THEN DROP TABLE IF EXISTS tmp_organizationtreedetail; END IF;
raise info 'Script executed successfully';
end ;
$BODY$;					   