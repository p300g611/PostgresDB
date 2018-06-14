--Delete student tests for KELPA by operational test window

--Validation:
select operationaltestwindowid,createddate::date,modifieddate::date,count(*) from testsession
where operationaltestwindowid=10171 and schoolyear=2017
group by operationaltestwindowid,createddate::date,modifieddate::date;

select operationaltestwindowid,st.createddate::date,st.modifieddate::date,count(*),count(distinct st.studentid) from testsession ts
inner join studentstests st on st.testsessionid=ts.id
where operationaltestwindowid=10171 and schoolyear=2017
group by operationaltestwindowid,st.createddate::date,st.modifieddate::date;

select operationaltestwindowid,st.createddate::date,st.modifieddate::date,count(distinct sts.id),count(distinct st.studentid) from testsession ts
inner join studentstests st on st.testsessionid=ts.id
inner join studentstestsections sts
on st.id=sts.studentstestid
where operationaltestwindowid=10171 and schoolyear=2017
group by operationaltestwindowid,st.createddate::date,st.modifieddate::date;


-- Method:1
begin;

drop table if exists tmp_ts;
select ts.id testsessionid,st.id studentstestsid into temp tmp_ts
from testsession ts
inner join studentstests st on st.testsessionid=ts.id
where operationaltestwindowid=10171 and schoolyear=2017
group by ts.id,st.id ;


delete from ccqscoreitem where ccqscoreid in (select id from ccqscore where scoringassignmentstudentid in
(select id from scoringassignmentstudent where studentstestsid in (select distinct studentstestsid from tmp_ts)));
		
delete from ccqscore where scoringassignmentstudentid in (select id from scoringassignmentstudent 
where studentstestsid in (select distinct studentstestsid from tmp_ts));

delete from scoringassignmentstudent where studentstestsid in (select distinct studentstestsid from tmp_ts); 

delete from scoringassignmentscorer where scoringassignmentid in (select sa.id from scoringassignment sa 
inner join testsession ts on ts.id=sa.testsessionid where operationaltestwindowid=10171 and ts.schoolyear=2017);
		  
delete from scoringassignment where testsessionid in (select distinct testsessionid from tmp_ts);

delete from studentsresponses where studentstestsectionsid in (
 select id from studentstestsections
 where studentstestid in (select id from studentstests where testsessionid in (select distinct testsessionid from tmp_ts)));
 
delete from studentstestsections
 where studentstestid in (select id from studentstests where testsessionid in (select distinct testsessionid from tmp_ts));
 
delete from studentstests where testsessionid in (select distinct testsessionid from tmp_ts);

delete from testsession where id in (select distinct testsessionid from tmp_ts);
commit;


-- Method:2
begin;
 
DO
$BODY$
DECLARE
    deleteids bigint[];
    syear integer;
    StartTime timestamptz;
EndTime timestamptz;
  Delta interval;
BEGIN   
	StartTime := clock_timestamp();
	FOR syear IN (select unnest(ARRAY[2000])) LOOP   --school year running for 2000 not existing
		RAISE NOTICE  'processing year : %', syear;
		select ARRAY_AGG(id) into deleteids 
		  from (select st.id from testsession ts 
		          inner join studentstests st on st.testsessionid=ts.id
                          where operationaltestwindowid=10171 and schoolyear=2017) as stids;
                          					       
		RAISE NOTICE  ' Number of studentstests records to be removed : %', array_length(deleteids, 1);

                RAISE NOTICE  'processing at:% delete on table:ccqscoreitem',clock_timestamp();
		delete from ccqscoreitem where ccqscoreid in (select id from ccqscore where scoringassignmentstudentid in
		(select id from scoringassignmentstudent where studentstestsid =ANY(deleteids)));
		
		RAISE NOTICE  'processing at:% delete on table:scoringassignmentstudentid',clock_timestamp();
		delete from ccqscore where scoringassignmentstudentid in (select id from scoringassignmentstudent where studentstestsid=ANY(deleteids));
		
		RAISE NOTICE  'processing at:% delete on table:scoringassignmentstudent',clock_timestamp();
		delete from scoringassignmentstudent where studentstestsid=ANY(deleteids); 

		RAISE NOTICE  'processing at:% delete on table:scoringassignmentscorer',clock_timestamp();
		delete from scoringassignmentscorer where scoringassignmentid in (select sa.id from scoringassignment sa 
		  inner join testsession ts on ts.id=sa.testsessionid where operationaltestwindowid=10171 and ts.schoolyear=2017);

		RAISE NOTICE  'processing at:% delete on table:scoringassignment',clock_timestamp();  
		delete from scoringassignment where testsessionid in (select id from testsession where operationaltestwindowid=10171 and schoolyear=2017);

		RAISE NOTICE  'processing at:% delete on table:studentsresponses',clock_timestamp();		
		delete from studentsresponses where studentstestsectionsid in (select id from studentstestsections where studentstestid=ANY(deleteids));

		RAISE NOTICE  'processing at:% delete on table:studentsresponsescopy',clock_timestamp();
		delete from studentsresponsescopy where studentstestsectionsid in (select id from studentstestsections where studentstestid=ANY(deleteids));

		RAISE NOTICE  'processing at:% delete on table:studentstestsectionstasksfoils',clock_timestamp();
		delete from studentstestsectionstasksfoils where studentstestsectionsid in (select id from studentstestsections where studentstestid=ANY(deleteids));

		RAISE NOTICE  'processing at:% delete on table:studentstestsectionstasks',clock_timestamp();
		delete from studentstestsectionstasks where studentstestsectionsid in (select id from studentstestsections where studentstestid=ANY(deleteids));

		RAISE NOTICE  'processing at:% delete on table:studentsresponseparameters',clock_timestamp();
		delete from studentsresponseparameters where studentstestsectionsid in (select id from studentstestsections where studentstestid=ANY(deleteids));

		RAISE NOTICE  'processing at:% delete on table:exitwithoutsavetest',clock_timestamp();
		delete from exitwithoutsavetest where studenttestsectionid in (select id from studentstestsections where studentstestid=ANY(deleteids));

		RAISE NOTICE  'processing at:% delete on table:studentstestsections',clock_timestamp();
		delete from studentstestsections where studentstestid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentadaptivetestthetastatus',clock_timestamp();
		delete from studentadaptivetestthetastatus where studentstestid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentadaptivetestfinaltheta',clock_timestamp();
		delete from studentadaptivetestfinaltheta where studentstestid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentsadaptivetestsections',clock_timestamp();
		delete from studentsadaptivetestsections where studentstestid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentspecialcircumstance',clock_timestamp();
		delete from studentspecialcircumstance where studenttestid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentstestshighlighterindex',clock_timestamp();
		delete from studentstestshighlighterindex where studenttestid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentstestshistory',clock_timestamp();
		delete from studentstestshistory where studentstestsid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentsteststags',clock_timestamp();
		delete from studentsteststags where studenttestid=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studentstests',clock_timestamp();
		delete from studentstests where id=ANY(deleteids);

		RAISE NOTICE  'processing at:% delete on table:studenttrackerband',clock_timestamp();
		delete from studenttrackerband where testsessionid in (select id from testsession where operationaltestwindowid=10171 and schoolyear=2017);

		RAISE NOTICE  'processing at:% delete on table:testsession',clock_timestamp();
		--delete from testsession where schoolyear=syear;
		delete from testsession where operationaltestwindowid=10171 and schoolyear=2017;
		RAISE NOTICE  'completed studenttests and testsession data for year : %', syear;
		
	END LOOP; 
	EndTime := clock_timestamp();	
  Delta := 1000 * ( extract(epoch from EndTime) - extract(epoch from StartTime) );
  RAISE NOTICE 'Duration in millisecs=%', Delta;
END;
$BODY$;

commit;




delete from scoringassignmentstudent where scoringassignmentid in (select id from scoringassignment where testsessionid in(select id from testsession where operationaltestwindowid=10171));
delete from scoringassignmentscorer where scoringassignmentid in (select id from scoringassignment where testsessionid in(select id from testsession where operationaltestwindowid=10171));
delete from scoringassignment where testsessionid in(select id from testsession where operationaltestwindowid=10171);

delete from studentsresponses where studentstestsectionsid in (
 select id from studentstestsections
 where studentstestid in (select id from studentstests where testsessionid in (select id from testsession where operationaltestwindowid=10171)));
delete from studentstestsections
 where studentstestid in (select id from studentstests where testsessionid in (select  id from testsession where operationaltestwindowid=10171));
delete from studentstests where testsessionid in (select distinct id from testsession where operationaltestwindowid=10171);
delete from testsession where id in (select id from testsession where operationaltestwindowid=10171);