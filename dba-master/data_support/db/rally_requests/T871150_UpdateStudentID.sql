BEGIN;

update student 
set   statestudentidentifier='7291891760',
      modifieddate = now(),
	  modifieduser =12
where id = 1325485;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1325485, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "120674", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;
	  
update student 
set   statestudentidentifier='5982845001',
      legalfirstname ='Jayven',
	  username ='jayv.keys',
      modifieddate = now(),
	  modifieduser =12
where id = 1340002;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1340002, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "125537", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;

update student 
set   statestudentidentifier='1379202419',
      modifieddate = now(),
	  modifieduser =12
where id = 1349067;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1349067, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "2018624", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;
	  
update student 
set   statestudentidentifier='2152707251',
      modifieddate = now(),
	  modifieduser =12
where id = 1343048;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1343048, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "215270725", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;
	  
update student 
set   statestudentidentifier='1091600030',
      modifieddate = now(),
	  modifieduser =12
where id = 1325340;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1325340, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "1463993094", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;
	  
update student 
set   statestudentidentifier='4949207050',
      modifieddate = now(),
	  modifieduser =12
where id = 1324383;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1324383, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "2604712226", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;	

update student 
set   statestudentidentifier='5162566393',
      modifieddate = now(),
	  modifieduser =12
where id = 1324974;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1324974, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "7535934185", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;	

update student 
set   statestudentidentifier='5868711927',
      modifieddate = now(),
	  modifieduser =12
where id = 1341507;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1341507, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "7647968838", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;	

update student 
set   statestudentidentifier='2121848714',
      modifieddate = now(),
	  modifieduser =12
where id = 1326033;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1326033, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "7707015883", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#871150 inactivated the students"}'::JSON;
	  
COMMIT;