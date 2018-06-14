-- Validation 
select st.studentid, st.enrollmentid,ort.schoolid,ort.schoolname,ort.districtid,ort.districtname,st.id studentstestsid, ts.id testsessionid
,sth.action,sth.acteddate reactivationcreateddate,
isr.createddate reportcreateddate,isr.id reportid,isr.contentareaid
--into temp tmp_react
from studentstests st
join enrollment en on en.id =st.enrollmentid
join organizationtreedetail ort on ort.schoolid=en.attendanceschoolid
join testsession ts on ts.id=st.testsessionid
join testcollection tc on ts.testcollectionid=tc.id
join studentstestshistory sth on sth.studentstestsid=st.id
join interimstudentreport isr on isr.studentid=st.studentid and isr.attendanceschoolid=ts.attendanceschoolid and isr.contentareaid=tc.contentareaid   
where isr.createddate < sth.acteddate  and sth.action='REACTIVATION'
order by st.studentid,isr.contentareaid;
    
\copy (select * from tmp_react) to 'tmp_reactivation.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *)  ;              
\copy (select * from studentreportquestioninfo where interimstudentreportid in (select reportid from tmp_react)) to 'studentreportquestioninfo_delete_20171020.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);                
\copy (select * from interimstudentreport where id in (select reportid from tmp_react)) to 'interimstudentreport_delete_20171020.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);                

--Delete interim reports
 
begin;            
delete from studentreportquestioninfo where interimstudentreportid in (select  reportid from tmp_react);
delete from interimstudentreport where id in (select reportid from tmp_react);
commit;




