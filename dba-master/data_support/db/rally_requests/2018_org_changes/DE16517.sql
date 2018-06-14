/*
We are needing a file that lists the window (ITI or Spring) and pool (Operational or Field Test) for each testlet. 
The ideal file will have 3 columns: testletexternalid, window, and pool.
*/

select distinct  tl.externalid  "Testletexternalid",
       case when ts.operationaltestwindowid = 10163 then 'ITI'
	        else 'Spring' end as "Window", 
	   case when ts.operationaltestwindowid in (10176,10186,10178,10180,10202,10204,10182,10190,
	             10192,10194,10208,10198,10196,10206,10184,10188,10199) then 'Fieldtest' 
	        else 'Operational' end  as "Pool"
into tmp_item_information
from studentstests st
join enrollment en on en.id =st.enrollmentid 
 join testsession ts on st.testsessionid=ts.id
 join operationaltestwindow opt on opt.id =ts.operationaltestwindowid
 JOIN studentstestsections sts ON sts.studentstestid = st.id
 JOIN testsection tsec ON sts.testsectionid = tsec.id
 JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
 JOIN testlet tl on tl.id =tstv.testletid
 where st.activeflag is true and en.currentschoolyear=2017  and 
 ts.operationaltestwindowid in (10163,10176,10186,10178,10180,10202,10204,10182,10190,10192,10194,10208,
10198,10196,10206,10184,10188,10199,10175,10185,10177,10179,10209,10201,10203,10181,10189,10191,10193,
10207,10197,10195,10205,10183,10219,10187,10200,10210,10211,10212,10215,10216);
\copy (select * from tmp_item_information order by 1) to 'tmp_testlet_information.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
