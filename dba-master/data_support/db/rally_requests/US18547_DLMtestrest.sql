/* validation
select st.id as stid, ts.id as tsid, ts.name as testsessionname, stb.activeflag as A, t.testname,
 (select categorycode as status from category where id = sts.status)
from student stud
join studenttracker st on st.studentid = stud.id
join studenttrackerband stb on stb.studenttrackerid = st.id
join testsession ts on ts.id = stb.testsessionid
join studentstests sts on sts.testsessionid = ts.id and sts.studentid = stud.id
join test t on t.id = sts.testid
where stud.statestudentidentifier = '1015653464'
and st.contentareaid =440
order by stb.createddate asc;

--only for SS ( no need to deactivate studenttracker)
select id, name,activeflag from testsession where id in (select testsessionid from studentstests where studentid = (select id from student where statestudentidentifier ='1021788481'));

--if do not have tests and testsession not assigning
--UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
   --  WHERE id in (st);
*/
BEGIN;
-- student:1001800574
---US18547: DLM TEST RESETS 04/19/2016
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (2594509,2969793,3108088,3111138,3183837,3208605,3231577,3273026,3278979,3287938));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (2594509,2969793,3108088,3111138,3183837,3208605,3231577,3273026,3278979,3287938));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (2594509,2969793,3108088,3111138,3183837,3208605,3231577,3273026,3278979,3287938);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (2594509,2969793,3108088,3111138,3183837,3208605,3231577,3273026,3278979,3287938);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (2594509,2969793,3108088,3111138,3183837,3208605,3231577,3273026,3278979,3287938);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 1001800574, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "2594509,2969793,3108088,3111138,3183837,3208605,3231577,3273026,3278979,3287938", "activeflag": true}')::JSON,  ('{"Reason": "As per US18547, inactivated the students tests"}')::JSON);
    
 update studenttracker set status = 'UNTRACKED' where id in (288755);



-- student:1021788481 (for SS no tracker)
---US18547: DLM TEST RESETS 04/19/2016
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (2447424,3112735,3438574,2965691,2966192,3288564,3509053,3515846,3540053,3377075,3352533,3515880,3446016,3508191,3445036,2965819,3509097,3349373,3286516,3514843,3377794));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (2447424,3112735,3438574,2965691,2966192,3288564,3509053,3515846,3540053,3377075,3352533,3515880,3446016,3508191,3445036,2965819,3509097,3349373,3286516,3514843,3377794));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (2447424,3112735,3438574,2965691,2966192,3288564,3509053,3515846,3540053,3377075,3352533,3515880,3446016,3508191,3445036,2965819,3509097,3349373,3286516,3514843,3377794);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (2447424,3112735,3438574,2965691,2966192,3288564,3509053,3515846,3540053,3377075,3352533,3515880,3446016,3508191,3445036,2965819,3509097,3349373,3286516,3514843,3377794);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (2447424,3112735,3438574,2965691,2966192,3288564,3509053,3515846,3540053,3377075,3352533,3515880,3446016,3508191,3445036,2965819,3509097,3349373,3286516,3514843,3377794);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 1021788481, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "2447424,3112735,3438574,2965691,2966192,3288564,3509053,3515846,3540053,3377075,3352533,3515880,3446016,3508191,3445036,2965819,3509097,3349373,3286516,3514843,3377794", "activeflag": true}')::JSON,  ('{"Reason": "As per US18547, inactivated the students tests"}')::JSON);
    
 --update studenttracker set status = 'UNTRACKED' where id in (288755);

-- student:1016008422
---US18547: DLM TEST RESETS 04/19/2016
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (2891847,3111141,3422524));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (2891847,3111141,3422524));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (2891847,3111141,3422524);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (2891847,3111141,3422524);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (2891847,3111141,3422524);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 1016008422, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "2891847,3111141,3422524", "activeflag": true}')::JSON,  ('{"Reason": "As per US18547, inactivated the students tests"}')::JSON);
    
 update studenttracker set status = 'UNTRACKED' where id in (242579);


-- student:1015653464
---US18547: DLM TEST RESETS 04/19/2016
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (2468821));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (2468821));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (2468821);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (2468821);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (2468821);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 1015653464, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "2468821", "activeflag": true}')::JSON,  ('{"Reason": "As per US18547, inactivated the students tests"}')::JSON);
    
 update studenttracker set status = 'UNTRACKED' where id in (238310);

 COMMIT;  

