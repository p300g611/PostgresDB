--CB DATABASE Information
drop table if exists tmp_cb_item;
create temp table tmp_cb_item (externaltaskid bigint,externaltaskvariantid bigint,passage_id text,item_name text,type_of_TE_item text,
                            numberofpossiblescores_count integer,numberofpossiblescores text,max_score integer,scoring_type text,item_response_1 integer,item_response_2 integer,
			    item_response_3 integer,item_response_4 integer,item_response_5 integer,item_response_6 integer,item_response_7 integer,item_response_8 integer,
			    item_response_9 integer,item_response_10 integer,item_response_11 integer,item_response_12 integer,primary_contend_code text,secondary_contend_code text,
			    cognitive_complexity_framework text,item_cognitive_level text,target_grade_of_item text,item_content_codes text,organizationname text,tasktypecode text,
			    responsescore integer,scoringmethod text);
\COPY tmp_cb_item FROM 'tmp_final_report.csv' DELIMITER ',' CSV HEADER ; 

--Test Identification
--Note:For interim uncomment below two lines and str.assessmentprogramid=0
drop table if exists tmp_studentstests;
SELECT  distinct
 ap.abbreviatedname            assessment_name
,tp.programname                program_name
,sub.abbreviatedname           test_subject
,gc.abbreviatedname            test_grade
,t.id                          form_identifier
,(select count(tinn.id) from test tinn where tinn.externalid=t.externalid) form_version 
,t.externalid                  test_cbid
,t.testname                    testname
,t.testinternalname            testInternalName 
,st.startdatetime              start_time
,st.enddatetime                end_time
,case when st.status =86 then round(extract(epoch from st.enddatetime - st.startdatetime)/60)
      else null end            total_elapsed_time	     
,ca.categorycode               test_status
,st.interimtheta               interimtheta
,ts.stageid                    stage
,sc.cedscode                   sc_code
,st.studentid                  studentid
,st.id                         studentstestsid
,ts.rosterid                   rosterid
,e.id                          enrollmentid
,tc.contentareaid              contentareaid 
 into temp tmp_studentstests
from studentstests st
INNER JOIN testsession ts on ts.id =st.testsessionid and ts.activeflag is true
INNER JOIN category ca on ca.id =st.status
INNER JOIN test t on t.id =st.testid 
INNER JOIN testspecstatementofpurpose tstop on t.testspecificationid=tstop.testspecificationid
INNER JOIN category ct on ct.id=tstop.statementofpurposeid and ct.categorycode='INSTRCT' AND tp.programname ='Interim'
INNER JOIN enrollment e ON st.enrollmentid = e.id
inner join gradecourse egc  on e.currentgradelevel=egc.id
INNER JOIN testcollectionstests tct ON t.id = tct.testid
INNER JOIN testcollection tc ON tc.id = tct.testcollectionid
LEFT OUTER JOIN contentarea sub on sub.id =tc.contentareaid
LEFT OUTER JOIN gradecourse gc on gc.id =tc.gradecourseid
INNER JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
INNER JOIN assessment a ON atc.assessmentid = a.id
INNER JOIN testingprogram tp ON a.testingprogramid = tp.id
INNER JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id 
LEFT JOIN studentspecialcircumstance stsc ON (st.id = stsc.studenttestid) and stsc.activeflag is true
LEFT JOIN specialcircumstance sc ON (stsc.specialcircumstanceid = sc.id)
where st.activeflag is true 
 and e.currentschoolyear=2017 and ap.id=12;

CREATE INDEX idx_se_studentstests ON tmp_studentstests   USING btree (studentid,enrollmentid);
CREATE INDEX idx_st_studentstests ON tmp_studentstests   USING btree (studentstestsid);

--Find subscore and subscoredefinitionname
drop table if exists tmp_subscore;
select str.id studentreportid,str.studentid,str.enrollmentid,str.rawscore,str.contentareaid
,str.scalescore
,str.subscore
,ld.level    performance_level
,MAX(case when rss.subscoredefinitionname ='Claim_1_all'         then rss.rating end) as    	      Claim_1_all_rating         
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_1' then rss.rating end) as    	      Claim_1_Rpt_Group_1_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_2' then rss.rating end) as    	      Claim_1_Rpt_Group_2_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_3' then rss.rating end) as    	      Claim_1_Rpt_Group_3_rating
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_4' then rss.rating end) as    	      Claim_1_Rpt_Group_4_rating
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_5' then rss.rating end) as    	      Claim_1_Rpt_Group_5_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_6' then rss.rating end) as    	      Claim_1_Rpt_Group_6_rating
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_7' then rss.rating end) as    	      Claim_1_Rpt_Group_7_rating
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_8' then rss.rating end) as    	      Claim_1_Rpt_Group_8_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_9' then rss.rating end) as    	      Claim_1_Rpt_Group_9_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_2_all'         then rss.rating end) as    	      Claim_2_all_rating
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_1' then rss.rating end) as    	      Claim_2_Rpt_Group_1_rating
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_2' then rss.rating end) as    	      Claim_2_Rpt_Group_2_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_3' then rss.rating end) as    	      Claim_2_Rpt_Group_3_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_3_all'         then rss.rating end) as    	      Claim_3_all_rating 
,MAX(case when rss.subscoredefinitionname ='Claim_4_all'         then rss.rating end) as    	      Claim_4_all_rating 
,MAX(case when rss.subscoredefinitionname ='Mega_claim_2_3_4'    then rss.rating end) as    	      Mega_claim_2_3_4_rating
,MAX(case when rss.subscoredefinitionname ='Claim_1_all'         then rss.subscorerawscore end) as    Claim_1_all_subscore        
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_1' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_1_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_2' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_2_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_3' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_3_subscore
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_4' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_4_subscore
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_5' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_5_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_6' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_6_subscore
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_7' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_7_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_8' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_8_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_9' then rss.subscorerawscore end) as    Claim_1_Rpt_Group_9_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_2_all'         then rss.subscorerawscore end) as    Claim_2_all_subscore
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_1' then rss.subscorerawscore end) as    Claim_2_Rpt_Group_1_subscore
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_2' then rss.subscorerawscore end) as    Claim_2_Rpt_Group_2_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_3' then rss.subscorerawscore end) as    Claim_2_Rpt_Group_3_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_3_all'         then rss.subscorerawscore end) as    Claim_3_all_subscore 
,MAX(case when rss.subscoredefinitionname ='Claim_4_all'         then rss.subscorerawscore end) as    Claim_4_all_subscore 
,MAX(case when rss.subscoredefinitionname ='Mega_claim_2_3_4'    then rss.subscorerawscore end) as    Mega_claim_2_3_4_subscore
into temp tmp_subscore  
from reportsubscores rss 
inner join studentreport str on rss.studentreportid=str.id and str.studentid=rss.studentid
LEFT OUTER JOIN leveldescription ld on str.levelid=ld.id
where str.schoolyear=2017 and str.assessmentprogramid=0
and exists (select 1 from tmp_studentstests tmp where tmp.studentid=str.studentid and tmp.enrollmentid=str.enrollmentid)
group by str.id,str.studentid,str.enrollmentid,str.rawscore,str.contentareaid
,str.scalescore
,str.subscore
,ld.level;
 

CREATE INDEX idx_se_tmp_subscore ON tmp_subscore   USING btree (studentid,enrollmentid);

--PNP extract
drop table if exists tmp_pnp;
SELECT
s.id                     studentid,
spiav.id                 valueid,
piac.attributecontainer  attributecontainer,
pia.attributename        attributename,
spiav.selectedvalue      "value"
 into temp tmp_pnp
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join gradecourse egc  on e.currentgradelevel=egc.id
JOIN studentassessmentprogram sap ON sap.studentid = s.id
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc
ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid in (select organizationid from orgassessmentprogram where assessmentprogramid=12) AND e.currentschoolyear=2017
and exists (select 1 from tmp_studentstests tmp where tmp.studentid=e.studentid and tmp.enrollmentid=e.id);

--\copy (select  * from tmp_pnp) to 'kap_pnp.txt' (FORMAT CSV,DELIMITER('|'), HEADER TRUE, FORCE_QUOTE *);

--Student characteristics
drop table if exists tmp_student;
select distinct
 s.statestudentidentifier            student_state_identifier
,ot.statedisplayidentifier           student_state
,s.id                                studentid
,gc.abbreviatedname                  academic_grade_level
,fl.categoryname                     student_first_language
,to_char(s.dateofbirth, 'MMDDYYYY')  dob
,case when s.gender = 1 then 'M' when s.gender = 0 then 'F' else '' end                        gender
,s.comprehensiverace                                                                           race
,case when s.hispanicethnicity is true then 'T'
      when s.hispanicethnicity is false then 'N' else null end                                 hispanic
,case when coalesce(esolparticipationcode,'')='' then null else esolparticipationcode end      ELL
,case when coalesce(primarydisabilitycode,'')='' then 'N' else primarydisabilitycode end       disability_exceptionality
,case when e.giftedstudent is true then 'T' else 'N' end                                       giftedcode
,case when coalesce(qualifiedfor504,'')<>'' then 'T' else 'N' end                              qualifiedfor504
,0::int                                                                                        PNP_requested
,e.exitwithdrawaltype                                                                          exitwithdrawaltype
,e.id                                                                                          enrollmentid
into temp tmp_student                                                                              
from student s
inner join enrollment e on s.id=e.studentid and s.activeflag is true 
inner join organizationtreedetail ot on e.attendanceschoolid=ot.schoolid
inner join gradecourse gc on gc.id=e.currentgradelevel 
left outer join category fl on fl.categorycode=s.firstlanguage 
  and fl.categorytypeid=(select id from categorytype  where  typecode='FIRST_LANGUAGE')
left outer join category pd on pd.categorycode=s.primarydisabilitycode 
  and pd.categorytypeid=(select id from categorytype  where  typecode='PRIMARY_DISABILITY_CODES') 
  where exists (select 1 from tmp_studentstests tmp where tmp.studentid=s.id and tmp.enrollmentid=e.id);

CREATE INDEX idx_se_student ON tmp_student   USING btree (studentid,enrollmentid);


update tmp_student 
set PNP_requested=1
where studentid in (select studentid from tmp_pnp);

--Item Infromation 
drop table if exists tmp_taskvariant;
 with ep_items as(
 SELECT DISTINCT
 tv.id                                              taskvariantid
,tv.externalid                                      externalid
,tv.taskdifficultyid                                taskdifficultyid
 FROM test t
JOIN testsection as ts ON (t.id = ts.testid)
JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
JOIN testcollectionstests tct ON t.id = tct.testid
JOIN testcollection tc ON tc.id = tct.testcollectionid
JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
JOIN assessment a ON atc.assessmentid = a.id
JOIN testingprogram tp ON a.testingprogramid = tp.id
JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
 WHERE ap.id=12) 
 select 
  eptv.taskvariantid
 ,eptv.externalid                                      
 ,eptv.taskdifficultyid  
 ,cbtv.passage_id ,cbtv.item_name ,cbtv.type_of_TE_item 
 ,cbtv.numberofpossiblescores_count ,cbtv.numberofpossiblescores ,cbtv.max_score ,cbtv.scoring_type ,cbtv.item_response_1 ,cbtv.item_response_2 
 ,cbtv.item_response_3 ,cbtv.item_response_4 ,cbtv.item_response_5 ,cbtv.item_response_6 ,cbtv.item_response_7 ,cbtv.item_response_8
 ,cbtv.item_response_9 ,cbtv.item_response_10 ,cbtv.item_response_11 ,cbtv.item_response_12 ,cbtv.primary_contend_code ,cbtv.secondary_contend_code 
 ,cbtv.cognitive_complexity_framework ,cbtv.item_cognitive_level ,cbtv.target_grade_of_item ,cbtv.item_content_codes ,cbtv.organizationname ,cbtv.tasktypecode 
 ,cbtv.responsescore ,cbtv.scoringmethod                               
  into temp tmp_taskvariant 
 from ep_items eptv
 inner join tmp_cb_item cbtv on eptv.externalid=cbtv.externaltaskvariantid ;

CREATE INDEX idx_tv_taskvariant ON tmp_taskvariant USING btree (taskvariantid);


drop table if exists tmp_studentsresponses;	   
select 
 sr.response item_response
,sr.score    scored_item
,sr.createddate item_start_time 
,sr.modifieddate item_ended_time
,round(extract(epoch from sr.modifieddate - sr.createddate)) item_time
,sr.studentstestsid
,sr.studentstestsectionsid
,sr.testsectionid
,sr.taskvariantid
,sr.studentid
,taskvariantposition 
,testletid
,testsectionname 
,testletname
into temp tmp_studentsresponses
from studentsresponses sr
left outer join (select testsectionid,taskvariantid,taskvariantposition,testletid,testsectionname,testletname from testsection as ts 
JOIN testsectionstaskvariants AS tstv ON ts.id = tstv.testsectionid
left outer join testlet tl on tl.id=tstv.testletid) ts on ts.testsectionid=sr.testsectionid and ts.taskvariantid=sr.taskvariantid
where exists (select 1 from tmp_studentstests tmp where tmp.studentstestsid=sr.studentstestsid);

CREATE INDEX idx_st_studentsresponses ON tmp_studentsresponses USING btree (studentstestsectionsid,taskvariantid);


drop table if  exists tmp_foil_sr;
with cte_foil as
(
select studentstestsectionsid,
       taskvariantid,
       unnest(string_to_array(item_response, ',')) foilid  
  from tmp_studentsresponses sr
  where left(item_response,1)='[' and right(item_response,1)=']' and left(item_response,2)<>'[{' and left(item_response,2)<>'[[' 
)
select tmp.studentstestsectionsid,
      tmp.taskvariantid,'['||array_to_string(array_agg(distinct tfv.responseorder), ',')||']'  responseorder
into temp tmp_foil_sr
from cte_foil tmp
inner join (select tvf.taskvariantid,tvf.foilid,row_number() over (partition by tvf.taskvariantid order by partorder,responseorder) responseorder
               from taskvariantsfoils AS tvf 
               JOIN foil as f on tvf.foilid = f.id
              LEFT OUTER JOIN multiparttaskvariant mtv ON mtv.id = f.multiparttaskvariantid ) tfv
   on tfv.taskvariantid=tmp.taskvariantid and trim('[]' from tmp.foilid)::text=tfv.foilid::text
 group by tmp.studentstestsectionsid,tmp.taskvariantid ;

CREATE INDEX idx_st_tmp_foil_sr ON tmp_foil_sr USING btree (studentstestsectionsid,taskvariantid);
--KELPA Non scoring reason
drop table if exists tmp_nonscoringreason;
select distinct
 scs.studentid
,scs.studentstestsid
,ccqi.taskvariantid
,ccqi.nonscoringreason
,nonsc.categorycode
 into temp tmp_nonscoringreason
from scoringassignmentstudent scs 
inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
inner join testsession ts on ts.id = sc.testsessionid and ts.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sccq.id and ccq.activeflag is true
inner join ccqscoreitem ccqi on ccqi.ccqscoreid=ccq.id and ccqi.activeflag is true
inner join testcollection tc on tc.id = ts.testcollectionid and tc.activeflag is true
inner join assessmentstestcollections asmnttc on asmnttc.testcollectionid = ts.testcollectionid and asmnttc.activeflag is true
inner join assessment asmnt on asmnt.id = asmnttc.assessmentid and asmnt.activeflag is true
inner join testingprogram tp on tp.id = asmnt.testingprogramid and tp.activeflag is true
inner join assessmentprogram ap on ap.id = tp.assessmentprogramid and ap.activeflag is true
inner join stage stg  on stg.id=ts.stageid
inner join category c on c.id=ccq.status and c.activeflag is true
left outer join category nonsc on nonsc.id =ccqi.nonscoringreason
where ap.id=12  and ts.schoolyear=2017 and ccqi.nonscoringreason is not null
and exists (select 1 from tmp_studentstests tmp where tmp.studentstestsid=scs.studentstestsid);

CREATE INDEX idx_sttv_nonscoringreason ON tmp_nonscoringreason USING btree (studentstestsid,taskvariantid);

--Final student report
drop table if exists tmp_final_extract_st;
select  st.assessment_name
,st.program_name
,st.test_subject
,st.test_grade
,st.form_identifier
,st.form_version 
,st.test_cbid
,st.testname
,st.testInternalName 
,st.start_time
,st.end_time
,st.total_elapsed_time	     
,st.test_status
,s.student_state_identifier
,s.student_state
,s.studentid
,s.academic_grade_level
,s.student_first_language
,s.dob
,s.gender
,s.race
,s.hispanic
,s.ELL
,s.disability_exceptionality
,s.giftedcode
,s.qualifiedfor504
,s.PNP_requested
,st.sc_code
,case when str.studentid is not null then 'Y' else 'N' end  attemptedness
,s.exitwithdrawaltype
,st.stage
,str.rawscore
,str.scalescore
,st.interimtheta
,str.performance_level
,str.subscore
,str.Claim_1_all_rating         
,str.Claim_1_Rpt_Group_1_rating 
,str.Claim_1_Rpt_Group_2_rating 
,str.Claim_1_Rpt_Group_3_rating
,str.Claim_1_Rpt_Group_4_rating
,str.Claim_1_Rpt_Group_5_rating 
,str.Claim_1_Rpt_Group_6_rating
,str.Claim_1_Rpt_Group_7_rating
,str.Claim_1_Rpt_Group_8_rating 
,str.Claim_1_Rpt_Group_9_rating 
,str.Claim_2_all_rating
,str.Claim_2_Rpt_Group_1_rating
,str.Claim_2_Rpt_Group_2_rating 
,str.Claim_2_Rpt_Group_3_rating 
,str.Claim_3_all_rating 
,str.Claim_4_all_rating 
,str.Mega_claim_2_3_4_rating
,str.Claim_1_all_subscore        
,str.Claim_1_Rpt_Group_1_subscore 
,str.Claim_1_Rpt_Group_2_subscore 
,str.Claim_1_Rpt_Group_3_subscore
,str.Claim_1_Rpt_Group_4_subscore
,str.Claim_1_Rpt_Group_5_subscore 
,str.Claim_1_Rpt_Group_6_subscore
,str.Claim_1_Rpt_Group_7_subscore 
,str.Claim_1_Rpt_Group_8_subscore 
,str.Claim_1_Rpt_Group_9_subscore 
,str.Claim_2_all_subscore
,str.Claim_2_Rpt_Group_1_subscore
,str.Claim_2_Rpt_Group_2_subscore 
,str.Claim_2_Rpt_Group_3_subscore 
,str.Claim_3_all_subscore 
,str.Claim_4_all_subscore 
,str.Mega_claim_2_3_4_subscore
,s.enrollmentid
,st.studentstestsid
  into temp tmp_final_extract_st
 from tmp_studentstests st
inner join tmp_student s on s.studentid=st.studentid and s.enrollmentid=st.enrollmentid
left outer join tmp_subscore str on str.studentid=st.studentid and str.enrollmentid=st.enrollmentid and str.contentareaid=st.contentareaid
;

CREATE INDEX idx_sts_tmp_final_extract_st ON tmp_final_extract_st USING btree (studentstestsid,studentid);

--Final response report
drop table if exists tmp_final_extract_sr;
select 
 tv.taskvariantid       
,tv.externalid       
,tv.passage_id
,tv.item_name
,tv.tasktypecode
,tv.type_of_TE_item
,tv.numberofpossiblescores_count            
,tv.numberofpossiblescores                  
,tv.max_score
,tv.scoring_type
,sr.item_response
,sr.scored_item
,sr.item_start_time
,sr.item_ended_time
,sr.item_time
,tv.primary_contend_code
,tv.secondary_contend_code
,tv.cognitive_complexity_framework
,tv.item_cognitive_level
,tv.target_grade_of_item
,tv.item_content_codes
,tv.item_response_1
,tv.item_response_2 
,tv.item_response_3 
,tv.item_response_4 
,tv.item_response_5 
,tv.item_response_6
,tv.item_response_7 
,tv.item_response_8
,tv.item_response_9 
,tv.item_response_10
,tv.item_response_11
,tv.item_response_12 
,sr.testsectionname
,sr.taskvariantposition
,sr.testletid   
,tv.taskdifficultyid
,sr.testletname
,sr.studentstestsid
,sr.studentid
,f.responseorder
,nonsc.nonscoringreason nonscoringreason
,sr.studentstestsectionsid
  into temp tmp_final_extract_sr
 from tmp_studentsresponses sr 
join tmp_taskvariant tv on tv.taskvariantid=sr.taskvariantid
left outer join tmp_foil_sr f on f.studentstestsectionsid=sr.studentstestsectionsid and f.taskvariantid=sr.taskvariantid
left outer join tmp_nonscoringreason nonsc on nonsc.studentstestsid=sr.studentstestsid and nonsc.taskvariantid=tv.taskvariantid
;

CREATE INDEX idx_sts_tmp_final_extract_sr ON tmp_final_extract_sr USING btree (studentstestsid,studentid);

--Final report
drop table if exists tmp_final_extract;
select 
 st.assessment_name
,st.program_name
,st.test_subject
,st.test_grade
,st.form_identifier
,st.test_cbid
,st.testname
,st.testInternalName 
,st.start_time
,st.end_time
,st.total_elapsed_time	     
,st.test_status
,st.student_state_identifier
,st.student_state
,st.studentid
,st.academic_grade_level
,st.student_first_language
,st.dob
,st.gender
,st.race
,st.hispanic
,st.ELL
,st.disability_exceptionality
,st.giftedcode
,st.qualifiedfor504
,st.PNP_requested
,st.sc_code
,st.attemptedness
,st.exitwithdrawaltype
,tv.externalid                         item_id
,tv.passage_id
,tv.item_name
,tv.tasktypecode                       item_type
,tv.type_of_TE_item 
,st.stage
,tv.numberofpossiblescores_count       passible_scores                         
,tv.numberofpossiblescores             number_of_possible_scores
,tv.max_score
,tv.scoring_type
,tv.item_response
,tv.responseorder
,tv.scored_item
,tv.nonscoringreason                   not_score_code
,tv.item_start_time
,tv.item_ended_time
,tv.item_time
,st.rawscore
,st.scalescore
,st.interimtheta                       theta_estimates
,st.performance_level
,st.subscore
,st.Claim_1_Rpt_Group_1_rating 
,st.Claim_1_Rpt_Group_2_rating 
,st.Claim_1_Rpt_Group_3_rating
,st.Claim_1_Rpt_Group_4_rating
,st.Claim_1_Rpt_Group_5_rating 
,st.Claim_1_Rpt_Group_6_rating
,st.Claim_1_Rpt_Group_7_rating
,st.Claim_1_Rpt_Group_8_rating 
,st.Claim_1_Rpt_Group_9_rating 
,st.Claim_2_all_rating
,st.Claim_2_Rpt_Group_1_rating
,st.Claim_2_Rpt_Group_2_rating 
,st.Claim_2_Rpt_Group_3_rating 
,st.Claim_3_all_rating 
,st.Claim_4_all_rating 
,st.Mega_claim_2_3_4_rating
,st.Claim_1_all_subscore        
,st.Claim_1_Rpt_Group_1_subscore 
,st.Claim_1_Rpt_Group_2_subscore 
,st.Claim_1_Rpt_Group_3_subscore
,st.Claim_1_Rpt_Group_4_subscore
,st.Claim_1_Rpt_Group_5_subscore 
,st.Claim_1_Rpt_Group_6_subscore
,st.Claim_1_Rpt_Group_7_subscore 
,st.Claim_1_Rpt_Group_8_subscore 
,st.Claim_1_Rpt_Group_9_subscore 
,st.Claim_2_all_subscore
,st.Claim_2_Rpt_Group_1_subscore
,st.Claim_2_Rpt_Group_2_subscore 
,st.Claim_2_Rpt_Group_3_subscore 
,st.Claim_3_all_subscore 
,st.Claim_4_all_subscore 
,st.Mega_claim_2_3_4_subscore
,tv.primary_contend_code
,tv.secondary_contend_code
,tv.cognitive_complexity_framework 
,item_cognitive_level 
,tv.item_response_1
,tv.item_response_2 
,tv.item_response_3 
,tv.item_response_4 
,tv.item_response_5 
,tv.item_response_6
,tv.item_response_7 
,tv.item_response_8
,tv.item_response_9 
,tv.item_response_10
,tv.item_response_11
,tv.item_response_12 
,tv.taskvariantposition
,tv.testsectionname
,tv.testletid    
,tv.taskdifficultyid                      
,tv.testletname
,tv.studentstestsid 
,tv.studentstestsectionsid
,tv.taskvariantid
into temp tmp_final_extract  from tmp_final_extract_st st 
left outer join tmp_final_extract_sr tv on tv.studentstestsid=st.studentstestsid and tv.studentid=st.studentid;

--\copy (select * from tmp_final_extract) to 'kap_extract_ela.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);       
--\copy (select * from tmp_final_extract) to 'kap_extract_ela.txt'  delimiter '|' CSV HEADER ;
\copy (select * from tmp_final_extract) to 'interim_extract_all.txt' (FORMAT CSV,DELIMITER('|'), HEADER TRUE, FORCE_QUOTE *);





