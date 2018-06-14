CREATE TEMPORARY TABLE tmp_ssid(ssid  text ); 
\COPY tmp_ssid FROM 'KSSSIDST.csv' DELIMITER ',' CSV HEADER ; 

select tmp.ssid SSID,
       s.legalfirstname StudentFirstName,
       s.legallastname StudentLastName,
       otd.districtdisplayidentifier DistrictDisplayIdentifier,
       otd.districtname DistrictName,
       otd.schooldisplayidentifier SchoolName,
       ts.name TestSessionName,
       st.startdatetime TestStartDateTime,
       st.enddatetime TestEndDateTime,
       sspc.specialcircumstanceid SCcode,
       e.activeflag enrollmentflag       
       into temp tmp_testsession
       from tmp_ssid tmp 
   left outer join student s  on s.statestudentidentifier=tmp.ssid and s.stateid=51
   left outer join enrollment e on s.id=e.studentid  
   left outer join organizationtreedetail otd on otd.schoolid=e.attendanceschoolid
   left outer join studentstests st on st.enrollmentid=e.id and st.studentid=s.id and st.activeflag is true
   left outer join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
   left outer join studentspecialcircumstance sspc on sspc.studenttestid=st.id and sspc.activeflag is true;

\COPY (select * from tmp_testsession ) to 'tmp_testsession.csv' DELIMITER ',' CSV HEADER ;
