-- student SSID:9740655747,reset test --DLM-AntinaCooper-1417373-IMELARIIP
begin;

UPDATE studentsresponses 
   SET activeflag = false, 
     modifieduser = (SELECT id FROM aartuser WHERE email= 'ats_dba_team@ku.edu'),
     modifieddate = now()
     WHERE studentstestsid =18640814;

UPDATE studentstestsections 
    SET activeflag = false,  
        modifieduser = (SELECT id FROM aartuser WHERE email= 'ats_dba_team@ku.edu'),
        modifieddate = now()
        WHERE studentstestid =18640814;

UPDATE studentstests 
    SET activeflag = false, 
        modifieduser = (SELECT id FROM aartuser WHERE email= 'ats_dba_team@ku.edu'),
        modifieddate = now()
        WHERE id =18640814;
                 
UPDATE testsession 
    SET activeflag = false, 
        modifieduser = (SELECT id FROM aartuser WHERE email= 'ats_dba_team@ku.edu'), 
        modifieddate = now()
        WHERE id IN (select testsessionid from studentstests where id = 18640814);

	  
	  
UPDATE ititestsessionhistory 
    SET activeflag = false, 
        modifieduser = (SELECT id FROM aartuser WHERE email= 'ats_dba_team@ku.edu'), 
        modifieddate = now()
        WHERE id =781110;

commit;