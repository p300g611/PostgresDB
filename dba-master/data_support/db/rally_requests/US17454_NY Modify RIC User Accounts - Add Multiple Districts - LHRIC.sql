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


	select      'msamis@lhric.org' username, 
		    'Mark' firstname, 
		     null middlename, 
		    'Samis' surname, 
		    '307a08d319561af5b495da6c6c65f5bf0b094592c7799d68f058a5f4f6bb6ca35826eba6bb3202746b13cc92df7d1c25688a166cde17c44d0eb16f22b05731f1' as "password", 
		    'msamis@lhric.org' email, 
		    '' uniquecommonidentifier, 
		    0 defaultusergroupsid, 
		    'mxokvhdsihffdsyj' ukey, 
		    now_date createddate, 
		    12 createduser, 
		    true activeflag, 
		    now_date modifieddate, 
		    12 modifieduser, 
		    'Mark Samis' displayname;
		    
	  RAISE NOTICE 'new user added to aartusert table:msamis@lhric.org'; 


	

FOR art_userid IN (select id from aartuser where email in ('msamis@lhric.org'))

LOOP
  RAISE NOTICE 'Create new dist insert into organization';
              drop table if exists  insert_dist ;
              Create temporary table insert_dist ( organizationname text ,displayidentifier text ) ;
              insert into insert_dist  
		    select 'OAKVIEW PREP SCHOOL','662300449883'
				union select 'PEARL RIVER SDA SCHOOL','500308445850'
				union select 'CHAPEL SCHOOL (THE)','660303315778'
				union select 'ST MARK''S LUTHERAN SCHOOL','662300315793'
				union select 'AL-NOOR SCHOOL','331500629494'
				union select 'ANDALUSIA SCHOOL','662300625497'
				union select 'MIRAJ ISLAMIC SCHOOL','353100629737'
				union select 'WESTCHESTER MUSLIM CENTER','660900625519'
				union select 'CAROL & FRANK BIONDI EDUC CENTER','662300516461'
				union select '-ACAD OF OUR LADY OF GOOD COUNSEL HS','662200145156'
				union select 'ACAD OF OUR LADY OF GOOD COUNSEL ES','660805145155'
				union select 'ACADEMY OF MT ST URSULA','321000145364'
				union select 'ACADEMY OF ST DOROTHY','353100145263'
				union select 'ALBERTUS MAGNUS HIGH SCHOOL','500101145198'
				union select 'ALL HALLOWS INSTITUTE','320900145199'
				union select 'ALL SAINTS SCHOOL','310500145206'
				union select 'ANNUNCIATION SCHOOL','662300145095'
				union select 'ANNUNCIATION SCHOOL','310500145215'
				union select 'AQUINAS HIGH SCHOOL','321000145201'
				union select 'ARCHBISHOP STEPINAC HIGH SCHOOL','662200145185'
				union select 'ASCENSION SCHOOL','310300147412'
				union select 'ASSUMPTION SCHOOL','661500145098'
				union select 'BISHOP DUNN MEMORIAL SCHOOL','441600145069'
				union select 'BLESSED SACRAMENT SCHOOL','310300145234'
				union select 'BLESSED SACRAMENT SCHOOL','353100145235'
				union select 'BLESSED SACRAMENT SCHOOL','321200145236'
				union select 'BLESSED SACRAMENT-ST GABRIEL HIGH','661100145105'
				union select 'CARDINAL HAYES HIGH SCHOOL','320700145282'
				union select 'CARDINAL SPELLMAN HIGH SCHOOL','321100145436'
				union select 'CATHEDRAL HIGH SCHOOL','310200145242'
				union select 'CHRIST THE KING SCHOOL','662300145108'
				union select 'CHRIST THE KING SCHOOL','320900145251'
				union select 'CONNELLY CTR EDUCATION/HOLY CHILD MS','310100149439'
				union select 'CONVENT OF THE SACRED HEART','310200147087'
				union select 'CORPUS CHRISTI SCHOOL','310300145259'
				union select 'CORPUS CHRISTI-HOLY ROSARY SCHOOL','661904145111'
				union select 'CRISTO REY HIGH SCHOOL','310300149994'
				union select 'DOMINICAN ACADEMY','310200145262'
				union select 'EPIPHANY SCHOOL (THE)','310200145268'
				union select 'FORDHAM PREPARATORY SCHOOL','321000145270'
				union select 'GOOD SHEPHERD SCHOOL','310600145279'
				union select 'GUARDIAN ANGEL SCHOOL','310200145281'
				union select 'HOLY CROSS SCHOOL','320800145288'
				union select 'HOLY CROSS SCHOOL','310200145290'
				union select 'HOLY FAMILY SCHOOL','320800145291'
				union select 'HOLY NAME OF JESUS SCHOOL','310300145293'
				union select 'HOLY NAME OF JESUS SCHOOL','660805145121'
				union select 'HOLY NAME OF JESUS SCHOOL','661100145120'
				union select 'HOLY ROSARY SCHOOL','353100145295'
				union select 'HOLY ROSARY SCHOOL','321100145296'
				union select 'HOLY SPIRIT SCHOOL','321000145297'
				union select 'HOLY TRINITY SCHOOL','131601145055'
				union select 'IMMACULATE CONCEPTION SCHOOL','353100145302'
				union select 'IMMACULATE CONCEPTION SCHOOL','660301145127'
				union select 'IMMACULATE CONCEPTION SCHOOL','321100145303'
				union select 'IMMACULATE CONCEPTION SCHOOL','310100145301'
				union select 'IMMACULATE CONCEPTION SCHOOL','320700145305'
				union select 'IMMACULATE HEART OF MARY SCHOOL','662001145128'
				union select 'INCARNATION SCHOOL','310600145306'
				union select 'IONA GRAMMAR SCHOOL','661100145130'
				union select 'IONA PREP SCHOOL','661100145129'
				union select 'JOHN F KENNEDY CATHOLIC HIGH SCHOOL','662101147146'
				union select 'KINGSTON CATHOLIC SCHOOL','620600145037'
				union select 'LA SALLE ACADEMY','310100145336'
				union select 'LOYOLA SCHOOL','310200145338'
				union select 'MARIA REGINA HIGH SCHOOL','660407147445'
				union select 'MARYMOUNT SCHOOL OF NY','310200145356'
				union select 'MONSIGNOR FARRELL HIGH SCHOOL','353100145269'
				union select 'MONSIGNOR SCANLAN HIGH SCHOOL','320800145286'
				union select 'MONTFORT ACADEMY','660101145041'
				union select 'MOORE CATHOLIC HIGH SCHOOL','353100145361'
				union select 'MOST PRECIOUS BLOOD SCHOOL','441301147141'
				union select 'MOTHER CABRINI HIGH SCHOOL','310600145240'
				union select 'MT CARMEL-HOLY ROSARY SCHOOL','310400145294'
				union select 'MT CARMEL-ST BENEDICTA SCHOOL','353100145363'
				union select 'MT ST MICHAEL ACADEMY','321100145359'
				union select 'NATIVITY MISSION CENTER','310100148811'
				union select 'NATIVITY OF OUR BLESSED LADY SCHOOL','321100145365'
				union select 'NOTRE DAME ACADEMY ELEM SCHOOL','353100145369'
				union select 'NOTRE DAME ACADEMY HIGH SCHOOL','353100145370'
				union select 'NOTRE DAME SCHOOL','310200145371'
				union select 'OUR LADY HELP OF CHRISTIANS SCHOOL','353100145377'
				union select 'OUR LADY OF ANGELS SCHOOL','321000145372'
				union select 'OUR LADY OF FATIMA SCHOOL','662300145154'
				union select 'OUR LADY OF GOOD COUNSEL SCHOOL','353100145374'
				union select 'OUR LADY OF GRACE SCHOOL','321100145376'
				union select 'OUR LADY OF LOURDES SCHOOL','310600145378'
				union select 'OUR LADY OF MERCY SCHOOL','321000145380'
				union select 'OUR LADY OF MT CARMEL SCHOOL','660409145159'
				union select 'OUR LADY OF MT CARMEL SCHOOL','321000145383'
				union select 'OUR LADY OF MT CARMEL SCHOOL','441000145081'
				union select 'OUR LADY OF PERPETUAL HELP SCHOOL','661601145162'
				union select 'OUR LADY OF POMPEII SCHOOL','310200145386'
				union select 'OUR LADY OF REFUGE SCHOOL','321000145390'
				union select 'OUR LADY OF SORROWS SCHOOL','310100145393'
				union select 'OUR LADY OF SORROWS SCHOOL','662200145164'
				union select 'OUR LADY OF THE ASSUMPTION SCHOOL','320800145373'
				union select 'OUR LADY OF VICTORY ACAD-WESTCHES','660403146710'
				union select 'OUR LADY OF VICTORY SCHOOL','660900145166'
				union select 'OUR LADY QUEEN OF ANGELS SCHOOL','310400145387'
				union select 'OUR LADY QUEEN OF MARTYRS SCHOOL','310600145388'
				union select 'OUR LADY QUEEN OF PEACE SCHOOL','353100145389'
				union select 'OUR LADY STAR OF THE SEA SCHOOL','353100145394'
				union select 'PRESTON HIGH SCHOOL','320800145411'
				union select 'REGINA COELI SCHOOL','130801145068'
				union select 'REGIS HIGH SCHOOL','310200145416'
				union select 'RESURRECTION SCHOOL','661800145175'
				union select 'RICE HIGH SCHOOL','310500145418'
				union select 'SACRED HEART ELEMENTARY SCHOOL','662300145179'
				union select 'SACRED HEART HIGH SCHOOL','662300145180'
				union select 'SACRED HEART OF JESUS SCHOOL','310200145432'
				union select 'SACRED HEART SCHOOL','441201145086'
				union select 'SACRED HEART SCHOOL','500401145051'
				union select 'SACRED HEART SCHOOL','441600149355'
				union select 'SACRED HEART SCHOOL','320900145430'
				union select 'SACRED HEART SCHOOL','660407145178'
				union select 'SACRED HEART SCHOOL','353100145428'
				union select 'SACRED HEART SCHOOL','440901145088'
				union select 'SACRED HEART SCHOOL EARLY CHILDHOOD','660900145177'
				union select 'SAINTS PHILIP & JAMES SCHOOL','321100145407'
				union select 'SALESIAN HIGH SCHOOL','661100145183'
				union select 'SANTA MARIA SCHOOL','321100145433'
				union select 'SCHOOL OF THE HOLY CHILD','660501145118'
				union select 'ST ADALBERT SCHOOL','353100145194'
				union select 'ST AGNES BOYS HIGH SCHOOL','310300145196'
				union select 'ST ALOYSIUS SCHOOL','310500145208'
				union select 'ST ANGELA MERICI SCHOOL','320900145211'
				union select 'ST ANN ELEMENTARY SCHOOL','321000145212'
				union select 'ST ANN SCHOOL','310400145213'
				union select 'ST ANN SCHOOL','661401145094'
				union select 'ST ANN SCHOOL','662300145093'
				union select 'ST ANN SCHOOL','353100145214'
				union select 'ST ANSELM SCHOOL','320700145216'
				union select 'ST ANTHONY SCHOOL','321200145218'
				union select 'ST ANTHONY SCHOOL','662300145096'
				union select 'ST ANTHONY SCHOOL','500108145040'
				union select 'ST ANTHONY''S SCHOOL','660501145097'
				union select 'ST ATHANASIUS SCHOOL','320800145225'
				union select 'ST AUGUSTINE SCHOOL','500101147572'
				union select 'ST AUGUSTINE SCHOOL','661401145100'
				union select 'ST AUGUSTINE SCHOOL','620803145030'
				union select 'ST AUGUSTINE SCHOOL','320900145226'
				union select 'ST BARNABAS ELEMENTARY SCHOOL','321100145229'
				union select 'ST BARNABAS HIGH SCHOOL','321100145230'
				union select 'ST BARTHOLOMEW SCHOOL','662300145102'
				union select 'ST BENEDICT SCHOOL','320800145231'
				union select 'ST BRENDAN SCHOOL','321000145237'
				union select 'ST BRIGID SCHOOL','310100145238'
				union select 'ST CASIMIR SCHOOL','662300145106'
				union select 'ST CATHARINE''S HIGH SCHOOL','321100145244'
				union select 'ST CHARLES BORROMEO SCHOOL','310500145250'
				union select 'ST CHARLES SCHOOL','353100145249'
				union select 'ST CHRISTOPHER SCHOOL','353100145252'
				union select 'ST CLARE SCHOOL','321100145253'
				union select 'ST CLARE SCHOOL','353100145254'
				union select 'ST COLUMBANUS SCHOOL','662401145110'
				union select 'ST DENIS/ST COLUMBA SCHOOL','132101145054'
				union select 'ST DOMINIC SCHOOL','321100145261'
				union select 'ST ELIZABETH ANN SETON SCHOOL','662401147143'
				union select 'ST ELIZABETH SCHOOL','310600145266'
				union select 'ST EUGENE SCHOOL','662300145113'
				union select 'ST FRANCES DE CHANTAL SCHOOL','320800145271'
				union select 'ST FRANCIS OF ASSISI SCHOOL','321100147410'
				union select 'ST FRANCIS XAVIER SCHOOL','321100145274'
				union select 'ST GABRIEL SCHOOL','321000145276'
				union select 'ST GEORGE ACADEMY','310100147414'
				union select 'ST GEORGE ELEMENTARY SCHOOL','310100145277'
				union select 'ST GREGORY BARBARIGO SCHOOL','500201145043'
				union select 'ST GREGORY THE GREAT SCHOOL','310300145280'
				union select 'ST HELENA SCHOOL','321100145284'
				union select 'ST IGNATIUS LOYOLA SCHOOL','310200145299'
				union select 'ST IGNATIUS SCHOOL','320800149495'
				union select 'ST JAMES SCHOOL','310200145308'
				union select 'ST JAMES THE APOSTLE SCHOOL','480102145019'
				union select 'ST JAMES-ST JOSEPH SCHOOL','310200145328'
				union select 'ST JEAN BAPTISTE HIGH SCHOOL','310200145309'
				union select 'ST JEROME SCHOOL','320700145311'
				union select 'ST JOHN CHRYSOSTOM SCHOOL','321200145315'
				union select 'ST JOHN SCHOOL','321000145313'
				union select 'ST JOHN THE BAPTIST SCHOOL','662300145131'
				union select 'ST JOHN THE EVANGELIST SCHOOL','480101145020'
				union select 'ST JOHN VIANNEY CURE OF ARS SCHOOL','320800145318'
				union select 'ST JOHN VILLA ACADEMY ELEMENTARY','353100145320'
				union select 'ST JOHN VILLA ACADEMY HIGH SCHOOL','353100145319'
				union select 'ST JOHN''S SCHOOL','440601145074'
				union select 'ST JOSEPH & THOMAS SCHOOL','353100147139'
				union select 'ST JOSEPH BY THE SEA HIGH SCHOOL','353100145330'
				union select 'ST JOSEPH HILL ACADEMY ELEM SCHOOL','353100145332'
				union select 'ST JOSEPH HILL ACADEMY HIGH SCHOOL','353100145331'
				union select 'ST JOSEPH OF THE HOLY FAMILY SCHOOL','310500145327'
				union select 'ST JOSEPH PAROCHIAL SCHOOL','353100145321'
				union select 'ST JOSEPH SCHOOL','320900145329'
				union select 'ST JOSEPH SCHOOL','441600147140'
				union select 'ST JOSEPH SCHOOL','132201145059'
				union select 'ST JOSEPH SCHOOL','620600145034'
				union select 'ST JOSEPH SCHOOL','660303145135'
				union select 'ST JOSEPH SCHOOL','661301145138'
				union select 'ST JOSEPH''S PAROCHIAL SCHOOL','441000145076'
				union select 'ST JOSEPH''S SCHOOL-YORKVILLE','310200145326'
				union select 'ST JUDE SCHOOL','310600145333'
				union select 'ST LUCY SCHOOL','321100145339'
				union select 'ST LUKE SCHOOL','320700145342'
				union select 'ST MARGARET MARY SCHOOL','320900145345'
				union select 'ST MARGARET MARY SCHOOL','353100145346'
				union select 'ST MARGARET OF CORTONA SCHOOL','321000145344'
				union select 'ST MARGARET SCHOOL','500308145046'
				union select 'ST MARK THE EVANGELIST SCHOOL','310500145347'
				union select 'ST MARTIN DE PORRES SCHOOL','131601145060'
				union select 'ST MARTIN OF TOURS SCHOOL','321000145348'
				union select 'ST MARY OF THE SNOW SCHOOL','621601145036'
				union select 'ST MARY SCHOOL','132101145061'
				union select 'ST MARY SCHOOL','662300145145'
				union select 'ST MARY SCHOOL','132101145062'
				union select 'ST MARY SCHOOL','321100145349'
				union select 'ST MARY SCHOOL','353100145350'
				union select 'ST MARY STAR OF THE SEA SCHOOL','321100145352'
				union select 'ST NICHOLAS OF TOLENTINE ES','321000145366'
				union select 'ST PATRICK SCHOOL','662402145169'
				union select 'ST PATRICK SCHOOL','353100145397'
				union select 'ST PATRICK SCHOOL','660102145167'
				union select 'ST PATRICK''S OLD CATHEDRAL SCHOOL','310200145398'
				union select 'ST PAUL SCHOOL','310400145400'
				union select 'ST PAUL SCHOOL','500304145050'
				union select 'ST PAUL THE APOSTLE','662300145170'
				union select 'ST PETER & PAUL SCHOOL','660900145173'
				union select 'ST PETER SCHOOL','130801145067'
				union select 'ST PETER SCHOOL','590901148047'
				union select 'ST PETER SCHOOL','662300145172'
				union select 'ST PETER''S ELEMENTARY SCHOOL','353100145405'
				union select 'ST PETER''S HIGH SCHOOL FOR BOYS','353100145402'
				union select 'ST PETER''S HIGH SCHOOL FOR GIRLS','353100145403'
				union select 'ST PETER''S SCHOOL','500201145047'
				union select 'ST PHILIP NERI SCHOOL','321000145406'
				union select 'ST PIUS V HIGH SCHOOL','320700145409'
				union select 'ST RAYMOND ACADEMY FOR GIRLS','321100145413'
				union select 'ST RAYMOND BOYS HIGH SCHOOL','321100145412'
				union select 'ST RAYMOND ELEMENTARY SCHOOL','321100145414'
				union select 'ST RITA SCHOOL','353100145419'
				union select 'ST ROCH SCHOOL','353100145421'
				union select 'ST ROSE OF LIMA SCHOOL','310600145423'
				union select 'ST SIMON STOCK ELEMENTARY SCHOOL','321000145434'
				union select 'ST STEPHEN & ST EDWARD SCHOOL','442101145089'
				union select 'ST STEPHEN OF HUNGARY SCHOOL','310200145439'
				union select 'ST SYLVESTER SCHOOL','353100145440'
				union select 'ST TERESA SCHOOL','353100145441'
				union select 'ST THERESA SCHOOL','661402145186'
				union select 'ST THERESA SCHOOL','320800145442'
				union select 'ST THOMAS AQUINAS SCHOOL','321200145443'
				union select 'ST THOMAS OF CANTERBURY SCHOOL','440301145091'
				union select 'ST VINCENT FERRER HIGH SCHOOL','310200145454'
				union select 'STS ANTHONY-FRANCES OF ROME SCHOOL','321100145217'
				union select 'STS JOHN & PAUL SCHOOL','660701145134'
				union select 'STS PETER & PAUL SCHOOL','320700145404'
				union select 'TRANSFIGURATION SCHOOL','310200145447'
				union select 'TRANSFIGURATION SCHOOL','660401145189'
				union select 'URSULINE SCHOOL','661100145450'
				union select 'VILLA MARIA ACADEMY','320800145452'
				union select 'VISITATION SCHOOL','321000145455'
				union select 'XAVIER HIGH SCHOOL','310300145456'
				union select 'ATERES BAIS YAAKOV ACAD OF ROCKLAND','500401229697'
				union select 'BAIS CHINUCH L''BONOIS','500402226030'
				union select 'BAIS ROCHEL SCHOOL OF BORO PARK','332000207910'
				union select 'BAIS SHIFRA MIRIAM','500402229299'
				union select 'BAIS TRANY OF MONSEY','500402225496'
				union select 'BAIS YAAKOV HS OF SPRING VALLEY','500402227568'
				union select 'BAIS YAAKOV OHEL VICHNA','500402229837'
				union select 'BAS MIKROH','500402229085'
				union select 'BETH JACOB HIGH SCHOOL','332000206898'
				union select 'BETH RACHEL SCHOOL FOR GIRLS','331400227203'
				union select 'BETH ROCHEL SCHOOL-GIRLS','500402226680'
				union select 'BNEI YAKOV YOSEF OF MONSEY','500402225674'
				union select 'BNOS ESTHER PUPA','500402229565'
				union select 'BNOS SARAH OF MONSEY','500402225733'
				union select 'BNOS ZION OF BOBOV','332000227819'
				union select 'BOBOVER YESHIVA BNEI ZION-15TH AVE','332000226900'
				union select 'BOBOVER YESHIVA OF MONSEY','500402225550'
				union select 'CENTRAL UTA OF MONSEY - GIRLS','500402226135'
				union select 'CONG MACHZIKEI HADAS OF BELZ','500402228547'
				union select 'CONG YESHIVA OF GREATER MONSEY INC','500402226086'
				union select 'CONGRE MACHON TIFERES BACHURIM','500402225587'
				union select 'CONGREGATION ATERES TZVI','500401229856'
				union select 'CONGREGATION BAIS MALKA','500402229623'
				union select 'CONGREGATION BIRCHOS YOSEF','500402995555'
				union select 'CONGREGATION BNOS SARA INC','500402225677'
				union select 'CONGREGATION BOROV INC','500402226163'
				union select 'CONGREGATION DERECH EMES','500402229491'
				union select 'CONGREGATION KOIFER NEFESH','500402225721'
				union select 'HYCHEL HATORAH','331400229829'
				union select 'IMREI SHUFER','500402225751'
				union select 'KHHD YOEL OF SATMAR BP','331400225510'
				union select 'MOSDOS SANZ KLAUSENBURG OF MONSEY','500402229806'
				union select 'MOSDOS SANZ OF MONSEY','500402226156'
				union select 'OHEL ELOZER','331400225670'
				union select 'REUBEN GITTELMAN HEBREW DAY SCHOOL','500402217679'
				union select 'SHAAREI TORAH OF ROCKLAND','500402207407'
				union select 'SKILL BUILDING CENTER (THE)','500402225490'
				union select 'STEIN YESHIVA OF LINCOLN PARK','662300229082'
				union select 'TALMUD TORAH BOBOV','500402225047'
				union select 'TALMUD TORAH D''RABINU YOEL','332000229159'
				union select 'TALMUD TORAH KHAL ADAS YEREIM','500402229103'
				union select 'TORAH VYIRAH OF BORO PARK','332000228254'
				union select 'UTA','500402228423'
				union select 'YESHIVA AHAVATH ISRAEL-BNOS VISNITZ','500402227589'
				union select 'YESHIVA AVIR YAAKOV','500402229520'
				union select 'YESHIVA BAIS HACHINUCH','500402209903'
				union select 'YESHIVA BETH DAVID','500402227455'
				union select 'YESHIVA OF SPRING VALLEY','500402226477'
				union select 'YESHIVA TZOIN YOSEF','500402229325'
				union select 'BIBLE SPEAKS ACADEMY (THE)','331800805087'
				union select 'CORNERSTONE CHRISTIAN SCHOOL','500402808884'
				union select 'EMMANUEL CHILDREN''S MISSION SCHOOL','660900809841'
				union select 'YONKERS CHRISTIAN ACADEMY','662300809020'
				union select 'BRITISH INTERNATIONAL SCHOOL OF NY','310200995529'
				union select 'CARDINAL MCCLOSKEY SCHOOL','661401998991'
				union select 'CLEAR VIEW SCHOOL (THE)','661401997756'
				union select 'FERNCLIFF MANOR FOR THE RETARDED','662300997808'
				union select 'GARVEY SCHOOL','321100995742'
				union select 'GATEWAY MIDDLE SCHOOL (THE)','310300995746'
				union select 'GATEWAY SCHOOL OF NY','310300997763'
				union select 'GREAT TOMORROWS USA SCHOOL','310300999860'
				union select 'GREEN CHIMNEYS SCHOOL-LITTLE FOLKS','480601996550'
				union select 'HALLEN SCHOOL','661100997871'
				union select 'IVES SCHOOL','662101997144'
				union select 'LYCEUM KENNEDY','310200996794'
				union select 'NEW LIFE SCHOOL (THE)','320700996063'
				union select 'NEW YORK SCHOOL FOR THE DEAF','660407997118'
				union select 'ORCHARD SCHOOL-ANDRUS CHILD HOME','660404998061'
				union select 'PRIME MOVERS ACADEMY','320800995748'
				union select 'REGENT SCHOOL','321100998390'
				union select 'SCHOLAR SKILLS CHRISTIAN ACADEMY','332200805491'
				union select 'SCHOOL AT COLUMBIA UNIVERSITY (THE)','310300999956'
				union select 'SUMMIT SCHOOL (THE)','500304998107'
				union select 'WESTFIELD DAY SCHOOL (THE)','661800999826'
				union select 'WINDWARD SCHOOL (THE)','662200996541'
				union select 'MT VERNON SCHOOL DISTRICT','660900010000'
				union select 'NEW ROCHELLE CITY SD','661100010000'
				union select 'PEEKSKILL CITY SD','661500010000'
				union select 'RYE CITY SD','661800010000'
				union select 'WHITE PLAINS CITY SD','662200010000'
				union select 'BLIND BROOK-RYE UFSD','661905020000'
				union select 'BRIARCLIFF MANOR UFSD','661402020000'
				union select 'ELMSFORD UFSD','660409020000'
				union select 'GARRISON UFSD','480404020000'
				union select 'IRVINGTON UFSD','660402020000'
				union select 'ARDSLEY UFSD','660405030000'
				union select 'BRONXVILLE UFSD','660303030000'
				union select 'CROTON-HARMON UFSD','660202030000'
				union select 'DOBBS FERRY UFSD','660403030000'
				union select 'EASTCHESTER UFSD','660301030000'
				union select 'EDGEMONT UFSD','660406030000'
				union select 'HASTINGS-ON-HUDSON UFSD','660404030000'
				union select 'KATONAH-LEWISBORO UFSD','660101030000'
				union select 'MAMARONECK UFSD','660701030000'
				union select 'NANUET UFSD','500108030000'
				union select 'NYACK UFSD','500304030000'
				union select 'OSSINING UFSD','661401030000'
				union select 'PEARL RIVER UFSD','500308030000'
				union select 'PELHAM UFSD','661601030000'
				union select 'PLEASANTVILLE UFSD','660809030000'
				union select 'PORT CHESTER-RYE UFSD','661904030000'
				union select 'RYE NECK UFSD','661901030000'
				union select 'SCARSDALE UFSD','662001030000'
				union select 'TUCKAHOE UFSD','660302030000'
				union select 'UFSD-TARRYTOWNS','660401030000'
				union select 'VALHALLA UFSD','660805030000'
				union select 'HALDANE CSD','480401040000'
				union select 'NORTH SALEM CSD','661301040000'
				union select 'POCANTICO HILLS CSD','660802040000'
				union select 'PUTNAM VALLEY CSD','480503040000'
				union select 'BEDFORD CSD','660102060000'
				union select 'BREWSTER CSD','480601060000'
				union select 'BYRAM HILLS CSD','661201060000'
				union select 'CARMEL CSD','480102060000'
				union select 'CHAPPAQUA CSD','661004060000'
				union select 'CLARKSTOWN CSD','500101060000'
				union select 'EAST RAMAPO CSD (SPRING VALLEY)','500402060000'
				union select 'GREENBURGH CSD','660407060000'
				union select 'HARRISON CSD','660501060000'
				union select 'HAVERSTRAW-STONY POINT CSD (NORTH RO','500201060000'
				union select 'HENDRICK HUDSON CSD','660203060000'
				union select 'LAKELAND CSD','662401060000'
				union select 'MAHOPAC CSD','480101060000'
				union select 'MT PLEASANT CSD','660801060000'
				union select 'RAMAPO CSD (SUFFERN)','500401060000'
				union select 'SOMERS CSD','662101060000'
				union select 'SOUTH ORANGETOWN CSD','500301060000'
				union select 'YORKTOWN CSD','662402060000'
				union select 'ABBOTT UFSD','660413020000'
				union select 'GREENBURGH ELEVEN UFSD','660411020000'
				union select 'GREENBURGH-GRAHAM UFSD','660410020000'
				union select 'GREENBURGH-NORTH CASTLE UFSD','660412020000'
				union select 'HAWTHORNE-CEDAR KNOLLS UFSD','660803020000'
				union select 'MT PLEASANT-BLYTHEDALE UFSD','660806020000'
				union select 'MT PLEASANT-COTTAGE UFSD','660804020000'
				union select 'AMANI PUBLIC CHARTER SCHOOL','660900861000'
				union select 'CHARTER SCH-EDUC EXCELLENCE','662300860862'
				union select 'PUTNAM-NORTHERN WESTCHESTER BOCES','489000000000'
				union select 'ROCKLAND BOCES','509000000000'
				union select 'WESTCHESTER BOCES','669000000000';
			
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
			RAISE NOTICE 'rows inserted organizationrelation : %' , row_count;*/	
			row_count := ( select count(*) from usersorganizations);

         insert into usersorganizations ( aartuserid, organizationid, isdefault) 
         select    art_userid  aartuserid, 
                   o.id organizationid ,
                   case when inst.displayidentifier='662300449883' and inst.organizationname ='OAKVIEW PREP SCHOOL' then true 
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

