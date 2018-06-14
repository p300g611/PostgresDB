/*
--validation
Drop table if exists input_id;
Drop table if exists tmp_merge;

create temporary table input_id (studenttest_id bigint, roster_id bigint);

\COPY input_id FROM 'updateinfo.csv' DELIMITER ',' CSV HEADER; 

select   studenttest_id, roster_id into temp tmp_merge from input_id;

select studenttest_id from tmp_merge tmp
left outer join studentstests st on st.id =tmp.studenttest_id
where st.id is null;

select distinct roster_id from tmp_merge tmp
left outer join roster st on st.id =tmp.roster_id
where st.id is null;

select studenttest_id, count(*)from tmp_merge group by studenttest_id having count(*)>1;

select studenttest_id,iti.id,roster_id,ts.rosterid,iti.rosterid as itirosterid from tmp_merge tmp
inner join studentstests st on st.id = tmp.studenttest_id
inner join testsession ts on ts.id = st.testsessionid
left outer join ititestsessionhistory iti on iti.testsessionid=ts.id
where iti.rosterid is null;

select studenttest_id,sc.id,roster_id,ts.rosterid,sc.rosterid as scrosterid from tmp_merge tmp
inner join studentstests st on st.id = tmp.studenttest_id
inner join testsession ts on ts.id = st.testsessionid
left outer join scoringassignment sc on sc.testsessionid=ts.id
*/
do 
$BODY$
DECLARE
update_num int;

data bigint[][]= ARRAY[
					[14504309,1073235],
					[14504295,1073235],
					[14504298,1073235],
					[14581911,1080703],
					[14581910,1080703],
					[14581912,1080703],
					[14581909,1080703],
					[14581921,1080703],
					[14581919,1080703],
					[14581918,1080703],
					[14581916,1080703],
					[14644826,1098485],
					[14644823,1098485],
					[14644808,1098485],
					[14644807,1098485],
					[14644805,1098485],
					[14644803,1098485],
					[14644789,1098485],
					[14644428,1098485],
					[14644031,1098485],
					[14644018,1098485],
					[14644007,1098485],
					[14644001,1098485],
					[14643994,1098485],
					[14643991,1098485],
					[14644773,1098485],
					[14644771,1098485],
					[14644770,1098485],
					[14644769,1098485],
					[14644733,1098485],
					[14644731,1098485],
					[14644725,1098485],
					[14644722,1098485],
					[14644644,1098485],
					[14644642,1098485],
					[14644639,1098485],
					[14644635,1098485],
					[14644531,1098485],
					[14644528,1098485],
					[14615630,1099469],
					[14615627,1099469],
					[14615622,1099469],
					[14615601,1099469],
					[14615598,1099469],
					[14615593,1099469],
					[14615591,1099469]

    
];
BEGIN

FOR i in array_lower(data,1)..array_upper(data,1) LOOP

update testsession 
set   rosterid=data[i][2],
       modifieddate=now(),
	   modifieduser =12
where id = (select testsessionid from studentstests where id = data[i][1]);

update ititestsessionhistory
set    rosterid=data[i][2],
       modifieddate=now(),
	   modifieduser=12
where  testsessionid = (select testsessionid from studentstests where id = data[i][1]);

END LOOP;
END;
$BODY$;