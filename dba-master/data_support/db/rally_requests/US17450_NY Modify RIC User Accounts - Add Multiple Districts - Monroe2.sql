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

	select      'bharris@bocesmaars.org' username, 
		    'Bridget' firstname, 
		     null middlename, 
		    'Harris' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'bharris@bocesmaars.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Bridget Harris' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:bharris@bocesmaars.org'; 

	/*INSERT INTO aartuser(
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
		    
	select      'mmaloney@bocesmaars.org' username, 
		    'Mari-Ellen' firstname, 
		     null middlename, 
		    'Maloney' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'mmaloney@bocesmaars.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Mari-Ellen Maloney' displayname;
	  RAISE NOTICE 'new user added to aartusert table:mmaloney@bocesmaars.org'; 
	  
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
		    
	select      'sjackson@bocesmaars.org' username, 
		    'Steve' firstname, 
		     null middlename, 
		    'Jackson' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'sjackson@bocesmaars.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Steve Jackson' displayname;
	  RAISE NOTICE 'new user added to aartusert table:sjackson@bocesmaars.org'; */
	

FOR art_userid IN (select id from aartuser where email in ('bharris@bocesmaars.org' ,'mmaloney@bocesmaars.org','sjackson@bocesmaars.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist (organizationname text ,displayidentifier  text ) ;
              insert into insert_dist  
		 select 'NORTHRIDGE CHRISTIAN SCHOOL','261600858399'
		union select 'NORTHSTAR CHRISTIAN ACADEMY','260401857742'
		union select 'ST PAUL LUTHERAN SCHOOL','261101325771'
		union select 'WESTFALL ACADEMY','260101625038'
		union select 'ALL SAINTS ACADEMY','571000166198'
		union select 'AQUINAS INST OF ROCHESTER','261600167041'
		union select 'BISHOP KEARNEY HIGH SCHOOL','260801166610'
		union select 'CATHEDRAL SCHOOL AT HOLY ROSARY','261600165163'
		union select 'HOLY CROSS SCHOOL','261600166178'
		union select 'HOLY FAMILY ELEMENTARY SCHOOL','070600166199'
		union select 'HOLY FAMILY MIDDLE SCHOOL','070600166214'
		union select 'IMMACULATE CONCEPTION SCHOOL','610600166183'
		union select 'MOTHER OF SORROWS SCHOOL','260501166205'
		union select 'NATIVITY PREPARATORY ACADEMY','261600165998'
		union select 'NAZARETH ELEMENTARY SCHOOL','261600166206'
		union select 'OUR LADY OF MERCY HIGH SCHOOL','261201166604'
		union select 'SCHOOL OF THE HOLY CHILDHOOD','261701167030'
		union select 'SETON CATHOLIC SCHOOL','260101166208'
		union select 'SIENA CATHOLIC ACADEMY','260101166230'
		union select 'SS PETER & PAUL SCHOOL','050100166218'
		union select 'ST AGNES PAROCHIAL SCHOOL','240101166156'
		union select 'ST ANN SCHOOL','571800166161'
		union select 'ST FRANCIS DESALES-ST STEPHEN''S','430700166227'
		union select 'ST JOHN NEUMANN SCHOOL','260801165157'
		union select 'ST JOSEPH SCHOOL','050100169701'
		union select 'ST JOSEPH SCHOOL','261201166189'
		union select 'ST KATERI SCHOOL','260803166171'
		union select 'ST LAWRENCE SCHOOL','260501166192'
		union select 'ST LOUIS SCHOOL','261401167057'
		union select 'ST MARY OUR MOTHER SCHOOL','070901166200'
		union select 'ST MARY''S SCHOOL','430300166197'
		union select 'ST MICHAEL SCHOOL','650101166201'
		union select 'ST MICHAEL''S SCHOOL','680601166202'
		union select 'ST PATRICK SCHOOL','600601166216'
		union select 'ST PIUS X SCHOOL','260401166221'
		union select 'ST RITA SCHOOL','261901166223'
		union select 'HILLEL COMMUNITY DAY SCHOOL','260101226476'
		union select 'CORNERSTONE CHRISTIAN ACADEMY','261801808866'
		union select 'DESTINY CHRISTIAN SCH AND PRESCHOOL','260101809946'
		union select 'GREECE CHRISTIAN SCHOOL','260501808815'
		union select 'LIMA CHRISTIAN SCHOOL','260901808131'
		union select 'ROCHESTER CHRISTIAN SCHOOL','261901807039'
		union select 'WEBSTER CHRISTIAN SCHOOL','261901808468'
		union select 'ARCHANGEL SCHOOL','260401994567'
		union select 'CRESTWOOD CHILDREN''S CENTER','262001997047'
		union select 'HAMIDIYE ACADEMY','261600995647'
		union select 'HILLSIDE CHILDREN''S CENTER-VARICK','560603995073'
		union select 'HILLSIDE CHILDREN''S CTR-SNELL FARM','570302995084'
		union select 'HILLSIDE CHILDRENS CENTER SCHOOL','261600997698'
		union select 'HILLSIDE CHLDRNS CTR-FINGER LAKES','050301999417'
		union select 'HILLSIDE-HALPERN EDUCATIONAL CTR','261901997789'
		union select 'HOPE HALL SCHOOL','260401999477'
		union select 'NORMAN HOWARD SCHOOL','261701998567'
		union select 'ROCHESTER SCHOOL FOR THE DEAF','261600997046'
		union select 'VILLA OF HOPE','260501996191'
		union select 'EAST ROCHESTER UFSD','261313030000'
		union select 'HOLLEY CSD','450704040000'
		union select 'KENDALL CSD','450607040000'
		union select 'WHEATLAND-CHILI CSD','262001040000'
		union select 'BRIGHTON CSD','260101060000'
		union select 'BROCKPORT CSD','261801060000'
		union select 'CHURCHVILLE-CHILI CSD','261501060000'
		union select 'EAST IRONDEQUOIT CSD','260801060000'
		union select 'FAIRPORT CSD','261301060000'
		union select 'GATES-CHILI CSD','260401060000'
		union select 'GREECE CSD','260501060000'
		union select 'HILTON CSD','261101060000'
		union select 'HONEOYE FALLS-LIMA CSD','260901060000'
		union select 'PENFIELD CSD','261201060000'
		union select 'PITTSFORD CSD','261401060000'
		union select 'RUSH-HENRIETTA CSD','261701060000'
		union select 'SPENCERPORT CSD','261001060000'
		union select 'WEBSTER CSD','261901060000'
		union select 'WEST IRONDEQUOIT CSD','260803060000'
		union select 'DISCOVERY CHARTER SCHOOL','260501861002'
		union select 'EUGENIO MARIA DE HOSTOS CHARTER SCHO','261600860811'
		union select 'GENESEE COMM CHARTER SCHOOL','261600860826'
		union select 'PUC ACHIEVE CHARTER SCHOOL','261600861071'
		union select 'RENAISSANCE ACADEMY CHARTER-ARTS','260501861067'
		union select 'ROCHESTER ACADEMY CHARTER SCHOOL','261600860910'
		union select 'ROCHESTER CAREER MENTORING CHARTER','261600861019'
		union select 'TRUE NORTH ROCHESTER  PREP-WEST CAMP','261600860705'
		union select 'TRUE NORTH ROCHESTER PREP CHARTER','261600860906'
		union select 'UNIVERSITY PREP CHAR SCH-YOUNG MEN','261600860985'
		union select 'URBAN CHOICE CHARTER SCHOOL','261600860877'
		union select 'VERTUS CHARTER SCHOOL','261600861069'
		union select 'YOUNG WOMEN''S COLLEGE PREP CHARTE','261600861020'
		union select 'MONROE 1 BOCES','269100000000'
		union select 'MONROE 2-ORLEANS BOCES','269200000000'
		union select 'RIC MONROE/M.A.A.R.S.','269100900000'
		union select 'MARY CARIOLA CHILDRENS CENTER ','261600997048';
			
		row_count := ( select count(*) from insert_dist);
		RAISE NOTICE 'rows need to process: %' , row_count;	
		row_count := ( select count(*) from organization);
	
	/*INSERT INTO organization(displayidentifier,organizationname,organizationtypeid,createddate,activeflag,createduser,modifieduser,modifieddate,reportprocess)
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
			RAISE NOTICE 'rows inserted organizationrelation : %' , row_count; */	
			row_count := ( select count(*) from usersorganizations);

         insert into usersorganizations ( aartuserid, organizationid, isdefault) 
         select    art_userid  aartuserid, 
                   o.id organizationid ,
                   case when inst.displayidentifier='260401857742' and inst.organizationname ='NORTHSTAR CHRISTIAN ACADEMY' then true 
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
