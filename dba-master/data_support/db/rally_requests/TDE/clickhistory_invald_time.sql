with tmp_response as (
SELECT assessmentprogramid,studentid,studentstestid, studentstestsectionsid,task.buttons,task.ts task_time,filename
from tdeclickhistory 
cross join unnest (tdeclickhistory.tasks) as t1(task)
)
select distinct assessmentprogramid,studentid,studentstestid, studentstestsectionsid,task_time,button.ts button_time,filename
from tmp_response 
cross join unnest(tmp_response.buttons) as t2(button)
where task_time like '%Invalid Date%' or button.ts like '%Invalid Date%' ;