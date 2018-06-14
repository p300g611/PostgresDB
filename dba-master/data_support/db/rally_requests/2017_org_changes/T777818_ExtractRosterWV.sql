
select stu.statestudentidentifier SSID, org.schoolname schoolname,org.districtname districtname,
r.id rosterid,ca.abbreviatedname rostersubject, gc.abbreviatedname grade


into temp tmp_statewv
from student stu
join enrollment en on en.studentid =stu.id and en.activeflag is true
join organizationtreedetail org on org.schoolid =en.attendanceschoolid
join gradecourse gc on gc.id =en.currentgradelevel
join enrollmentsrosters enr on enr.enrollmentid=en.id and enr.activeflag is true
join roster r on enr.rosterid=r.id and r.activeflag is true
join contentarea ca on ca.id=r.statesubjectareaid 
where org.statedisplayidentifier ='WV' and en.currentschoolyear=2017 and stu.activeflag is true and
gc.abbreviatedname in ('9','10','11','12') 
order by org.schoolname,org.districtname,gc.abbreviatedname ;

\copy (select * from tmp_statewv) to 'T777818_ExtractRosterWV.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);


