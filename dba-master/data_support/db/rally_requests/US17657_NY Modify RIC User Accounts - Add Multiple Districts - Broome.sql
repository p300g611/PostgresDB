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

	select      'Bwickman@btboces.org' username, 
		    'Bob' firstname, 
		     null middlename, 
		    'Wickman' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'Bwickman@btboces.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Bob Wickman' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:Bwickman@btboces.org'; 

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
		    
	select      'Lcallaha@btboces.org' username, 
		    'Lisa' firstname, 
		     null middlename, 
		    'Callahan' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'Lcallaha@btboces.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Lisa Callahan' displayname;
	  RAISE NOTICE 'new user added to aartusert table:Lcallaha@btboces.org'; 
	  
/*	INSERT INTO aartuser(
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
		    
	select      'Tfarnham@btboces.org' username, 
		    'Tim' firstname, 
		     null middlename, 
		    'Farnham' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'Tfarnham@btboces.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Tim Farnham' displayname;
	  RAISE NOTICE 'new user added to aartusert table:Tfarnham@btboces.org'; */
	

FOR art_userid IN (select id from aartuser where email in ('Bwickman@btboces.org' ,'Lcallaha@btboces.org','tfarnham@btboces.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist (organizationname text ,displayidentifier  text ) ;
              insert into insert_dist  
		 select 'ZION LUTHERAN SCHOOL','600601328678'
			union select 'ISLAMBERG CHILDREN''S ACADEMY','031301629156'
			union select 'BROOKWOOD SCHOOL (THE)','471701999556'
			union select 'CHILDREN''S HOME OF WYOMING CONFER','030701998858'
			union select 'CRESCENT ACADEMY (THE)','031502995612'
			union select 'SPRINGBROOK NEW YORK, INC','471101997806'
			union select 'BINGHAMTON CITY SD','030200010000'
			union select 'ONEONTA CITY SD','471400010000'
			union select 'AFTON CSD','080101040000'
			union select 'ANDES CSD','120102040000'
			union select 'BAINBRIDGE-GUILFORD CSD','080201040000'
			union select 'CHARLOTTE VALLEY CSD','120401040000'
			union select 'CHERRY VALLEY-SPRINGFIELD CSD','472202040000'
			union select 'COOPERSTOWN CSD','471701040000'
			union select 'DELAWARE ACADEMY CSD AT DELHI','120501040000'
			union select 'DEPOSIT CSD','031301040000'
			union select 'DOWNSVILLE CSD','120301040000'
			union select 'EDMESTON CSD','470501040000'
			union select 'FRANKLIN CSD','120701040000'
			union select 'GEORGETOWN-SOUTH OTSELIC CSD','081401040000'
			union select 'GILBERTSVILLE-MOUNT UPTON CSD','470202040000'
			union select 'GILBOA-CONESVILLE CSD','540801040000'
			union select 'GREENE CSD','080601040000'
			union select 'HANCOCK CSD','120906040000'
			union select 'HARPURSVILLE CSD','030501040000'
			union select 'HUNTER-TANNERSVILLE CSD','190901040000'
			union select 'JEFFERSON CSD','540901040000'
			union select 'LAURENS CSD','470801040000'
			union select 'MARGARETVILLE CSD','121401040000'
			union select 'MILFORD CSD','471101040000'
			union select 'MORRIS CSD','471201040000'
			union select 'NEWARK VALLEY CSD','600402040000'
			union select 'OTEGO-UNADILLA CSD','471601040000'
			union select 'OXFORD ACADEMY & CSD','081501040000'
			union select 'ROXBURY CSD','121502040000'
			union select 'SCHENEVUS CSD','470901040000'
			union select 'SHERBURNE-EARLVILLE CSD','082001040000'
			union select 'SOUTH KORTRIGHT CSD','121702040000'
			union select 'STAMFORD CSD','121701040000'
			union select 'TIOGA CSD','600903040000'
			union select 'UNADILLA VALLEY CSD','081003040000'
			union select 'WALTON CSD','121901040000'
			union select 'WINDHAM-ASHLAND-JEWETT CSD','191401040000'
			union select 'WORCESTER CSD','472506040000'
			union select 'NORWICH CITY SD','081200050000'
			union select 'CHENANGO FORKS CSD','030101060000'
			union select 'CHENANGO VALLEY CSD','030701060000'
			union select 'JOHNSON CITY CSD','031502060000'
			union select 'MAINE-ENDWELL CSD','031101060000'
			union select 'OWEGO-APALACHIN CSD','600601060000'
			union select 'SIDNEY CSD','121601060000'
			union select 'SUSQUEHANNA VALLEY CSD','030601060000'
			union select 'UNION-ENDICOTT CSD','031501060000'
			union select 'VESTAL CSD','031601060000'
			union select 'WHITNEY POINT CSD','031401060000'
			union select 'WINDSOR CSD','031701060000'
			union select 'BROOME-DELAWARE-TIOGA BOCES','039000000000'
			union select 'DELAW-CHENANGO-MADISON-OTSEGO BOCES','129000000000'
			union select 'OTSEGO-DELAW-SCHOHARIE-GREENE BOCES','199000000000';
			
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
                   case when inst.displayidentifier='600601328678' and inst.organizationname ='ZION LUTHERAN SCHOOL' then true 
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