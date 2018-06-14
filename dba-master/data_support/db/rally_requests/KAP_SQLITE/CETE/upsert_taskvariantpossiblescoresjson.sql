create temp table tmp_cb_item (externaltaskid bigint,externaltaskvariantid bigint,passage_id text,item_name text,type_of_TE_item text,
                            numberofpossiblescores_count integer,numberofpossiblescores text,max_score integer,scoring_type text,item_response_1 integer,item_response_2 integer,
			    item_response_3 integer,item_response_4 integer,item_response_5 integer,item_response_6 integer,item_response_7 integer,item_response_8 integer,
			    item_response_9 integer,item_response_10 integer,item_response_11 integer,item_response_12 integer,primary_contend_code text,secondary_contend_code text,
			    cognitive_complexity_framework text,item_cognitive_level text,target_grade_of_item text,item_content_codes text,organizationname text,tasktypecode text,
			    responsescore integer,scoringmethod text);
\COPY tmp_cb_item FROM '/srv/extracts/CETE/tmp_final_report.csv' DELIMITER ',' CSV HEADER ; 

update taskvariantpossiblescoresjson src
set numberofpossiblescores_count=tgt.numberofpossiblescores_count,
numberofpossiblescores=tgt.numberofpossiblescores,
max_score=tgt.max_score,
scoring_type=tgt.scoring_type,
modifieddate=now(),
modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
from tmp_cb_item tgt where src.externaltaskvariantid=tgt.externaltaskvariantid
and (
coalesce(src.numberofpossiblescores_count,0)<>coalesce(tgt.numberofpossiblescores_count,0) or
coalesce(src.numberofpossiblescores,'')<>coalesce(tgt.numberofpossiblescores,'') or
coalesce(src.max_score,0)<>coalesce(tgt.max_score,0) or 
coalesce(src.scoring_type,'')<>coalesce(tgt.scoring_type,''));

insert into taskvariantpossiblescoresjson(externaltaskvariantid,
numberofpossiblescores_count,
numberofpossiblescores,
max_score,
scoring_type,
createddate,
createduser,
modifieddate,
modifieduser
)
select distinct src.externaltaskvariantid,
 src.numberofpossiblescores_count,
src.numberofpossiblescores,
src.max_score,
src.scoring_type,
now() createddate,
(select id from aartuser where email ='ats_dba_team@ku.edu') createduser,
now() modifieddate,
(select id from aartuser where email ='ats_dba_team@ku.edu') modifieduser from tmp_cb_item src 
left outer join  taskvariantpossiblescoresjson tgt 
on src.externaltaskvariantid=tgt.externaltaskvariantid
where tgt.externaltaskvariantid is null;



