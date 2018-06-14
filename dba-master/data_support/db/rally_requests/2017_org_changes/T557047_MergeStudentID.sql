BEGIN;

update student 
set activeflag = false,
    modifieddate = now(),
	modifieduser =12
where id = 856761;




update student 
set statestudentidentifier ='2604712226',
    modifieddate = now(),
	modifieduser =12
where id = 1324383;



INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'SCRIPT', 'Studentstateidentifier', 1324383, 12, now(), 'RESET_STUDENT_SSID', '{"statestudentidentifier": "2604712226", "activeflag": "true"}'::JSON,  
      '{"Reason": "As ticket#557047 inactivated the students"}'::JSON;
	  
COMMIT;