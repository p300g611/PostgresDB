--data check  for duplicates testname 
-- 862735 (Oklahoma)
-- 1316014 (New Jersey)
-- 1282951 (New York)

 select st.studentid,st.id stid,st.status,st.activeflag,ts.source,t.testname,gc.name sessions,gct.name collection,gce.name enroll,st.modifieddate
 from studentstests st
 inner join test t on t.id=st.testid
 inner join enrollment e on e.id=st.enrollmentid
 inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
 inner join testcollection tc on tc.id=ts.testcollectionid
 left outer join gradecourse gc on gc.id=ts.gradecourseid
 left outer join gradecourse gct on gct.id=tc.gradecourseid
 left outer join gradecourse gce on gce.id=e.currentgradelevel
 where st.studentid =862735  order by st.activeflag,t.testname;


--Need to inactive 
 select st.studentid,st.id stid,st.status,st.activeflag,ts.source,t.testname,gc.name sessions,gct.name collection,gce.name enroll,st.modifieddate
 from studentstests st
 inner join test t on t.id=st.testid
 inner join enrollment e on e.id=st.enrollmentid
 inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
 inner join testcollection tc on tc.id=ts.testcollectionid
 left outer join gradecourse gc on gc.id=ts.gradecourseid
 left outer join gradecourse gct on gct.id=tc.gradecourseid
 left outer join gradecourse gce on gce.id=e.currentgradelevel
 where st.studentid  in (862735,1316014,1282951) 
 and gc.name=gce.name and tc.contentareaid=441
  order by st.activeflag,t.testname;


--Update
BEGIN;

UPDATE studentsresponses SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE studentstestsid IN (23102650,23015604,23047302) and activeflag = true;

UPDATE studentstestsections SET activeflag = false,  modifieduser = 174744, modifieddate = now()
      WHERE studentstestid IN (23102650,23015604,23047302) and activeflag = true;

UPDATE studentstests SET manualupdatereason ='FieldTestDuplicated DE17319', activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (23102650,23015604,23047302) and activeflag = true;
                 
UPDATE testsession SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (select testsessionid from studentstests where id in (23102650,23015604,23047302) ) and activeflag = true;


COMMIT;  


--Update
BEGIN;


UPDATE studentsresponses SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE studentstestsid IN (23207811,23207809,23207812) and activeflag = true;

UPDATE studentstestsections SET activeflag = false,  modifieduser = 174744, modifieddate = now()
      WHERE studentstestid IN (23207811,23207809,23207812) and activeflag = true;

UPDATE studentstests SET manualupdatereason ='FieldTestDuplicated DE17319', activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (23207811,23207809,23207812) and activeflag = true;
                 
UPDATE testsession SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (select testsessionid from studentstests where id in (23207811,23207809,23207812) ) and activeflag = true;

UPDATE studenttracker SET status='TRACKED',modifieduser = 174744, modifieddate = now()
     WHERE id IN (select id from studenttracker where studentid  in (862735,1316014,1282951) and contentareaid=441 and schoolyear=2018);

COMMIT;  


--Update
BEGIN;


UPDATE studentsresponses SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE studentstestsid IN (23207854) and activeflag = true;

UPDATE studentstestsections SET activeflag = false,  modifieduser = 174744, modifieddate = now()
      WHERE studentstestid IN (23207854) and activeflag = true;

UPDATE studentstests SET manualupdatereason ='FieldTestDuplicated DE17319', activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (23207854) and activeflag = true;
                 
UPDATE testsession SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (select testsessionid from studentstests where id in (23207854) ) and activeflag = true;

UPDATE studenttracker SET status='TRACKED',modifieduser = 174744, modifieddate = now()
     WHERE id IN (select id from studenttracker where studentid  in (1282951) and contentareaid=441 and schoolyear=2018);

COMMIT; 
