BEGIN;
-- Update student rosterid. student ID:1013102509
--ELA
	  update testsession
	  set rosterid=920592
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1013102509'
				  and st.status=86)
		and rosterid=946280;

		
--M
	  update testsession
	  set rosterid=920593
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1013102509'
				  and st.status=86)
		and rosterid=946281;
COMMIT;		