--KAP only oeprational test windows
--excludes tests where end date is greater than start date
--limited to Buhler, El Dorado and Derby school districts.

\f ','
\a
\pset expanded off

\o 'average_duration.csv'

SELECT otd.districtname AS District,
          stg.name AS "Stage Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes",
          count(st.id) AS "Total Student Tests"
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON (en.studentid = s.id)
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    AND ts.activeflag is true
    AND ts.operationaltestwindowid in (10124,10131,10132,10133)
    AND otd.districtdisplayidentifier IN ('D0313','D0260','D0490')
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    GROUP BY otd.districtname, stg.name
    ORDER BY otd.districtname,stg.name;


\o 'dist_average_duration_grade_subject.csv'

SELECT otd.districtname AS District,
           stg.name AS "Stage Name",
           gc.name AS Grade,
           ca.abbreviatedname AS Subject,           
           round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes",
           count(st.id) AS "Total Student Tests"
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN testcollection tc ON (ts.testcollectionid = tc.id) AND st.testcollectionid=tc.id
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON (en.studentid = s.id)
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    JOIN contentarea ca ON (tc.contentareaid = ca.id)
    JOIN gradecourse gc ON (gc.id=ts.gradecourseid)    
    WHERE st.activeflag is true
    AND st.status = 86
    AND ts.activeflag is true
    AND ts.operationaltestwindowid in (10124,10131,10132,10133)
    AND otd.districtdisplayidentifier IN ('D0313','D0260','D0490')
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL 
    GROUP BY otd.districtname, stg.name, gc.name, ca.abbreviatedname
    ORDER BY otd.districtname,stg.name, gc.name, ca.abbreviatedname;
    
    
    
\o 'st_average_duration_grade_subject.csv'

    SELECT stg.name AS "Stage Name",
           gc.name AS Grade,
           ca.abbreviatedname AS Subject,           
           round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes",
           count(st.id) AS "Total Student Tests"
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN testcollection tc ON (ts.testcollectionid = tc.id) AND st.testcollectionid=tc.id
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN contentarea ca ON (tc.contentareaid = ca.id)
    JOIN gradecourse gc ON (gc.id=ts.gradecourseid)    
    WHERE st.activeflag is true
    AND st.status = 86
    AND ts.activeflag is true
    AND ts.operationaltestwindowid in (10124,10131,10132,10133)
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    GROUP BY stg.name, gc.name, ca.abbreviatedname
    ORDER BY stg.name, gc.name, ca.abbreviatedname;    


-- KELPA 2017 tests duration (average_duration_domain)
drop table if exists tmp_kelpa;
SELECT    otd.statename "State Name",
         -- otd.districtname AS "District Name",
          --gc.name AS "Grade",
          stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kelpa
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2017
    AND ts.activeflag is true
    AND ts.operationaltestwindowid =10171
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename--,otd.districtname,gc.name
     ,stg.name
    ORDER BY otd.statename,stg.name;    

\COPY (select * from tmp_kelpa) to 'average_duration_domain.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);    


-- KELPA 2017 tests duration (average_duration_domain_grade)
drop table if exists tmp_kelpa;
SELECT    otd.statename "State Name",
          gc.name AS "Grade",
          stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kelpa
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2017
    AND ts.activeflag is true
    AND ts.operationaltestwindowid =10171
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,gc.name, stg.name
    ORDER BY otd.statename,length(gc.name),gc.name,stg.name;    

\COPY (select * from tmp_kelpa) to 'average_duration_domain_grade.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);  

-- KELPA 2017 tests duration (average_duration_domain_grade)
drop table if exists tmp_kelpa;
SELECT    otd.statename "State Name",
          otd.districtname AS "District Name",
          --gc.name AS "Grade",
          stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kelpa
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2017
    AND ts.activeflag is true
    AND ts.operationaltestwindowid =10171
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,otd.districtname--,gc.name
    , stg.name
    ORDER BY otd.statename,otd.districtname,stg.name;    

\COPY (select * from tmp_kelpa) to 'average_duration_domain_district.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--================================================================================================================
-- KELPA 2018 tests duration (average_duration_domain)
drop table if exists tmp_kelpa;
SELECT    otd.statename "State Name",
         -- otd.districtname AS "District Name",
          --gc.name AS "Grade",
          stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kelpa
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid =10252
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename--,otd.districtname,gc.name
     ,stg.name
    ORDER BY otd.statename,stg.name;    

\COPY (select * from tmp_kelpa) to 'average_duration_domain.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);    


-- KELPA 2018 tests duration (average_duration_domain_grade)
drop table if exists tmp_kelpa;
SELECT    otd.statename "State Name",
          gc.name AS "Grade",
          stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kelpa
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid =10252
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,gc.name, stg.name
    ORDER BY otd.statename,length(gc.name),gc.name,stg.name;    

\COPY (select * from tmp_kelpa) to 'average_duration_domain_grade.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);  

-- KELPA 2018 tests duration (average_duration_domain_grade)
drop table if exists tmp_kelpa;
SELECT    otd.statename "State Name",
          otd.districtname AS "District Name",
          --gc.name AS "Grade",
          stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kelpa
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid =10252
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,otd.districtname--,gc.name
    , stg.name
    ORDER BY otd.statename,otd.districtname,stg.name;    

\COPY (select * from tmp_kelpa) to 'average_duration_domain_district.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--================================================================================================================
--Average time to take each test by grade/by phase for KAP and KELPA using our final data

-- KELPA 2018 tests by grade
drop table if exists tmp_kelpa;
SELECT    
          otd.statename "State Name",
          --otd.districtname AS "District Name",
         --gc.name AS "Grade",
         -- t.externalid  "CB TestID",
         -- t.testname    "Test Name",
         stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kelpa
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    inner join test t on t.id=st.testid
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid =10252
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename--,gc.name,
    --t.externalid,t.testname
    ,stg.name
   -- ,otd.districtname
    ORDER BY otd.statename,--t.externalid,
    stg.name;    

-- Please comment columns based on the file names and run below file 
\COPY (select * from tmp_kelpa) to 'KELPA_average_duration_domain_grade_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\COPY (select * from tmp_kelpa) to 'KELPA_average_duration_domain_distric_tes.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\COPY (select * from tmp_kelpa) to 'KELPA_average_duration_domain_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\COPY (select * from tmp_kelpa) to 'KELPA_average_duration_domain.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


-- KAP 2018 tests by grade
drop table if exists tmp_kap;
SELECT    
          otd.statename "State Name",
      --    otd.districtname AS "District Name",
          --gc.name AS "Grade",
          t.externalid  "CB TestID",
         t.testname    "Test Name",
           stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kap
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    inner join test t on t.id=st.testid
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid  in (10258,10261)
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,t.externalid,t.testname--,gc.name
    ,stg.name
    --,otd.districtname
    ORDER BY otd.statename--,length(gc.name),gc.name
    ,stg.name,t.externalid
    ;   

-- Please comment columns based on the file names and run below file 
\COPY (select * from tmp_kap) to 'KAP_average_duration_domain_grade_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\COPY (select * from tmp_kap) to 'KAPaverage_duration_domain_distric_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\COPY (select * from tmp_kap) to 'KAP_average_duration_domain_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\COPY (select * from tmp_kap) to 'KAP_average_duration_domain.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--===============================================================================================================
--average time for students who got a 1 vs 2 vs 3 vs 4 for KAP
-- validation to check duplicate reports 
select  studentid,enrollmentid,contentareaid,count(*)
from studentreport sr  where assessmentprogramid =12 and schoolyear=2018
inner join leveldescription ld on ld.id=sr.levelid
group by studentid,enrollmentid,contentareaid
having count(*)>1;

--1) KAP 2018 tests by grade
drop table if exists tmp_kap;
with std_reports as (select ld.levelname,sr.enrollmentid,sr.studentid,sr.contentareaid 
from studentreport sr  join leveldescription ld on ld.id=sr.levelid
  where sr.assessmentprogramid =12 and sr.schoolyear=2018)
SELECT    
          otd.statename "State Name",
      --    otd.districtname AS "District Name",
          gc.name AS "Grade",
          levelname "Level Name",
          t.externalid  "CB TestID",
         t.testname    "Test Name",
           stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kap
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    inner join test t on t.id=st.testid
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    join std_reports sr on sr.enrollmentid=st.enrollmentid and sr.studentid=st.studentid and sr.contentareaid=tc.contentareaid 
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid  in (10258,10261)
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,t.externalid,t.testname,gc.name
    ,stg.name,levelname
    --,otd.districtname
    ORDER BY otd.statename--,length(gc.name),gc.name
    ,stg.name,t.externalid;

    drop table tmp_kap_level;
    select  "State Name","Grade","CB TestID","Test Name","Domain Name"
         ,max ( case when "Level Name"='Level 1' then "Average Time in Minutes"::char(10) else '' end ) "Level 1" 
         ,max ( case when "Level Name"='Level 2' then "Average Time in Minutes"::char(10) else '' end ) "Level 2" 
         ,max ( case when "Level Name"='Level 3' then "Average Time in Minutes"::char(10) else '' end ) "Level 3" 
         ,max ( case when "Level Name"='Level 4' then "Average Time in Minutes"::char(10) else '' end ) "Level 4" 
         into temp tmp_kap_level
    from  tmp_kap
    group by "State Name","Grade","CB TestID","Test Name","Domain Name"
  order by "State Name","Domain Name","CB TestID";
  
\COPY (select * from tmp_kap_level order by "State Name",length("Grade"),"Grade","Domain Name","CB TestID","Test Name") to 'KAP_average_duration_domain_grade_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--2) KAP 2018 tests by grade
drop table if exists tmp_kap;
with std_reports as (select ld.levelname,sr.enrollmentid,sr.studentid,sr.contentareaid 
from studentreport sr  join leveldescription ld on ld.id=sr.levelid
  where sr.assessmentprogramid =12 and sr.schoolyear=2018)
SELECT    
          otd.statename "State Name",
         otd.districtname AS "District Name",
         -- gc.name AS "Grade",
          levelname "Level Name",
          t.externalid  "CB TestID",
         t.testname    "Test Name",
           stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kap
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    inner join test t on t.id=st.testid
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    join std_reports sr on sr.enrollmentid=st.enrollmentid and sr.studentid=st.studentid and sr.contentareaid=tc.contentareaid 
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid  in (10258,10261)
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,t.externalid,t.testname--,gc.name
    ,stg.name,levelname
    ,otd.districtname
    ORDER BY otd.statename--,length(gc.name),gc.name
    ,stg.name,t.externalid;

    drop table if exists tmp_kap_level;
    select  "State Name","CB TestID","Test Name","District Name","Domain Name"
         ,max ( case when "Level Name"='Level 1' then "Average Time in Minutes"::char(10) else '' end ) "Level 1" 
         ,max ( case when "Level Name"='Level 2' then "Average Time in Minutes"::char(10) else '' end ) "Level 2" 
         ,max ( case when "Level Name"='Level 3' then "Average Time in Minutes"::char(10) else '' end ) "Level 3" 
         ,max ( case when "Level Name"='Level 4' then "Average Time in Minutes"::char(10) else '' end ) "Level 4" 
         into temp tmp_kap_level
    from  tmp_kap
    group by "State Name","CB TestID","Test Name","District Name","Domain Name"
  order by "State Name","District Name","Domain Name","CB TestID";
  
\COPY (select * from tmp_kap_level order by "State Name","District Name","Domain Name","CB TestID","Test Name") to 'KAPaverage_duration_domain_distric_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--3) KAP 2018 tests by grade
drop table if exists tmp_kap;
with std_reports as (select ld.levelname,sr.enrollmentid,sr.studentid,sr.contentareaid 
from studentreport sr  join leveldescription ld on ld.id=sr.levelid
  where sr.assessmentprogramid =12 and sr.schoolyear=2018)
SELECT    
          otd.statename "State Name",
        -- otd.districtname AS "District Name",
         -- gc.name AS "Grade",
          levelname "Level Name",
         -- t.externalid  "CB TestID",
         --t.testname    "Test Name",
           stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kap
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    inner join test t on t.id=st.testid
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    join std_reports sr on sr.enrollmentid=st.enrollmentid and sr.studentid=st.studentid and sr.contentareaid=tc.contentareaid 
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid  in (10258,10261)
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename--,t.externalid,t.testname--,gc.name
    ,stg.name,levelname
    --,otd.districtname
    ORDER BY otd.statename--,length(gc.name),gc.name
    ,stg.name;

    drop table if exists tmp_kap_level;
    select  "State Name","Domain Name"
         ,max ( case when "Level Name"='Level 1' then "Average Time in Minutes"::char(10) else '' end ) "Level 1" 
         ,max ( case when "Level Name"='Level 2' then "Average Time in Minutes"::char(10) else '' end ) "Level 2" 
         ,max ( case when "Level Name"='Level 3' then "Average Time in Minutes"::char(10) else '' end ) "Level 3" 
         ,max ( case when "Level Name"='Level 4' then "Average Time in Minutes"::char(10) else '' end ) "Level 4" 
         into temp tmp_kap_level
    from  tmp_kap
    group by "State Name","Domain Name"
  order by "State Name","Domain Name";
\COPY (select * from tmp_kap_level) to 'KAP_average_duration_domain.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--4) KAP 2018 tests by grade
drop table if exists tmp_kap;
with std_reports as (select ld.levelname,sr.enrollmentid,sr.studentid,sr.contentareaid 
from studentreport sr  join leveldescription ld on ld.id=sr.levelid
  where sr.assessmentprogramid =12 and sr.schoolyear=2018)
SELECT    
          otd.statename "State Name",
        -- otd.districtname AS "District Name",
         -- gc.name AS "Grade",
          levelname "Level Name",
         t.externalid  "CB TestID",
         t.testname    "Test Name",
           stg.name AS "Domain Name",
          round(avg((extract(epoch from st.enddatetime - st.startdatetime))/60)) AS "Average Time in Minutes"
          --,count(st.id) AS "Total Student Tests"
          into temp tmp_kap
    FROM studentstests st
    JOIN testsession ts ON (st.testsessionid = ts.id)
    JOIN stage stg ON (ts.stageid = stg.id)
    JOIN student s ON (s.id = st.studentid)
    inner join test t on t.id=st.testid
    JOIN enrollment en ON en.studentid = s.id and en.id=st.enrollmentid
    JOIN testcollection tc ON st.testcollectionid=tc.id
    join gradecourse gc ON gc.id=en.currentgradelevel
    JOIN organizationtreedetail otd ON (otd.schoolid = en. attendanceschoolid)
    join std_reports sr on sr.enrollmentid=st.enrollmentid and sr.studentid=st.studentid and sr.contentareaid=tc.contentareaid 
    WHERE st.activeflag is true
    AND st.status = 86
    and ts.schoolyear=2018
    AND ts.activeflag is true
    AND ts.operationaltestwindowid  in (10258,10261)
    AND otd.statedisplayidentifier='KS'
    AND st.enddatetime > st.startdatetime
    AND st.enddatetime is NOT NULL 
    AND st.startdatetime is NOT NULL
    and (extract(epoch from st.enddatetime - st.startdatetime)/60)<=90
    GROUP BY otd.statename,t.externalid,t.testname--,gc.name
    ,stg.name,levelname
    --,otd.districtname
    ORDER BY otd.statename--,length(gc.name),gc.name
    ,stg.name;

    drop table if exists tmp_kap_level;
    select "State Name","CB TestID","Test Name","Domain Name"
         ,max ( case when "Level Name"='Level 1' then "Average Time in Minutes"::char(10) else '' end ) "Level 1" 
         ,max ( case when "Level Name"='Level 2' then "Average Time in Minutes"::char(10) else '' end ) "Level 2" 
         ,max ( case when "Level Name"='Level 3' then "Average Time in Minutes"::char(10) else '' end ) "Level 3" 
         ,max ( case when "Level Name"='Level 4' then "Average Time in Minutes"::char(10) else '' end ) "Level 4" 
         into temp tmp_kap_level
    from  tmp_kap
    group by  "State Name","CB TestID","Test Name","Domain Name"
  order by "State Name","CB TestID","Test Name","Domain Name";
\COPY (select * from tmp_kap_level order by "State Name","Domain Name","CB TestID","Test Name") to 'KAP_average_duration_domain_test.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);    

