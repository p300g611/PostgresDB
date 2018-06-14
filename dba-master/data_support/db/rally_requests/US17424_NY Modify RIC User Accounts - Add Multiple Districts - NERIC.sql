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

	select      'mary.mcgeoch@neric.org' username, 
		    'Mary' firstname, 
		     null middlename, 
		    'McGeoch' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'mary.mcgeoch@neric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Mary McGeoch' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:mary.mcgeoch@neric.org'; 

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
		    
	select      'rosemary.baum@neric.org' username, 
		    'Rosemary' firstname, 
		     null middlename, 
		    'Baum' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'rosemary.baum@neric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Rosemary Baum' displayname;
	  RAISE NOTICE 'new user added to aartusert table:rosemary.baum@neric.org'; 
	  
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
		    
	select      'william.adam@neric.org' username, 
		    'William' firstname, 
		     null middlename, 
		    'Adam' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'william.adam@neric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'William Adam' displayname;
	  RAISE NOTICE 'new user added to aartusert table:william.adam@neric.org'; 
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
		    
	select      'matthew.coleman@neric.org' username, 
		    'Matthew' firstname, 
		     null middlename, 
		    'Coleman' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'matthew.coleman@neric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Matthew Coleman' displayname;
	  RAISE NOTICE 'new user added to aartusert table:matthew.coleman@neric.org';   

FOR art_userid IN (select id from aartuser where email in ('mary.mcgeoch@neric.org' ,'rosemary.baum@neric.org','william.adam@neric.org','matthew.coleman@neric.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist (organizationname text ,displayidentifier  text ) ;
              insert into insert_dist  
                         select 'ACAD OF HOLY NAME-LOWER SCHOOL','010100115685'
			union select 'ALBANY CITY SD','010100010000'
			union select 'ALBANY COMMUNITY CHARTER SCHOOL','010100860899'
			union select 'ALBANY LEADERSHIP CHARTER HS-GIRLS','010100860960'
			union select 'ALL SAINTS'' CATHOLIC ACADEMY','010100115684'
			union select 'AMSTERDAM CITY SD','270100010000'
			union select 'AN NUR ISLAMIC SCHOOL','010601629639'
			union select 'ARGYLE CSD','640101040000'
			union select 'AUGUSTINIAN ACADEMY-ELEMENTARY','222201155866'
			union select 'AUSABLE VALLEY CSD','090201040000'
			union select 'AVERILL PARK CSD','491302060000'
			union select 'BALLSTON SPA CSD','521301060000'
			union select 'BEEKMANTOWN CSD','090301060000'
			union select 'BERKSHIRE UFSD','100308020000'
			union select 'BERLIN CSD','490101040000'
			union select 'BERNE-KNOX-WESTERLO CSD','010201040000'
			union select 'BETHLEHEM CSD','010306060000'
			union select 'BISHOP MAGINN HIGH SCHOOL','010100118044'
			union select 'BLESSED SACRAMENT SCHOOL','010100115665'
			union select 'BOLTON CSD','630101040000'
			union select 'BRASHER FALLS CSD','510101040000'
			union select 'BRIGHTER CHOICE CHARTER SCHOOL-BOYS','010100860829'
			union select 'BRIGHTER CHOICE CHARTER SCHOOL-GIRLS','010100860830'
			union select 'BROADALBIN-PERTH CSD','171102040000'
			union select 'BROWN SCHOOL','530600999304'
			union select 'BRUNSWICK CSD (BRITTONKILL)','490202040000'
			union select 'BRUSHTON-MOIRA CSD','161601040000'
			union select 'BURNT HILLS-BALLSTON LAKE CSD','520101060000'
			union select 'CAIRO-DURHAM CSD','190301040000'
			union select 'CAMBRIDGE CSD','641610040000'
			union select 'CANAJOHARIE CSD','270301040000'
			union select 'CANTON CSD','510201060000'
			union select 'CAPITAL REGION BOCES','019000000000'
			union select 'CATHOLIC CENTRAL HIGH SCHOOL','490601115672'
			union select 'CATSKILL CSD','190401060000'
			union select 'CHATEAUGAY CSD','160801040000'
			union select 'CHATHAM CSD','101001040000'
			union select 'CHAZY UFSD','090601020000'
			union select 'CHRISTIAN BROTHERS ACADEMY','010601115674'
			union select 'CLIFTON-FINE CSD','510401040000'
			union select 'CLINTON-ESSEX-WARREN-WASHING BOCES','099000000000'
			union select 'COBLESKILL-RICHMONDVILLE CSD','541102060000'
			union select 'COHOES CITY SD','010500010000'
			union select 'COLTON-PIERREPONT CSD','510501040000'
			union select 'CORINTH CSD','520401040000'
			union select 'COXSACKIE-ATHENS CSD','190501040000'
			union select 'CROWN POINT CSD','150203040000'
			union select 'DUANESBURG CSD','530101040000'
			union select 'EAST GREENBUSH CSD','490301060000'
			union select 'EDINBURG COMMON SD','520601080000'
			union select 'EDWARDS-KNOX CSD','513102040000'
			union select 'ELIZABETHTOWN-LEWIS CSD','150301040000'
			--union select 'FAITH CHRISTIAN ACADEMY','101300856144'
			union select 'FONDA-FULTONVILLE CSD','270601040000'
			union select 'FORT ANN CSD','640502040000'
			union select 'FORT EDWARD UFSD','640601020000'
			union select 'FORT PLAIN CSD','270701040000'
			union select 'FRANKLIN-ESSEX-HAMILTON BOCES','169000000000'
			union select 'GALWAY CSD','520701040000'
			union select 'GERMANTOWN CSD','100902040000'
			union select 'GLENS FALLS CITY SD','630300010000'
			union select 'GLENS FALLS COMN SD','630918080000'
			union select 'GLOVERSVILLE CITY SD','170500010000'
			union select 'GOUVERNEUR CSD','511101060000'
			union select 'GRANVILLE CSD','640701040000'
			union select 'GRAPEVILLE CHRISTIAN SCHOOL','190701859503'
			union select 'GREEN ISLAND UFSD','010701030000'
			union select 'GREEN TECH HIGH CHARTER SCHOOL','010100860907'
			union select 'GREENVILLE CSD','190701040000'
			union select 'GREENWICH CSD','640801040000'
			union select 'GUILDERLAND CSD','010802060000'
			union select 'HADLEY-LUZERNE CSD','630801040000'
			union select 'HAMILTON-FULTON-MONTGOMERY BOCES','209000000000'
			union select 'HAMMOND CSD','511201040000'
			union select 'HARRIET TUBMAN DEMOCRATIC HS','010100996053'
			union select 'HARRISVILLE CSD','230301040000'
			union select 'HARTFORD CSD','641001040000'
			union select 'HEBREW ACADEMY-CAPITAL DISTRICT','010601216559'
			union select 'HENRY JOHNSON CHARTER SCHOOL','010100860892'
			union select 'HERMON-DEKALB CSD','511301040000'
			union select 'HEUVELTON CSD','512404040000'
			union select 'HOLY FAMILY SCHOOL','161501159247'
			union select 'HOLY NAME OF JESUS ACADEMY','512001185654'
			--union select 'HOLY NAME SCHOOL','090201155002'
			union select 'HOLY SPIRIT SCHOOL','490301115686'
			union select 'HOOSIC VALLEY CSD','491401040000'
			union select 'HOOSICK FALLS CSD','490501060000'
			union select 'HUDSON CITY SD','101300010000'
			union select 'HUDSON FALLS CSD','641301060000'
			union select 'IMMACULATE HEART CENTRAL HIGH SCH','222000155874'
			union select 'IMMACULATE HEART ELEMENTARY SCHOOL','222000155013'
			union select 'INDIAN LAKE CSD','200401040000'
			union select 'JOHNSBURG CSD','630601040000'
			union select 'JOHNSTOWN CITY SD','170600010000'
			union select 'KEENE CSD','150601040000'
			union select 'KETCHUM-GRANDE SCHOOL','520101998694'
			union select 'KINDERHOOK CSD','101401040000'
			union select 'KING''S SCHOOL (THE)','520401808772'
			union select 'KIPP TECH VALLEY CHARTER SCHOOL','010100860867'
			union select 'LA SALLE INSTITUTE','490801116667'
			union select 'LA SALLE SCHOOL','010100115705'
			union select 'LAKE GEORGE CSD','630701040000'
			union select 'LAKE PLACID CSD','151102040000'
			union select 'LAKE PLEASANT CSD','200601040000'
			union select 'LANSINGBURGH CSD','490601060000'
			union select 'LISBON CSD','511602040000'
			union select 'LONG LAKE CSD','200701040000'
			union select 'LOUDONVILLE CHRISTIAN SCHOOL','010623806562'
			union select 'MADRID-WADDINGTON CSD','511901040000'
			union select 'MAIMONIDES HEBREW DAY SCHOOL','010100208496'
			union select 'MALONE CSD','161501060000'
			union select 'MASSENA CSD','512001060000'
			union select 'MATER  CHRISTI SCHOOL','010100115671'
			union select 'MAYFIELD CSD','170801040000'
			union select 'MECHANICVILLE CITY SD','521200050000'
			union select 'MEKEEL CHRISTIAN ACADEMY','530202807972'
			union select 'MENANDS UFSD','010615020000'
			union select 'MIDDLEBURGH CSD','541001040000'
			union select 'MINERVA CSD','150801040000'
			union select 'MORIAH CSD','150901040000'
			union select 'MORRISTOWN CSD','512101040000'
			union select 'MOTHER TERESA ACADEMY','520302995153'
			union select 'MOUNTAIN LAKE CHILDRENS RESIDENCE','151102999844'
			union select 'MT MORIAH ACADEMY','010306809859'
			union select 'NEW LEBANON CSD','101601040000'
			union select 'NEWCOMB CSD','151001040000'
			union select 'NISKAYUNA CSD','530301060000'
			union select 'NORTH COLONIE CSD','010623060000'
			union select 'NORTH GREENBUSH COMN SD (WILLIAMS)','490801080000'
			union select 'NORTH WARREN CSD','630202040000'
			union select 'NORTHEAST PARENT & CHILD SOCIETY','530600998000'
			union select 'NORTHEASTERN CLINTON CSD','090501040000'
			union select 'NORTHERN ADIRONDACK CSD','090901040000'
			union select 'NORTHVILLE CSD','170901040000'
			union select 'NORWOOD-NORFOLK CSD','512201040000'
			union select 'NOTRE DAME-BISHOP GIBBONS SCHOOL','530600115681'
			--union select 'NYS DEPT OF CORRECTIONS','010100690001'
			union select (select organizationname from organization where id=79303),'010100970002'
			union select 'NYS OFFICE OF MENTAL HEALTH','010100690100'
			union select 'OGDENSBURG CITY SD','512300010000'
			union select 'OPPENHEIM-EPHRATAH-ST. JOHNSVILLE CS','271201040000'
			--union select 'OPWDD','010100690101'
			union select 'OUR SAVIOR''S LUTHERAN SCHOOL','010601315801'
			union select 'PARISHVILLE-HOPKINTON CSD','512501040000'
			--union select 'PARSONS CHILD AND FAMILY CENTER','010100996557' error wrong displyident
			union select 'PERU CSD','091101060000'
			union select 'PISECO COMN SD','200101080000'
			union select 'PLATTSBURGH CITY SD','091200010000'
			union select 'POTSDAM CSD','512902060000'
			union select 'PUTNAM CSD','641401040000'
			union select 'QUEENSBURY UFSD','630902030000'
			union select 'QUESTAR III (R-C-G) BOCES','499000000000'
			union select 'RAVENA-COEYMANS-SELKIRK CSD','010402060000'
			union select 'RENSSELAER CITY SD','491200010000'
			union select 'ROBERT C PARKER SCHOOL','491302999322'
			union select 'ROTTERDAM-MOHONASEN CSD','530515060000'
			union select 'SACRED HEART SCHOOL','491700115756'
			union select 'SAINT GREGORY''S SCHOOL FOR BOYS','010623116561'
			union select 'SALEM CSD','641501040000'
			union select 'SALMON RIVER CSD','161201040000'
			union select 'SARANAC CSD','091402060000'
			union select 'SARANAC LAKE CSD','161401060000'
			union select 'SARATOGA CENTRAL CATHOLIC HIGH SCH','521800115750'
			union select 'SARATOGA SPRINGS CITY SD','521800010000'
			union select 'SCHALMONT CSD','530501060000'
			union select 'SCHENECTADY CITY SD','530600010000'
			union select 'SCHODACK CSD','491501040000'
			union select 'SCHOHARIE CSD','541201040000'
			union select 'SCHROON LAKE CSD','151401040000'
			union select 'SCHUYLERVILLE CSD','521701040000'
			union select 'SCOTIA-GLENVILLE CSD','530202060000'
			union select 'SETON ACADEMY','091200155496'
			union select 'SETON CATHOLIC CENTRAL HIGH SCHOOL','091101159175'
			union select 'SHARON SPRINGS CSD','541401040000'
			union select 'SHENENDEHOWA CSD','520302060000'
			union select 'SOUTH COLONIE CSD','010601060000'
			union select 'SOUTH GLENS FALLS CSD','521401040000'
			union select 'ST AGNES PAROCHIAL SCHOOL','151102155008'
			union select 'ST AMBROSE SCHOOL','010623115655'
			union select 'ST ANNE INSTITUTE','010100115658'
			union select 'ST AUGUSTINE''S SCHOOL','490601115663'
			union select 'ST BERNARD''S SCHOOL','161401155868'
			union select 'ST CATHERINE''S CENTER FOR CHILDREN','010100997791'
			union select 'ST CLEMENT''S RGNL CATHOLIC SCHOOL','521800119176'
			union select 'ST COLMAN''S SCHOOL','010623995677'
			union select 'ST FRANCIS DE SALES RGNL CATHOLIC SC','210601115680'
			union select 'ST JAMES SCHOOL','511101155007'
			union select 'ST JUDE THE APOSTLE SCHOOL','490804115704'
			union select 'ST KATERI PARISH SCHOOL','530301115682'
			union select 'ST LAWRENCE-LEWIS BOCES','519000000000'
			union select 'ST MADELEINE SOPHIE SCHOOL','010802115707'
			union select 'ST MARY SCHOOL','510201155004'
			union select 'ST MARY''S ACADEMY-ELEMENTARY','490501117509'
			union select 'ST MARY''S INST ELEMENTARY SCHOOL','270100115723'
			union select 'ST MARY''S SCHOOL','521301115711'
			union select 'ST MARY''S SCHOOL','522101115719'
			union select 'ST MARY''S SCHOOL','151501155883'
			union select 'ST MARY''S-SAINT ALPHONSUS RGNL CATHO','630300119303'
			union select 'ST PIUS X SCHOOL','010623115753'
			union select 'ST REGIS FALLS CSD','161801040000'
			union select 'ST THOMAS THE APOSTLE SCHOOL','010306115761'
			union select 'STILLWATER CSD','522001040000'
			union select 'TACONIC HILLS CSD','100501040000'
			union select 'TICONDEROGA CSD','151501060000'
			union select 'TRINITY CATHOLIC SCHOOL','512001155896'
			union select 'TROY CITY SD','491700010000'
			union select 'TRUE NORTH TROY PREP CHARTER SCHOOL','491700860931'
			union select 'TUPPER LAKE CSD','160101060000'
			union select 'VANDERHEYDEN HALL','490804998235'
			union select 'VOORHEESVILLE CSD','011003060000'
			union select 'WARRENSBURG CSD','631201040000'
			union select 'WASHING-SARA-WAR-HAMLTN-ESSEX BOCES','649000000000'
			union select 'WATERFORD-HALFMOON UFSD','522101030000'
			union select 'WATERVLIET CITY SD','011200010000'
			union select 'WELLS CSD','200901040000'
			union select 'WESTPORT CSD','151601040000'
			union select 'WHEELERVILLE UFSD','170301020000'
			union select 'WHITEHALL CSD','641701060000'
			union select 'WILLSBORO CSD','151701040000'
			union select 'WOODLAND HILL MONTESSORI SCHOOL','490301999028'
			union select 'WYNANTSKILL UFSD','490804020000';
			
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
                   case when inst.displayidentifier='010100115685' and inst.organizationname ='ACAD OF HOLY NAME-LOWER SCHOOL' then true 
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
