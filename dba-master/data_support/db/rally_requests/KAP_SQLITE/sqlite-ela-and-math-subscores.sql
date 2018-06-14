select s.id as "Student DB ID"
      ,s.statestudentidentifier as "State Student Identifier"
      ,otd.districtname as "District"
      ,otd.schoolname as "School"
      ,gc.abbreviatedname as "Grade"
      ,ca.abbreviatedname as "Content Area"
      ,sr.externaltest1id as "Test ID 1"
      ,sr.externaltest2id as "Test ID 2"
      ,sr.externaltest3id as "Test ID 3"
      ,sr.externaltest4id as "Test ID 4"
      ,sr.performancetestexternalid as "Performance Test ID"
      ,rss.subscoredefinitionname as "Subscore Definition Name"
      ,sr.incompletestatus as "Incomplete Status"
      ,rss.subscorerawscore as "Subscore Raw Score"
      , rss.rating as "Rating"
from (select distinct statestudentidentifier,id from student) s
join studentreport sr on s.id = sr.studentid
join organizationtreedetail otd on sr.attendanceschoolid = otd.schoolid and sr.districtid = otd.districtid and sr.stateid = otd.stateid
join contentarea ca on sr.contentareaid = ca.id
join gradecourse gc on sr.gradeid = gc.id
join reportsubscores rss on s.id = rss.studentid and sr.id = rss.studentreportid
where sr.schoolyear = 2016
and ca.abbreviatedname in ('ELA', 'M')
order by ca.abbreviatedname
       , otd.districtname
       , otd.schoolname
       , gc.abbreviatedname
       , s.statestudentidentifier
       , rss.subscoredefinitionname;