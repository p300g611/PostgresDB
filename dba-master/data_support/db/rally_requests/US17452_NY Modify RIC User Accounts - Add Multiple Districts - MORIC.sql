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


	select      'CUrich@moric.org' username, 
		    'Chris' firstname, 
		     null middlename, 
		    'Urich' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'CUrich@moric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Chris Urich' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:CUrich@moric.org'; 

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
		    
	select      'KDuell@moric.org' username, 
		    'Katie' firstname, 
		     null middlename, 
		    'Duell' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'KDuell@moric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Katie Duell' displayname;
	  RAISE NOTICE 'new user added to aartusert table:KDuell@moric.org'; 
	  
	
	

FOR art_userid IN (select id from aartuser where email in ('CUrich@moric.org' ,'KDuell@moric.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist (organizationname text ,displayidentifier  text ) ;
              insert into insert_dist  
		  select 'NEW YORK STATE SCHOOL FOR THE DEAF','411800877482'
		union select 'UTICA INTERNATIONAL ADVENTIST SCHOOL','412300445991'
		union select 'HOLY CROSS ACADEMY','251400189608'
		union select 'FAITH FELLOWSHIP CHRISTIAN SCHOOL','222000809092'
		union select 'NEW LIFE CHRISTIAN SCHOOL','250701808879'
		union select 'MESSIAH ACADEMY','411501805648'
		union select 'TILTON SCHOOL-HOUSE OF GOOD SHEPHERD','411504997416'
		union select 'ONEIDA CITY SD','251400010000'
		union select 'ROME CITY SD','411800010000'
		union select 'UTICA CITY SD','412300010000'
		union select 'WATERTOWN CITY SD','222000010000'
		union select 'NY MILLS UFSD','411504020000'
		union select 'TOWN OF WEBB UFSD','211901020000'
		union select 'ALEXANDRIA CSD','220202040000'
		union select 'BEAVER RIVER CSD','231301040000'
		union select 'BELLEVILLE-HENDERSON CSD','220909040000'
		union select 'BROOKFIELD CSD','250109040000'
		union select 'CAMDEN CSD','410601040000'
		union select 'COPENHAGEN CSD','230201040000'
		union select 'DOLGEVILLE CSD','211003040000'
		union select 'GENERAL BROWN CSD','220401040000'
		union select 'HAMILTON CSD','250701040000'
		union select 'LA FARGEVILLE CSD','221401040000'
		union select 'LOWVILLE ACADEMY & CSD','230901040000'
		union select 'LYME CSD','221301040000'
		union select 'MADISON CSD','251101040000'
		union select 'MORRISVILLE-EATON CSD','250401040000'
		union select 'MOUNT MARKHAM CSD','212001040000'
		union select 'ORISKANY CSD','412901040000'
		union select 'POLAND CSD','211103040000'
		union select 'REMSEN CSD','411701040000'
		union select 'RICHFIELD SPRINGS CSD','472001040000'
		union select 'SACKETS HARBOR CSD','221001040000'
		union select 'SAUQUOIT VALLEY CSD','411603040000'
		union select 'SOUTH JEFFERSON CSD','220101040000'
		union select 'SOUTH LEWIS CSD','231101040000'
		union select 'STOCKBRIDGE VALLEY CSD','251501040000'
		union select 'THOUSAND ISLANDS CSD','220701040000'
		union select 'VAN HORNESVILLE-OWEN D YOUNG CSD','211701040000'
		union select 'WATERVILLE CSD','411902040000'
		union select 'WEST CANADA VALLEY CSD','210302040000'
		union select 'WESTMORELAND CSD','412801040000'
		union select 'INLET COMN SD','200501080000'
		union select 'LITTLE FALLS CITY SD','210800050000'
		union select 'SHERRILL CITY SD','412000050000'
		union select 'ADIRONDACK CSD','410401060000'
		union select 'CANASTOTA CSD','250901060000'
		union select 'CARTHAGE CSD','222201060000'
		union select 'CENTRAL VALLEY CSD AT ILION-MOHAWK','212101040000'
		union select 'CLINTON CSD','411101060000'
		union select 'FRANKFORT-SCHUYLER CSD','210402060000'
		union select 'HERKIMER CSD','210601060000'
		union select 'HOLLAND PATENT CSD','412201060000'
		union select 'INDIAN RIVER CSD','220301060000'
		union select 'NEW HARTFORD CSD','411501060000'
		union select 'WHITESBORO CSD','412902060000'
		union select 'HERK-FULTON-HAMILTON-OTSEGO BOCES','219000000000'
		union select 'JEFFER-LEWIS-HAMIL-HERK-ONEIDA BOCES','229000000000'
		union select 'MADISON-ONEIDA BOCES','259000000000'
		union select 'ONEIDA-HERKIMER-MADISON BOCES','419000000000'
		union select 'UPSTATE CEREBRAL PALSY INC ','412300999379';
			
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
                   case when inst.displayidentifier='411800877482' and inst.organizationname ='NEW YORK STATE SCHOOL FOR THE DEAF' then true 
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

