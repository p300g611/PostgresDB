BEGIN;

--2955430536 DLM-HintonAnzell-2955430536-IM ELA CW.11-12 PP

UPDATE studentstestsections SET activeflag = false,  modifieduser = 12, modifieddate = now()
      WHERE studentstestid = 14532878;

UPDATE studentstests SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =14532878 ;
                 
UPDATE testsession SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =3857675;

UPDATE ititestsessionhistory SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =594908;	
	 
	 
--4120618046 DLM-SolangeCesile-4120618046-IM ELA CW.11-12 PP

UPDATE studentstestsections SET activeflag = false,  modifieduser = 12, modifieddate = now()
      WHERE studentstestid = 14532879;

UPDATE studentstests SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =14532879 ;
                 
UPDATE testsession SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =3857676;

UPDATE ititestsessionhistory SET activeflag = false, modifieduser = 12, modifieddate = now(),status = 533
     WHERE id =594909;		 

COMMIT;