psql -h tdedb1.prodku.cete.us -U tde_reader tde

\copy ( select * from lcsentries) TO 'TDELCS_Extract_12012016.csv' with CSV HEADER;

psql -h pool.prodku.cete.us -U aart_reader aart-prod

create temporary table tmp_LCS(lcsid text,studentstestsid bigint);

\COPY tmp_LCS FROM 'TDELCS_Extract_12012016.csv' DELIMITER ',' CSV HEADER ;

select distinct 
      otd.schoolid, otd.schoolname, otd.districtid, otd.districtname,  otd.statename
 INTO temp table lcs_extract
      from student stu
	  join enrollment en on en.studentid =stu.id
      join studentstests sts on sts.enrollmentid = en.id
      join tmp_LCS tlcs on tlcs.studentstestsid = sts.id
      join organizationtreedetail otd on otd.schoolid = en.attendanceschoolid
	  where en.currentschoolyear =2017 limit 10;
      
\copy (SELECT * FROM lcs_extract) TO 'DLM_LCS_12012016.csv' DELIMITER ',' CSV HEADER;

