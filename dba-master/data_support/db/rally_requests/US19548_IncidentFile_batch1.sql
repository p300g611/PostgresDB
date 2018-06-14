create temporary table tmp_EEcode(cc text,grf text); --GRF  match EE codes
\COPY tmp_EEcode FROM 'Contentframeworkdetailcode_EE_correspondence.csv' DELIMITER ',' CSV HEADER ;


--States to include in Batch 1: Miccosukee Indian School, Colorado, Kansas, Illinois, Wisconsin, Alaska
--Issue code:1.	First testlet re-administered after student transfer (DE15409)

-- select id from organization o
-- where displayidentifier in ('BIE-Miccosukee','CO','KS','IL','WI','AK');
-- select distinct source from testsession limit 10;


create temporary table tmp_std_ca(studentid bigint,subjectid bigint); 
\COPY tmp_std_ca FROM 'DE15409.csv' DELIMITER ',' CSV HEADER ;

-- select * from student 
-- where id in (699246,948264,959435,959837,959855,959927,966758,978530,978532,1128321,1128322,1128330,1128332,1128334,1128383
-- ,1128391,1130424,1130497,1134272,1264556,1281149,1296556,1300973,1313741,1314226,1317445,1320419,1342419,1343888
-- ,1348756,1349536,1350691,1351600,1354547,1354819,1389018,1390062,1393975,1406787,1406813,1406869);

--from 04/04/2017 and DE15409
-- select distinct studentid,name from studentstests st
-- inner join testsession ts on st.testsessionid=ts.id
-- where st.id in (16676935,
-- 16802384,
-- 16804269,
-- 16805375,
-- 16806017,
-- 16821738,
-- 16545539,
-- 16547379,
-- 16715167,
-- 16796884,
-- 16825506,
-- 17039550,
-- 16480873,
-- 16794347,
-- 16950837,
-- 16957294,
-- 17033067,
-- 17052624,
-- 16779958,
-- 16897090,
-- 16774861,
-- 16866044) order by studentid;
-- 
-- 1264377--440
-- 1264376--440
-- 1264376--3

-- select opw.id,opw.windowname,organizationname,effectivedate,expirydate,o.id  from operationaltestwindowstate opws
--    inner join operationaltestwindow opw on opw.id=opws.operationaltestwindowid
--    inner join organization o on o.id=opws.stateid
--     where displayidentifier in ('BIE-Miccosukee','CO','KS','IL','WI')
--     and assessmentprogramid=3
--     --and EXTRACT(YEAR FROM expirydate) =2017;
--     order by opw.id;

-- Find the student and codes related to window(EOI)(need to eliminate if test name like "R-")
  select distinct statestudentidentifier,
                  --t.testname,
                   cfd.contentcode,  
                   stn.organizationname,
                   s.legallastname,
                   s.legalfirstname,
                   s.legalmiddlename,
                   s.generationcode,
                   s.dateofbirth,
                   s.id studentid
                   into temp tmp_Incidentfile1   
                    --select  stb.operationalwindowid,s.stateid,count( *)                
              from studenttracker str
		    join studenttrackerband stb on stb.studenttrackerid = str.id
		    join studentstests st on st.testsessionid = stb.testsessionid
		    join testsession tss on tss.id=st.testsessionid and tss.activeflag is true
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
		    join student s on s.id = str.studentid
		    left JOIN organization stn on  stn.id=s.stateid
		    join tmp_std_ca std on std.studentid=s.id and ca.id=std.subjectid
		    where s.stateid in (9631,9632,3384,35999,79430,51)
		          and  ((t.testname not like '%R-%' and tss.source<>'ITI') or tss.source='ITI')  --need to test this
		          and st.activeflag is true 
		          and s.activeflag is true
		         --group by s.stateid,stb.operationalwindowid
		         ;

  
select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         1 issue_code,
         organizationname state ,
         tmp.studentid,
         tmp.legallastname,
         tmp.legalfirstname,
         tmp.legalmiddlename,
         tmp.generationcode,
         tmp.dateofbirth,
         grf
into temp tmp_Incidentfile_ee1
  from tmp_Incidentfile1 tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct studentid,statestudentidentifier,state,legalfirstname,legalmiddlename,legallastname,generationcode,dateofbirth,contentframeworkdetailcode,issue_code FROM tmp_Incidentfile_ee1 order by state,legalfirstname) TO 'tmp_Incidentfile_ee1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct studentid,statestudentidentifier,state,legalfirstname,legalmiddlename,legallastname,generationcode,dateofbirth,grf contentframeworkdetailcode,issue_code FROM tmp_Incidentfile_ee1 order by state,legalfirstname) TO 'tmp_Incidentfile_grf1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);








