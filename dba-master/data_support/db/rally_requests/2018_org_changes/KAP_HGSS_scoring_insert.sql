-- Insert manual scoring not completed 
-- Need to change the scores 
-- Need to make sure students responses available
-- Script has dependency need to run by the order  

begin;
--Set scoring status to complete
 update scoringassignmentstudent
    set kelpascoringstatus = 631, modifieddate=now(),
       modifieduser = 12
    where activeflag = true and coalesce(kelpascoringstatus,0)<>631
    and studentstestsid in (
	select distinct  st.id studenttestid
	from studentstests st 
	inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
	inner join student s on s.id=st.studentid
	inner join testsession ts on ts.id=st.testsessionid
	inner join studentstestsections sts on sts.studentstestid=st.id
	inner join testcollection tc on tc.id=st.testcollectionid
	inner join studentsresponses sr on sr.studentstestsectionsid=sts.id and st.id=sr.studentstestsid
	inner join stage stg on stg.id=tc.stageid
	where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258)  
	and s.statestudentidentifier in ('2729257136'
,'9895002335'
,'5217835982'
,'7523981348'
,'8193783603'
,'4472990628'
,'7091138538'
,'1156794323'
,'1957373644'
,'4102870296'
,'3701141711'
,'3733207513'
,'2863584022'
,'6411225192'
,'8287180791'
,'1306245184'
,'5914969751'
,'7925898836'
,'2927830509'
,'4184844332'
,'3705750135'
,'8153860836'
,'5110389497'
,'3733539273') and s.stateid=51
	 and tc.contentareaid=443 and stg.name='Performance'
	 and not exists (select 1 from studentstestscore stc where stc.studenttestid=st.id ));

--Insert scores from https://kansas.sharepoint.com/:x:/r/teams/ats/_layouts/15/Doc.aspx?sourcedoc=%7B83e74b60-508b-4ba5-84df-145b874dc2ec%7D&action=default
INSERT INTO studentstestscore(
            studenttestid, taskvariantId, scorerid, score, nonscorereason, 
            rubriccategoryid, activeflag, source, createddate, createduser, 
            modifieddate, modifieduser)
select distinct 
 st.id studenttestid, 
 sr.taskvariantid taskvariantId,
 12   scorerid,
case when s.statestudentidentifier in ('3733207513','6411225192','8287180791') then 1
	when s.statestudentidentifier in ('5217835982','4102870296','3701141711','5914969751') then 2
	when s.statestudentidentifier in ('4472990628','7091138538','1306245184','5110389497','3733539273') then 3 
	when s.statestudentidentifier in ('1957373644','7925898836','2927830509','4184844332','8153860836') then 4
	else 0 end  score,
case when s.statestudentidentifier in ('2729257136','7523981348','8193783603','1156794323','2863584022','3705750135') then 643
	when s.statestudentidentifier in ('9895002335') then 644
	else null::int end nonscorereason, 
(select id from rubriccategory where taskvariantid =sr.taskvariantid) rubriccategoryid,
true  activeflag,'MANUAL' source,
now() createddate,
12 createduser, 
now() modifieddate,
12 modifieduser 
from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id and st.id=sr.studentstestsid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258)  
and s.statestudentidentifier in ('2729257136'
,'9895002335'
,'5217835982'
,'7523981348'
,'8193783603'
,'4472990628'
,'7091138538'
,'1156794323'
,'1957373644'
,'4102870296'
,'3701141711'
,'3733207513'
,'2863584022'
,'6411225192'
,'8287180791'
,'1306245184'
,'5914969751'
,'7925898836'
,'2927830509'
,'4184844332'
,'3705750135'
,'8153860836'
,'5110389497'
,'3733539273') and s.stateid=51
 and tc.contentareaid=443 and stg.name='Performance'
 and not exists (select 1 from studentstestscore stc where stc.studenttestid=st.id );


commit;

            