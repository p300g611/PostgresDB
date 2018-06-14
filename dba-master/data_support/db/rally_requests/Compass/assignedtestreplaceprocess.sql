--DROP TABLE if exists public.testreplacetracking;
CREATE TABLE if not exists public.testreplacetracking
( id BIGSERIAL not null,
  testidold bigint not null, 
  testidnew bigint not null, 
  createddate timestamp with time zone DEFAULT ('now'::text)::timestamp with time zone,
  createduser integer NOT NULL,
  activeflag boolean DEFAULT true,
  modifieddate timestamp with time zone DEFAULT ('now'::text)::timestamp with time zone,
  modifieduser integer NOT NULL,
  processeddate timestamp with time zone,
  processerror text,
  status text,
  studentstestsids text,
  reason character varying(250),
  CONSTRAINT testreplacetracking_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.testreplacetracking OWNER TO aart;

CREATE OR REPLACE FUNCTION public.assignedtestreplaceprocess()
  RETURNS text AS
$BODY$
DECLARE
	tmp_testreplacetracking_rows record;
	tmp_testcollections_rows  record;
	tmp_testsessions_id  record;
	tmp_testsessions_rows record;
	tmp_studentstests_id record;
	tmp_studentstests_rows record;
	tmp_testsection_ids record;
	tmp_studenttrackerband_rows record;
	var_STUDENT_TEST_STATUS bigint;
	var_SSTUDENT_TESTSECTION_STATUS bigint;
	var_testsessions_id_seq bigint;
	var_studentstests_id_seq bigint;
	var_studentstests_ids_updated text;
	var_now timestamp with time zone;
	var_user bigint ;
	row_count bigint ;
BEGIN 
     var_studentstests_ids_updated:='';
     select id into var_user from aartuser where username='cetesysadmin';
     select now() into var_now;
     select c.id into var_STUDENT_TEST_STATUS  from category c inner join categorytype ct on ct.id=c.categorytypeid where ct.typecode='STUDENT_TEST_STATUS' and categorycode='unused';
     select c.id into var_SSTUDENT_TESTSECTION_STATUS  from category c inner join categorytype ct on ct.id=c.categorytypeid where ct.typecode='STUDENT_TESTSECTION_STATUS' and categorycode='unused';
	-- 1.  Build a tracking table to find the tests that need a change, and to capture how many student tests were impacted.
	-- 2.  Validate test collection to make sure the same test collection is in before and after the change.
	-- 3.  Inactivate unused student tests and student test sections and test session if the session is related to an old test id.
	-- 4.  Re-assign student tests, student test section, and test session (if session has testid).
	-- 5.  If an old test session record has studenttrackerband inactivate the old record and re-assign the new student tracker band with the new test session id.
for tmp_testreplacetracking_rows in (select testidold,testidnew from testreplacetracking where status='inprogress')
  loop     
	select tmp_testreplacetracking_rows.testidold testsidold,tmp_testreplacetracking_rows.testidnew testidnew,
	       'Mismatch test collection for Old testid:'|| tmp_testreplacetracking_rows.testidold||' collection externalids:'||array_to_string(ARRAY_AGG(distinct coalesce(old.externalid,0)),',')
	         ||' New testid:'||tmp_testreplacetracking_rows.testidnew||' collection externalids:'||array_to_string(ARRAY_AGG(distinct coalesce(new.externalid,0)),',') errormsg
	       into tmp_testcollections_rows from (select tc.externalid,tct.testid from testcollectionstests tct 
					        inner join testcollection tc on tct.testcollectionid=tc.id
					        where tct.testid=tmp_testreplacetracking_rows.testidold union all select 0,0) old
				         full outer join (select tc.externalid,tmp_testreplacetracking_rows.testidold testid_old  from testcollectionstests tct 
				               inner join testcollection tc on tct.testcollectionid=tc.id
	                                       where tct.testid=tmp_testreplacetracking_rows.testidnew union all select 0,0) new on new.testid_old=old.testid
	     where coalesce(new.externalid,0)<>coalesce(old.externalid,0)
	     group by tmp_testreplacetracking_rows.testidold,tmp_testreplacetracking_rows.testidnew;        

             select count(*) into row_count FROM  testsection ts WHERE testid=tmp_testreplacetracking_rows.testidnew;
       
  if (length(tmp_testcollections_rows.errormsg)>0 or row_count=0) 
  then  
         if (length(tmp_testcollections_rows.errormsg)>0 ) then 
         RAISE INFO 'Error Message %',tmp_testcollections_rows.errormsg;
         update testreplacetracking 
         set modifieddate =var_now,modifieduser=var_user,status='failed',processerror=tmp_testcollections_rows.errormsg
         where  status='inprogress' and testidold=tmp_testreplacetracking_rows.testidold and testidnew=tmp_testreplacetracking_rows.testidnew;
         end if;
         if (row_count=0) then 
         RAISE INFO 'Error Message testsection are missing for testid:%',tmp_testreplacetracking_rows.testidnew;
         update testreplacetracking 
         set modifieddate =var_now,modifieduser=var_user,status='failed',processerror=coalesce(tmp_testcollections_rows.errormsg,'')||'testsection are missing for new testid'
         where  status in ('inprogress','failed') and testidold=tmp_testreplacetracking_rows.testidold and testidnew=tmp_testreplacetracking_rows.testidnew;
         end if; 

  else 
  RAISE INFO 'Testreplacetracking processing for testid:%',tmp_testreplacetracking_rows.testidnew;
  for tmp_testsessions_id in (select distinct ts.id testsessionid from studentstests  st 
                              inner join testsession ts on st.testsessionid=ts.id and st.activeflag is true and ts.activeflag is true
                              inner join operationaltestwindow otw on otw.id = ts.operationaltestwindowid 
			      AND ((otw.effectivedate <= CURRENT_TIMESTAMP AND otw.expirydate >= CURRENT_TIMESTAMP AND otw.suspendwindow IS false) 
			      OR (otw.effectivedate <= CURRENT_TIMESTAMP AND ts.windowexpirydate >= CURRENT_TIMESTAMP))
			      where st.status=var_STUDENT_TEST_STATUS and st.testid= tmp_testreplacetracking_rows.testidold)
    loop   
        var_testsessions_id_seq:=null;  
        if ( (select count(1) from testsession ts where ts.id=tmp_testsessions_id.testsessionid and coalesce(ts.testid,0)=tmp_testreplacetracking_rows.testidold)>0) then 
        select ts.*  into tmp_testsessions_rows from  testsession ts where ts.id=tmp_testsessions_id.testsessionid and coalesce(ts.testid,0)=tmp_testreplacetracking_rows.testidold; 
        RAISE INFO 'Building testsessions for Testid:%',tmp_testreplacetracking_rows.testidnew;
         INSERT INTO public.testsession(rosterid, name, status, createddate, createduser, activeflag,modifieduser, modifieddate, testid, testcollectionid, source, 
				    attendanceschoolid, operationaltestwindowid, testtypeid, gradecourseid,stageid, windowexpirydate, schoolyear, testpanelid,
				    subjectareaid, windoweffectivedate, windowstartdate, windowstarttime, windowendtime,suspend)
          VALUES (tmp_testsessions_rows.rosterid, tmp_testsessions_rows.name, tmp_testsessions_rows.status,var_now,var_user,true,var_user,var_now ,tmp_testreplacetracking_rows.testidnew, tmp_testsessions_rows.testcollectionid, tmp_testsessions_rows.source, 
				    tmp_testsessions_rows.attendanceschoolid, tmp_testsessions_rows.operationaltestwindowid, tmp_testsessions_rows.testtypeid, tmp_testsessions_rows.gradecourseid,tmp_testsessions_rows.stageid, tmp_testsessions_rows.windowexpirydate, tmp_testsessions_rows.schoolyear, tmp_testsessions_rows.testpanelid,
				    tmp_testsessions_rows.subjectareaid, tmp_testsessions_rows.windoweffectivedate, tmp_testsessions_rows.windowstartdate, tmp_testsessions_rows.windowstarttime, tmp_testsessions_rows.windowendtime,tmp_testsessions_rows.suspend)
				    RETURNING id INTO var_testsessions_id_seq;
				    RAISE INFO 'Testsessions inserted recordid:%',var_testsessions_id_seq; 
         
	   if ((select count(*) from information_schema.tables where table_name='studenttrackerband')>0) then 			     
            for tmp_studenttrackerband_rows in (select stb.* from  studenttrackerband stb 
                           inner join testsession ts on ts.id=stb.testsessionid and ts.activeflag and stb.activeflag is true 
                           where ts.id=tmp_testsessions_id.testsessionid and coalesce(ts.testid,0)=tmp_testreplacetracking_rows.testidold order by stb.id desc limit 1)
             loop  
             update studenttrackerband set activeflag= false, modifieduser=var_user, modifieddate=var_now
             where id=tmp_studenttrackerband_rows.id;                             
             INSERT INTO public.studenttrackerband(studenttrackerid, complexitybandid, testsessionid, source,activeflag, createddate, createduser, modifieddate, modifieduser, 
                                              essentialelementid, operationalwindowid)	
             values( tmp_studenttrackerband_rows.studenttrackerid, tmp_studenttrackerband_rows.complexitybandid, var_testsessions_id_seq, tmp_studenttrackerband_rows.source,true, var_now, var_user, var_now, var_user, 
                                              tmp_studenttrackerband_rows.essentialelementid, tmp_studenttrackerband_rows.operationalwindowid );
             end loop;    
           end if;

          update testsession set activeflag= false, modifieduser=var_user, modifieddate=var_now
          where id=tmp_testsessions_id.testsessionid; 
                 			    
        end if;         			    
        for tmp_studentstests_id in (select distinct st.id studentstestsid from studentstests  st 
                              inner join testsession ts on st.testsessionid=ts.id and st.activeflag is true and ts.activeflag is true
                              inner join operationaltestwindow otw on otw.id = ts.operationaltestwindowid 
	                      AND ((otw.effectivedate <= CURRENT_TIMESTAMP AND otw.expirydate >= CURRENT_TIMESTAMP AND otw.suspendwindow IS false) 
			      OR (otw.effectivedate <= CURRENT_TIMESTAMP AND ts.windowexpirydate >= CURRENT_TIMESTAMP))
			      where st.status=var_STUDENT_TEST_STATUS and st.testid=tmp_testreplacetracking_rows.testidold and st.testsessionid=tmp_testsessions_id.testsessionid)
                loop                
		var_studentstests_ids_updated:=var_studentstests_ids_updated||tmp_studentstests_id.studentstestsid||',';
                update studentstests set activeflag= false, modifieduser=var_user, modifieddate=var_now,manualupdatereason=coalesce(manualupdatereason,'')||'ASSIGNEDTESTREPLACEPROCESS'
                where id=tmp_studentstests_id.studentstestsid;
                                
                update studentstestsections set activeflag= false, modifieduser=var_user, modifieddate=var_now,manualupdatereason=coalesce(manualupdatereason,'')||'ASSIGNEDTESTREPLACEPROCESS'
                where studentstestid=tmp_studentstests_id.studentstestsid;
                RAISE INFO 'Studentstests id inactivated:%',tmp_studentstests_id.studentstestsid;
                
                select st.* into tmp_studentstests_rows from studentstests st where st.id=tmp_studentstests_id.studentstestsid ;
		INSERT INTO public.studentstests(studentid, testid, testcollectionid, status, testsessionid,createddate, createduser, activeflag, modifieduser, modifieddate,
			    ticketno,  scores, enrollmentid, finalbandid,enhancednotes, completionreason, interimtheta, previousstudentstestid, 
			     totalrawscore, scoringassignmentid, transferedtestsessionid,transferedenrollmentid, currenttestnumber, numberoftestsrequired			     
		,meta, proctoremail, proctorname, proctorlocation --Uncomment this line for Compass
			     )
	        values (tmp_studentstests_rows.studentid, tmp_testreplacetracking_rows.testidnew, tmp_studentstests_rows.testcollectionid, var_STUDENT_TEST_STATUS, coalesce(var_testsessions_id_seq,tmp_testsessions_id.testsessionid),var_now, var_user, true, var_user, var_now,
			    tmp_studentstests_rows.ticketno,  tmp_studentstests_rows.scores, tmp_studentstests_rows.enrollmentid, tmp_studentstests_rows.finalbandid,tmp_studentstests_rows.enhancednotes, tmp_studentstests_rows.completionreason,
			    tmp_studentstests_rows.interimtheta, tmp_studentstests_rows.previousstudentstestid, tmp_studentstests_rows.totalrawscore, tmp_studentstests_rows.scoringassignmentid, tmp_studentstests_rows.transferedtestsessionid,tmp_studentstests_rows.transferedenrollmentid, tmp_studentstests_rows.currenttestnumber, tmp_studentstests_rows.numberoftestsrequired
		,tmp_studentstests_rows.meta, tmp_studentstests_rows.proctoremail, tmp_studentstests_rows.proctorname, tmp_studentstests_rows.proctorlocation --Uncomment this line for Compass
			    ) RETURNING id INTO var_studentstests_id_seq;	    
                        RAISE INFO 'Studentstests inserted recordid:%',var_studentstests_id_seq;
                     
			for tmp_testsection_ids in (select id FROM  testsection ts WHERE testid=tmp_testreplacetracking_rows.testidnew )
			 loop 
			 INSERT INTO public.studentstestsections(studentstestid, testsectionid, statusid, lastnavqnum, createddate, modifieddate, createduser, modifieduser, activeflag)
			 select var_studentstests_id_seq,tmp_testsection_ids.id,var_SSTUDENT_TESTSECTION_STATUS,0,var_now,var_now,var_user,var_user,true;
			 end loop;
        
               end loop;       
   end loop; 
   update testreplacetracking 
   set modifieddate =var_now,modifieduser=var_user,status='complete',studentstestsids=RTRIM(var_studentstests_ids_updated,',')
   where  status='inprogress' and testidold=tmp_testreplacetracking_rows.testidold and testidnew=tmp_testreplacetracking_rows.testidnew;
   var_studentstests_ids_updated:='';
-- begin;
-- select public.assignedtestreplaceprocess();
-- select * from testsession order by 1 desc limit 10;
-- select * from testreplacetracking where status<>'complete'; 
-- INSERT INTO public.testreplacetracking(testidold, testidnew, createddate,createduser, activeflag, modifieddate, modifieduser,status,reason)
-- select distinct st.testid testidold, (select max(id) from test tinn where tinn.externalid=t.externalid) testidnew,
--        now() createddate, (select id from aartuser where username='cetesysadmin') createduser,true activeflag,
--        now() modifieddate,(select id from aartuser where username='cetesysadmin') modifieduser,'inprogress' status,'Testing testreplacetracking'reason
--        from studentstests  st inner join testsession ts on st.testsessionid=ts.id and st.activeflag is true and ts.activeflag is true
--        inner join operationaltestwindow otw on otw.id = ts.operationaltestwindowid 
--        inner join test t on t.id=st.testid
-- 	AND ((otw.effectivedate <= CURRENT_TIMESTAMP AND otw.expirydate >= CURRENT_TIMESTAMP AND otw.suspendwindow IS false) 
-- 	OR (otw.effectivedate <= CURRENT_TIMESTAMP AND ts.windowexpirydate >= CURRENT_TIMESTAMP))
--   where st.status=84 and t.externalid in (22,25) and t.id<>(select max(id) from test tinn where tinn.externalid=t.externalid);
-- commit;
 end if;
 end loop; 
       
return 'SUCCESS';
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.assignedtestreplaceprocess() OWNER TO aart;

