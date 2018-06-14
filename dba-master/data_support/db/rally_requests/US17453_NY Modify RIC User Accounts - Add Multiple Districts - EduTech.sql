BEGIN;
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 art_userid integer;
 ny_dist record ;
 result integer;
 row_count integer;
BEGIN
now_date :=now();



	INSERT INTO aartuser(
		    username, 
		    firstname, 
		    middlename, 
		    surname, 
		    password, 
		    email, 
		    uniquecommonidentifier, 
		    defaultusergroupsid, 
		    ukey, 
		    createddate, 
		    createduser, 
		    activeflag, 
		    modifieddate, 
		    modifieduser, 
		    displayname) 


	select      'RYeoman@edutech.org' username, 
		    'Rich' firstname, 
		     null middlename, 
		    'Yeoman' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'RYeoman@edutech.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Rich Yeoman' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:RYeoman@edutech.org'; 


	

FOR art_userid IN (select id from aartuser where email in ('RYeoman@edutech.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist (organizationname text, displayidentifier  text  ) ;
              insert into insert_dist  
		   select 'NEW YORK STATE SCHOOL FOR THE BLIND','180300877197'
			union select 'FINGER LAKES CHRISTIAN SCHOOL','560701859281'
			union select 'CRYSTAL VALLEY CHRISTIAN SCHOOL','680801658922'
			union select 'ST PAUL LUTHERAN SCHOOL','180300329652'
			union select 'NOTRE DAME HIGH SCHOOL','180300137112'
			--union select 'DESALES HIGH SCHOOL','430700166659'   Inactive from RIC list
			union select 'EAST PALMYRA CHRISTIAN SCHOOL','650101806701'
			union select 'CALVARY CHAPEL ACADEMY','430300999233'
			union select 'GILEAD SCHOOL OF DISCIPLESHIP','671201995611'
			union select 'BATAVIA CITY SD','180300010000'
			union select 'GENEVA CITY SD','430700010000'
			union select 'ALEXANDER CSD','180202040000'
			union select 'AVON CSD','240101040000'
			union select 'BYRON-BERGEN CSD','180701040000'
			union select 'CALEDONIA-MUMFORD CSD','240201040000'
			union select 'CLYDE-SAVANNAH CSD','650301040000'
			union select 'DALTON-NUNDA CSD (KESHEQUA)','241101040000'
			union select 'DUNDEE CSD','680801040000'
			union select 'EAST BLOOMFIELD CSD','430501040000'
			union select 'ELBA CSD','180901040000'
			union select 'GANANDA CSD','650902040000'
			union select 'GENESEO CSD','240401040000'
			union select 'HONEOYE CSD','431401040000'
			union select 'LETCHWORTH CSD','670401040000'
			union select 'LYONS CSD','650501040000'
			union select 'MANCHESTER-SHORTSVILLE CSD (RED JACK','431101040000'
			union select 'MARION CSD','650701040000'
			union select 'MT MORRIS CSD','240901040000'
			union select 'NAPLES CSD','431201040000'
			union select 'OAKFIELD-ALABAMA CSD','181101040000'
			union select 'PAVILION CSD','181201040000'
			union select 'PEMBROKE CSD','181302040000'
			union select 'RED CREEK CSD','651503040000'
			union select 'ROMULUS CSD','560603040000'
			union select 'WARSAW CSD','671501040000'
			union select 'WAYLAND-COHOCTON CSD','573002040000'
			union select 'WILLIAMSON CSD','651402040000'
			union select 'WYOMING CSD','671002040000'
			union select 'YORK CSD','241701040000'
			union select 'CANANDAIGUA CITY SD','430300050000'
			union select 'ATTICA CSD','670201060000'
			union select 'DANSVILLE CSD','241001060000'
			union select 'GORHAM-MIDDLESEX CSD (MARCUS WHITMAN','430901060000'
			union select 'LE ROY CSD','181001060000'
			union select 'LIVONIA CSD','240801060000'
			union select 'NEWARK CSD','650101060000'
			union select 'NORTH ROSE-WOLCOTT CSD','651501060000'
			union select 'PALMYRA-MACEDON CSD','650901060000'
			union select 'PENN YAN CSD','680601060000'
			union select 'PERRY CSD','671201060000'
			union select 'PHELPS-CLIFTON SPRINGS CSD','431301060000'
			union select 'SENECA FALLS CSD','560701060000'
			union select 'SODUS CSD','651201060000'
			union select 'VICTOR CSD','431701060000'
			union select 'WATERLOO CSD','561006060000'
			union select 'WAYNE CSD','650801060000'
			union select 'GENESEE VALLEY BOCES','249000000000'
			union select 'WAYNE-FINGER LAKES BOCES','439000000000';
			
		row_count := ( select count(*) from insert_dist);
		RAISE NOTICE 'rows need to process: %' , row_count;	
		row_count := ( select count(*) from organization);
	
	INSERT INTO organization(displayidentifier,organizationname,organizationtypeid,createddate,activeflag,createduser,modifieduser,modifieddate,reportprocess)
	select  insert_dist.displayidentifier,
	        insert_dist.organizationname,
	        5 organizationtypeid,
	        now_date createddate,
	        true activeflag,
	        12 createduser,
	        12 modifieduser,
	        now_date modifieddate,
	        false reportprocess from insert_dist 
	                               left outer join ( select  displayidentifier,organizationname from organization_children((select id from organization where organizationname = 'New York' and organizationtypeid=2)) 
	                                                  ) exist_dist_ny 
	                                               on insert_dist.displayidentifier= exist_dist_ny.displayidentifier
	                                                 and insert_dist.organizationname=exist_dist_ny.organizationname 
	                                  where  exist_dist_ny.organizationname is null;
	                                  
			row_count := ( select count(*) from organization) - row_count;
			RAISE NOTICE 'rows inserted organization : %' , row_count;	
			row_count := ( select count(*) from organizationrelation);

      		    INSERT INTO organizationrelation
				   (organizationid
				   ,parentorganizationid
				   ,createddate
				   ,activeflag
				   ,createduser
				   ,modifieduser
				   ,modifieddate)
   
				   select 
				   
					    o.id             organizationid
					   ,(select id from organization where organizationname = 'New York' and organizationtypeid=2) parentorganizationid
					   ,now_date         createddate
					   ,true               activeflag
					   ,12                createduser
					   ,12                modifieduser
					   ,now_date          modifieddate
				   from organization o
				   inner join insert_dist inst on  o.displayidentifier= inst.displayidentifier
	                                                       and o.organizationname= inst.organizationname 
	                           left outer join  organizationrelation orel on  orel.organizationid=o.id
	                                                                       and orel.parentorganizationid= (select id from organization where organizationname = 'New York' and organizationtypeid=2)                        
				 where o.createddate=now_date and orel.organizationid is null;	
		
			 	
			row_count := ( select count(*) from organizationrelation) - row_count;
			RAISE NOTICE 'rows inserted organizationrelation : %' , row_count;	
			row_count := ( select count(*) from usersorganizations);

         insert into usersorganizations ( aartuserid, organizationid, isdefault) 
         select    art_userid  aartuserid, 
                   o.id organizationid ,
                   case when inst.displayidentifier='180300877197' and inst.organizationname ='NEW YORK STATE SCHOOL FOR THE BLIND' then true 
                   else null end isdefault from  organization o
				         inner join insert_dist inst on  o.displayidentifier= inst.displayidentifier
	                                                             and o.organizationname= inst.organizationname 
	                                 left outer join  usersorganizations uo on o.id= uo.organizationid
	                                                                        and uo.aartuserid =  art_userid                        
				 where 'New York'= (select organizationname from organization_parent(o.id) where organizationtypeid=2)
				       and uo.aartuserid  is null ;

			row_count := ( select count(*) from usersorganizations) - row_count;
			RAISE NOTICE 'rows inserted usersorganizations : %' , row_count;	
			row_count := ( select count(*) from userorganizationsgroups);

       insert into userorganizationsgroups ( groupid, status,userorganizationid,isdefault)				 
       select case when o.organizationtypeid=5 then   (select id from groups where groupcode='DTC')
                   else (select id from groups where groupcode='BTC') end groupid,
              2                                             status,
              uo.id                         userorganizationid,
              true                          isdefault
                                    from usersorganizations uo 
                                         inner join organization o on o.id=uo.organizationid
				         inner join insert_dist inst on  o.displayidentifier= inst.displayidentifier
	                                                             and o.organizationname= inst.organizationname 
	                                 left outer join  userorganizationsgroups uog on uog.userorganizationid= uo.id
	                                                                              and uog.groupid =  case when o.organizationtypeid=5 then   (select id from groups where groupcode='DTC')
                                                                                                                  else (select id from groups where groupcode='BTC') end                       
				 where 'New York'= (select organizationname from organization_parent(o.id) where organizationtypeid=2)
				       and uo.aartuserid =  art_userid 
				       and uog.userorganizationid  is null;
				       
			row_count := ( select count(*) from userorganizationsgroups) - row_count;
			RAISE NOTICE 'rows inserted userorganizationsgroups : %' , row_count;	
END LOOP; 			       
		   
END;
$BODY$; 
COMMIT;

