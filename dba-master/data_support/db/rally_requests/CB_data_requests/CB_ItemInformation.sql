--Step1.Calculation for partialcredit:
select taskvariantid,scoringdata  into temp tmp_pcscores from cb.taskvariant tv where scoringmethod ='partialcredit';
\copy (select * from tmp_pcscores) to 'tmp_pcscores.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- Local table creation Postgres 9.2 does not support only local 9.3
--=======================================================================
create temp table tmp_pcscores2 (taskvariantid text ,scoringdata text);
\COPY tmp_pcscores2 FROM 'tmp_pcscores.csv' DELIMITER ',' CSV HEADER ; 
-- select * into   tmp_pcscores2_bkup from tmp_pcscores2;
alter table tmp_pcscores2 add jsondata json;
alter table tmp_pcscores2 add scoringdatanew json;
-- validation
-- select * from tmp_pcscores2 where scoringdatanew::text ilike '%partialResponses%'  ;
-- select * from tmp_pcscores2 where scoringdatanew::text not ilike '%partialResponses%'  ;
-- select * from tmp_pcscores2 where jsondata is null ;
-- some of those in incorrect format only when they have partial
update tmp_pcscores2 set scoringdatanew=scoringdata::json;
update tmp_pcscores2 set jsondata=scoringdatanew::json->'partialResponses'
where scoringdatanew::text ilike '%partialResponses%'; 
-- select taskvariantid,json_array_elements(jsondata)->>'score' scores,'' possibleval  from tmp_pcscores2 where jsondata is not null order by 1;--use query execute to file
\copy (select taskvariantid,json_array_elements(jsondata)->>'score' scores,'' possibleval  from tmp_pcscores2 where jsondata is not null order by 1) to 'tmp_possibleval.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=======================================================================
-- Switch back to CB server
create  temp table  tmp_possibleval  (taskvariantid bigint ,scores text,possibleval text);
\COPY tmp_possibleval FROM 'tmp_possibleval.csv' DELIMITER ',' CSV HEADER ;  
 
--  select * from tmp_possibleval;
--  insert into tmp_possibleval
--  select taskvariantid::bigint,json_array_elements(jsondata)->>'score' scores,'' possibleval  from tmp_pcscores2 where jsondata is not null order by taskvariantid;

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
			               where taskvariantid=tmp_table.taskvariantid order by 1,2)
			  LOOP 
			        select  tmp_table.scores::numeric into tmp_table.scores;
			        total:=total::numeric+tmp_table.scores::numeric;
			        msg:=msg||','||round(total,3);
			        raise info 'msg:%',msg;end loop;
	update tmp_possibleval set possibleval=msg where taskvariantid=tmp_table.taskvariantid; 		        
   end loop;
end;
$$;  

--Step2.Calculation for subtractivemodel:
select taskvariantid,scoringdata  into temp tmp_smscores from cb.taskvariant tv where scoringmethod ='subtractivemodel';
\copy (select * from tmp_smscores) to 'tmp_smscores.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
-- Local table creation Postgres 9.2 does not support only local 9.3
--=======================================================================
create temp table tmp_smscores2 (taskvariantid text ,scoringdata text);
\COPY tmp_smscores2 FROM 'tmp_smscores.csv' DELIMITER ',' CSV HEADER ; 
alter table tmp_smscores2 add jsondata json;
alter table tmp_smscores2 add scoringdatanew json;
-- validation
-- select * from tmp_smscores2 where scoringdatanew::text ilike '%partialResponses%'  ;
-- select * from tmp_smscores2 where scoringdatanew::text not ilike '%partialResponses%'  ;
-- select * from tmp_smscores2 where jsondata is null ;
--some of those in incorrect format only when they have partial

update tmp_smscores2 set scoringdatanew=scoringdata::json;
update tmp_smscores2 set jsondata=scoringdatanew::json->'partialResponses'
where scoringdatanew::text ilike '%partialResponses%';
\copy (select taskvariantid,json_array_elements(jsondata)->>'score' scores,'' possibleval  from tmp_smscores2 where jsondata is not null order by 1) to 'tmp_sm_possibleval.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=======================================================================
-- Switch back to CB server
create  temp table  tmp_sm_possibleval  (taskvariantid bigint ,scores text,possibleval text);
\COPY tmp_sm_possibleval FROM 'tmp_sm_possibleval.csv' DELIMITER ',' CSV HEADER ;  

do 
$$
declare id bigint ;
        msg text ;
        total numeric;
        tmp_table record;
begin
total:=0;

FOR tmp_table IN (select distinct taskvariantid from tmp_sm_possibleval order by 1)
  LOOP  
  msg:='0';
  total=0;
  raise info 'id:%',tmp_table.taskvariantid;
                     FOR tmp_table IN (select taskvariantid, scores from tmp_sm_possibleval  
			               where taskvariantid=tmp_table.taskvariantid and scores::numeric>0 order by 1,2)
			  LOOP 
			        select  tmp_table.scores::numeric into tmp_table.scores;
			        total:=total::numeric+tmp_table.scores::numeric;
			        msg:=msg||','||round(total,3);
			        raise info 'msg:%',msg;end loop;
	update tmp_sm_possibleval set possibleval=msg where taskvariantid=tmp_table.taskvariantid; 		        
   end loop;
end;
$$;  


--\copy (select * from tmp_sm_possibleval order by 1, scores::numeric ;) to 'tmp_pcscores.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
/*
alter table tmp_sm_possibleval add possibleval_new text;
create  temp table  tmp_sm_possibleval_new  (taskvariantid bigint ,scores text,possibleval text);

do 
$$
declare id bigint ;
        msg text ;
        total numeric;
        tmp_table record;
begin
total:=0;

FOR tmp_table IN (select distinct taskvariantid from tmp_sm_possibleval order by 1)
  LOOP  
  msg:='';
  total=0;
  raise info 'id:%',tmp_table.taskvariantid;
                     FOR tmp_table IN (select taskvariantid, scores from tmp_sm_possibleval
			               where taskvariantid=tmp_table.taskvariantid order by 1,2)
			  LOOP 
			        select  tmp_table.scores::numeric into tmp_table.scores;
			        total:=total::numeric+tmp_table.scores::numeric;
			        --msg:=msg||','||round(total,3);
			        insert into tmp_sm_possibleval_new(taskvariantid,scores)
			        select tmp_table.taskvariantid,round(total,3);
			        raise info 'total:%',total;end loop;
	--update tmp_sm_possibleval set possibleval=msg where taskvariantid=tmp_table.taskvariantid; 		        
   end loop;
end;
$$;  	


-- select taskvariantid, array_to_string(array_agg(distinct scores::text), ',') as new  from  
-- tmp_sm_possibleval_new
-- where taskvariantid=9
-- group by taskvariantid;


update tmp_sm_possibleval src
set possibleval_new=tmp.possibleval_new
from (select taskvariantid, array_to_string(array_agg(distinct scores::text), ',') as possibleval_new  from  
tmp_sm_possibleval_new
group by taskvariantid) tmp where tmp.taskvariantid=src.taskvariantid;


update tmp_sm_possibleval src
set possibleval_new=  case when possibleval_new ilike '%0.000%' then possibleval_new else '0.000'||','||possibleval_new end;
*/
-- \copy (select * from tmp_sm_possibleval order by 1) to 'tmp_sm_possibleval_cal.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
---------------------------------------------------------------------------------------------------
--Step3.Report creation:
--  select * from tmp_possibleval order by 1,2;    
-- \copy (select * from tmp_possibleval order by 1,2) to 'scoresfile.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 
-- Find the correct response for taskvariant
drop table if exists tmp_foil;
select tv.taskvariantid,SUM(case when  correctresponse is true then 1 else 0 end ) Numberofcorrectfoils 
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf 
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,99)=0 limit 1) correctresponsefoilsorder_0
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf 
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=1 limit 1) correctresponsefoilsorder_1
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=2 limit 1) correctresponsefoilsorder_2
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=3 limit 1) correctresponsefoilsorder_3
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf 
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=4 limit 1) correctresponsefoilsorder_4
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf 
		  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=5 limit 1) correctresponsefoilsorder_5
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=6 limit 1) correctresponsefoilsorder_6
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=7 limit 1) correctresponsefoilsorder_7
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf 
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=8 limit 1) correctresponsefoilsorder_8
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf 
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=9 limit 1) correctresponsefoilsorder_9
        ,(select case when correctresponse is true  then true else false end from cb.taskvariantresponse stvf 
                  where stvf.taskvariantid =tv.taskvariantid and coalesce(stvf.multipartid,0) =coalesce(tv.multipartid,0) and coalesce(responseorder,0)=10 limit 1) correctresponsefoilsorder_10
        ,tv.multipartid 
        ,mtv.scoringdependency
          into temp tmp_foil
          from cb.taskvariantresponse tv 
inner join cb.taskvariant tvid on tvid.taskvariantid=tv.taskvariantid and tvid.inuse is true
left outer join cb.multiparttaskvariant mtv on  tv.multipartid=mtv.multipartid and tv.taskvariantid=mtv.taskvariantid 
group by tv.taskvariantid,tv.multipartid,scoringdependency;
-- Main script 
 SELECT
	     ca.name 				taskcontentareaname
	    ,case when gc.name is not null then gc.name else gb.name end  testgrade	    
	    ,cfd.contentcode 			contentframeworkdetailcode
	    ,tfd.isprimary 			primarycontentframeworkdetail
	    ,ctd.name                           cognitivecategoryname
            ,t.taskid                           externaltaskid
            ,tv.taskvariantid                   externaltaskvariantid
            ,t.taskname                         taskname
            ,tv.name                            variantname
            ,stt.abbreviation                   tasktypecode 
            ,stst.abbreviation                  tasksubtypecode
            ,tmp.Numberofcorrectfoils           Numberofcorrectfoils
	    ,tmp.correctresponsefoilsorder_0	correctresponsefoilsorder_0
	    ,tmp.correctresponsefoilsorder_1	correctresponsefoilsorder_1
	    ,tmp.correctresponsefoilsorder_2	correctresponsefoilsorder_2
	    ,tmp.correctresponsefoilsorder_3	correctresponsefoilsorder_3
	    ,tmp.correctresponsefoilsorder_4	correctresponsefoilsorder_4
	    ,tmp.correctresponsefoilsorder_5	correctresponsefoilsorder_5
	    ,tmp.correctresponsefoilsorder_6	correctresponsefoilsorder_6
	    ,tmp.correctresponsefoilsorder_7	correctresponsefoilsorder_7
	    ,tmp.correctresponsefoilsorder_8	correctresponsefoilsorder_8
	    ,tmp.correctresponsefoilsorder_9	correctresponsefoilsorder_9
	    ,tmp.correctresponsefoilsorder_10	correctresponsefoilsorder_10
	    ,t.maxscore			        itemmaxscore
	    ,null::integer			responsescore
            ,tv.scoringmethod			Scoringmethod
            ,case when tv.approvedstatus=0 then 'Approved' else 'Unapproved' end approvedstatus
            ,case when tv.status=2 then 'Draft' else 'Complete' end status
            ,t.scoringneeded scoringneeded
	    ,tmp.Numberofcorrectfoils		Numberofcorrectresponses
	    ,case when scoringmethod='correctOnly'   then '0,'||t.maxscore
	          when scoringmethod='Dependent'     then '0,'|| 
	                  case when replace(substring(scoringdata ,strpos(scoringdata,'"Primary","score":"'),case  when strpos(scoringdata,'"Primary","score":"') =0 then 0 else 24 end),'"Primary","score":"','') ='0' then 
	                          t.maxscore::text else replace(substring(scoringdata ,strpos(scoringdata,'"Primary","score":"'),case  when strpos(scoringdata,'"Primary","score":"') =0 then 0 else 24 end),'"Primary","score":"','')||',' ||t.maxscore end 
	         	else '' end                    Numberofpossiblescores
	    ,null::integer                      Numberofpossiblescores_count
	    ,m.mediaid			        mediaID 
	    ,m.mediatitle			PassageTitle
	    ,tmp.multipartid                    multiparttaskvariantid
	    ,scoringdependency                  multipartscoringdependency 
	    ,o.name                             organizationname
	     into temp tmp_final_report       
from cb.taskvariant tv 
   inner join organization_ o on o.organizationid=tv.organizationid
   inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
   Inner join tmp_foil tmp on tmp.taskvariantid=tv.taskvariantid
   left outer join cb.taskcontentframeworkdetails tfd on tfd.taskid=t.taskid and o.organizationid=tfd.organizationid
   left outer join cb.contentframeworkdetail cfd on tfd.contentframeworkdetailid=cfd.contentframeworkdetailid 
   left outer join cb.gradecourse gc on t.gradecourseid=gc.gradecourseid and o.organizationid=gc.organizationid and gc.inuse is true 
   left outer join cb.contentarea ca on t.contentareaid=ca.contentareaid and o.organizationid=ca.organizationid and ca.inuse is true 
   left outer join cb.tasktype tt on tt.tasktypeid=t.tasktypeid  and tt.inuse is true and o.organizationid=tt.organizationid
   left outer join cb.systemrecord stt on stt.id=tt.systemrecordid  and stt.inuse is true 
   left outer join cb.tasksubtype tst on t.tasksubtypeid=tst.tasksubtypeid  and tt.tasktypeid=tst.tasktypeid  and tst.inuse is true
   left outer join cb.systemrecord stst on stst.id=tst.systemrecordid  and stst.inuse is true 
   left outer join cb.cognitivetaxonomydimension ctd on ctd.cognitivetaxonomydimensionid=t.cognitivetaxonomydimensionid  and ctd.inuse is true and o.organizationid=ctd.organizationid
   left outer join cb.taskvariantmediavariant tmtv on tv.taskvariantid=tmtv.taskvariantid and coalesce(tmp.multipartid,0)=coalesce(tmtv.multipartid,0)
   left outer join cb.mediavariant mtv on tmtv.mediavariantid=mtv.mediavariantid and o.organizationid=mtv.organizationid and mtv.inuse is true 
   left outer join cb.media m on m.mediaid=mtv.mediaid and o.organizationid=m.organizationid and m.inuse is true    
   left outer join cb.systemrecord gb on t.gradebandid=gb.id      
   where  tv.inuse is true and t.inuse is true
          and o.organizationid not in (16800,18404) --Playground states
   order by o.name,tv.taskvariantid; 



update tmp_final_report src
set Numberofpossiblescores=tmp.possibleval
from (select distinct  taskvariantid,possibleval from tmp_possibleval) tmp where tmp.taskvariantid=src.externaltaskvariantid;

update tmp_final_report src
set Numberofpossiblescores=tmp.possibleval
from (select distinct  taskvariantid,possibleval from tmp_sm_possibleval) tmp where tmp.taskvariantid=src.externaltaskvariantid;

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
select tvr.taskvariantid,multipartid,case when tvr.new ilike '%0%' then tvr.new else '0,'||tvr.new end Numberofpossiblescores,
case when tvr.new ilike '%0%' then tvr.cnt else tvr.cnt+1 end Numberofpossiblescores_count from tmp_final_report src 
inner join (                
select tvr.taskvariantid,multipartid, array_to_string(array_agg(distinct  responsescore::text), ',') new ,count(distinct responsescore) cnt 
from cb.taskvariantresponse tvr 
where correctresponse is true
group by taskvariantid,multipartid ) tvr on tvr.taskvariantid=src.externaltaskvariantid  
where   tasktypecode in ('MC-S') and coalesce(Numberofpossiblescores_count,0)=0) tvr    
where  tvr.taskvariantid=src.externaltaskvariantid and coalesce(src.multiparttaskvariantid,0)=coalesce(tvr.multipartid,0); 


    

\copy (select distinct * from tmp_final_report where  organizationname<>'K-ELPA') to 'tmp_final_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);       
\copy (select distinct * from tmp_final_report where  organizationname<>'K-ELPA') to 'tmp_final_report.txt'  delimiter ',' CSV HEADER;

\copy (select distinct * from tmp_final_report where  organizationname='K-ELPA') to 'tmp_final_report_kelpa.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);       
\copy (select distinct * from tmp_final_report where  organizationname='K-ELPA') to 'tmp_final_report_kelpa.txt'  delimiter ',' CSV HEADER;



 /*
 --validation

 select distinct *  into temp tmp_final from tmp_final_report;
  select count(*) from (
 select contentframeworkdetailcode , primarycontentframeworkdetail,  externaltaskvariantid,multiparttaskvariantid,count(*)
from tmp_final
group by contentframeworkdetailcode , primarycontentframeworkdetail,  externaltaskvariantid,multiparttaskvariantid
having count(*)>1)tt;

---should be zero
select contentframeworkdetailcode , primarycontentframeworkdetail,  externaltaskvariantid,multiparttaskvariantid,mediaid,count(*)
from tmp_final
group by contentframeworkdetailcode , primarycontentframeworkdetail,  externaltaskvariantid,multiparttaskvariantid,mediaid
having count(*)>1;

select  externaltaskvariantid,count(distinct organizationname)
from tmp_final
group by   externaltaskvariantid
having count(distinct organizationname)>1;

select count(*) from tmp_final where taskcontentareaname is null ;
select count(*) from tmp_final where testgrade is null ;
 */       