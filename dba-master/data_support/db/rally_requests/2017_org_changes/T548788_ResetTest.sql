BEGIN;
--DLM-AdamsCorbin-8080854812-IM ELA RI.9-10.3 IP


UPDATE studentstestsections SET activeflag = false,  modifieduser = 12, modifieddate = now()
      WHERE studentstestid = 14596452;

UPDATE studentstests SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =14596452 ;
                 
UPDATE testsession SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =3888872;

UPDATE ititestsessionhistory SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =619882;	

COMMIT;