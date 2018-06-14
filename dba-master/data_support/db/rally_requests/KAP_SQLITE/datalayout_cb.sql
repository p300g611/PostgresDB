-- Find possible score, number of possible scores, ittem key-current version
drop table if exists tmp_pcscores;
select taskvariantid,scoringdata  into temp tmp_pcscores from cb.taskvariant tv where scoringmethod ='partialcredit' or scoringmethod ='subtractivemodel';
\copy (select * from tmp_pcscores) to 'tmp_pcscores.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- Local table creation Postgres 9.2 does not support only local 9.3
drop table if exists  tmp_pcscores2;
create temp table tmp_pcscores2 (taskvariantid text ,scoringdata text);
\COPY tmp_pcscores2 FROM 'tmp_pcscores.csv' DELIMITER ',' CSV HEADER ; 
alter table tmp_pcscores2 add jsondata json;
alter table tmp_pcscores2 add scoringdatanew json;
update tmp_pcscores2 set scoringdatanew=scoringdata::json;
update tmp_pcscores2 set jsondata=scoringdatanew::json->'partialResponses'
where scoringdatanew::text ilike '%partialResponses%'; 
\copy (select taskvariantid,json_array_elements(jsondata)->>'score' scores,'' possibleval  from tmp_pcscores2 where jsondata is not null order by 1) to 'tmp_possibleval.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- Switch back to CB server
drop table if exists  tmp_possibleval;
create  temp table  tmp_possibleval  (taskvariantid bigint ,scores text,possibleval text);
\COPY tmp_possibleval FROM 'tmp_possibleval.csv' DELIMITER ',' CSV HEADER ;  
 
do 
$$
declare id bigint ;
        msg text ;
        total numeric;
        tmp_table record;
begin
total:=0;

FOR tmp_table IN (select distinct taskvariantid from tmp_possibleval order by 1)
  LOOP  
  msg:='0';
  total=0;
  raise info 'id:%',tmp_table.taskvariantid;
                     FOR tmp_table IN (select taskvariantid, scores from tmp_possibleval
			               where taskvariantid=tmp_table.taskvariantid and scores::numeric>0 order by 1,2)
			  LOOP 
			        select  tmp_table.scores::numeric into tmp_table.scores;
			        total:=total::numeric+tmp_table.scores::numeric;
			        msg:=msg||','||round(total,3);
			        raise info 'msg:%',msg;end loop;
	update tmp_possibleval set possibleval=msg where taskvariantid=tmp_table.taskvariantid; 		        
   end loop;
end;
$$;  

-- Main script 
drop table if exists tmp_tv_cr_order;
with tv_order as(
select tv.taskvariantid,responseorder+1 responseorder_new,partorder,correctresponse,
row_number() over (partition by tv.taskvariantid order by partorder,responseorder) row_num_res
from cb.taskvariantresponse tv 
inner join cb.taskvariant tvid on tvid.taskvariantid=tv.taskvariantid and tvid.inuse is true
left outer join cb.multiparttaskvariant mtv on  tv.multipartid=mtv.multipartid and tv.taskvariantid=mtv.taskvariantid 
order by tv.taskvariantid,partorder,responseorder
)
select taskvariantid,row_num_res,row_number() over (partition by taskvariantid order by row_num_res) row_num_cr
  into temp tmp_tv_cr_order  
from tv_order where correctresponse is true;

CREATE INDEX idx_tmp_tv_cr_order ON tmp_tv_cr_order USING btree(taskvariantid);

drop table if exists tmp_foil;
select 
taskvariantid
,count(*) Noofcr
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=1) cr1
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=2) cr2
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=3) cr3
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=4) cr4
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=5) cr5
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=6) cr6
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=7) cr7
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=8) cr8
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=9) cr9
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=10) cr10
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=11) cr11
,(select row_num_res from tmp_tv_cr_order res where res.taskvariantid=cr.taskvariantid and res.row_num_cr=12) cr12
into temp tmp_foil
from tmp_tv_cr_order cr
group by taskvariantid; 

drop table if exists tmp_final_report;
 SELECT distinct 
	         t.taskid                           externaltaskid
		,tv.taskvariantid                   externaltaskvariantid
                ,(select  array_to_string(array_agg(distinct m.mediaid ), ',') from 
		   cb.taskvariantmediavariant tmtv 
		   left outer join cb.mediavariant mtv on tmtv.mediavariantid=mtv.mediavariantid and o.organizationid=mtv.organizationid and mtv.inuse is true 
		   left outer join cb.media m on m.mediaid=mtv.mediaid and o.organizationid=m.organizationid and m.inuse is true  
		   where tv.taskvariantid=tmtv.taskvariantid )   passage_id
		,tv.name                           item_name
		,tst.name                          type_of_TE_item
		,null::integer                     Numberofpossiblescores_count
		,case when scoringmethod='correctOnly'   then '0,'||t.maxscore
	           when scoringmethod='Dependent'     then '0,'|| 
	           case when replace(substring(scoringdata ,strpos(scoringdata,'"Primary","score":"'),case  when strpos(scoringdata,'"Primary","score":"') =0 then 0 else 24 end),'"Primary","score":"','') ='0' then 
	           t.maxscore::text else replace(substring(scoringdata ,strpos(scoringdata,'"Primary","score":"'),case  when strpos(scoringdata,'"Primary","score":"') =0 then 0 else 24 end),'"Primary","score":"','')||',' ||t.maxscore end 
	         	else '' end                 Numberofpossiblescores
	        ,t.maxscore                         max_score
		,tv.scoringmethod		    scoring_type
		,tmp.cr1                            item_response_1
		,tmp.cr2                            item_response_2
		,tmp.cr3                            item_response_3
		,tmp.cr4                            item_response_4
		,tmp.cr5                            item_response_5
		,tmp.cr6                            item_response_6
		,tmp.cr7                            item_response_7
		,tmp.cr8                            item_response_8
		,tmp.cr9                            item_response_9
		,tmp.cr10                           item_response_10
		,tmp.cr11                           item_response_11
		,tmp.cr12                           item_response_12
		,(select array_to_string(array_agg(distinct cfd.contentcode), ',') from  cb.taskcontentframeworkdetails tfd 
                         left outer join cb.contentframeworkdetail cfd on tfd.contentframeworkdetailid=cfd.contentframeworkdetailid 
                         where tfd.taskid=t.taskid and o.organizationid=tfd.organizationid and tfd.isprimary is true 
                         group by tfd.taskid)       primary_contend_code
		,(select array_to_string(array_agg(distinct cfd.contentcode), ',')  from  cb.taskcontentframeworkdetails tfd
                         left outer join cb.contentframeworkdetail cfd on tfd.contentframeworkdetailid=cfd.contentframeworkdetailid 
                          where tfd.taskid=t.taskid and o.organizationid=tfd.organizationid and tfd.isprimary is false 
                          group by tfd.taskid)      secondary_contend_code
		,ctt.name                           cognitive_complexity_framework
		,ctd.name                           item_cognitive_level
		,gc.name                            target_grade_of_item 
		,ca.name                            item_content_codes
		,o.name                             organizationname
		,stt.abbreviation                   tasktypecode 
		,null::integer			    responsescore
		,tv.scoringmethod		    scoringmethod
	      into temp tmp_final_report   
   from cb.taskvariant tv 
   inner join organization_ o on o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   left outer join tmp_foil tmp on tmp.taskvariantid=tv.taskvariantid   
   left outer join cb.gradecourse gc on t.gradecourseid=gc.gradecourseid and o.organizationid=gc.organizationid and gc.inuse is true 
   left outer join cb.contentarea ca on t.contentareaid=ca.contentareaid and o.organizationid=ca.organizationid and ca.inuse is true 
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.systemrecord stt on stt.id=tt.systemrecordid  and stt.inuse is true 
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid  and tt.tasktypeid=tst.tasktypeid  and tst.inuse is true
   left outer join cb.systemrecord stst on stst.id=tst.systemrecordid  and stst.inuse is true 
   left outer join cb.cognitivetaxonomydimension ctd on ctd.cognitivetaxonomydimensionid=t.cognitivetaxonomydimensionid  and ctd.inuse is true and o.organizationid=ctd.organizationid
   left outer join cb.cognitivetaxonomy ctt on ctt.cognitivetaxonomyid=t.cognitivetaxonomyid and ctt.inuse is true and o.organizationid=ctt.organizationid
   left outer join cb.systemrecord gb on t.gradebandid=gb.id 
   where  tv.inuse is true and t.inuse is true
          and o.organizationid not in (16800,18404) --Playground states
   order by tv.taskvariantid; 

update tmp_final_report src
set Numberofpossiblescores=tmp.possibleval
from (select distinct  taskvariantid,possibleval from tmp_possibleval) tmp where tmp.taskvariantid=src.externaltaskvariantid;

update tmp_final_report src
set Numberofpossiblescores_count= case when coalesce(Numberofpossiblescores,'')='' then null
                                       when length(Numberofpossiblescores)=length(replace(Numberofpossiblescores,',','')) then 1
                                       else length(Numberofpossiblescores)-length(replace(Numberofpossiblescores,',',''))+1 end
   ,responsescore= case when tasktypecode in ('MC-K','T-F','MC-MS') then 
                         (select responsescore from cb.taskvariantresponse tvr where correctresponse is true and tvr.taskvariantid=src.externaltaskvariantid limit 1)   
                        else  null end;

update tmp_final_report src
set Numberofpossiblescores_count= case when  responsescore is null then null else 2 end 
   ,Numberofpossiblescores= case when  responsescore is null then '' else '0,'||responsescore end 
where tasktypecode in ('MC-K','T-F') and coalesce(Numberofpossiblescores_count,0)=0;  

update tmp_final_report src
set Numberofpossiblescores_count= case when  responsescore is null then null else 2 end 
   ,Numberofpossiblescores= case when  responsescore is null then '' else '0,'||responsescore end 
where tasktypecode in ('MC-MS') and coalesce(Numberofpossiblescores_count,0)=0 and scoringmethod='correctOnly';  


update tmp_final_report src
set Numberofpossiblescores_count= tvr.Numberofpossiblescores_count 
   ,Numberofpossiblescores=tvr.Numberofpossiblescores
from (                
select tvr.taskvariantid,case when tvr.new ilike '%0%' then tvr.new else '0,'||tvr.new end Numberofpossiblescores,
case when tvr.new ilike '%0%' then tvr.cnt else tvr.cnt+1 end Numberofpossiblescores_count from tmp_final_report src 
inner join (                
select tvr.taskvariantid, array_to_string(array_agg(distinct  responsescore::text), ',') new ,count(distinct responsescore) cnt 
from cb.taskvariantresponse tvr 
where correctresponse is true
group by taskvariantid) tvr on tvr.taskvariantid=src.externaltaskvariantid  
where   tasktypecode in ('MC-S') and coalesce(Numberofpossiblescores_count,0)=0) tvr    
where  tvr.taskvariantid=src.externaltaskvariantid; 
    

\copy (select distinct * from tmp_final_report) to 'tmp_final_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 