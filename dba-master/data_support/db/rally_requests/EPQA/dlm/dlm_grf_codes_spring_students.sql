drop table if exists tmp_grf_tab;
with tmp_grf as (
select id,ee1||''||ee2||''||ee3||''||ee4||''||ee5||''||ee6||''||ee7||''||ee8||''||ee9||''||ee10||''||ee11||''||ee12||''||ee13||''||ee14||''||ee15||''||ee16||''||ee17||''||ee18||''||ee19||''||ee20||''||ee21||''||ee22||''||ee23||''||ee24||''||ee25||''||ee26
 grf_codes from uploadgrffile where  invalidationcode=0 and reportyear =2018)
select  
id
,grf_codes
,(length(grf_codes)-length(replace(grf_codes::text,0::text,''))) noof0s  
,(length(grf_codes)-length(replace(grf_codes::text,1::text,''))) noof1s  
,(length(grf_codes)-length(replace(grf_codes::text,2::text,''))) noof2s  
,(length(grf_codes)-length(replace(grf_codes::text,3::text,''))) noof3s  
,(length(grf_codes)-length(replace(grf_codes::text,4::text,''))) noof4s  
,(length(grf_codes)-length(replace(grf_codes::text,5::text,''))) noof5s  
,(length(grf_codes)-length(replace(grf_codes::text,6::text,''))) noof6s  
,(length(grf_codes)-length(replace(grf_codes::text,7::text,''))) noof7s  
,(length(grf_codes)-length(replace(grf_codes::text,8::text,''))) noof8s  
,(length(grf_codes)-length(replace(grf_codes::text,9::text,''))) noof9s  
into temp tmp_grf_tab  
from tmp_grf;

drop table if exists tmp_epqa;
select --distinct 
  s.studentid studentid
 ,s.statestudentidentifier 
 ,s.studentlegalfirstname         
 ,s.studentlegalmiddlename        
 ,s.studentlegallastname          
 ,s.generationcode        
 ,to_char(s.dateofbirth  ,'mm/dd/yyyy') dateofbirth
 ,s.gradeid
 ,s.subjectid  
 ,grf_codes
 
 ,noof3s
 ,noof4s
 ,noof5s
 ,noof9s
 ,noof4s+noof5s noof45s
 ,3*noof3s sumofnoof3s 
 ,4*noof4s+5*noof5s  sumofnoof45s     
 ,1*noof1s+2*noof2s+3*noof3s+4*noof4s+5*noof5s+6*noof6s+7*noof7s+8*noof8s            sumofnon9s   
 ,1*noof1s+2*noof2s+3*noof3s+4*noof4s+5*noof5s+6*noof6s+7*noof7s+8*noof8s+9*noof9s   sumofnoofall  

--  ,noof0s  
--  ,noof1s  
--  ,noof2s  
--  ,noof3s  
--  ,noof4s  
--  ,noof5s  
--  ,noof6s  
--  ,noof7s  
--  ,noof8s  
--  ,noof9s  
--  ,noof1s+noof2s+noof3s+noof4s+noof5s+noof6s+noof7s+noof8s+noof9s                     countofnon0s   
--  ,noof0s+noof1s+noof2s+noof3s+noof4s+noof5s+noof6s+noof7s+noof8+noof9s               countofall  
--  ,1*noof1s+2*noof2s+3*noof3s+4*noof4s+5*noof5s+6*noof6s+7*noof7s+8*noof8s            sumofnon9s   
--  ,1*noof1s+2*noof2s+3*noof3s+4*noof4s+5*noof5s+6*noof6s+7*noof7s+8*noof8s+9*noof9s   sumofnoofall 
 
  into temp tmp_epqa
from uploadgrffile s 
inner join tmp_grf_tab tmp on tmp.id=s.id;

\copy (select * from tmp_epqa) to 'dlm_grf_code_spring_students.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);




