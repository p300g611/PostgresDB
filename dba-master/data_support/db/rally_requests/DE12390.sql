DO
$BODY$
DECLARE
 sttestid bigint;
BEGIN
select id into sttestid from studentstests where testsessionid = (select id from testsession where name='DLM-ITI_IM ELA EW.5 DP_2278699482');
RAISE NOTICE 'Updating status for studenttestid: % ', sttestid;
UPDATE studentsresponses SET activeflag = false WHERE studentstestsid = sttestid;
UPDATE studentstestsections SET statusid = 125 WHERE studentstestid = sttestid;
UPDATE studentstests SET status= 84 WHERE id=sttestid;
RAISE NOTICE 'Done Updating status for studenttestid: % ', sttestid;
END;
$BODY$;

DO
$BODY$
DECLARE
 sttestid bigint;
BEGIN
select id into sttestid from studentstests where testsessionid = (select id from testsession where name='DLM-ITI_IM ELA EW.8 DP_3258037876');
RAISE NOTICE 'Updating status for studenttestid: % ', sttestid;
UPDATE studentsresponses SET activeflag = false WHERE studentstestsid = sttestid;
UPDATE studentstestsections SET statusid = 125 WHERE studentstestid = sttestid;
UPDATE studentstests SET status= 84 WHERE id=sttestid;
RAISE NOTICE 'Done Updating status for studenttestid: % ', sttestid;
END;
$BODY$;
