BEGIN;


update student 
set    statestudentidentifier='8159114168',
       modifieddate=now(),
	   modifieduser =174744
where id =1325087;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      SELECT 'DATA_SUPPORT', 'STUDENT', 1325087, 12, now(), 'RESET_SSID', '{"statestudentidentifier": "815911416"}'::JSON,  
      '{"Reason": "As ticket#642767"," statestudentidentifier":"8159114168"}'::JSON;
	

update student 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where id =1391261;
	
update enrollment 

set   activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =2772307;


COMMIT;


 