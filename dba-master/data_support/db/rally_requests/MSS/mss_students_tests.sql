select 
 s.id  studentid
,s.statestudentidentifier
,s.legalfirstname
,s.legallastname
,e.localstudentidentifier
,o.displayidentifier "Aypschool"
,o.organizationname  "Aypschoolname"
,ot.schoolname       "Attendanceschool"
,r.coursesectionname "Rostername"
,st.testid 
,t.testname
,cst.categoryname
,st.startdatetime
,st.enddatetime
 into temp tmp_mss_students_tests
FROM student s
inner join enrollment e on e.studentid=s.id and s.activeflag is true and e.activeflag is true 
inner join enrollmentsrosters er on e.id=er.enrollmentid and er.activeflag is true
inner join roster r on r.id=er.rosterid and r.activeflag is true
inner join organization o on o.id=e.aypschoolid and o.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
left outer join studentstests st on st.studentid=e.studentid and st.activeflag is true
left outer join test t on t.id=st.testid and t.activeflag is true
left outer join category cst on cst.id=st.status
where ot.schoolname='MSS School'  and e.currentschoolyear=2017;
\copy (select * from tmp_mss_students_tests ) to '/srv/extracts/helpdesk/rally_requests/MSS/mss_masterpull.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);