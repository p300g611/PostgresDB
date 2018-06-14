--update studentstest,testssion, and ititestsessionhistory for ELA

DO
$BODY$
DECLARE

newenrollment record;
alltest  record;

data integer[] :=array [78911,
						523653,
						585685,
						585729,
						729159,
						816634,
						828112,
						855616,
						856188,
						856453,
						857566,
						858298,
						859338,
						859463,
						892285,
						1162944,
						1205469,
						1207306,
						1210088,
						1216702,
						1315097,
						1328074];
BEGIN

For i in array_lower(data,1) .. array_upper(data,1) loop

select * into newenrollment ( select stu.id studentid, en.id enrollmentid, r.id rosterid,en.attendanceschoolid from student stu
                           join enrollment en on en.studentid =stu.id
                           join enrollmentsrosters enr on enr.enrollmentid =en.id
                           join roster r on r.id =enr.rosterid
                      where en.activeflag is true and enr.activeflag is true  and  r.statesubjectareaid=3 and stu.id = data[i]);
					  
					  
select * into alltest ( select st.studentid, st.enrollmentid, st.id studenttestid, ts.id testsessionid,ts.rosterid tsrosterid, iti.id itiid, iti.rosterid itirosterid
						 from studentstests st
						 join testsession ts on ts.id=st.testsessionid
						 join testcollection tc on tc.id =st.testcollectionid
						 join ititestsessionhistory iti on iti.studentid =st.studentid and iti.testsessionid =ts.id
						 where  tc.contentareaid=3 and st.status=86
						 and st.studentid =data[i] );
update studentstests
set    enrollmentid =en.enrollmentid,
       modifieddate =now(),
	   modifieduser = (select id from aartuser where email='ats_dba_team@ku.edu')
	 where id in (select alt.studenttestid from alltest alt
	              join newenrollment en on en.studentid =alt.studentid 
				  where alt.enrollmentid <> en.enrollmentid);
				  
	 
update testsession 
set    rosterid =en.rosterid,
       attendanceschoolid=en.attendanceschoolid, 
        modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where id in (select alt.testsessionid from alltest alt 
             join newenrollment en on en.studentid=alt.studentid and alt.tsrosterid<>en.rosterid);


update ititestsessionhistory
set    rosterid=en.rosterid,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where id in (select alt.testsessionid from alltest alt 
             join newenrollment en on en.studentid=alt.studentid and alt.itirosterid<>en.rosterid );

END LOOP;

END;

$BODY$;




	 
	 
	 

						 
                                                                               


