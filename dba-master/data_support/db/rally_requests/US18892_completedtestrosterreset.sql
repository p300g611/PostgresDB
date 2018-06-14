
BEGIN;
-- student 1692019--ELA
	  update testsession
	  set rosterid=879828				
	  ,modifieddate=now()
	  ,modifieduser=12
	  where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1692019'
				  and st.status=86)
		                  and rosterid in (1051404) ; 

		                  
-- student 1783208--ELA
	  update testsession
	  set rosterid=879842
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1783208'
				  and st.status=86)
		and rosterid in (1051404) ; 
		
	                
-- student 1695424--ELA
	  update testsession
	  set rosterid=879828
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1695424'
				  and st.status=86)
		and rosterid=1051404 ; 

		
-- student 1839949--ELA
	  update testsession
	  set rosterid=879842
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1839949'
				  and st.status=86)
		and rosterid=1051404; 

-- student 2021547--ELA
	  update testsession
	  set rosterid=879842
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2021547'
				  and st.status=86)
		and rosterid=1051404;

-- student 1709297--ELA
	  update testsession
	  set rosterid=879828
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1709297'
				  and st.status=86)
		and rosterid=1051404;


-- student 2002260--M
	  update testsession
	  set rosterid=890762
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2002260'
				  and st.status=86)
		and rosterid=1057894;
		

-- student 2012830--M
	  update testsession
	  set rosterid=890910
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2012830'
				  and st.status=86)
		and rosterid=1057894;



-- student 1789689--M
	  update testsession
	  set rosterid=891081
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1789689'
				  and st.status=86)
		and rosterid=879874;

-- student 1703459--M
	  update testsession
	  set rosterid=890992
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1703459'
				  and st.status=86)
		and rosterid=1057886;
			

-- student 2041004--M
	  update testsession
	  set rosterid=890992
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2041004'
				  and st.status=86)
		and rosterid=1057886;



-- student 1671334--M
	  update testsession
	  set rosterid=890992
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1671334'
				  and st.status=86)
		and rosterid=1057886;


-- student 2080995--M
	  update testsession
	  set rosterid=890992
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2080995'
				  and st.status=86)
		and rosterid=1057886;


-- student 1849950--M
	  update testsession
	  set rosterid=890992
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1849950'
				  and st.status=86)
		and rosterid=1057886;
		

-- student 2160692--M
	  update testsession
	  set rosterid=890992
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2160692'
				  and st.status=86)
		and rosterid=1057886;	

-- student 1988814--M
	  update testsession
	  set rosterid=890992
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1988814'
				  and st.status=86)
		and rosterid=1057886;


-- student 1850954--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1850954'
				  and st.status=86)
		and rosterid=880046;			


-- student 1787613--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1787613'
				  and st.status=86)
		and rosterid=880046;
		

-- student 1787613--M
	  update testsession
	  set rosterid=890842
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1787613'
				  and st.status=86)
		and rosterid=879895;


-- student 1895753--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1895753'
				  and st.status=86)
		and rosterid=880046;


-- student 1783147--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1783147'
				  and st.status=86)
		and rosterid=880046;


-- student 1783744--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1783744'
				  and st.status=86)
		and rosterid=880046;


-- student 1858613--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1858613'
				  and st.status=86)
		and rosterid=880046;



-- student 1782315--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1782315'
				  and st.status=86)
		and rosterid=880046;


-- student 1932904--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1932904'
				  and st.status=86)
		and rosterid=880046;


-- student 2261632--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2261632'
				  and st.status=86)
		and rosterid=880046;


-- student 1834154--ELA
	  update testsession
	  set rosterid=890841
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1834154'
				  and st.status=86)
		and rosterid=880046;



	
COMMIT;				
		 		