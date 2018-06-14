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

	select      'mmaloney@e1b.org' username, 
		    'M' firstname, 
		     null middlename, 
		    'Maloney' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'mmaloney@e1b.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'M Maloney' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:mmaloney@e1b.org'; 

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
		    
	select      'khalbert@e1b.org' username, 
		    'K' firstname, 
		     null middlename, 
		    'Halbert' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'khalbert@e1b.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'K. Halbert' displayname;
	  RAISE NOTICE 'new user added to aartusert table:khalbert@e1b.org'; 
	  
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
		    
	select      'datkinson@e1b.org' username, 
		    'D' firstname, 
		     null middlename, 
		    'Atkinson' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'datkinson@e1b.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'D. Atkinson' displayname;
	  RAISE NOTICE 'new user added to aartusert table:datkinson@e1b.org'; 
	

FOR art_userid IN (select id from aartuser where email in ('mmaloney@e1b.org' ,'khalbert@e1b.org','datkinson@e1b.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist (organizationname text ,displayidentifier  text ) ;
              insert into insert_dist  
                          select 'GUSTAVUS ADOLPHUS CHILD & FAMILY','061700308038'
			union select 'HOLY GHOST LUTHERAN SCHOOL','400701325764'
			union select 'NAZARETH LUTHERAN SCHOOL','140600329774'
			union select 'ST JOHN LUTHERAN SCHOOL','400701325766'
			union select 'ST MATTHEW LUTHERAN SCHOOL','400900325770'
			union select 'ST PETER LUTHERAN SCHOOL-N RIDGE','401501325773'
			union select 'ST PETER''S LUTHERAN SCHOOL','400701326654'
			union select 'TRINITY LUTHERAN SCHOOL','142801325775'
			union select 'AL-RASHEED ACADEMY','141800626108'
			union select 'AMBROSE CATHOLIC ACADEMY','140600136337'
			union select 'ANNUNCIATION-BVM SCHOOL','141301136357'
			union select 'ARCHBISHOP WALSH HIGH SCHOOL','042400136448'
			union select 'BAKER VICTORY SERVICES','141800137227'
			union select 'BISHOP TIMON-SAINT JUDE HIGH SCHOOL','140600136362'
			union select 'BUFFALO ACADEMY OF THE SACRED HEART','140201136377'
			union select 'CARDINAL O''HARA HIGH SCHOOL','142601136593'
			union select 'CATHOLIC ACADEMY OF NIAGARA FALLS','400800135992'
			union select 'CATHOLIC ACADEMY OF THE HOLY FAMILY','061700136237'
			union select 'CATHOLIC ACADEMY WEST BUFFALO','140600139125'
			union select 'CHRIST THE KING SCHOOL','140201136433'
			union select 'DESALES CATHOLIC ELEMENTARY SCHOOL','400400136417'
			union select 'FOURTEEN HOLY HELPERS SCHOOL','142801136290'
			union select 'HOLY ANGELS ACADEMY','140600136276'
			union select 'HOLY FAMILY SCHOOL','181001136291'
			union select 'IMMACULATA ACADEMY','141604136331'
			union select 'IMMACULATE CONCEPTION SCHOOL','022601136563'
			union select 'IMMACULATE CONCEPTION SCHOOL','140301136236'
			union select 'MARY QUEEN OF ANGELS SCHOOL','140701139960'
			union select 'MT MERCY ACADEMY','140600136375'
			union select 'MT ST MARY ACADEMY','142601136387'
			union select 'NARDIN ACADEMY HIGH SCHOOL','140600136307'
			union select 'NARDIN ACADEMY-ELEMENTARY','140600137113'
			union select 'NATIVITY OF OUR LORD SCHOOL','142301136425'
			union select 'NATIVITY-BVM SCHOOL','140801136238'
			union select 'NATIVITYMIGUEL MID SCH-BUFFALO','140600139127'
			union select 'NIAGARA CATHOLIC JR/SR HIGH SCHOOL','400800136367'
			union select 'NORTH TONAWANDA CATHOLIC SCHOOL','400900139249'
			union select 'NORTHERN CHAUTAUQUA CATHOLIC SCHOOL','060800139173'
			union select 'NOTRE DAME ACADEMY','140600135498'
			union select 'OUR LADY OF BLACK ROCK','140600136296'
			union select 'OUR LADY OF POMPEII SCHOOL','141901136242'
			union select 'OUR LADY OF VICTORY SCHOOL','141800136305'
			union select 'OUR LADY-BLESSED SACRAMENT','141901137240'
			union select 'OUR LADY-SACRED HEART SCHOOL','142801136594'
			union select 'QUEEN OF HEAVEN SCHOOL','142801137104'
			union select 'SACRED HEART VILLA SCHOOL','400301137225'
			union select 'SOUTHERN TIER CATHOLIC SCHOOL','042400139126'
			union select 'SOUTHTOWNS CATHOLIC SCHOOL','141604136382'
			union select 'ST ALOYSIUS REGIONAL SCHOOL','141101136383'
			union select 'ST AMELIA SCHOOL','142601136293'
			union select 'ST ANDREW''S COUNTRY DAY SCHOOL','142601137102'
			union select 'ST BENEDICT SCHOOL','140201136411'
			union select 'ST BERNADETTE SCHOOL','142301136413'
			union select 'ST CHRISTOPHER SCHOOL','140207136286'
			union select 'ST DOMINIC SAVIO MIDDLE SCHOOL','400800139905'
			union select 'ST FRANCIS HIGH SCHOOL','141604136402'
			union select 'ST FRANCIS OF ASSISI SCHOOL','142500136343'
			union select 'ST GREGORY THE GREAT SCHOOL','140203136273'
			union select 'ST JOHN THE BAPTIST SCHOOL','140101136379'
			union select 'ST JOHN THE BAPTIST SCHOOL','142601136418'
			union select 'ST JOHN VIANNEY SCHOOL','142301136271'
			union select 'ST JOSEPH SCHOOL','180300137106'
			union select 'ST JOSEPH SCHOOL','042801136452'
			union select 'ST JOSEPH UNIVERSITY SCHOOL','140600136295'
			union select 'ST JOSEPH''S COLLEGIATE INSTITUTE','142601136325'
			union select 'ST LEO''S SCHOOL','140207136239'
			union select 'ST MARGARET SCHOOL','140600136349'
			union select 'ST MARK SCHOOL','140600136376'
			union select 'ST MARY''S ELEMENTARY SCHOOL','141901136283'
			union select 'ST MARY''S HIGH SCHOOL','141901136332'
			union select 'ST MARY''S OF THE LAKE SCHOOL','141604136251'
			union select 'ST MARY''S SCHOOL','140203136252'
			union select 'ST PAUL SCHOOL','142601136319'
			union select 'ST PETER & PAUL SCHOOL','141601136318'
			union select 'ST PETER & PAUL SCHOOL','140203136333'
			union select 'ST PETER SCHOOL','400301136456'
			union select 'ST STEPHEN SCHOOL','141501137228'
			union select 'ST VINCENT DE PAUL SCHOOL','141301136254'
			union select 'STELLA NIAGARA EDUC PARK','400301136253'
			union select 'TRINITY CATHOLIC ACADEMY','140600135017'
			union select 'JEWISH HERITAGE DAY SCHOOL','140203229522'
			union select 'KADIMAH SCHOOL OF BUFFALO','140201205429'
			union select 'CENTRAL CHRISTIAN ACADEMY','060800808602'
			union select 'CHRISTIAN ACADEMY OF WESTRN NY','400900805999'
			union select 'CHRISTIAN CENTRAL ACADEMY','140203806578'
			union select 'GREATER REFUGE TEMPLE CHRISTIAN ACAD','140600809632'
			union select 'NEW LIFE CHRISTIAN SCHOOL','042400805651'
			union select 'AURORA WALDORF SCHOOL','140301999928'
			union select 'ELMWOOD FRANKLIN SCHOOL','140600996445'
			union select 'GATEWAY-LONGVIEW LYNDE SCHOOL','140203997682'
			union select 'MT ST JOSEPH ACADEMY','140600996270'
			union select 'NEW DIRECTIONS-H G LEWIS CAMPUS SCH','400400997431'
			union select 'ST MARY''S SCHOOL FOR THE DEAF','140600996459'
			union select 'UNIVERSAL SCHOOL','140600999851'
			union select 'BUFFALO CITY SD','140600010000'
			union select 'DUNKIRK CITY SD','060800010000'
			union select 'HORNELL CITY SD','571800010000'
			union select 'JAMESTOWN CITY SD','061700010000'
			union select 'LACKAWANNA CITY SD','141800010000'
			union select 'LOCKPORT CITY SD','400400010000'
			union select 'NIAGARA FALLS CITY SD','400800010000'
			union select 'NORTH TONAWANDA CITY SD','400900010000'
			union select 'OLEAN CITY SD','042400010000'
			union select 'ROCHESTER CITY SD','261600010000'
			union select 'TONAWANDA CITY SD','142500010000'
			union select 'CLEVELAND HILL UFSD','140703020000'
			union select 'CHEEKTOWAGA-MARYVALE UFSD','140702030000'
			union select 'CHEEKTOWAGA-SLOAN UFSD','140709030000'
			union select 'DEPEW UFSD','140707030000'
			union select 'EAST AURORA UFSD','140301030000'
			union select 'KENMORE-TONAWANDA UFSD','142601030000'
			union select 'AKRON CSD','142101040000'
			union select 'ALFRED-ALMOND CSD','020101040000'
			union select 'ANDOVER CSD','020601040000'
			union select 'ARKPORT CSD','571901040000'
			union select 'AVOCA CSD','570201040000'
			union select 'BARKER CSD','401301040000'
			union select 'BELFAST CSD','020801040000'
			union select 'BEMUS POINT CSD','061001040000'
			union select 'BOLIVAR-RICHBURG CSD','022902040000'
			union select 'BROCTON CSD','062301040000'
			union select 'CANASERAGA CSD','021102040000'
			union select 'CASSADAGA VALLEY CSD','060401040000'
			union select 'CATTARAUGUS-LITTLE VALLEY CSD','042302040000'
			union select 'CHAUTAUQUA LAKE CSD','060503040000'
			union select 'CLYMER CSD','060701040000'
			union select 'CUBA-RUSHFORD CSD','022302040000'
			union select 'ELLICOTTVILLE CSD','040901040000'
			union select 'FALCONER CSD','061101040000'
			union select 'FILLMORE CSD','022001040000'
			union select 'FORESTVILLE CSD','061503040000'
			union select 'FRANKLINVILLE CSD','041101040000'
			union select 'FREWSBURG CSD','060301040000'
			union select 'FRIENDSHIP CSD','021601040000'
			union select 'GENESEE VALLEY CSD','020702040000'
			union select 'HAMMONDSPORT CSD','572901040000'
			union select 'HINSDALE CSD','041401040000'
			union select 'HOLLAND CSD','141701040000'
			union select 'LYNDONVILLE CSD','451001040000'
			union select 'NORTH COLLINS CSD','142201040000'
			union select 'PANAMA CSD','061601040000'
			union select 'PINE VALLEY CSD (SOUTH DAYTON)','060601040000'
			union select 'PORTVILLE CSD','042901040000'
			union select 'PRATTSBURGH CSD','572301040000'
			union select 'RANDOLPH CSD','043001040000'
			union select 'RIPLEY CSD','062401040000'
			union select 'SCIO CSD','022401040000'
			union select 'SHERMAN CSD','062601040000'
			union select 'SILVER CREEK CSD','061501040000'
			union select 'WEST VALLEY CSD','040204040000'
			union select 'WESTFIELD CSD','062901040000'
			union select 'WHITESVILLE CSD','022101040000'
			union select 'SALAMANCA CITY SD','043200050000'
			union select 'ALBION CSD','450101060000'
			union select 'ALDEN CSD','140101060000'
			union select 'ALLEGANY-LIMESTONE CSD','040302060000'
			union select 'AMHERST CSD','140201060000'
			union select 'CHEEKTOWAGA CSD','140701060000'
			union select 'CLARENCE CSD','140801060000'
			union select 'EDEN CSD','141201060000'
			union select 'EVANS-BRANT CSD (LAKE SHORE)','141401060000'
			union select 'FREDONIA CSD','062201060000'
			union select 'FRONTIER CSD','141604060000'
			union select 'GOWANDA CSD','042801060000'
			union select 'GRAND ISLAND CSD','141501060000'
			union select 'HAMBURG CSD','141601060000'
			union select 'IROQUOIS CSD','141301060000'
			union select 'LANCASTER CSD','141901060000'
			union select 'LEWISTON-PORTER CSD','400301060000'
			union select 'MEDINA CSD','450801060000'
			union select 'NEWFANE CSD','400601060000'
			union select 'NIAGARA-WHEATFIELD CSD','400701060000'
			union select 'ORCHARD PARK CSD','142301060000'
			union select 'ROYALTON-HARTLAND CSD','401201060000'
			union select 'SOUTHWESTERN CSD AT JAMESTOWN','060201060000'
			union select 'SPRINGVILLE-GRIFFITH INST CSD','141101060000'
			union select 'STARPOINT CSD','401001060000'
			union select 'SWEET HOME CSD','140207060000'
			union select 'WELLSVILLE CSD','022601060000'
			union select 'WEST SENECA CSD','142801060000'
			union select 'WILLIAMSVILLE CSD','140203060000'
			union select 'WILSON CSD','401501060000'
			union select 'YORKSHIRE-PIONEER CSD','043501060000'
			union select 'HOPEVALE UFSD AT HAMBURG','141603020000'
			union select 'RANDOLPH ACAD UFSD','043011020000'
			union select 'RANDOLPH ACADEMY-HAMBURG CAMPUS','043011020002'
			union select 'ALOMA D JOHNSON CHARTER SCHOOL','140600860911'
			union select 'BUFFALO ACAD-SCI CHARTER SCHOOL','140600860861'
			union select 'BUFFALO UNITED CHARTER SCHOOL','140600860851'
			union select 'CHARTER SCHOOL FOR APPLIED TECHNOLOG','142601860031'
			union select 'CHARTER SCHOOL OF INQUIRY','140600861072'
			union select 'COMMUNITY CHARTER SCHOOL','140600860843'
			union select 'ELMWOOD VILLAGE CHARTER SCHOOL','140600860896'
			union select 'ENTERPRISE CHARTER SCHOOL','140600860856'
			union select 'GLOBAL CONCEPTS CHARTER SCHOOL','141800860044'
			union select 'HEALTH SCIENCES CHARTER SCHOOL','140600860961'
			union select 'KING CENTER CHARTER SCHOOL','140600860814'
			union select 'NIAGARA CHARTER SCHOOL','400701860890'
			union select 'ORACLE CHARTER SCHOOL','140600860868'
			union select 'PINNACLE CHARTER SCHOOL','140600860853'
			union select 'SOUTH BUFFALO CHARTER SCHOOL','140600860817'
			union select 'TAPESTRY CHARTER SCHOOL','140600860838'
			union select 'WEST BUFFALO CHARTER SCHOOL','140600860986'
			union select 'WESTERN NY MARITIME CHARTER SCHOOL','140600860863'
			union select 'WESTMINSTER COMMUNITY CHARTER SCHOOL','140600860874'
			union select 'CATTAR-ALLEGANY-ERIE-WYOMING BOCES','049000000000'
			union select 'ERIE 1 BOCES','149100000000'
			union select 'ERIE 2-CHAUTAUQUA-CATTARAUGUS BOCES','149200000000'
			union select 'ORLEANS-NIAGARA BOCES','459000000000';
			
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
			RAISE NOTICE 'rows inserted organizationrelation : %' , row_count;	*/
			row_count := ( select count(*) from usersorganizations);

         insert into usersorganizations ( aartuserid, organizationid, isdefault) 
         select    art_userid  aartuserid, 
                   o.id organizationid ,
                   case when inst.displayidentifier='061700308038' and inst.organizationname ='GUSTAVUS ADOLPHUS CHILD & FAMILY' then true 
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
