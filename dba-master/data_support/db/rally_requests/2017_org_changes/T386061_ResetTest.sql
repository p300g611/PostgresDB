

begin;



UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE id in (24713330,24713305);

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id in (14475189,14475164);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (3815937,3815912);



INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 860631, 12, now(), 'RESET_STUDENT_TRACKER', ('{"TestSessionIds": "3815937,3815912", "activeflag": true}')::JSON,  
      ('{"Reason": "As per T386061, inactivated the students tests"}')::JSON);




commit;