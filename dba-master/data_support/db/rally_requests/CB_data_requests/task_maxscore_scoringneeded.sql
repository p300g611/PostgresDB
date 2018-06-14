/*--     select distinct table_name from information_schema.columns where column_name ilike 'taskvariantid'   order by 1
-- example script



select * from cb.taskvariantrevision where taskvariantid=3990

select  t.tasktypeid,
        td.testdevelopmentid testid,
        td.name testname,
        td.publishedstatus,
        t.taskid,
        tv.taskvariantid,
	tv.name taskvariantname,
	tv.previoussource,
	tv.organizationid,
	tv.scoringmethod,
	tv.scoringdata,
	t.maxscore taskmaxscore,
	--tvr.taskvariantresponseid,
	 sum(case when tvr.correctresponse is true then 1 else 0 end) correctresponse,
	max(tvr.responsescore) responsescore,
	--tvr.responseorder,      
        tt.name ItemType,
        tst.name SubtaskTypeName,
        tc.name testcollectionname,
        tpt.name,
        tpt.programname 
from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   inner join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where      td.inuse is true
          and tds.inuse is true 
          and tdst.inuse is true 
          and tv.inuse is true 
          and t.inuse is true         
          and tc.inuse is true 
          and tpt.inuse is true 
          and o.name='KAP' and tpt.name='Interim' 
          and tv.name ilike '%10 Smart Routes to Bicycle Safety_Q%'
         -- and tv.scoringmethod is not null-- limit 1
  group by t.tasktypeid,td.testdevelopmentid ,
        td.name ,
        td.publishedstatus,
        tv.taskvariantid,
        t.taskid,
	tv.name ,
	tv.previoussource,
	tv.organizationid,
	tv.scoringmethod,
	tv.scoringdata,
	t.maxscore ,
        tt.name ,
        tst.name ,
        tc.name ,
        tpt.name,
        tpt.programname;
 





--1) validation correctresponse not set   count should be zero

select   distinct tv.taskid,tvr.taskvariantid
from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   left outer join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where o.name='KAP' and tpt.name='Interim' and tt.name='Multiple Choice - Keyed' 
    and tvr.correctresponse is true and tvr.responsescore =0;

----
select   distinct tv.taskid,tvr.taskvariantid
from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   left outer join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where o.name='KAP' and tpt.name='Interim' and tt.name='Multiple Choice - Keyed'
    and tvr.correctresponse is false and tvr.responsescore =1;

-- validation:max score is zero or grater than 1
select taskvariantid,correctresponse,responsescore from (
   select  t.tasktypeid,
        td.testdevelopmentid testid,
        td.name testname,
        td.publishedstatus,
        t.taskid,
        tv.taskvariantid,
	tv.name taskvariantname,
	tv.previoussource,
	tv.organizationid,
	tv.scoringmethod,
	tv.scoringdata,
	t.maxscore taskmaxscore,
	--tvr.taskvariantresponseid,
	 sum(case when tvr.correctresponse is true then 1 else 0 end) correctresponse,
	max(tvr.responsescore) responsescore,
	--tvr.responseorder,      
        tt.name ItemType,
        tst.name SubtaskTypeName,
        tc.name testcollectionname,
        tpt.name,
        tpt.programname
       -- select tvr.correctresponse,tv.taskvariantid,tvr.taskvariantresponseid
    from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid --and tv.taskvariantid=11421 
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   left outer join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where o.name='KAP' and tpt.name='Interim' and tt.name='Multiple Choice - Keyed'  and tdst.inuse is true -- should be true 
  group by t.tasktypeid,td.testdevelopmentid ,
        td.name ,
        td.publishedstatus,
        tv.taskvariantid,
        t.taskid,
	tv.name ,
	tv.previoussource,
	tv.organizationid,
	tv.scoringmethod,
	tv.scoringdata,
	t.maxscore ,
        tt.name ,
        tst.name ,
        tc.name ,
        tpt.name,
        tpt.programname) mscr
        where correctresponse=0 or responsescore =0 or responsescore>1 or correctresponse>1 ;


-- validation task max scroe not set
 select t.taskid,t.maxscore 
from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   left outer join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where o.name='KAP' and tpt.name='Interim' and tt.name='Multiple Choice - Keyed'
   and t.maxscore <>1 ;

 --2) only scring need set to true (existing true 6130, false 5972)

  --report 
  /*
select distinct t.taskid,t.scoringneeded ,t.maxscore into temp tmp_scoringneeded_task
from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   left outer join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where o.name='KAP' and tpt.name='Interim' and tt.name='Multiple Choice - Keyed'
   and t.scoringneeded is false or coalesce(t.maxscore,0)=0;

\copy (select * from tmp_scoringneeded_task) to 'tmp_scoringneeded_task.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
*/

begin;
update cb.task
set modifieduserid=10168,
 modifiedusername='Test middle Test',
 scoringneeded=true,
 modifieddate=now()
where taskid in (select distinct  t.taskid
from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   left outer join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where o.name='KAP' and tpt.name='Interim' and tt.name='Multiple Choice - Keyed'
   and t.scoringneeded is false);

update cb.task
set modifieduserid=10168,
 modifiedusername='Test middle Test',
 maxscore=1,
 modifieddate=now()
where taskid in (select distinct  t.taskid
from cb.testdevelopment  td
   inner join organization_ o on o.organizationid=td.organizationid
   inner join cb.testdevelopmenttestsection tds on tds.testdevelopmentid=td.testdevelopmentid
   inner join cb.testdevelopmentsectiontask tdst on tds.testdevelopmenttestsectionid=tdst.testdevelopmenttestsectionid
   inner join cb.taskvariant tv on tv.taskvariantid=tdst.taskvariantid and o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid and tst.inuse is true
   left outer join cb.testcollection tc on tc.testcollectionid=td.testcollectionid and o.organizationid=tc.organizationid
   left outer Join cb.testingprogram tpt on tpt.testingprogramid=t.testingprogramid and o.organizationid=tpt.organizationid
   where o.name='KAP' and tpt.name='Interim' and tt.name='Multiple Choice - Keyed'
   and coalesce(t.maxscore,0)=0);
commit; 





