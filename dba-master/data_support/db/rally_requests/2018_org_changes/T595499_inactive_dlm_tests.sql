--Update
BEGIN;

UPDATE studentsresponses SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE studentstestsid IN (23229282,23230196,23230195) and activeflag = true;

UPDATE studentstestsections SET activeflag = false,  modifieduser = 174744, modifieddate = now()
      WHERE studentstestid IN (23229282,23230196,23230195) and activeflag = true;

UPDATE studentstests SET manualupdatereason ='T595499', activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (23229282,23230196,23230195) and activeflag = true;
                 
UPDATE testsession SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (select testsessionid from studentstests where id in (23229282,23230196,23230195) ) and activeflag = true;


COMMIT;  

