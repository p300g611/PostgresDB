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
art_userid := 146894;

  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist (displayidentifier  text , organizationname text ) ;
              insert into insert_dist  
                        Select  '580303020000','Amagansett UFSD' 
			Union Select  '580106030000','Amityville District' 
			Union Select  '580101030000','Babylon District' 
			Union Select  '580501030000','Bay Shore Union Free School District' 
			Union Select  '580505020000','Bayport-Blue Point District' 
			Union Select  '580512030000','Brentwood UFSD' 
			Union Select  '580909020000','Bridgehampton District' 
			Union Select  '580302860027','CDCH Charter School' 
			Union Select  '580233020000','Center Moriches Union Free SD' 
			Union Select  '580513030000','Central Islip UFSD' 
			Union Select  '580402060000','Cold Spring Harbor District' 
			Union Select  '580410030000','Commack Union Free School District' 
			Union Select  '580203020000','Comsewogue District' 
			Union Select  '580507060000','Connetquot District' 
			Union Select  '580105030000','Copiague District' 
			Union Select  '580107030000','Deer Park UFSD' 
			Union Select  '580301020000','East Hampton District' 
			Union Select  '580503030000','East Islip District' 
			Union Select  '580234020000','East Moriches Union Free School District' 
			Union Select  '580917020000','East Quogue District' 
			Union Select  '580912060000','Eastport/South Manor CSD' 
			Union Select  '580401020000','Elwood Union Free School District' 
			Union Select  '580514020000','Fire Island District' 
			Union Select  '581004020000','Fishers Island UFSD' 
			Union Select  '581010020000','Greenport District' 
			Union Select  '580405060000','Half Hollow Hills Central SD' 
			Union Select  '580905020000','Hampton Bays District' 
			Union Select  '580406060000','Harborfields Central School District' 
			Union Select  '580506030000','Hauppauge UFSD' 
			Union Select  '580403030000','Huntington Union Free School District' 
			Union Select  '580502020000','Islip District' 
			Union Select  '580805060000','Kings Park Central School District' 
			Union Select  '580104030000','Lindenhurst District' 
			Union Select  '580603020000','Little Flower District' 
			Union Select  '580212060000','Longwood District' 
			Union Select  '581012020000','Mattituck-Cutchogue District' 
			Union Select  '580211060000','Middle Country District' 
			Union Select  '580208020000','Miller Place District' 
			Union Select  '580306020000','Montauk District' 
			Union Select  '580207020000','Mount Sinai District' 
			Union Select  '581015080000','New Suffolk District' 
			Union Select  '580103030000','North Babylon District' 
			Union Select  '580404030000','Northport-East Northport Union Free SD' 
			Union Select  '581002020000','Oysterponds District' 
			Union Select  '580224030000','Patchogue-Medford District' 
			Union Select  '580206020000','Port Jefferson District' 
			Union Select  '580903020000','Quogue District' 
			Union Select  '580901020000','Remsenburg-Speonk District' 
			Union Select  '580602040000','Riverhead CSD' 
			Union Select  '580602860032','Riverhead Charter School' 
			Union Select  '580209020000','Rocky Point District' 
			Union Select  '580205060000','Sachem District' 
			Union Select  '580305020000','Sag Harbor Union Free School District' 
			Union Select  '580910080000','Sagaponack District' 
			Union Select  '580504030000','Sayville District' 
			Union Select  '580701020000','Shelter Island School District' 
			Union Select  '580601040000','Shoreham-Wading Rvr District' 
			Union Select  '580801060000','Smithtown District' 
			Union Select  '580235060000','South Country District' 
			Union Select  '580413030000','South Huntington Union Free SD' 
			Union Select  '580906030000','Southampton District' 
			Union Select  '581005020000','Southold Union Free School District' 
			Union Select  '580304020000','Springs District' 
			Union Select  '580201060000','Three Village District' 
			Union Select  '580913080000','Tuckahoe District' 
			Union Select  '580302080000','Wainscott District' 
			Union Select  '580102030000','West Babylon Union Free School District' 
			Union Select  '580509030000','West Islip District' 
			Union Select  '580902020000','Westhampton Beach District' 
			Union Select  '580232030000','William Floyd Union Free SD' 
			Union Select  '580109020000','Wyandanch UFSD' 
			Union Select  '421800010000','Syracuse City School District';
			
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

         insert into usersorganizations ( aartuserid, organizationid) 
         select    art_userid  aartuserid, 
                   o.id organizationid   from  organization o
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
       select (select id from groups where groupcode='DTC') groupid,
              2                                             status,
              uo.id                         userorganizationid,
              true                          isdefault
                                    from usersorganizations uo 
                                         inner join organization o on o.id=uo.organizationid
				         inner join insert_dist inst on  o.displayidentifier= inst.displayidentifier
	                                                             and o.organizationname= inst.organizationname 
	                                 left outer join  userorganizationsgroups uog on uog.userorganizationid= uo.id
	                                                                              and uog.groupid =  (select id from groups where groupcode='DTC')                       
				 where 'New York'= (select organizationname from organization_parent(o.id) where organizationtypeid=2)
				       and uo.aartuserid =  art_userid 
				       and uog.userorganizationid  is null;
				       
			row_count := ( select count(*) from userorganizationsgroups) - row_count;
			RAISE NOTICE 'rows inserted userorganizationsgroups : %' , row_count;	
				       
		   
END;
$BODY$; 

























