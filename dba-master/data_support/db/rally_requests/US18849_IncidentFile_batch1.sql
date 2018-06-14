create temporary table tmp_eoi(ssid text,conarea text ,err text);--Routing Issue reported for students from DLM 
\COPY tmp_eoi FROM 'eoi.csv' DELIMITER ',' CSV HEADER ;

 create temporary table tmp_EEcode(cc text,grf text); --GRF  match EE codes
\COPY tmp_EEcode FROM 'Contentframeworkdetailcode_EE_correspondence.csv' DELIMITER ',' CSV HEADER ;

-- Find the student and codes related to window(EOI)(need to eliminate if test name like "R-")
  select distinct statestudentidentifier,
                  --t.testname,
                  cfd.contentcode,  
                   stn.organizationname
                    into temp tmp_Incidentfile
               from studenttracker str
		    join studenttrackerband stb on stb.studenttrackerid = str.id
		    join studentstests st on st.testsessionid = stb.testsessionid
		    JOIN test t ON st.testid = t.id
		    JOIN testsection as ts ON (t.id = ts.testid)
		    JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
		    JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
		    LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
		    LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id 
		    LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
		    LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
		    LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
		    LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
		    LEFT JOIN operationaltestwindowstate ows on ows.operationaltestwindowid=stb.operationalwindowid
		    left JOIN organization stn on  stn.id=ows.stateid
		    join student s on s.id = str.studentid
		    join tmp_eoi eoi on eoi.ssid=s.statestudentidentifier
		    where stb.operationalwindowid in (   10147,
							 10157,
							 10144, 
							 10146,
							 10134);

select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         1 issue_code,
         organizationname state ,
         grf
into temp tmp_Incidentfile_ee
  from tmp_Incidentfile tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct statestudentidentifier,contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee order by 1) TO 'tmp_Incidentfile_ee1.csv' DELIMITER ',' CSV HEADER;--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct statestudentidentifier,grf contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee order by 1) TO 'tmp_Incidentfile_grf1.csv' DELIMITER ',' CSV HEADER;

--Issue code2:Misrouting due to NA scores not being scored as incorrect.(need to eliminate if test name like "R-")


select distinct statestudentidentifier,
                  --t.testname,
                  cfd.contentcode,  
                   stn.organizationname
                    into temp tmp_Incidentfile2
               from studenttracker str
		    join studenttrackerband stb on stb.studenttrackerid = str.id
		    join studentstests st on st.testsessionid = stb.testsessionid
		    JOIN test t ON st.testid = t.id
		    JOIN testsection as ts ON (t.id = ts.testid)
		    JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
		    JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
		    LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
		    LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id 
		    LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
		    LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
		    LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
		    LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
		    LEFT OUTER JOIN  studentsresponses sres1 ON st.id = sres1.studentstestsid
		    join student s on s.id = str.studentid
		    LEFT JOIN operationaltestwindowstate ows on ows.operationaltestwindowid=stb.operationalwindowid
		    left JOIN organization stn on  stn.id=ows.stateid
		    inner join studentassessmentprogram sap on sap.studentid=s.id and sap.assessmentprogramid=3
		    where stb.operationalwindowid in (   10147,
							 10157,
							 10144,
							 10146,
							 10134)
		                and sres1.studentstestsid is null 
				and str.activeflag is true 
				and stb.activeflag is true 
				and st.activeflag is true 
				and sap.activeflag is true
				and s.activeflag is true
				and st.status=86;



select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         2 issue_code,
         organizationname state ,
         grf
into temp tmp_Incidentfile_ee2
  from tmp_Incidentfile2 tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct statestudentidentifier,contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee2 order by 1) TO 'tmp_Incidentfile_ee2.csv' DELIMITER ',' CSV HEADER;--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct statestudentidentifier,grf contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee2 order by 1) TO 'tmp_Incidentfile_grf2.csv' DELIMITER ',' CSV HEADER;













