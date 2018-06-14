/*
 SELECT    en.id eenrollmentid,
           en.activeflag,
           st.id AS studentstestid,
           st.testsessionid,
           st.testcollectionid as testcollectionid,
           st.testid as testid,
           st.enrollmentid stenrollmentid,
           c.categorycode as status,
           ts.stageid as stageid,
           ts.gradecourseid as gradecourseid,
           st.activeflag testactive,
           ts.activeflag sessiontactive,
           attsch.displayidentifier AS attSchdisplay,
           ca.abbreviatedname AS contentareaname,
           ts.name AS testsessionname
     FROM studentstests st
     JOIN enrollment en ON en.id = st.enrollmentid
     JOIN testcollection tc ON tc.id = st.testcollectionid
     JOIN organization attsch ON attsch.id = en.attendanceschoolid
     JOIN organization aypsch ON aypsch.id = en.aypschoolid
     JOIN contentarea ca ON ca.id = tc.contentareaid
     JOIN student stu ON stu.id = en.studentid
     JOIN testsession ts ON ts.id = st.testsessionid
     --inner join studentsresponses sr on st.id=sr.studentstestsid
     JOIN category c ON c.id = st.status
     WHERE stu.statestudentidentifier = '1002417237'
       --AND stu.stateid = 51        
       AND en.currentschoolyear = 2016
       --AND ca.abbreviatedname = 'Sci' --ELA,M
       --AND attsch.displayidentifier = _future_school
           --AND ts.operationaltestwindowid IN (10131,10132,10133)
           ;
*/
BEGIN;

-- student 1002417237
update studentstests
set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
where 	status=86 
       and activeflag is false 
       and studentid in ( select id from student 
			     where statestudentidentifier='1002417237');

update studentsresponses
set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
where 	activeflag is false 
       and studentstestsid in (select st.id from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1002417237'
				  and st.status=86 and st.activeflag is true);  
 update testsession
	  set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1002417237'
				  and st.status=86 and st.activeflag is true); 
-- student 1002733986
update studentstests
set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
where 	status=86 
       and activeflag is false 
       and studentid in ( select id from student 
			     where statestudentidentifier='1002733986');

update studentsresponses
set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
where 	 activeflag is false 
       and studentstestsid in (select st.id from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1002733986'
				  and st.status=86 and st.activeflag is true);  
 update testsession
	  set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1002733986'
				  and st.status=86 and st.activeflag is true); 
-- student 1002393916
update studentstests
set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
where 	status=86 
       and activeflag is false 
       and studentid in ( select id from student 
			     where statestudentidentifier='1002393916');

update studentsresponses
set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
where 	activeflag is false 
       and studentstestsid in (select st.id from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1002393916'
				  and st.status=86 and st.activeflag is true);  
 update testsession
	  set activeflag=true
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1002393916'
				  and st.status=86 and st.activeflag is true); 				  
COMMIT;

