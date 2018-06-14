BEGIN;
--SSID:5387055126 REMOVE:ELA.EE.CW.11-12.PP

UPDATE studentsresponses SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE studentstestsid = 14492053 and testid = 44445;

UPDATE studentstestsections SET activeflag = false,  modifieduser = 12, modifieddate = now()
      WHERE studentstestid = 14492053;

UPDATE studentstests SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE id =14492053 ;
                 
UPDATE testsession SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE id =3829516;

UPDATE ititestsessionhistory SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE id =558557;	

COMMIT;