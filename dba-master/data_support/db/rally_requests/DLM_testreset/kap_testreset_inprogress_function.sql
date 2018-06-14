--DROP FUNCTION kap_testreset_inprogress(bigint,bigint,bigint,int);
CREATE OR REPLACE FUNCTION kap_testreset_inprogress(out_year bigint,out_studentid bigint,out_subject bigint,out_ticket_number int)
    RETURNS text
                AS 
$BODY$
DECLARE 
   tmp_infstud record;
   in_enrollmentid bigint;
   in_studentstestid bigint;
   row_count bigint;
   update_count bigint;
BEGIN
   row_count:=0;
   update_count:=0;
   RAISE INFO 'Prepare reset test for studentid:%,subject:%',out_studentid,out_subject;
   select count(distinct e.id) into row_count 
   from enrollment e 
   join studentstests st on st.studentid=e.studentid
   where  e.currentschoolyear=out_year and e.studentid=out_studentid;

if row_count<>1 
   then
   RAISE INFO 'Please check the student enrollment information for studentid:%',out_studentid;
   else
FOR tmp_infstud in (
select distinct e.id eid, st.id stid,stg.code  
from enrollment e 
join studentstests st on st.studentid=e.studentid
join testsession ts on ts.id=st.testsessionid
join testcollection tc on tc.id =st.testcollectionid
join studentstestsections sts on sts.studentstestid=st.id
join stage stg on stg.id=tc.stageid
where e.currentschoolyear=out_year and e.studentid=out_studentid and tc.contentareaid=out_subject and e.activeflag is true 
and ts.operationaltestwindowid in (10261) and ts.source ='BATCHAUTO'and st.activeflag is true) Loop

    if tmp_infstud.code='Stg1'then
    RAISE INFO 'Prepare reset the student test for studentid:%,enrollmentid:%,studentstestid:%,stage:%,subject:%',out_studentid,tmp_infstud.eid,tmp_infstud.stid,tmp_infstud.code,out_subject;
      with tmp_rows_update as (
         update studentstests
         set    status =85, 
                modifieddate=now(),
                            manualupdatereason ='for ticket #'||out_ticket_number::text, 
                            modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
               where id = tmp_infstud.stid and studentid=out_studentid
       returning 1)
       select count(*) into update_count from tmp_rows_update;
       RAISE INFO 'stage:%,studentstests update:%',tmp_infstud.code,update_count;

       with tmp_rows_update as (
         update studentstestsections
         set    statusid =126,
                modifieddate=now(),
                            modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
              where studentstestid =tmp_infstud.stid
       returning 1)
       select count(*) into update_count from tmp_rows_update;
       RAISE INFO 'stage:%,studentstestsectin update:%',tmp_infstud.code,update_count;
    end if;


    if tmp_infstud.code='Stg2' then
    RAISE INFO 'Prepare reset the student test for studentid:%,enrollmentid:%,studentstestid:%,stage:%,subject:%',out_studentid,tmp_infstud.eid,tmp_infstud.stid,tmp_infstud.code,out_subject;
      with tmp_rows_update as (
        update studentstests
        set    activeflag =false, 
               modifieddate=now(),
                           manualupdatereason ='for ticket #'||out_ticket_number::text, 
                           modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
              where id = tmp_infstud.stid and studentid=out_studentid and activeflag =true
             returning 1 )
        select count(*) into update_count from tmp_rows_update;
      RAISE INFO 'stage:%,studentstests update:%',tmp_infstud.code,update_count; 


      with tmp_rows_update as (
         update studentstestsections
         set    activeflag =false,
                modifieddate=now(),
                            modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
               where studentstestid =tmp_infstud.stid and activeflag =true 
               returning 1)
           select count(*) into update_count from tmp_rows_update;
          RAISE INFO 'stage:%,studentstestsection update:%',tmp_infstud.code,update_count;

      with tmp_rows_update as (
         update studentsresponses
         set    activeflag =false,
                modifieddate=now(),
                            modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
               where  studentstestsid  =tmp_infstud.stid and studentid =out_studentid and activeflag =true 
              returning 1)  
            select count(*) into update_count from tmp_rows_update;
            RAISE INFO 'stage:%,studentsresponse update:%',tmp_infstud.code,update_count; 
   END IF;
end loop;
END IF;

return  'success';

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION kap_testreset_inprogress (bigint, bigint, bigint, int) owner to aart;
