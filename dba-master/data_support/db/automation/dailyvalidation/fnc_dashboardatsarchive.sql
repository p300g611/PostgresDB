-- DASHBOARD ARCHIVE TABLES
drop table if exists dashboardnewsessionsarchive;
CREATE TABLE public.dashboardnewsessionsarchive
( id bigserial not null,
  statename character varying(200),
  operationaltestwindowid bigint,
  contentarea character varying(100),
  contentareaid bigint,
  testcollectionname character varying(75),
  grade character varying(150),
  gradebandname character varying(100),
  status bigint,
  schoolid bigint,
  schoolname character varying(200),
  districtid bigint,
  districtname character varying(200),
  stateid bigint,
  source character varying(20),
  stagename character varying(75),
  assessmentprogram character varying(100),
  assessmentprogramid bigint,
  nooftests_lastday bigint,
  nooftests_today bigint,
  nooftests bigint,
  nostage2testscompleted bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardnewsessionsarchive
  OWNER TO aartdw;


DROP TABLE if exists dashboardstudentscoringarchive;

CREATE TABLE dashboardstudentscoringarchive
( id bigserial not null,
  ssid character varying(50),
  legalfirstname character varying(80),
  legallastname character varying(80),
  studentid bigint,
  schoolname character varying(200),
  districtname character varying(200),
  grade character varying(10),
  enrollflag boolean,
  studenttestid bigint,
  ststatus bigint,
  testsessionname character varying(300),
  testcollectionname character varying(75),
  scored text,
  scorestatus integer,
  schoolid bigint,
  districtid bigint,
  stateid bigint,
  statename character varying(200),
  assessmentprogram character varying(100),
  assessmentprogramid bigint,
  stageid bigint,
  stagename character varying(75),
  enddatetime timestamp with time zone,
  contentarea  character varying(100),
  contentareaid bigint,
  studentid_kelpa_allsessions bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardstudentscoringarchive
  OWNER TO aartdw;

DROP TABLE if exists dashboardreactivationsarchive;

CREATE TABLE dashboardreactivationsarchive
( id bigserial not null,
  studentname text,
  statestudentidentifier character varying(50),
  studentid bigint,
  stateid bigint,
  statename character varying(200),
  districtname character varying(200),
  districtid bigint,
  schoolname character varying(200),
  schoolid bigint,
  grade character varying,
  gradecourseid bigint,
  gradebandid bigint,
  gradeband character varying(75),
  subjectareaid bigint,
  subject character varying(100),
  startdatetime timestamp with time zone,
  enddatetime timestamp with time zone,
  assessmentprogram character varying(100),
  assessmentprogramid bigint,
  studentstestsid bigint,
  testsessionid bigint,
  testsessionname character varying(300),
  action character varying(20),
  acteddate timestamp with time zone,
  acteduser integer,
  reactivatedbyid bigint,
  reactivatedby text,
  studentstestshistoryid bigint,
  stagename character varying(75),
  testname character varying(75),
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardreactivationsarchive
  OWNER TO aartdw;

DROP TABLE if exists dashboardtestingoutsidehoursarchive;

CREATE TABLE dashboardtestingoutsidehoursarchive
( id bigserial not null,
  studentname text,
  statestudentidentifier character varying(50),
  studentid bigint,
  stateid bigint,
  statename character varying(200),
  districtname character varying(200),
  districtid bigint,
  schoolname character varying(200),
  schoolid bigint,
  grade character varying,
  gradecourseid bigint,
  gradebandid bigint,
  gradeband character varying(75),
  subjectareaid bigint,
  subject character varying(100),
  assessmentprogram character varying(100),
  assessmentprogramid bigint,
  studentstestsid bigint,
  testsessionid bigint,
  testsessionname character varying(300),
  startdatetime timestamp with time zone,
  enddatetime timestamp with time zone,
  stagename character varying(75),
  testname character varying(75),
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);  
ALTER TABLE dashboardtestingoutsidehoursarchive
  OWNER TO aartdw;
DROP TABLE if exists  dashboardstudentscompletedarchive;
CREATE TABLE dashboardstudentscompletedarchive
( id bigserial not null,
  assessmentprogramid bigint,
  assessmentprogram character varying(100),
  subject character varying(100),
  subjectid bigint,
  attendanceschoolid bigint,
  schoolname character varying(200),
  schooldisplayidentifier character varying(100),
  districtid bigint,
  districtname character varying(200),
  districtdisplayidentifier character varying(100),
  stateid bigint,
  statename character varying(200),
  grade character varying(150),
  gradeid bigint,
  gradelevel character varying(10),
  source character varying(20),
  countstudentscompleted bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardstudentscompletedarchive
  OWNER TO aartdw;  

DROP TABLE if exists  dashboardinterimarchive;

CREATE TABLE dashboardinterimarchive
( id bigserial not null,
  statename character varying(200),
  districtname character varying(200),
  districtdbid bigint,
  schoolname character varying(200),
  schooldbid bigint,
  grade character varying(150),
  gradebandname character varying(100),
  contentarea character varying(100),
  roster character varying(75),
  rosterdbid bigint,
  teacher text,
  teacherdbid bigint,
  operationaltestwindowid bigint,
  testcollectionname character varying(75),
  status text,
  assessmentprogram character varying(100),
  assessmentprogramid bigint,
  nooftests bigint,
  nooftests_lastday bigint,
  nooftests_today bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardinterimarchive
  OWNER TO aartdw;  

drop table if exists dashboarddlmfcsarchive;
CREATE TABLE dashboarddlmfcsarchive
( id bigserial not null,
  "STATE_NAME" character varying(100),
  "COMPLETE" bigint,
  "READY_TO_SUBMIT" bigint,
  "IN_PROGRESS" bigint,
  "NOT_STARTED" bigint,
  "TOTAL_FCS" bigint,
  "TOTAL_STUDENTS" bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboarddlmfcsarchive
  OWNER TO aartdw;

drop table if exists dashboardtdearchive;
CREATE TABLE dashboardtdearchive
( id bigserial not null,
  day date,
  "time" text,
  studenttestsectioncount bigint,
  interval_alias timestamp with time zone,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardtdearchive
  OWNER TO aartdw;

drop table if exists dashboardkapelamatharchive;

CREATE TABLE dashboardkapelamatharchive
( id bigserial not null,
  operationaltestwindowid bigint,
  studentid bigint,
  studentstestsid bigint,
  statename character varying(200),
  districtname character varying(200),
  districtid bigint,
  schoolname character varying(200),
  schoolid bigint,
  grade character varying(10),
  subjectareaid bigint,
  testcollectionname character varying(75),
  testname character varying(75),
  startdatetime_cst timestamp without time zone,
  enddatetime_cst timestamp without time zone,
  timetaken_min double precision,
  status bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardkapelamatharchive
  OWNER TO aartdw;

drop table if exists dashboardkapsciarchive;

CREATE TABLE dashboardkapsciarchive
( id bigserial not null,
  operationaltestwindowid bigint,
  studentid bigint,
  studentstestsid bigint,
  statename character varying(200),
  districtname character varying(200),
  districtid bigint,
  schoolname character varying(200),
  schoolid bigint,
  grade character varying(10),
  subjectareaid bigint,
  testcollectionname character varying(75),
  testname character varying(75),
  startdatetime_cst timestamp without time zone,
  enddatetime_cst timestamp without time zone,
  timetaken_min double precision,
  status bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardkapsciarchive
  OWNER TO aartdw; 


drop table if exists dashboardcpassarchive;

CREATE TABLE dashboardcpassarchive
( id bigserial not null,
  operationaltestwindowid bigint,
  studentid bigint,
  studentstestsid bigint,
  statename character varying(200),
  districtname character varying(200),
  districtid bigint,
  schoolname character varying(200),
  schoolid bigint,
  grade character varying(10),
  subjectareaid bigint,
  testcollectionname character varying(75),
  testname character varying(75),
  startdatetime_cst timestamp without time zone,
  enddatetime_cst timestamp without time zone,
  timetaken_min double precision,
  status bigint,
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardcpassarchive
  OWNER TO aartdw;  

drop table if exists dashboardstudentsassignedarchive;

CREATE TABLE dashboardstudentsassignedarchive
( id bigserial not null,
  assessmentprogram character varying(100),
  assessmentprogramid bigint,
  contentarea character varying,
  contentareaid bigint,
  grade character varying(150),
  gradeid bigint,
  gradelevel integer,
  operationaltestwindowid bigint,
  source character varying(20),
  sessionsassignedyear bigint,
  studentsassignedyear bigint,
  stateid bigint,
  statename character varying(200),
  statedisplayidentifier character varying(100),
  districtid bigint,
  districtname character varying(200),
  districtdisplayidentifier character varying(100),
  schoolid bigint,
  schoolname character varying(200),
  schooldisplayidentifier character varying(100),
  createddate timestamp with time zone default ('now'::text)::timestamp with time zone not null,
  modifieddate timestamp with time zone default ('now'::text)::timestamp with time zone not null
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardstudentsassignedarchive OWNER TO aartdw;

DROP TABLE IF EXISTS public.dashboardatscalllinedaily;
CREATE TABLE dashboardatscalllinedaily
(
  call_id int,
  segment int,
  row_date date,
  row_time time,
  segstart time,
  segstop time,
  duration int,
  calling_party char(30),
  dialed_number bigint,
  dispivector int,
  disposition varchar(10),
  disposition_time int,
  dispsplit int,
  ans_logid int,
  talk_time int,
  hold_time int,
  acw_time int,
  transout char(1),
  conf char(1),
  assist char(1),
  acd  int)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardatscalllinedaily
  OWNER TO aartdw;

DROP TABLE IF EXISTS public.dashboardatscalllinearchive;
CREATE TABLE public.dashboardatscalllinearchive
(
  id bigserial NOT NULL,
  call_id int,
  segment int,
  row_date date,
  row_time time,
  segstart time,
  segstop time,
  duration int,
  calling_party char(30),
  dialed_number bigint,
  dispivector int,
  disposition varchar(10),
  disposition_time int,
  dispsplit int,
  ans_logid int,
  talk_time int,
  hold_time int,
  acw_time int,
  transout char(1),
  conf char(1),
  assist char(1),
  acd  int,
  createddate  timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  modifieddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone

)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardatscalllinearchive
  OWNER TO aartdw;
  
DROP TABLE IF EXISTS public.dashboardatsosticketdaily;
CREATE TABLE public.dashboardatsosticketdaily
(
  ticket_number integer NOT NULL,
  date timestamp without time zone,
  subject character varying(200),
  from_user character varying(100),
  from_email character varying(100),
  priority character varying(20),
  department character varying(20),
  help_topic character varying(100),
  source character varying(20),
  current_status character varying(20),
  last_updated timestamp without time zone,
  due_date timestamp without time zone,
  overdue smallint,
  answered smallint,
  assigned_to character varying(100),
  agent_assigned character varying(100),
  team_assigned character varying(100),
  nine_minute_flag character varying(3),
  program character varying(10),
  state character varying(20),
  district character varying(20),
  school character varying(100),
  defect character varying(10),
  policy character varying(3),
  resolution character varying(100),
  user_file character varying(3),
  roster_file character varying(3),
  enrollment_file character varying(3),
  tec_file character varying(3),
  include smallint,
  include_open smallint,
  days_to_update numeric,
  age_since_created numeric,
  age_since_updated numeric,
  created_date date,
  in_current_year smallint,
  include_pending smallint,
  include_open_current_year smallint,
  include_pending_current_year smallint,
  include_current_year smallint,
  last_30 smallint,
  last_30_include smallint,
  last_30_pending_include smallint,
  last_30_open_include smallint,
  last_7 smallint,
  last_7_include smallint,
  last_7_pending_include smallint,
  last_7_open_include smallint 
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.dashboardatsosticketdaily
  OWNER TO aartdw;

DROP TABLE IF EXISTS public.dashboardatsosticketachive;
CREATE TABLE public.dashboardatsosticketachive
(
  id bigserial not null,
  ticket_number integer NOT NULL,
  date timestamp without time zone,
  subject character varying(200),
  from_user character varying(100),
  from_email character varying(100),
  priority character varying(20),
  department character varying(20),
  help_topic character varying(100),
  source character varying(20),
  current_status character varying(20),
  last_updated timestamp without time zone,
  due_date timestamp without time zone,
  overdue smallint,
  answered smallint,
  assigned_to character varying(100),
  agent_assigned character varying(100),
  team_assigned character varying(100),
  nine_minute_flag character varying(3),
  program character varying(10),
  state character varying(20),
  district character varying(20),
  school character varying(100),
  defect character varying(10),
  policy character varying(3),
  resolution character varying(100),
  user_file character varying(3),
  roster_file character varying(3),
  enrollment_file character varying(3),
  tec_file character varying(3),
  include smallint,
  include_open smallint,
  days_to_update numeric,
  age_since_created numeric,
  age_since_updated numeric,
  created_date date,
  in_current_year smallint,
  include_pending smallint,
  include_open_current_year smallint,
  include_pending_current_year smallint,
  include_current_year smallint,
  last_30 smallint,
  last_30_include smallint,
  last_30_pending_include smallint,
  last_30_open_include smallint,
  last_7 smallint,
  last_7_include smallint,
  last_7_pending_include smallint,
  last_7_open_include smallint,
  createddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  modifieddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.dashboardatsosticketachive
  OWNER TO aartdw;  



DROP FUNCTION if exists fnc_dashboardatsarchive();
CREATE OR REPLACE FUNCTION public.loadepatsdashboardarchive()
  RETURNS character varying AS
$BODY$
	DECLARE 
		val_today timestamp with time zone;
		
	BEGIN
     	        val_today:=now();
     	PERFORM start_etllogdetails('loadepatsdashboardarchive','processing');        
     	RAISE NOTICE 'processing dashboardtestingsummaryarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardtestingsummary')
	THEN
           INSERT INTO public.dashboardtestingsummaryarchive(
            id, assessmentprogram, assessmentprogramid, contentarea, contentareaid,schoolname, schoolid, districtname, districtid, statename, stateid, 
            countsessionscompletedtoday, countsessionscompletedlastschoolday,countsessionscompletedthisyear, countstudentsassignedthisyear, 
            countstudentscompletedthisyear, countreactivatedlastschoolday,countreactivatedthisyear, status, createddate, modifieddate)
	    select  id, assessmentprogram, assessmentprogramid, contentarea, contentareaid,schoolname, schoolid, districtname, districtid, statename, stateid, 
            countsessionscompletedtoday, countsessionscompletedlastschoolday,countsessionscompletedthisyear, countstudentsassignedthisyear, 
            countstudentscompletedthisyear, countreactivatedlastschoolday,countreactivatedthisyear, status, createddate, modifieddate from dashboardtestingsummary src
            where not exists (select 1 from dashboardtestingsummaryarchive tgt where src.id=tgt.id ); 
	END IF;	    
     	RAISE NOTICE 'processing dashboardscoringsummaryarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardscoringsummary')
	THEN
	INSERT INTO public.dashboardscoringsummaryarchive(
            id, assessmentprogram, assessmentprogramid, contentarea, contentareaid,schoolname, schoolid, districtname, districtid, statename, stateid, 
            countsessionsscoredtoday, countsessionsscoredlastschoolday, countsessionsscoredthisyear, countsessionscompletednotscored, countsessionsassignedthisyear, 
            status, createddate, modifieddate)
	select id, assessmentprogram, assessmentprogramid, contentarea, contentareaid,schoolname, schoolid, districtname, districtid, statename, stateid, 
            countsessionsscoredtoday, countsessionsscoredlastschoolday, countsessionsscoredthisyear, countsessionscompletednotscored, countsessionsassignedthisyear, 
            status, createddate, modifieddate from dashboardscoringsummary src 
            where not exists (select 1 from dashboardscoringsummaryarchive tgt where tgt.id=src.id);  
	END IF;	 
     	RAISE NOTICE 'processing dashboardnewsessionsarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardnewsessionsdaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardnewsessionsarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardnewsessionsarchive(statename, operationaltestwindowid, contentarea,contentareaid, testcollectionname,grade, gradebandname, status, schoolid, schoolname, districtid, 
            districtname, stateid, source, stagename, assessmentprogram,assessmentprogramid, nooftests_lastday, nooftests_today, nooftests,nostage2testscompleted)
		    select statename, operationaltestwindowid, contentarea,contentareaid, testcollectionname,grade, gradebandname, status, schoolid, schoolname, districtid, 
            districtname, stateid, source, stagename, assessmentprogram,assessmentprogramid, nooftests_lastday, nooftests_today, nooftests,nostage2testscompleted
		    from dashboardnewsessionsdaily; END IF;  
	END IF;	 
	RAISE NOTICE 'processing dashboardstudentscoringarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardstudentscoringdaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardstudentscoringarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardstudentscoringarchive(ssid, legalfirstname, legallastname, studentid, schoolname,districtname, grade, enrollflag, 
             studenttestid, ststatus, testsessionname,testcollectionname, scored, scorestatus, schoolid, districtid, 
            stateid, statename, assessmentprogram, assessmentprogramid, stageid,stagename, enddatetime,contentarea,contentareaid, studentid_kelpa_allsessions)
		    select ssid, legalfirstname, legallastname, studentid, schoolname,districtname, grade, enrollflag, 
             studenttestid, ststatus, testsessionname,testcollectionname, scored, scorestatus, schoolid, districtid, 
            stateid, statename, assessmentprogram, assessmentprogramid, stageid,stagename, enddatetime,contentarea,contentareaid, studentid_kelpa_allsessions
		    from dashboardstudentscoringdaily; END IF;  
	END IF; 
	RAISE NOTICE 'processing dashboardreactivationsarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardreactivationsdaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardreactivationsarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardreactivationsarchive(studentname, statestudentidentifier, studentid, stateid,statename, districtname, districtid, schoolname, schoolid, grade,gradecourseid,			gradebandid, gradeband, subjectareaid, subject, startdatetime, enddatetime, assessmentprogram, assessmentprogramid, studentstestsid, testsessionid,testsessionname,
            action, acteddate, acteduser, reactivatedbyid, reactivatedby,studentstestshistoryid, stagename)
		    select studentname, statestudentidentifier, studentid, stateid,statename, districtname, districtid, schoolname, schoolid, grade,gradecourseid,			gradebandid,                    gradeband, subjectareaid, subject, startdatetime, enddatetime, assessmentprogram, assessmentprogramid, studentstestsid, testsessionid,testsessionname,
            action, acteddate, acteduser, reactivatedbyid, reactivatedby,studentstestshistoryid, stagename
		   from dashboardreactivationsdaily; END IF;  
	END IF;	 
	RAISE NOTICE 'processing dashboardtestingoutsidehoursarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardtestingoutsidehoursdaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardtestingoutsidehoursarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardtestingoutsidehoursarchive(studentname, statestudentidentifier, studentid, stateid, 
            statename, districtname, districtid, schoolname, schoolid, grade,gradecourseid,gradebandid,gradeband, subjectareaid, subject, assessmentprogram, assessmentprogramid, 
            studentstestsid, testsessionid,testsessionname, startdatetime, enddatetime,stagename)
		    select studentname, statestudentidentifier, studentid, stateid, 
            statename, districtname, districtid, schoolname, schoolid, grade,gradecourseid,gradebandid,gradeband, subjectareaid, subject, assessmentprogram, assessmentprogramid, 
            studentstestsid, testsessionid,testsessionname, startdatetime, enddatetime,stagename
		    from dashboardtestingoutsidehoursdaily; END IF;  
	END IF;
	RAISE NOTICE 'processing dashboardstudentscompletedarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardstudentscompleteddaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardstudentscompletedarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardstudentscompletedarchive(assessmentprogramid, assessmentprogram, subject, subjectid,attendanceschoolid, schoolname,
              schooldisplayidentifier, districtid,districtname, districtdisplayidentifier, stateid, statename,grade, gradeid, gradelevel,source, countstudentscompleted)
		    select assessmentprogramid, assessmentprogram, subject, subjectid,attendanceschoolid, schoolname,
              schooldisplayidentifier, districtid,districtname, districtdisplayidentifier, stateid, statename,grade, gradeid, gradelevel,source, countstudentscompleted
		    from dashboardstudentscompleteddaily; END IF;  
	END IF;
	RAISE NOTICE 'processing dashboardinterimarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardinterimdaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardinterimarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardinterimarchive(statename, districtname, districtdbid, schoolname, schooldbid,grade, gradebandname, contentarea, roster, rosterdbid, teacher, 
            teacherdbid, operationaltestwindowid, testcollectionname, status,assessmentprogram, assessmentprogramid, nooftests, nooftests_lastday,nooftests_today)
		    select statename, districtname, districtdbid, schoolname, schooldbid,grade, gradebandname, contentarea, roster, rosterdbid, teacher, 
            teacherdbid, operationaltestwindowid, testcollectionname, status,assessmentprogram, assessmentprogramid, nooftests, nooftests_lastday,nooftests_today
		    from dashboardinterimdaily; END IF;  
	END IF;	
	RAISE NOTICE 'processing dashboarddlmfcsarchive:%',clock_timestamp();  
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboarddlmfcsdaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboarddlmfcsarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboarddlmfcsarchive("STATE_NAME","COMPLETE","READY_TO_SUBMIT","IN_PROGRESS","NOT_STARTED","TOTAL_FCS","TOTAL_STUDENTS")
		    select "STATE_NAME","COMPLETE","READY_TO_SUBMIT","IN_PROGRESS","NOT_STARTED","TOTAL_FCS","TOTAL_STUDENTS"
		    from dashboarddlmfcsdaily; END IF;
        END IF;
        RAISE NOTICE 'processing dashboardtdearchive:%',clock_timestamp();            
 	IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboarddlmfcsdaily')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardtdearchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardtdearchive(day, "time", studenttestsectioncount, interval_alias)
                   select day, "time", studenttestsectioncount, interval_alias from dashboardtdedaily; END IF;
        END IF;  
        /* 
        RAISE NOTICE 'processing dashboardkapelamatharchive:%',clock_timestamp();            
 	IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardkapelamatharchive')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardkapelamatharchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardkapelamatharchive(operationaltestwindowid, studentid, studentstestsid, statename,districtname,districtid,
              schoolname, schoolid, grade, subjectareaid,testcollectionname, testname, startdatetime_cst, enddatetime_cst,timetaken_min, status)
                   select operationaltestwindowid, studentid, studentstestsid, statename,districtname,districtid,
              schoolname, schoolid, grade, subjectareaid,testcollectionname, testname, startdatetime_cst, enddatetime_cst,timetaken_min, status from dashboardkapelamathdaily;END IF;
        END IF; 
         RAISE NOTICE 'processing dashboardkapsciarchive:%',clock_timestamp();            
 	IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardkapsciarchive')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardkapsciarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardkapsciarchive(operationaltestwindowid, studentid, studentstestsid, statename,districtname, districtid,
              schoolname, schoolid, grade, subjectareaid, testcollectionname, testname, startdatetime_cst, enddatetime_cst, timetaken_min, status)
                   select operationaltestwindowid, studentid, studentstestsid, statename,districtname, districtid,
              schoolname, schoolid, grade, subjectareaid, testcollectionname, testname, startdatetime_cst, enddatetime_cst, timetaken_min, status from dashboardkapscidaily; END IF;
        END IF;
        RAISE NOTICE 'processing dashboardcpassarchive:%',clock_timestamp();            
 	IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardcpassarchive')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardcpassarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardcpassarchive(operationaltestwindowid, studentid, studentstestsid, statename,districtname, districtid,
             schoolname, schoolid, grade, subjectareaid, testcollectionname, testname, startdatetime_cst, enddatetime_cst,timetaken_min, status)
                   select operationaltestwindowid, studentid, studentstestsid, statename,districtname, districtid,
             schoolname, schoolid, grade, subjectareaid, testcollectionname, testname, startdatetime_cst, enddatetime_cst,timetaken_min, status from dashboardcpassdaily; END IF;
        END IF;  
         */ 
        RAISE NOTICE 'processing dashboardstudentsassignedarchive:%',clock_timestamp();            
 	IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='dashboardstudentsassignedarchive')
	THEN
            IF not EXISTS (SELECT 1 FROM dashboardstudentsassignedarchive WHERE createddate::date=now()::date limit 1)
             then  INSERT INTO dashboardstudentsassignedarchive(
            assessmentprogram, assessmentprogramid, contentarea, contentareaid,grade, gradeid, gradelevel,operationaltestwindowid,source, sessionsassignedyear, studentsassignedyear, 
            stateid, statename, statedisplayidentifier, districtid, districtname,districtdisplayidentifier, schoolid, schoolname, schooldisplayidentifier)
                   select assessmentprogram, assessmentprogramid, contentarea, contentareaid,grade, gradeid, gradelevel,operationaltestwindowid,source, sessionsassignedyear, studentsassignedyear, 
            stateid, statename, statedisplayidentifier, districtid, districtname,districtdisplayidentifier, schoolid, schoolname, schooldisplayidentifier from dashboardstudentsassigneddaily; END IF;
        END IF;         
       RAISE NOTICE 'Processing dashboardatscalllinearchive:%',clock_timestamp();
	  IF EXISTS (SELECT 1 FROM information_schema.tables where table_name='dashboardatscalllinedaily')
	   THEN
	    IF NOT EXISTS (SELECT 1 FROM dashboardatscalllinearchive WHERE createddate::date=now()::date limit 1)
	    THEN
	    INSERT INTO dashboardatscalllinearchive (call_id,segment,row_date,row_time,segstart,segstop,duration,calling_party ,dialed_number ,dispivector,disposition ,disposition_time ,
				      dispsplit ,ans_logid,talk_time ,hold_time ,acw_time ,transout,conf ,assist ,acd )
			      select  call_id,segment,row_date,row_time,segstart,segstop,duration,calling_party ,dialed_number ,dispivector,disposition ,disposition_time ,
				      dispsplit ,ans_logid,talk_time ,hold_time ,acw_time ,transout,conf ,assist,acd
				      from dashboardatscalllinedaily; 
	       END IF;
	   END IF;
           /*select  call_id,segment,row_date,row_time,segstart,segstop,duration,calling_party ,dialed_number ,dispivector,disposition ,disposition_time ,
	       dispsplit ,ans_logid,talk_time ,hold_time ,acw_time ,transout,conf,assist,acd,talk_time+hold_time as hold_talk
           from dashboardatscalllinearchive
           WHERE createddate::date=now()::date and dispivector IN (34, 283, 284, 285, 288, 289);*/
	  RAISE NOTICE 'Processing dashboardatsosticketachive:%',clock_timestamp();
	  IF EXISTS (SELECT 1 FROM information_schema.tables where table_name ='dashboardatsosticketdaily')
	    THEN
	       IF NOT EXISTS (SELECT 1 FROM dashboardatsosticketachive where createddate::date=now()::date limit 1) 
	       THEN
	       INSERT INTO dashboardatsosticketachive( ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
				source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned ,nine_Minute_Flag ,program ,
				state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file,
				include ,include_open,days_to_update ,age_since_created ,age_since_updated ,created_date ,in_current_year ,
				include_pending ,include_open_current_year ,include_pending_current_year ,include_current_year ,last_30 ,
				last_30_include ,last_30_pending_include ,last_30_open_include ,last_7 ,last_7_include ,
				last_7_pending_include ,last_7_open_include)
		       select   ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
				source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned ,nine_Minute_Flag ,program ,
				state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file,
				include ,include_open,days_to_update ,age_since_created ,age_since_updated ,created_date ,in_current_year ,
				include_pending ,include_open_current_year ,include_pending_current_year ,include_current_year ,last_30 ,
				last_30_include ,last_30_pending_include ,last_30_open_include ,last_7 ,last_7_include ,
				last_7_pending_include ,last_7_open_include
				from dashboardatsosticketdaily;
		   END IF;
	    END IF;
	   /* --Ten minutes record
           select ticket_number,date,subject,from_user ,from_email,priority,department,help_topic,source,current_status,last_updated ,due_date,overdue,answered
              ,assigned_to,agent_assigned ,team_assigned,nine_minute_flag ,program ,state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file
               from dashboardatsosticketdailywhere  nine_minute_flag='Yes';*/	
      PERFORM end_etllogdetails('loadepatsdashboardarchive','processing');            	
   RETURN 'SUCCESS';  END;
	$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.loadepatsdashboardarchive()
  OWNER TO aartdw;
GRANT EXECUTE ON FUNCTION loadepatsdashboardarchive() TO public;
GRANT EXECUTE ON FUNCTION loadepatsdashboardarchive() TO aartdw;


-- select loadepatsdashboardarchive();