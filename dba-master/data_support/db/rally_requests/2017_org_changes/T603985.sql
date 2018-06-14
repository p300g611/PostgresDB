-- select o.districtname,o.schoolname
-- ,s.statestudentidentifier statestudentidentifier
-- ,tgc.name testgrade
-- ,t.testname,en.currentschoolyear,schoolname,districtname,statename,tgc.abbreviatedname 
-- -- into temp tmp_extract 

select st.id,st.createddate,st.createddate,st.startdatetime
from enrollment en
inner join student s on s.id=en.studentid
inner join organizationtreedetail o on o.schoolid=en.attendanceschoolid and en.activeflag is true
inner join studentstests st on en.studentid = st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join test t on st.testid = t.id
where o.districtid=52895;


--  \copy (select * from tmp_extract ) to 'tmp_extract.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);							