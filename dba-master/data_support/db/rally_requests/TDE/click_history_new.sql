
--For a particular student/test, on how many items did a student change their answer.
-- From AWS 
with tmp_response as (
SELECT assessmentprogramid,studentid,studentstestid, studentstestsectionsid,task.id taskid,task.responses,filename
from tdeclickhistory 
cross join unnest (tdeclickhistory.tasks) as t1(task)
)
select assessmentprogramid,studentid,studentstestid, studentstestsectionsid,taskid, respond.responseoption
,LEAD (respond.responseoption, 1) OVER ( PARTITION BY studentstestsectionsid,taskid ORDER BY studentstestsectionsid,taskid,respond.ts) lead_responseoption
,respond.iscorrectresponse,respond.ts,filename 
from tmp_response 
cross join unnest(tmp_response.responses) as t2(respond)
where  respond.ts is not null and respond is not null
;
--  Move to postgres 
drop table if exists tmp_response;
create temp table tmp_response(assessmentprogramid bigint, studentid bigint,studentstestid bigint, studentstestsectionsid bigint,
 taskid bigint,responseoption text,lead_responseoption text,iscorrectresponse text,ts text,filename text);
\copy tmp_response from 'tmp.csv' DELIMITER ',' CSV HEADER;
--list all responses option
drop table if exists tmp_responseoption;
with tmp_click as (
select assessmentprogramid,tmp.studentid,tmp.studentstestid,tmp.studentstestsectionsid,tmp.taskid,responseoption,lead_responseoption,
row_number()over(partition by tmp.studentid,tmp.studentstestsectionsid,tmp.taskid order by tmp.ts) cnt_number,
LEAD (tmp.studentstestsectionsid, 1) OVER ( PARTITION BY tmp.studentstestsectionsid,tmp.taskid ORDER BY tmp.studentstestsectionsid,tmp.taskid,ts) lead_studentstestsectionid,
ts,iscorrectresponse,filename
--into temp tmp_newcount
from tmp_response tmp
	   inner join (select studentid,studentstestsectionsid,taskid,count(*)
	               from tmp_response 
				   group by studentid,studentstestsectionsid,taskid
				   having count(*)>1) sub on sub.studentid=tmp.studentid and sub.studentstestsectionsid=tmp.studentstestsectionsid
				                      and sub.taskid=tmp.taskid
									  order by studentid,studentstestsectionsid,taskid,ts asc)
select tmp.studentid,tmp.studentstestid,sts.id studentstestsectionsid,assessmentprogramid,t.id testid,
t.testname testname,taskid,
sum (case when code ='MC-MS' and coalesce(responseoption,'')<>coalesce(lead_responseoption,'') and lead_studentstestsectionid is not null then 1  
          when code <>'MC-MS' and responseoption is null and  lead_responseoption is not null and  lead_studentstestsectionid is not null then 1 
          when code <>'MC-MS' and responseoption is not null and  lead_responseoption is  null and  lead_studentstestsectionid is not null then 1 
          when code <>'MC-MS' and responseoption is not null and lead_responseoption is not null and lead_studentstestsectionid is not null then 1 
		  else 0 end) as click_cnt,
array_to_string(array_agg(responseoption),',') as reposeoption,
array_to_string(array_agg(distinct filename),',') as filename
into temp tmp_responseoption
from tmp_click tmp
       inner join taskvariant tv on tv.id =tmp.taskid 
       inner join tasktype ty on ty.id =  tv.tasktypeid
	   inner join studentstestsections sts on sts.id = tmp.studentstestsectionsid
	   inner join testsection ts on ts.id =sts.testsectionid
	   inner join test t on t.id =ts.testid
group by tmp.studentid,tmp.studentstestid,sts.id,assessmentprogramid,taskid,code,t.id,t.testname
order by studentid,studentstestsectionsid,assessmentprogramid,taskid;

\copy (select * from tmp_responseoption) to 'tmp_responsoption.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



--For a particular item, how many times did students change their answers
--download from aws and save with 'tmp_response.csv'
with tmp_response as (
SELECT studentid, studentstestsectionsid, task.id taskid,task.responses
from tdeclickhistory 
cross join unnest (tdeclickhistory.tasks) as t1(task)
where task.responses is not null
--where studentid=1415396 and studentstestsectionsid=29284643
)
select studentid, studentstestsectionsid,taskid,respond.responseoption,respond.isCorrectResponse,respond.ts
from tmp_response 
cross join unnest(tmp_response.responses) as t2(respond)
where respond.responseoption is not null-- and studentid=481569 and studentstestsectionsid=24701622 and taskid=378250
order by studentid, taskid;

drop table if exists tmp_response;
create temp table tmp_response( student_id bigint, studentstestsection_id bigint,task_id bigint,response_option text,is_correct text,response_time text);--,res_option text);
\copy tmp_response from 'tmp_response.csv' DELIMITER ',' CSV HEADER;


--add two column to count response number
with tmp_multiple as (
select student_id, studentstestsection_id,response_option,task_id,response_time
,LEAD (tmp.response_option, 1) OVER ( PARTITION BY studentstestsection_id,task_id ORDER BY studentstestsection_id,task_id) orders
from tmp_response  tmp 
inner join taskvariant tv on tv.id =tmp.task_id 
inner join tasktype ty on ty.id =  tv.tasktypeid
where code = 'MC-MS')
select student_id, studentstestsection_id,response_option,task_id,orders,
(SELECT COUNT(*)+1  FROM regexp_matches(response_option, ',', 'g')) as option_cnt,
(SELECT COUNT(*)+1  FROM regexp_matches(orders, ',', 'g')) as order_cnt
into temp tmp_multiplevalue
from tmp_multiple;
with tmp_count as (
    select task_id, tv.externalid, taskname,
	    case  when code in ('CR','ER','MP') and  no_ofoption_dis <>1then no_ofoption_dis-1	
          when 	no_ofoption_dis =1 then 0
		  else no_ofclick-1 end  no_ofchangeanswer
       from tmp_option tmp
       inner join taskvariant tv on tv.id=tmp.task_id
       inner join tasktype ty on ty.id= tv.tasktypeid
       where code <> 'MC-MS'
  union all
   select task_id, tv.externalid, taskname,
     case when   order_cnt-option_cnt >0 then order_cnt-option_cnt
	     else 0 end no_ofchangeanswer
    from tmp_multiplevalue tmp
    inner join taskvariant tv on tv.id=tmp.task_id
    inner join tasktype ty on ty.id= tv.tasktypeid
    where code = 'MC-MS')
select task_id, externalid,taskname, sum(no_ofchangeanswer) as no_ofchangeanswer
into temp tmp_answerchange
    from tmp_count
    where no_ofchangeanswer>0
    group by task_id, externalid,taskname
    order by task_id;
\copy (select * from tmp_answerchange) to 'tmp_noofanswerchange.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



