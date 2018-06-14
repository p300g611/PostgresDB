BEGIN;
--move student test to correct rosters
--studentID:8552267614,6751823074,9491761422


--ID: 8552267614
--update enrollmentsrosters

update enrollmentsrosters
set activeflag = false, modifieddate = now(), modifieduser =12
where id in (14310342,14307939) and activeflag is true;

--M
	  update testsession
	  set rosterid=1038093
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='8552267614'
				  and st.status=86)
		and rosterid=948782;
		
		
--ELA
	  update testsession
	  set rosterid=1038083
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='8552267614'
				  and st.status=86)
		and rosterid=947632;
		
--ID: 6751823074
--update enrollmentsrosters

update enrollmentsrosters
set activeflag = false, modifieddate = now(), modifieduser =12
where id in (14308056,14310453) and activeflag is true;

--M
	  update testsession
	  set rosterid=1038093
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='6751823074'
				  and st.status=86)
		and rosterid=948782;
		
		
--ELA
	  update testsession
	  set rosterid=1038083
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='6751823074'
				  and st.status=86)
		and rosterid=947632;
		
		
--ID:9491761422
--update enrollmentsrosters

update enrollmentsrosters
set activeflag = false, modifieddate = now(), modifieduser =12
where id in (14308638,14311078) and activeflag is true;
		
--ELA
	  update testsession
	  set rosterid=1038083
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='9491761422'
				  and st.status=86)
		and rosterid=948049;
		
COMMIT;