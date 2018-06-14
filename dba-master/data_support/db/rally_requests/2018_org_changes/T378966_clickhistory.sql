

select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid,sts.id from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.id=901868
order by 2;



select distinct sr.studentstestsectionsid,taskvariantid,foilid,score,sr.modifieddate,sr.response from studentstests st
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
left outer join studentsresponses sr on sr.studentstestsid=st.id
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and st.studentid=901868 and st.id=21098652
 order by sr.modifieddate;


aws s3 ls s3://kite-clickhistory-prod/ | grep "2018-04-04" | awk '{print $4}' >>tde04042018.out
cat  tde04042018.out | grep 901868


cp s3://kite-clickhistory-prod/15fzbri-901868-32489381-click.json   s3://kite-sqlite-extracts/tmp/test/helpdesk/


with tmp_response as (
SELECT studentid, studentstestid,studentstestsectionsid, task.id taskid,task.responses,filename
from tdeclickhistory_helpdesk 
cross join unnest (tdeclickhistory_helpdesk.tasks) as t1(task)
--where task.responses is not null
where studentid=901868 and studentstestid=21098652
)
select studentid,studentstestid, studentstestsectionsid,taskid,respond.responseoption,respond.isCorrectResponse,respond.ts,respond.score,filename
from tmp_response 
cross join unnest(tmp_response.responses) as t2(respond)
where respond.responseoption is not null-- and studentid=481569 and studentstestsectionsid=24701622 and taskid=378250
order by studentid, taskid;


--http://www.convertcsv.com/json-to-csv.htm