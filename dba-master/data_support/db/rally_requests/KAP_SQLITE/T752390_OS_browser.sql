-- TDE connection
--2016      --psql -h tdedb1.prodku.cete.us -U tde_reader tde
--2015,2014 --psql -h archdb1.prodku.cete.us  -U tde_reader tde_20150922
begin;
SELECT   t.typecode studentstestssectionsid,
                 case   when attrvalue ilike '%iPad; CPU%'       then 'iPad'
			when attrvalue ilike '%iPad; U%'         then 'iPad'
			when attrvalue ilike '%iPod; CPU%'       then 'iPad'
			when attrvalue ilike '%iPhone; CPU%'     then 'iPad'
			when attrvalue ilike '%Mac OS%'          then 'Mac'
			when attrvalue ilike '%Windows NT%'      then 'PCs'  
			when attrvalue ilike '%X11; CrOS%'       then 'ChromeOS'  
			when attrvalue ilike '%Linux%'           then 'Linux'
			when attrvalue ilike '%MobileSafari%'    then 'iPad'
			when attrvalue ilike '%Web/1.0%'         then 'PCs'
			when attrvalue ilike '%MacBook%'         then 'Mac'
			when attrvalue ilike '%Windows Phone%'   then 'iPad'
			when attrvalue ilike '%Mercury/810%'     then 'PCs'
			when attrvalue ilike '%Android; Mobile%' then 'iPad'
			else attrvalue end OSBrowser
           into temp tmp_OSBrowser
       FROM tracker_attrs ta 
       Inner JOIN tracker t ON ta.trackerid = t.id
       WHERE t.goaltype = 'Os-Browser' and typename='StudentTestSection'
         and coalesce(attrvalue,'') not in ('TDE-ChromeAgent','TdeLcs');

select sts.id studentstestssectionsid,
 case when useros ilike '%iPad; CPU%'       then 'iPad'
			when useros ilike '%iPad; U%'         then 'iPad'
			when useros ilike '%iPod; CPU%'       then 'iPad'
			when useros ilike '%iPhone; CPU%'     then 'iPad'
			when useros ilike '%Mac OS%'          then 'Mac'
			when useros ilike '%Windows NT%'      then 'PCs'  
			when useros ilike '%X11; CrOS%'       then 'ChromeOS'  
			when useros ilike '%Linux%'           then 'Linux'
			when useros ilike '%MobileSafari%'    then 'iPad'
			when useros ilike '%Web/1.0%'         then 'PCs'
			when useros ilike '%MacBook%'         then 'Mac'
			when useros ilike '%Windows Phone%'   then 'iPad'
			when useros ilike '%Mercury/810%'     then 'PCs'
			when useros ilike '%Android; Mobile%' then 'iPad'
			else useros end OSBrowser
           into temp tmp_OSBrowser_sa
 from studentaudit sa
 inner join studentstests st on st.studentid=sa.studentid
 inner join studentstestsections sts on st.id=sts.studentstestsid
 where coalesce(useros,'') not in ('TDE-ChromeAgent','TdeLcs');


select sa.studentid studentid,
    case   when useros ilike '%iPad; CPU%'       then 'iPad'
			when useros ilike '%iPad; U%'         then 'iPad'
			when useros ilike '%iPod; CPU%'       then 'iPad'
			when useros ilike '%iPhone; CPU%'     then 'iPad'
			when useros ilike '%Mac OS%'          then 'Mac'
			when useros ilike '%Windows NT%'      then 'PCs'  
			when useros ilike '%X11; CrOS%'       then 'ChromeOS'  
			when useros ilike '%Linux%'           then 'Linux'
			when useros ilike '%MobileSafari%'    then 'iPad'
			when useros ilike '%Web/1.0%'         then 'PCs'
			when useros ilike '%MacBook%'         then 'Mac'
			when useros ilike '%Windows Phone%'   then 'iPad'
			when useros ilike '%Mercury/810%'     then 'PCs'
			when useros ilike '%Android; Mobile%' then 'iPad'
			else useros end OSBrowser
           into temp tmp_OSBrowser_notest
 from studentaudit sa
 left outer join studentstests st on st.studentid=sa.studentid
 where coalesce(useros,'') not in ('TDE-ChromeAgent','TdeLcs','35.0) Gecko/20100101  TDE-IPADAgent','KITEClient/38.7.0/KITEWin/3.0.0') and st.studentid is null;

 
 \copy (select studentstestssectionsid::bigint,OSBrowser from tmp_OSBrowser union select studentstestssectionsid::bigint,OSBrowser from tmp_OSBrowser_sa) to 'tmp_OSBrowser.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select studentid,OSBrowser from tmp_OSBrowser_notest ) to 'tmp_OSBrowser_notest.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
rollback;
--EP connection
--2016      --psql -h pool.prodku.cete.us -U aart_reader aart-prod
--2014      --psql -h archdb1.prodku.cete.us  -U aart_reader aart_20141220
begin;
create temp table  tmp_OSBrowser ( studentstestssectionsid bigint , OSBrowser text);
\copy tmp_OSBrowser from 'tmp_OSBrowser.csv' delimiter ',' csv header;

create temp table  tmp_OSBrowser_notest ( studentid bigint , OSBrowser text);
\copy tmp_OSBrowser_notest from 'tmp_OSBrowser_notest.csv' delimiter ',' csv header;

select st.studentid studentid,
       st.id  studentstestsid,
       array_to_string(array_agg(distinct tmp.OSBrowser), '; ') OSBrowser 
                into temp tmp_OSBrowser_ep
FROM studentstests st
            Inner JOIN  test t ON st.testid = t.id
            Inner JOIN  studentstestsections sts ON sts.studentstestid = st.id
            Inner JOIN  testcollectionstests tct ON st.testid = tct.testid
            Inner JOIN  testcollection tc ON tc.id = tct.testcollectionid
            Inner JOIN  contentarea ca ON ca.id = tc.contentareaid
            Inner JOIN  assessmentstestcollections atc ON tc.id = atc.testcollectionid
            Inner JOIN  assessment a ON atc.assessmentid = a.id
            Inner JOIN  testingprogram tp ON a.testingprogramid = tp.id
            Inner JOIN  assessmentprogram ap ON tp.assessmentprogramid = ap.id
            Inner JOIN  testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id
            Inner JOIN  enrollment e ON st.enrollmentid = e.id
            left outer join  tmp_OSBrowser tmp on sts.id=tmp.studentstestssectionsid
            WHERE ap.id in (12,37) and ca.id in (3,440)  and e.currentgradelevel in (86,7,91,90)
                AND e.currentschoolyear=2014 AND st.activeflag='t' --2016
 group by st.studentid,st.id;   

-- tde no tests
update tmp_OSBrowser_ep ep
set OSBrowser=tmp.OSBrowser
from ( select studentid,array_to_string(array_agg(distinct OSBrowser), '; ') OSBrowser 
	 from tmp_OSBrowser_notest 
	 group by studentid) tmp 
	 where tmp.studentid=ep.studentid and coalesce(ep.OSBrowser,'')='';

-- ep no tests
update tmp_OSBrowser_ep ep
set OSBrowser=notest.OSBrowser
from ( select studentid,array_to_string(array_agg(distinct OSBrowser), '; ') OSBrowser 
	from   (select sa.studentid studentid,
		 case   when useros ilike '%iPad; CPU%'       then 'iPad'
			when useros ilike '%iPad; U%'         then 'iPad'
			when useros ilike '%iPod; CPU%'       then 'iPad'
			when useros ilike '%iPhone; CPU%'     then 'iPad'
			when useros ilike '%Mac OS%'          then 'Mac'
			when useros ilike '%Windows NT%'      then 'PCs'  
			when useros ilike '%X11; CrOS%'       then 'ChromeOS'  
			when useros ilike '%Linux%'           then 'Linux'
			when useros ilike '%MobileSafari%'    then 'iPad'
			when useros ilike '%Web/1.0%'         then 'PCs'
			when useros ilike '%MacBook%'         then 'Mac'
			when useros ilike '%Windows Phone%'   then 'iPad'
			when useros ilike '%Mercury/810%'     then 'PCs'
			when useros ilike '%Android; Mobile%' then 'iPad'
			else useros end OSBrowser
		 from studentaudit sa
		 where coalesce(useros,'') not in ('TDE-ChromeAgent','TdeLcs') )tmp
	 group by studentid) notest 
	 where notest.studentid=ep.studentid and coalesce(ep.OSBrowser,'')='';

\copy (select * from tmp_OSBrowser_ep where coalesce(OSBrowser,'')<>'' ) to 'OSBrowser_2014.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); --2016

rollback;

--EP connection
--2015      --psql -h archdb1.prodku.cete.us  -U aart_reader aartarchive
begin;

-- On archive no test collection to identify the KAP or AMP tests so we copy from prod(EP-2016)
-- psql -h pool.prodku.cete.us -U aart_reader aart-prod --only for test collections
select distinct tc.id
               into temp tmp_testcollection
            from testcollectionstests tct 
            Inner JOIN  testcollection tc ON tc.id = tct.testcollectionid
            Inner JOIN  contentarea ca ON ca.id = tc.contentareaid
            Inner JOIN  assessmentstestcollections atc ON tc.id = atc.testcollectionid
            Inner JOIN  assessment a ON atc.assessmentid = a.id
            Inner JOIN  testingprogram tp ON a.testingprogramid = tp.id
            Inner JOIN  assessmentprogram ap ON tp.assessmentprogramid = ap.id
            where  ap.id in (12,37) and ca.id in (3,440);
\copy (select id from tmp_testcollection ) to 'tmp_testcollection.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
-- switch back to 2015   
create temp table  tmp_testcollection (testcollectionid bigint );
\copy tmp_testcollection from 'tmp_testcollection.csv' delimiter ',' csv header;
 
create temp table  tmp_OSBrowser ( studentstestssectionsid bigint , OSBrowser text);
\copy tmp_OSBrowser from 'tmp_OSBrowser.csv' delimiter ',' csv header;

create temp table  tmp_OSBrowser_notest ( studentid bigint , OSBrowser text);
\copy tmp_OSBrowser_notest from 'tmp_OSBrowser_notest.csv' delimiter ',' csv header;

select st.studentid studentid,
       st.id  studentstestsid,
       array_to_string(array_agg(distinct tmp.OSBrowser), '; ') OSBrowser 
                into temp tmp_OSBrowser_ep
    from studentstests st
	inner join studentstestsections sts on sts.studentstestid = st.id 
	inner join studentenrollment sten on sten.studentid = st.studentid
	inner join tmp_testcollection tc on tc.testcollectionid = st.studentstests_testcollectionid
	left outer join  tmp_OSBrowser tmp on sts.id=tmp.studentstestssectionsid
	  where sten.currentgradelevel in (86,7,91,90) and 
              (coalesce(sten.assessmentprogramcode,'') ilike '%KAP%' or 
               coalesce(sten.assessmentprogramcode,'') ilike '%AMP%')
               group by st.studentid,st.id;   

-- tde no tests

select count(distinct studentid) from tmp_OSBrowser_ep where coalesce(OSBrowser,'')='';

select studentid,array_to_string(array_agg(distinct OSBrowser), '; ') OSBrowser 
     into temp tmp_OSBrowser_notest_agg
	 from tmp_OSBrowser_notest 
	 group by studentid;

-- update tmp_OSBrowser_ep ep
-- set OSBrowser=tmp.OSBrowser
-- from ( select studentid,array_to_string(array_agg(distinct OSBrowser), '; ') OSBrowser 
-- 	 from tmp_OSBrowser_notest 
-- 	 group by studentid) tmp 
-- 	 where tmp.studentid=ep.studentid and coalesce(ep.OSBrowser,'')='';

 update tmp_OSBrowser_ep ep
 set OSBrowser=tmp.OSBrowser
 from tmp_OSBrowser_notest_agg tmp 
 	 where tmp.studentid=ep.studentid and coalesce(ep.OSBrowser,'')='';	 


\copy (select * from tmp_OSBrowser_ep where coalesce(OSBrowser,'')<>'' ) to 'OSBrowser_2015.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

rollback; 







    

