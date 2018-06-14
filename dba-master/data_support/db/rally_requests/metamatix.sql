
--load the table into local
create temp table   tmp_meta (student_id text ,item_id bigint,stage text,item_number bigint,response text,score text);
\COPY tmp_meta FROM 'KS_Metametrics_Student_Responses.csv' DELIMITER ',' CSV HEADER ;

select distinct item_id  id into temp tmp_tv from tmp_meta ;

--validation only ELA,Math
select tv.externalid,count(distinct ca.id) from taskvariant tv 
inner join tmp_tv tmp on tmp.id=tv.externalid
inner join  testsectionstaskvariants ttv on ttv.taskvariantid=tv.id
inner join  testsection ts on ttv.testsectionid=ts.id
inner join  test t on t.id=ts.testid
inner join  contentarea ca on ca.id=t.contentareaid
group by tv.externalid
having count(distinct ca.id)>1;

--ela report
select tmp.* into temp KS_Metametrics_Student_Responses_ELA from tmp_meta tmp
inner join (select  tmp.id from taskvariant tv 
		inner join tmp_tv tmp on tmp.id=tv.externalid
		inner join  testsectionstaskvariants ttv on ttv.taskvariantid=tv.id
		inner join  testsection ts on ttv.testsectionid=ts.id
		inner join  test t on t.id=ts.testid
		inner join  contentarea ca on ca.id=t.contentareaid
		where ca.id=3
		group by tmp.id ) ela on tmp.item_id=ela.id;
--math report
select tmp.* into temp KS_Metametrics_Student_Responses_M from tmp_meta tmp
inner join (select  tmp.id from taskvariant tv 
		inner join tmp_tv tmp on tmp.id=tv.externalid
		inner join  testsectionstaskvariants ttv on ttv.taskvariantid=tv.id
		inner join  testsection ts on ttv.testsectionid=ts.id
		inner join  test t on t.id=ts.testid
		inner join  contentarea ca on ca.id=t.contentareaid
		where ca.id=440
		group by tmp.id
		) ela on tmp.item_id=ela.id;

--final validation 
select count(*) from KS_Metametrics_Student_Responses_M	;
select count(*) from KS_Metametrics_Student_Responses_ELA;
select count(*) from tmp_meta	;

--\copy (select * from KS_Metametrics_Student_Responses_M ) to 'KS_Metametrics_Student_Responses_M.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 		
\copy (select * from KS_Metametrics_Student_Responses_M ) to 'KS_Metametrics_Student_Responses_M.csv' DELIMITER ',' CSV HEADER ;		
--\copy (select * from KS_Metametrics_Student_Responses_ELA ) to 'KS_Metametrics_Student_Responses_ELA.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 		
\copy (select * from KS_Metametrics_Student_Responses_ELA ) to 'KS_Metametrics_Student_Responses_ELA.csv' DELIMITER ',' CSV HEADER ;		