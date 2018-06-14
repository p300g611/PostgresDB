

Begin;

select  stu.statestudentidentifier   ssid,
		stu.legalfirstname           studentfirstname,
		stu.legallastname            studentlastname,
		otd.districtdisplayidentifier  districtdisplayidentifier,
		otd.districtname              districtname,
		otd.schoolname               schoolname,
		ts.name                      testsessionname,
		st.startdatetime             teststartdatetime,
		st.enddatetime               testenddatetime,
		sspc.specialcircumstanceid   sccode,
		en.activeflag                 enrollmentactiveflag 

into temp itistudenttest

from studentstests st 
join testsession ts on st.testsessionid = ts.id
left join ititestsessionhistory iti on iti.testsessionid=ts.id and st.studentid=iti.studentid 
left join enrollment en on en.studentid = st.studentid
left join organizationtreedetail otd on otd.schoolid = en.attendanceschoolid
left  join studentspecialcircumstance sspc on sspc.studenttestid=st.id and sspc.activeflag is true
left join student stu on stu.id = en.studentid

where stu.statestudentidentifier in ('3108993992','9023935667');

\copy (select * from itistudenttest)  to 'T621122_extractiti.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;