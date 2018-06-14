-- Local table creation Postgres 9.2 does not support only local 9.3
--drop table if exists  tmp_pcscores2;
create temp table tmp_pcscores2 (taskvariantid text ,scoringdata text);
\COPY tmp_pcscores2 FROM '/srv/extracts/CETE/tmp_pcscores.csv' DELIMITER ',' CSV HEADER ; 
alter table tmp_pcscores2 add jsondata json;
alter table tmp_pcscores2 add scoringdatanew json;
update tmp_pcscores2 set scoringdatanew=scoringdata::json;
update tmp_pcscores2 set jsondata=scoringdatanew::json->'partialResponses'
where scoringdatanew::text ilike '%partialResponses%'; 
\copy (select taskvariantid,json_array_elements(jsondata)->>'score' scores,'' possibleval  from tmp_pcscores2 where jsondata is not null order by 1) to '/srv/extracts/CETE/tmp_possibleval.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
