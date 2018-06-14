-- =======================================================================
-- script has dependency need to run one step at a time
-- prod-aart
-- =======================================================================
select tv.id,tv.externalid,scoringmethod,code,scoringdata from taskvariant tv left outer join tasktype tp on tv.tasktypeid=tp.id order by externalid desc,id desc; 

\copy (select  * from tmp_max_tv order by externalid desc,id desc) to 'tmp_final_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select distinct tv.id,tv.externalid,tv.scoringmethod,tp.code,tv.scoringdata
into temp tmp_max_tv
 from taskvariant tv 
inner join (select max(tv.id) id,tv.externalid from taskvariant tv group by tv.externalid) tv_max on tv_max.id=tv.id
left outer join tasktype tp on tv.tasktypeid=tp.id
order by externalid desc,id desc;

\copy (select  * from tmp_max_tv order by externalid desc,id desc) to 'tmp_final_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 
-- =======================================================================
-- Local table creation Postgres 9.2 does not support only local 9.3(aartdw dev)
-- =======================================================================
-- step1:copy data
drop table if exists tmp_pcscores2;
create temp table tmp_pcscores2 (id bigint,externalid bigint,scoringmethod text,code text,scoringdata text);
\COPY tmp_pcscores2 FROM 'tmp_final_report.csv' DELIMITER ',' CSV HEADER ; 

-- select  scoringmethod,count(*) from tmp_pcscores2 
-- group by scoringmethod;
--   scoringmethod   | count
-- ------------------+--------
--                   | 368833
--  partialcredit    |  23968
--  correctOnly      |  30854
--  subtractivemodel |   2753
--  Dependent        |    473
--  partialquota     |     72
-- (6 rows)


-- step2:alter table need at json conversion
alter table tmp_pcscores2 add scoringdatanew json;
alter table tmp_pcscores2 add scoringdataprjs json;
alter table tmp_pcscores2 add scoringdatacrjs json;
alter table tmp_pcscores2 add scoringdataaljs json;
alter table tmp_pcscores2 add zero json;
alter table tmp_pcscores2 add one json;
alter table tmp_pcscores2 add two json;
alter table tmp_pcscores2 add three json;
alter table tmp_pcscores2 add four json;
alter table tmp_pcscores2 add five json;
alter table tmp_pcscores2 add six json;
alter table tmp_pcscores2 add seven json;
alter table tmp_pcscores2 add eight json;
alter table tmp_pcscores2 add nine json;
alter table tmp_pcscores2 add ten json;

-- step3:json field data population

update tmp_pcscores2 set scoringdatanew=scoringdata::json;

update tmp_pcscores2 set scoringdataprjs=scoringdatanew::json->'partialResponses'
where scoringdatanew::text ilike '%partialResponses%'; 

update tmp_pcscores2 set scoringdatacrjs=scoringdatanew::json->'correctResponses'
where scoringdatanew::text ilike '%correctResponses%';

update tmp_pcscores2 set scoringdataaljs=scoringdatanew::json->'allFoilsSelectedScore'
where scoringdatanew::text ilike '%allFoilsSelectedScore%';

update tmp_pcscores2 set scoringdatacrjs=scoringdatanew::json->'correctResponse'
where scoringdatanew::text ilike '%correctResponse%'and scoringdatacrjs is null;

-- step4:json conversion
create temp table tmp_tv_score(id bigint, code text, scoringmethod_org text, scroingmethod text,score text ,indexs text);

insert into tmp_tv_score
select id,code,scoringmethod,'partialResponses' "partialResponses",
json_array_elements(scoringdataprjs)->>'score' score , json_array_elements(scoringdataprjs)->>'index' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%partialResponses%'
union all
select id,code,scoringmethod,'correctResponses' "correctResponses",
json_array_elements(scoringdatacrjs)->>'score' score , json_array_elements(scoringdatacrjs)->>'index' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponses%'
union all
select id,code,scoringmethod,'allFoilsSelectedScore' "allFoilsSelectedScore",
scoringdataaljs->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%allFoilsSelectedScore%';

-- step5:json conversion
insert into tmp_tv_score
select src.id,src.code,src.scoringmethod,'correctResponse' "correctResponse",
src.scoringdatacrjs->>'score' score , scoringdatacrjs->>'index' "index"
from tmp_pcscores2 src
left outer join tmp_tv_score tgt on src.id=tgt.id
where src.scoringdatanew::text ilike '%correctResponse%' and tgt.score is null;

-- step6:json conversion
insert into tmp_tv_score
select src.id,src.code,src.scoringmethod,'correctResponse' "correctResponse",
json_array_elements(scoringdatacrjs)->>'score' score  , '' "index"
from tmp_pcscores2 src
left outer join tmp_tv_score tgt on src.id=tgt.id
where src.scoringdatanew::text ilike '%correctResponse%' and tgt.score is null and src.code='MP';

-- step7:json conversion
--special cases for CR and ITP items
--CR/correct
update tmp_pcscores2 set zero=scoringdata::json->0
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set one=scoringdata::json->1
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set two=scoringdata::json->2
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set three=scoringdata::json->3
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set four=scoringdata::json->4
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set five=scoringdata::json->5
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set six=scoringdata::json->6
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set seven=scoringdata::json->7
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set eight=scoringdata::json->8
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set nine=scoringdata::json->9
where scoringdatanew::text ilike '%correctResponse%' and code='CR';
update tmp_pcscores2 set ten=scoringdata::json->10
where scoringdatanew::text ilike '%correctResponse%' and code='CR';





-- step8:json conversion
insert into tmp_tv_score
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
(zero::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_1' "correctResponses_cr_1",
(one::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_2' "correctResponses_cr_2",
(two::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_3' "correctResponses_cr_3",
(three::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_4' "correctResponses_cr_4",
(four::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_5' "correctResponses_cr_5",
(five::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_6' "correctResponses_cr_6",
(six::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_7' "correctResponses_cr_7",
(seven::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_8' "correctResponses_cr_8",
(eight::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_9' "correctResponses_cr_9",
(nine::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_10' "correctResponses_cr_10",
(ten::json->>'correctResponse')::json->>'score' score , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR';

-- step9:json conversion
--CR/acceptableResponses
update tmp_pcscores2 set zero=scoringdata::json->0
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set one=scoringdata::json->1
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set two=scoringdata::json->2
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set three=scoringdata::json->3
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set four=scoringdata::json->4
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set five=scoringdata::json->5
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set six=scoringdata::json->6
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set seven=scoringdata::json->7
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set eight=scoringdata::json->8
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set nine=scoringdata::json->9
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';
update tmp_pcscores2 set ten=scoringdata::json->10
where scoringdatanew::text ilike '%acceptableResponses%' and code='CR';




-- step10:json conversion
--validation loop max is four 
-- select count(*) from (
-- select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
-- ((seven::json->>'acceptableResponses')::json->0)::json->>'score' score, '' "index"
-- from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR') aa where score>'';

insert into tmp_tv_score
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((one::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((one::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((one::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((one::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((one::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((one::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((two::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((two::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((two::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((two::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((two::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((two::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((three::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((three::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((three::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((three::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((three::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((three::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((four::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((four::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((four::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((four::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((four::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((four::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((five::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((five::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((five::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((five::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((five::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((five::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((six::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((six::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((six::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((six::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((six::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((six::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((seven::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((seven::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((seven::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((seven::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((seven::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((seven::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((eight::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((eight::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((eight::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((eight::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((eight::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((eight::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((nine::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((nine::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((nine::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((nine::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((nine::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((nine::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((ten::json->>'acceptableResponses')::json->0)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((ten::json->>'acceptableResponses')::json->1)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((ten::json->>'acceptableResponses')::json->2)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((ten::json->>'acceptableResponses')::json->3)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((ten::json->>'acceptableResponses')::json->4)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR'
union all
select id,code,scoringmethod,'correctResponses_cr_0' "correctResponses_cr_0",
((ten::json->>'acceptableResponses')::json->5)::json->>'score' , '' "index"
from tmp_pcscores2 where scoringdatanew::text ilike '%correctResponse%' and code='CR';


-- Method1: for validation 1 to 1 mapping for code validation

with agg_tv as
(select id,array_to_string(array_agg( distinct score::text), ',') newscore from tmp_tv_score where score::text>''
group by id)
select tv.id,tv.externalid,tv.scoringmethod,tv.code,tmp.newscore,tv.scoringdata
into temp tmp_tv_agg_score_report
from tmp_pcscores2 tv
left outer join agg_tv tmp on tmp.id=tv.id;


\copy (select  * from tmp_tv_agg_score_report order by externalid desc,id desc) to 'tmp_tv_agg_score_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- Method2: for validation 1 to many (tv-score) for score validation

with agg_tv as
(select distinct id,score::text newscore from tmp_tv_score where score::text>''
)
select tv.id,tv.externalid,tv.scoringmethod,tv.code,
tmp.newscore,split_part(tmp.newscore ,'.',2) newscore_split_part2,length(split_part(tmp.newscore ,'.',2)) len_newscore_split_part2,
tv.scoringdata
into temp tmp_tv_score_report
from tmp_pcscores2 tv
left outer join agg_tv tmp on tmp.id=tv.id;


\copy (select  * from tmp_tv_score_report order by externalid desc,id desc) to 'tmp_tv_score_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


with agg_tv as
(select distinct id,score::text newscore from tmp_tv_score where score::text>''
)
select tv.id,tv.externalid,tv.scoringmethod,tv.code,
tmp.newscore,split_part(tmp.newscore ,'.',2) newscore_split_part2,length(split_part(tmp.newscore ,'.',2)) len_newscore_split_part2,
length(tv.scoringdata::char(10)) scoringdata
into temp tmp_tv
from tmp_pcscores2 tv
left outer join agg_tv tmp on tmp.id=tv.id;


\copy (select  * from tmp_tv order by externalid desc,id desc) to 'tmp_tv.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

