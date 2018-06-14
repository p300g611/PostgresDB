drop table if exists tmp_ssid;
drop table if exists tmp_testsession;
CREATE TEMPORARY TABLE tmp_ssid(ssid  text ); 
\COPY tmp_ssid FROM 'KSSSIDST.csv' DELIMITER ',' CSV HEADER ; 

select tmp.ssid SSID,
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
       sspc.specialcircumstanceid SCcode,
       e.activeflag    enrollmentflag    
      into temp tmp_testsession
      from tmp_ssid tmp 
   left outer join student s  on s.statestudentidentifier=tmp.ssid and s.stateid=51
   left outer join enrollment e on s.id=e.studentid  
   left outer join organizationtreedetail otd on otd.schoolid=e.attendanceschoolid
   left outer join studentstests st on st.enrollmentid=e.id and st.studentid=s.id and st.activeflag is true
   left outer join studentstestsections sts on st.id = sts.studentstestid
   left outer join studentresponsescore strs on sts.id = strs.studentstestsectionsid
   left outer join category ca on strs.nonscorablecodeid = ca.id
   left outer join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
   left outer join studentsresponses str on str.studentid =s.id and str.studentstestsid = st.id 
   left outer join studentspecialcircumstance sspc on sspc.studenttestid=st.id and sspc.activeflag is true;

   
     

\COPY (select * from tmp_testsession ) to 'tmp_testsession.csv' DELIMITER ',' CSV HEADER ;

drop table if exists tmp_ssid;
drop table if exists tmp_testsession;
