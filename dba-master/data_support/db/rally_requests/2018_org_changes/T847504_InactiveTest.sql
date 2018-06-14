/*Ticket #847054
Please inactivate all the spring tests for the following four students. 
ssid:310310,188875,6993781430,9401003175 
*/

BEGIN;


UPDATE studentsresponses
 SET activeflag = false, 
 modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'),
 modifieddate = now()
     WHERE studentstestsid IN (22470781,22470164,22470312,22470042,22470420,22470508,22470430,22470518);

UPDATE studentstestsections 
SET activeflag = false,
modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), 
modifieddate = now()
      WHERE studentstestid IN (22470781,22470164,22470312,22470042,22470420,22470508,22470430,22470518);

UPDATE studentstests
 SET manualupdatereason ='as for ticket #847054',
 activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'),
 modifieddate = now()
     WHERE id IN (22470781,22470164,22470312,22470042,22470420,22470508,22470430,22470518);
                 
UPDATE testsession
 SET activeflag = false,
 modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'),
 modifieddate = now()
     WHERE id IN (select testsessionid from studentstests where id in (22470781,22470164,22470312,22470042,22470420,22470508,22470430,22470518));

UPDATE studenttrackerband
 SET activeflag = false,
 modifieddate = now(),
 modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu')
     WHERE testsessionid in (select testsessionid from studentstests where id in (22470781,22470164,22470312,22470042,22470420,22470508,22470430,22470518));



COMMIT;  

