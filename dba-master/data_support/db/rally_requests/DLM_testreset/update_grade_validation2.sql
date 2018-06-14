--validation2: Grade in enrollment table does not match grade on test table
--Function: updategradevalidation2 (bigint,bigint,bigint);
--DROP FUNCTION updategradevalidation2(bigint,bigint,bigint;
create or replace function updategradevalidation2(out_schoolyear bigint,out_studentid bigint,out_ticket bigint) 
returns text as 
$BODY$

declare 
	     dba_id int;
	     in_studentstest record;
         cnt_number int;
	     row_num int;
         update_number int;
	     error_msg text; 
begin
         error_msg:='';
         cnt_number:=0;
         row_num:=0;
         update_number:=0;
         Raise INFO 'Process studentid:%',out_studentid;
         select into dba_id (select id from aartuser where email='ats_dba_team@ku.edu');

        select count(distinct stu.id) into row_num 
        from student stu 
	    join enrollment en on en.studentid=stu.id 
	    join organizationtreedetail org on org.schoolid =en.attendanceschoolid
        where stu.id=out_studentid and stu.activeflag is true and en.activeflag is true and en.currentschoolyear=out_schoolyear;
    if (row_num=0) then 
       error_msg:='<error> the student does not exist for id:'||out_studentid;
	 else   
	  FOR in_studentstest in (select distinct st.id stid, ts.id tsid, eg.abbreviatedname engrade, tg.abbreviatedname tggrade,sts.id stsid,
                              sr.studentstestsid,iti.id itiid,strb.id strbid 
                              from enrollment en 
                              join gradecourse  eg on eg.id=en.currentgradelevel
                              join studentstests st on st.enrollmentid =en.id 
                              join test  t on t.id =st.testid
                              join gradecourse tg on tg.id=t.gradecourseid								  
                              join testsession ts on ts.id =st.testsessionid
                              join studentstestsections  sts on sts.studentstestid =st.id
							  join testcollection tc on tc.id=st.testcollectionid
                              left outer join studentsresponses sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
                              left outer join ititestsessionhistory iti on iti.studentid=st.studentid and iti.testsessionid=ts.id
                              left outer join studenttrackerband strb on  strb.testsessionid = ts.id 
                              where en.currentschoolyear=out_schoolyear and en.studentid =out_studentid and en.activeflag is true
                                    and eg.abbreviatedname<>tg.abbreviatedname and tg.abbreviatedname <>'OTH'
									) loop 
			RAISE INFO 'Corrent grade:%,deactiviate grade:%,studenttestid:%,testsessionid:%,studenttestsectionid:%,ititestsessionhistoryid:%,studenttrackerband:%',
                        in_studentstest.engrade,in_studentstest.tggrade,in_studentstest.stid,in_studentstest.tsid,in_studentstest.stsid,
                        in_studentstest.itiid,in_studentstest.strbid;	
						
            with tmp_rows_update as (           			   
			update  studentstests
                set activeflag =false,
                    modifieddate=now(),
	                manualupdatereason='for ticket #'||out_ticket::text, 
	                modifieduser =dba_id
					where id =in_studentstest.stid and studentid=out_studentid and activeflag is true
                    returning 1)
                    select count(*) into update_number from tmp_rows_update;
            RAISE INFO 'studentstests deactiviate:%',update_number; 
			
			cnt_number :=cnt_number+update_number;	
			
			with tmp_rows_update as(		
			update studentstestsections
                set activeflag =false,
                    modifieddate=now(),
	                modifieduser =dba_id
                    where id =in_studentstest.stsid and activeflag is true
                    returning 1)
                    select count(*) into update_number from tmp_rows_update;
            RAISE INFO 'studentstestsections deactiviate:%',update_number;
						
			with tmp_rows_update as (		
            update  testsession
            set     activeflag =false,
                    modifieddate=now(),
	                modifieduser =dba_id
                    where id=in_studentstest.tsid and activeflag is true
                    returning 1)
                    select count(*) into update_number from tmp_rows_update;
            RAISE INFO 'testsession deactiviate:%',update_number;
			        				
            IF   (in_studentstest.studentstestsid is not null) then                 
                with tmp_rows_update as (
                  update studentsresponses 
                  set  activeflag =false, 
                       modifieddate=now(),
	                   modifieduser =dba_id
                       where studentid = out_studentid and studentstestsid	=in_studentstest.stid and activeflag is true
                       returning 1)
                       select count(*) into update_number from tmp_rows_update;
            RAISE INFO 'Deactiviate studentsresponses:%',update_number;
            END IF;

            IF 	(in_studentstest.itiid is not null)  then
            with tmp_rows_update as (
                 update ititestsessionhistory
                     set activeflag =false, 
                         modifieddate=now(),
	                     modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
                         where id= in_studentstest.itiid and activeflag is true
                         returning 1)
                         select count(*) into update_number from tmp_rows_update;
            RAISE INFO 'Deactiviate ititestsessionhistory:%',update_number;
            END IF;
			
            IF 	(in_studentstest.strbid is not null) then
            with tmp_rows_update as (
                 update studenttrackerband
                     set activeflag =false, 
                         modifieddate=now(),
	                     modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
                         where  id =in_studentstest.strbid and testsessionid=in_studentstest.tsid and activeflag is true
                         returning 1)
                         select count(*) into update_number from tmp_rows_update;
            
            RAISE INFO 'Deactiviate studenttrakerband:%',update_number;
            END IF;			
        END LOOP;
		error_msg:='<sucess>update total number of studentstests '||cnt_number;
     END IF;
      RETURN error_msg;
  END; 
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION updategradevalidation2 (bigint,bigint,bigint) owner to aart;