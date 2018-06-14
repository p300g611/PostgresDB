-- Validation1:Find the number of student completed tests 
select categoryname,st.status,count(s.id)
FROM student s
inner join enrollment e on e.studentid=s.id and s.activeflag is true and e.activeflag is true 
inner join enrollmentsrosters er on e.id=er.enrollmentid and er.activeflag is true
inner join roster r on r.id=er.rosterid and r.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
left outer join studentstests st on st.studentid=e.studentid and st.activeflag is true
left outer join category cst on cst.id=st.status
where ot.schoolname='MSS School'  and e.currentschoolyear=2017 
group by categoryname,st.status;
--=======================================================================================================
-- Validation2:Counts validation by roster form
select
 s.id  studentid
,s.statestudentidentifier
,s.legalfirstname
,s.legallastname
,e.localstudentidentifier
,e.aypschoolid
,r.coursesectionname Rostername
FROM student s
inner join enrollment e on e.studentid=s.id and s.activeflag is true and e.activeflag is true
inner join enrollmentsrosters er on e.id=er.enrollmentid and er.activeflag is true
inner join roster r on r.id=er.rosterid and r.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
left outer join studentstests st on st.studentid=e.studentid and st.activeflag is true
where ot.schoolname='MSS School'  and e.currentschoolyear=2017 and st.status=86
AND  'Roster Form 14'=r.coursesectionname ORDER BY s.id;
--=======================================================================================================
-- Validation3:Counts validation by roster form
select 
 e.aypschoolid       "Aypschoolid"
,o.displayidentifier "Aypschool"
,o.organizationname  "Aypschoolname"
,categoryname
,count(*)
FROM student s
inner join enrollment e on e.studentid=s.id and s.activeflag is true and e.activeflag is true 
inner join enrollmentsrosters er on e.id=er.enrollmentid and er.activeflag is true
inner join roster r on r.id=er.rosterid and r.activeflag is true
inner join organization o on o.id=e.aypschoolid and o.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
left outer join studentstests st on st.studentid=e.studentid and st.activeflag is true
left outer join test t on t.id=st.testid and t.activeflag is true
left outer join category cst on cst.id=st.status
where ot.schoolname='MSS School'  and e.currentschoolyear=2017
group by   e.aypschoolid      
,o.displayidentifier 
,o.organizationname  
,categoryname;
--====================================================================================================
-- Extract1:masterpull:Completed student counts 
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
 into temp tmp_mss_masterpull
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
\copy (select * from tmp_mss_masterpull ) to 'tmp_mss_masterpull.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--====================================================================================================

-- Extract2:masterpull_item:Completed student counts 
select distinct
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
,st.id               "studentstestsid" 
,t.testname
,tl.testletname 
,cst.categoryname     "teststatus"
,st.startdatetime
,st.enddatetime
,sts.id               "testsectionid"  
,tstv.taskvariantid  
,taskvariantposition   
,sres1.score    
,sres1.response      "responsetext"   
into temp tmp_mss_masterpull_items
FROM studentstests st 
inner join test t on t.id=st.testid and t.activeflag is true
inner join category cst on cst.id=st.status
inner join student s on st.studentid=s.id and st.activeflag is true
inner join enrollment e on e.studentid=s.id and s.activeflag is true and e.activeflag is true 
inner join enrollmentsrosters er on e.id=er.enrollmentid and er.activeflag is true
inner join roster r on r.id=er.rosterid and r.activeflag is true
inner join organization o on o.id=e.aypschoolid and o.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentstestsections sts on sts.studentstestid=st.id and sts.activeflag is true
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join testlet tl on tl.id=tstv.testletid  
left outer JOIN studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid
where ot.schoolid=84707 and e.currentschoolyear=2017;
\copy (select * from tmp_mss_masterpull_items) to 'tmp_mss_masterpull_items.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

----------------------------------------------------------------------------------------














