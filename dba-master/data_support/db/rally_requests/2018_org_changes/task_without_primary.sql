/*
Need your help to prepare a query to find the tasks which is not having any primary. Note that a task can be shared across multiple orgs.
 Primary column is available in taskcontentframeworkdetails table.
*/
with tmp_count as(select tcf.taskid,tcf.organizationid,count(distinct tcf.isprimary)
 from cb.taskcontentframeworkdetails tcf
inner join cb.contentframeworkdetail cfd on cfd.contentframeworkdetailid = tcf.contentframeworkdetailid
inner join cb.contentframework cf on cf.contentframeworkid = cfd.contentframeworkid
inner join cb.task tk on tk.taskid =tcf.taskid --and tk.organizationid=tcf.organizationid
inner join cb.tasktype ty on ty.tasktypeid=tk.tasktypeid
where tk.inuse ='t'
group by tcf.taskid,tcf.organizationid
having count(distinct tcf.isprimary)=1)
select distinct tcf.taskid, tcf.organizationid,tcf.isprimary, tk.taskid,tk.organizationid
from tmp_count tmp
inner join cb.taskcontentframeworkdetails tcf on tcf.taskid = tmp.taskid and tmp.organizationid=tcf.organizationid
inner join cb.task tk on tk.taskid =tcf.taskid 
where tcf.isprimary ='f';




