BEGIN;
--SSID:6275071705 REMOVE:DLM-NavarroPedro-6275071705-IM ELA CW.11-12 PP,  EE: ELA.EE.RI.11-12.4

UPDATE studentsresponses SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE studentstestsid in (14492065,14492071);

UPDATE studentstestsections SET activeflag = false,  modifieduser = 12, modifieddate = now()
      WHERE studentstestid in (14492065,14492071);

UPDATE studentstests SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE id in (14492065,14492071);
                 
UPDATE testsession SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE id in (3829528,3829534);

UPDATE ititestsessionhistory SET activeflag = false, modifieduser = 12, modifieddate = now()
     WHERE id in (558565,558568);	

	 

COMMIT;