begin;
-- move students tests from 966067 to 961109

 update survey 
 set activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =961109 and activeflag = true;

 update survey 
 set studentid=961109, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =966067;


  update studentpnpjson 
 set activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =961109 and activeflag = true;;

 update studentpnpjson 
 set studentid=961109, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =966067;


 update studentprofileitemattributevalue 
 set activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =961109 and activeflag = true;

 update studentprofileitemattributevalue 
 set studentid=961109, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =966067;


 UPDATE studentsresponses SET studentid=961109, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =966067;

  UPDATE studentstests SET studentid=961109,enrollmentid=3414429,manualupdatereason='Ticket #T904989',  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =966067;

  UPDATE testsession SET name=replace(name,'966067','961109'), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =966067;

 update studenttracker 
 set studentid=961109, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =966067;

 commit;


 BEGIN;


UPDATE studentsresponses SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE studentstestsid IN (23229658,23230126) and activeflag = true;

UPDATE studentstestsections SET activeflag = false,  modifieduser = 174744, modifieddate = now()
      WHERE studentstestid IN (23229658,23230126) and activeflag = true;

UPDATE studentstests SET manualupdatereason ='Ticket #T904989', activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (23229658,23230126) and activeflag = true;
                 
UPDATE testsession SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (select testsessionid from studentstests where id in (23229658,23230126) ) and activeflag = true;

UPDATE studenttracker SET status='TRACKED',modifieduser = 174744, modifieddate = now()
     WHERE id IN (select id from studenttracker where studentid  in (961109) and contentareaid in (440,3) and schoolyear=2018);

update student 
set 
commbandid            = 230,
elabandid             = 230,
finalelabandid        = 230,
mathbandid            = 229,
finalmathbandid       = 229,
stateid               = 9632,
scibandid             = 229,
finalscibandid        = 229,
writingbandid         = 729
where id=961109;     

COMMIT;  

--script ran revers order corrected FCS info , to correct PNP need to run below script to update active .
select id from studentprofileitemattributevalue 
where  studentid=961109 and activeflag = false and  id in 
( 19300537,
 19300538,
 19300539,
 19300540,
 19300541,
 19300542,
 19300543,
 19300544,
 19300545,
 19300546,
 19300556,
 19300557,
 19300558,
 19300559,
 19300560,
 19300561,
 19300562,
 19300563,
 19300564,
 19300565,
 19300566,
 19300567,
 19300568,
 19300569,
 19300570,
 19300571,
 19300572,
 19300612,
 19300613,
 19300553,
 19300554,
 19300555,
 19300573,
 19300574,
 19300575,
 19300576,
 19300577,
 19300578,
 19300579,
 19300580,
 19300581,
 19300582,
 19300583,
 19300584,
 19300585,
 19300586,
 19300547,
 19300548,
 19300549,
 19300550,
 19300551,
 19300552,
 19300587,
 19300588,
 19300589,
 19300590,
 19300591,
 19300592,
 19300593,
 19300594,
 19300595,
 19300596,
 19300597,
 19300598,
 19300599,
 19300600,
 19300601,
 19300602,
 19300603,
 19300604,
 19300605,
 19300606,
 19300607,
 19300608,
 19300609,
 19300610,
 19300611);
