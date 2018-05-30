DROP TABLE if exists public.testchangetracking;

--1. Table script to track the content changed and republished items 
CREATE TABLE public.testchangetracking
( id BIGSERIAL not null,
  testidold bigint not null, 
  testidnew bigint not null, 
  taskvariantidold bigint not null,
  taskvariantidnew bigint not null, 
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
  CONSTRAINT testchangetracking_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.testchangetracking OWNER TO aart;


INSERT INTO public.testchangetracking(testidold, testidnew, taskvariantidold, taskvariantidnew,createddate, 
                createduser, activeflag, modifieddate, modifieduser,status,reason)
select 1 testidold, 1 testidnew, 10 taskvariantidold, 10 taskvariantidnew,
                now() createddate, (select id from aartuser where email='cete@ku.edu') createduser,true activeflag,
                now() modifieddate,(select id from aartuser where email='cete@ku.edu') modifieduser,'inprogress' status,'Testing testchangetracking'reason ;


select * from testchangetracking;
--questions 
--1. is possible items change on same tests id - I guess not 
--2. one item or all items need to insert into table because for insert


DROP FUNCTION if exists public.assignedtestchangeprocess();

CREATE OR REPLACE FUNCTION public.assignedtestchangeprocess()
  RETURNS text AS
$BODY$
DECLARE
	tmp_stdtest record;
	row_count bigint;
	update_count bigint;
	new_roster_id bigint;
	new_enrollroster_id bigint;
	new_enroll_id bigint;
	new_school_id bigint;
BEGIN 
     row_count:=0;
     update_count:=0;
     --Validation process 
	-- 1.    Build the tracking table to find the Items or tests need change and how many students tests impacted.
	-- 2.    Validated the tests max score, scoring method and scoring need flag 
	-- 3.    Validated test collection to make sure same test collection in before and after 
	-- 4.    Build the new test session if test session ties to old test.
	-- 5.    Update the students tests related  information related to old tests or items only for unused students tests.
	-- 6.    Clear the tests Json data.


      select id from studentstests  where testid=1;

     RAISE INFO 'Processing Studentid:%,Subject:%',var_studentid,var_subjectid;
	        select count(distinct er.id) into row_count
		from enrollment e
		inner join enrollmentsrosters er on er.enrollmentid=e.id 
		inner join roster r on r.id=er.rosterid
		where studentid=var_studentid and r.statesubjectareaid=var_subjectid and e.currentschoolyear=var_schoolyear
		and e.activeflag is true and er.activeflag and r.activeflag is true;
		
   if (row_count>1) then 
     RAISE INFO 'Duplicate active rosters for Studentid:%,Subject:%',var_studentid,var_subjectid;
   else 		
		select er.enrollmentid,er.id,er.rosterid,e.attendanceschoolid into new_enroll_id,new_enrollroster_id,new_roster_id,new_school_id
		from enrollment e
		inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=var_schoolyear
		inner join roster r on r.id=er.rosterid
		where studentid=var_studentid and r.statesubjectareaid=var_subjectid and e.currentschoolyear=var_schoolyear
		and e.activeflag is true and er.activeflag and r.activeflag is true;
     RAISE INFO 'Active enrollmentid:%,enrollmentsrosters:%,rosterid:%,attendanceschoolid:%',new_enroll_id,new_enrollroster_id,new_roster_id,new_school_id;
     RAISE INFO 'Before update studentstestsid,enrollmentid,testsession,attendanceschoolid,ts_rosterid,ititestsessionhistoryid,iti_rosterid,iti_erollrosterid';
    for tmp_stdtest in (select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,ts.attendanceschoolid,its.id itsid,its.rosterid,its.studentenrlrosterid
		from studentstests st 
		inner join testsession ts on ts.id=st.testsessionid 
		inner join testcollection tc on tc.id=ts.testcollectionid
		left outer join ititestsessionhistory its on its.testsessionid=ts.id
		where st.studentid=var_studentid and tc.contentareaid=var_subjectid and ts.schoolyear=var_schoolyear)
     loop         
        RAISE INFO 'Before update %,%,%,%,%,%,%,%'
                   ,tmp_stdtest.stid,tmp_stdtest.enrollmentid,tmp_stdtest.tsid,tmp_stdtest.attendanceschoolid,tmp_stdtest.rosterid,tmp_stdtest.itsid,tmp_stdtest.rosterid,tmp_stdtest.studentenrlrosterid;
     end loop;	



	WITH tmp_rows_updated AS (
	  update testsession 
	set    rosterid =new_roster_id,
	       modifieddate =now(),
	       modifieduser =174744,
	       attendanceschoolid=new_school_id
	where id in (select st.testsessionid from studentstests st 
			inner join testsession ts on ts.id=st.testsessionid 
			inner join testcollection tc on tc.id=ts.testcollectionid
			where st.studentid=var_studentid and tc.contentareaid=var_subjectid and ts.schoolyear=var_schoolyear) and rosterid<>new_roster_id
	    RETURNING 1
	)
	SELECT count(*) into update_count FROM tmp_rows_updated;
	     RAISE INFO 'testsession updated:%',update_count;

	WITH tmp_rows_updated AS (
		update ititestsessionhistory
		set    rosterid=new_roster_id,
		       studentenrlrosterid=new_enrollroster_id,
		       modifieddate =now(),
		       modifieduser =174744
	where testsessionid in (select st.testsessionid from studentstests st 
			inner join testsession ts on ts.id=st.testsessionid 
			inner join testcollection tc on tc.id=ts.testcollectionid
			where st.studentid=var_studentid and tc.contentareaid=var_subjectid and ts.schoolyear=var_schoolyear) and rosterid<>new_roster_id
	    RETURNING 1
	)
	SELECT count(*) into update_count FROM tmp_rows_updated;
	     RAISE INFO 'ititestsessionhistory updated:%',update_count;


	WITH tmp_rows_updated AS (
	        update studentstests 
		set    enrollmentid = new_enroll_id,
		       modifieddate =now(),
		       modifieduser =174744,
		       manualupdatereason='Ticket Number#'||var_studentid
	where id in (select st.id from studentstests st 
			inner join testsession ts on ts.id=st.testsessionid 
			inner join testcollection tc on tc.id=ts.testcollectionid
			where st.studentid=var_studentid and tc.contentareaid=var_subjectid and ts.schoolyear=var_schoolyear) and enrollmentid<>new_enroll_id
	    RETURNING 1
	)
	SELECT count(*) into update_count FROM tmp_rows_updated;
	     RAISE INFO 'studentstests updated:%',update_count;
     	
END IF;
return 'SUCCESS';
--select assignedtestchangeprocess(2018,165063,440,'ticket#');
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.assignedtestchangeprocess() OWNER TO aart;