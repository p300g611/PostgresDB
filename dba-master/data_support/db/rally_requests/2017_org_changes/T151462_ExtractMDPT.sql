select distinct s.statestudentidentifier, 
       s.legalfirstname StudentFirstName,
       s.legallastname StudentLastName,
       otd.districtdisplayidentifier DistrictDisplayIdentifier,
       otd.districtname DistrictName,
       otd.schoolname SchoolName,
	   otd.schooldisplayidentifier   AYPschoolidentifier,
       ts.name TestSessionName,
       st.startdatetime TestStartDateTime,
       st.enddatetime TestEndDateTime,
	   ca.categorycode as  ReasonNotScored,
       sspc.specialcircumstanceid Sccode,
       e.activeflag    Enrollmentflag
       into temp tmp_testsession
     from student s
   left outer join enrollment e on s.id=e.studentid  
   left outer join gradecourse gc on e.currentgradelevel =gc.id
   left outer join organizationtreedetail otd on otd.schoolid=e.attendanceschoolid
   left outer join studentstests st on st.enrollmentid=e.id and st.studentid=s.id and st.activeflag is true
   left outer join studentstestsections sts on st.id = sts.studentstestid
   left outer join studentresponsescore strs on sts.id = strs.studentstestsectionsid
   left outer join category ca on strs.nonscorablecodeid = ca.id
   left outer join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
   left outer join stage sg on ts.stageid = sg.id
   left outer join testcollection tc on ts.testcollectionid =tc.id
   left outer join contentarea ct on ct.id = tc.contentareaid
   left outer join studentspecialcircumstance sspc on sspc.studenttestid=st.id and sspc.activeflag is true

   where s.stateid =51 and ca.categorycode is not null and s.activeflag is true
   and gc.abbreviatedname ='11'and sg.name = 'Performance'
   and ct.abbreviatedname ='ELA' and e.currentschoolyear = 2016 ;

    
\COPY (select * from tmp_testsession ) to 'tmp_testsession.csv' DELIMITER ',' CSV HEADER ;