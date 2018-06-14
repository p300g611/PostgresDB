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

	select      'lpullaro@mhric.org' username, 
		    'Lisa' firstname, 
		     null middlename, 
		    'Pullaro' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'lpullaro@mhric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Lisa Pullaro' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:lpullaro@mhric.org'; 

	
	  

FOR art_userid IN (select id from aartuser where email in ('lpullaro@mhric.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist ( organizationname text,displayidentifier  text ) ;
              insert into insert_dist  
                        select 'MIDDLETOWN SDA CHURCH SCHOOL','441000445847'
		union select 'POUGHKEEPSIE SDA ELEMENTARY SCHOOL','131500445851'
		union select 'TABERNACLE CHRISTIAN ACADEMY','131500858427'
		union select 'JOHN A COLEMAN HIGH SCHOOL','620600147145'
		union select 'JOHN S BURKE CATHOLIC HIGH SCHOOL','440601145071'
		union select 'NORA CRONIN PRESENTATION ACADEMY','441600145592'
		union select 'OUR LADY OF LOURDES HIGH SCHOOL','131601145065'
		union select 'SAN MIGUEL ACADEMY OF NEWBURGH','441600145510'
		union select 'BAIS YAAKOV OF SOUTH FALLSBURG','590501226076'
		union select 'BAIS YISROEL SCHOOL','591401229948'
		union select 'CONGREGATION BNEI YOEL SCHOOL','441201229273'
		union select 'CONGREGATION MESIFTA OHR HATALMUD','441600229607'
		--union select 'HAMESIVTA','622002226060'
		union select 'HEBREW DAY SCHOOL OF SULLIVAN & ULST','591401226474'
		union select 'SHERI TORAH','441201229930'
		union select 'TALMUD TORAH IMREI BURECH','591401229947'
		union select 'UTA OF KIRYAS JOEL-BOYS','441202228240'
		union select 'UTA OF KIRYAS JOEL-GIRLS','441202228249'
		union select 'ZICHRON MOSHE SCHOOL','590501227505'
		union select 'ALPHA AND OMEGA SCHOOL','130200809895'
		union select 'FAITH CHRISTIAN ACADEMY','132101808641'
		union select 'GOOD SHEPHERD SCHOOL','620600808795'
		--union select 'GOSHEN CHRISTIAN SCHOOL','440601806662'
		union select 'HARMONY CHRISTIAN SCHOOL','441301808513'
		union select 'LEPTONDALE CHRISTIAN ACADEMY','621801808492'
		union select 'MILLENNIAL KINGDOM FAMILY SCHOOL','130801808737'
		union select 'WAWARSING CHRISTIAN ACADEMY','622002808754'
		union select 'AEF CHAPEL FIELD SCHOOL','440401759101'
		union select 'ANDERSON CENTER FOR AUTISM','130801996542'
		union select 'ASTOR SERVICES FOR CHILDREN-FAMILIES','131801998687'
		union select 'CHILDRENS HOME KINGSTON GROVE ST ACA','620600997425'
		union select 'DEVEREUX IN NY','131701999086'
		union select 'DUANE LAKE ACADEMY','131201994052'
		union select 'DUTCHESS DAY SCHOOL (THE)','132201996576'
		union select 'FEI TIAN ACADEMY OF THE ARTS','441800995574'
		union select 'HAWK MEADOW MONTESSORI SCHOOL','131601999527'
		union select 'HIGH MEADOW SCHOOL','620901998943'
		union select 'HUDSON HILLS ACADEMY','440102996083'
		union select 'HUDSON VALLEY SUDBURY SCHOOL','620600995752'
		union select 'MAPLEBROOK SCHOOL','131101996574'
		union select 'RIDGE SCHOOL (THE)','131500999463'
		union select 'TUXEDO PARK SCHOOL','441903997088'
		union select 'WEST POINT MIDDLE SCHOOL','440901996121'
		union select 'WOODSTOCK DAY SCHOOL','621601997896'
		union select 'BEACON CITY SD','130200010000'
		union select 'KINGSTON CITY SD','620600010000'
		union select 'MIDDLETOWN CITY SD','441000010000'
		union select 'NEWBURGH CITY SD','441600010000'
		union select 'POUGHKEEPSIE CITY SD','131500010000'
		union select 'CHESTER UFSD','440201020000'
		union select 'DOVER UFSD','130502020000'
		union select 'FLORIDA UFSD','442115020000'
		union select 'GREENWOOD LAKE UFSD','442111020000'
		union select 'KIRYAS JOEL VILLAGE UFSD','441202020000'
		union select 'SPACKENKILL UFSD','131602020000'
		union select 'TUXEDO UFSD','441903020000'
		union select 'ELDRED CSD','590801040000'
		union select 'GOSHEN CSD','440601040000'
		union select 'HIGHLAND CSD','620803040000'
		union select 'HIGHLAND FALLS CSD','440901040000'
		union select 'LIVINGSTON MANOR CSD','591302040000'
		union select 'MILLBROOK CSD','132201040000'
		union select 'MINISINK VALLEY CSD','441101040000'
		union select 'NORTHEAST CSD','131101040000'
		union select 'PAWLING CSD','131201040000'
		union select 'PINE PLAINS CSD','131301040000'
		union select 'RHINEBECK CSD','131801040000'
		union select 'ROSCOE CSD','591301040000'
		union select 'SULLIVAN WEST CSD','591502040000'
		union select 'TRI-VALLEY CSD','591201040000'
		union select 'PORT JERVIS CITY SD','441800050000'
		union select 'ARLINGTON CSD','131601060000'
		union select 'CORNWALL CSD','440301060000'
		union select 'ELLENVILLE CSD','622002060000'
		union select 'FALLSBURG CSD','590501060000'
		union select 'HYDE PARK CSD','130801060000'
		union select 'LIBERTY CSD','590901060000'
		union select 'MARLBORO CSD','621001060000'
		union select 'MONROE-WOODBURY CSD','441201060000'
		union select 'MONTICELLO CSD','591401060000'
		union select 'NEW PALTZ CSD','621101060000'
		union select 'ONTEORA CSD','621201060000'
		union select 'PINE BUSH CSD','440401060000'
		union select 'RED HOOK CSD','131701060000'
		union select 'RONDOUT VALLEY CSD','620901060000'
		union select 'SAUGERTIES CSD','621601060000'
		union select 'VALLEY CSD (MONTGOMERY)','441301060000'
		union select 'WALLKILL CSD','621801060000'
		union select 'WAPPINGERS CSD','132101060000'
		union select 'WARWICK VALLEY CSD','442101060000'
		union select 'WASHINGTONVILLE CSD','440102060000'
		union select 'NEWBURGH PREP CHARTER HIGH SCHOOL','441600861060'
		union select 'DUTCHESS BOCES','139000000000'
		union select 'ORANGE-ULSTER BOCES','449000000000'
		union select 'SULLIVAN BOCES','599000000000'
		union select 'ULSTER BOCES','629000000000';
			
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
                   case when inst.displayidentifier='441000445847' and inst.organizationname ='MIDDLETOWN SDA CHURCH SCHOOL' then true
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

