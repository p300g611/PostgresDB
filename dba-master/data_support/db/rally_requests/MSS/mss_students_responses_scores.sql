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
,t.externalid       testexternalid 
,st.id               "studentstestsid" 
,t.testname
,tl.testletname 
,cst.categoryname     "teststatus"
,st.startdatetime
,st.enddatetime
,sts.id               "testsectionid"  
,tstv.taskvariantid  
,tv.externalid       taskvariantexternalid
,taskvariantposition   
,sres1.score    
,sres1.response      "responsetext"  
,sres1.foilid
,tv.maxscore         taskvariantmaxscore
into temp tmp_mss_students_responses_scores
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
inner join taskvariant tv on tv.id=tstv.taskvariantid
left outer join testlet tl on tl.id=tstv.testletid  
left outer JOIN studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid
where ot.schoolid=84707 and e.currentschoolyear=2017;
\copy (select * from tmp_mss_students_responses_scores) to '/srv/extracts/helpdesk/rally_requests/MSS/mss_students_responses_scores.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);