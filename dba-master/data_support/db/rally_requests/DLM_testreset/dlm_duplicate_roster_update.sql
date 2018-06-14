-- DROP FUNCTION dlm_duplicate_roster_update(bigint, bigint,bigint,text);

CREATE OR REPLACE FUNCTION dlm_duplicate_roster_update(var_schoolyear bigint,var_studentid bigint,var_subjectid bigint,var_ticket text)
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
		--SELECT er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,er.modifieddate,r.coursesectionname, statesubjectareaid,teacherid,r.attendanceschoolid
		from enrollment e
		inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=var_schoolyear
		inner join roster r on r.id=er.rosterid
		where studentid=var_studentid and r.statesubjectareaid=var_subjectid and e.currentschoolyear=var_schoolyear
		and e.activeflag is true and er.activeflag and r.activeflag is true;
     RAISE INFO 'Active enrollmentid:%,enrollmentsrosters:%,rosterid:%,attendanceschoolid:%',new_enroll_id,new_enrollroster_id,new_roster_id,new_school_id;
     RAISE INFO 'Before update studentstestsid,enrollmentid,testsession,attendanceschoolid,ts_rosterid,ititestsessionhistoryid,iti_rosterid,iti_erollrosterid';
    for tmp_stdtest in (select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,ts.attendanceschoolid,its.id itsid,its.rosterid,its.studentenrlrosterid
                  --SELECT ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,ts.source,ts.attendanceschoolid
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

--validation 39
with dup as (
select e.studentid,r.statesubjectareaid,count(distinct r.id) from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id 
inner join studentassessmentprogram sap on sap.studentid=e.studentid and sap.assessmentprogramid=3 and sap.activeflag is true
inner join roster r on r.id=er.rosterid 
where e.studentid=var_studentid and e.currentschoolyear=var_schoolyear
group by e.studentid,r.statesubjectareaid
having count(distinct r.id)>1)
select count(distinct studentid) into row_count from (select st.studentid
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.schoolyear=var_schoolyear
inner join testcollection tc on tc.id=ts.testcollectionid
inner join enrollment e on st.studentid=e.studentid and e.currentschoolyear=var_schoolyear and e.activeflag is true 
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true 
inner join roster r on r.id=er.rosterid and r.activeflag is true 
where st.status in (86,494,679,681) and tc.contentareaid=r.statesubjectareaid 
and exists (select 1 from dup where dup.studentid=st.studentid) and 
 (st.enrollmentid<>e.id or er.rosterid<>ts.rosterid)) std;	     
     	RAISE INFO 'Validation39 for current student in all subjects count:%',row_count;
END IF;
return 'SUCCESS';
--select dlm_duplicate_roster_update(2018,165063,440,'ticket#');
END; $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
ALTER FUNCTION dlm_duplicate_roster_update(bigint, bigint,bigint,text) OWNER TO aart;

-- begin;
-- --select dlm_duplicate_roster_update(2018,165063,440,'ticket#');
-- 
-- rollback;

-- contentareaid,id,count
-- 3,165063,2
-- 3,853439,2
-- 440,165063,2
