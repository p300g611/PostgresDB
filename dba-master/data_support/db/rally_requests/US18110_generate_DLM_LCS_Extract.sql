psql -h tdedb1.prodku.cete.us -U tde_reader tde

\copy ( select * from lcsentries) TO 'TDELCS_Extract_04292016.csv' with CSV HEADER;

psql -h pool.prodku.cete.us -U aart_reader aart-prod

create temporary table tmp_LCS(lcsid text,studentstestsid bigint);

\COPY tmp_LCS FROM 'TDELCS_Extract_04292016.csv' DELIMITER ',' CSV HEADER ;

select distinct st.statestudentidentifier, st.legalfirstname as studentfirstname, st.legallastname as studentlastname,
       otd.districtname, otd.statename,au.firstname as teacherfirstname, otd.schoolname, au.surname as teacherlastname, au.email as teacheremail,
       t.testname, stb.createddate as trackercreateddate, sts.enddatetime - interval '5 hours' as TestEndTime, stb.id as studenttrackerbandid, sts.id as studentstestid
     INTO temp table lcs_extract
      from studenttracker str
      join studenttrackerband stb on stb.studenttrackerid = str.id
      join studentstests sts on sts.testsessionid = stb.testsessionid
      join tmp_LCS tlcs on tlcs.studentstestsid = sts.id
      join test t on t.id = sts.testid
      join student st on st.id = str.studentid
      join testsession ts on ts.id = stb.testsessionid
      join roster r on r.id = ts.rosterid
      join aartuser au on au.id = r.teacherid
      join organizationtreedetail otd on otd.schoolid = ts.attendanceschoolid
      where str.id = stb.studenttrackerid and sts.startdatetime::date>'04/15/2016'::date
      and stb.operationalwindowid in (10123,
10156,
10134,
10155,
10152,
10153,
10144,
10154,
10139,
10135,
10136,
10137,
10142,
10140,
10141,
10138,
10146,
10145,
10147)
order by st.statestudentidentifier, stb.id;

\copy (SELECT * FROM lcs_extract) TO 'DLM_LCS_04292016.csv' DELIMITER ',' CSV HEADER;
