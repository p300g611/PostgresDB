-- step1: create temp table for firstcontact sqlite format
SELECT
s.id             studentid,
ssr.createddate  createddate,
ssr.modifieddate modifieddate,
sl.labelnumber   surveylabelnumber,
sl.label         surveylabel,
sr.responselabel responselabel,
sr.responsevalue responsevalue,
ssr.responsetext responsetext
into temp firstcontact
FROM student s
JOIN enrollment AS e  ON (e.studentid = s.id)
JOIN survey sv ON s.id = sv.studentid
JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid
JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id
JOIN surveylabel sl ON sr.labelid = sl.id
-- JOIN studentassessmentprogram sap ON sap.studentid = s.id
-- JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
WHERE ssr.activeflag is true --AND sap.assessmentprogramid=3
-- AND e.currentschoolyear=2015
;
-- step2: questions answeres labels 
select row_number() over(order by labelnumber) s_no,labelnumber,label,sl,responselabel,responsevalue,responseorder 
into temp tmp_ques_answ
from surveylabel sl
inner JOIN surveyresponse sr ON sr.labelid = sl.id  

order by labelnumber,responseorder,responselabel; 

\copy (select * from tmp_ques_answ) to 'surveylabel_2015.csv' (FORMAT CSV,header true, FORCE_QUOTE *);

--step3: create index          
CREATE INDEX  idx1_firstcontact ON firstcontact (studentid);                          
CREATE INDEX  idx4_firstcontact ON firstcontact (surveylabelnumber);


--step4:dynamic sql replace                  
/*ep dynamic sql: 
   select ',(select responselabel from firstcontact_res '||labelnumber||' where '||labelnumber||'.surveylabelnumber='||''''||labelnumber||''''||' and fc.studentid='||labelnumber||'.studentid limit 1 )'||' "'||labelnumber||'"' 
   from surveylabel  order by labelnumber;
*/
--create table using below script
with 
 firstcontact_std
   as 
   ( select   studentid         
             ,date(min(createddate))  createddate        
             ,date(max(modifieddate)) modifieddate
              from firstcontact 
              group by studentid limit 1)
,firstcontact_res
   as 
   ( select    fc.studentid         
               ,fc.responselabel
               ,fc.surveylabelnumber
              from firstcontact fc)     
select 
  fc.studentid            "studentid"
 ,fc.createddate          "createddate"
 ,fc.modifieddate         "modifieddate"
 ,(select responselabel from firstcontact_res Q13_1 where Q13_1.surveylabelnumber='Q13_1' and fc.studentid=Q13_1.studentid limit 1 ) "Q13_1"
 ,(select responselabel from firstcontact_res Q132_1 where Q132_1.surveylabelnumber='Q132_1' and fc.studentid=Q132_1.studentid limit 1 ) "Q132_1"
 ,(select responselabel from firstcontact_res Q132_2 where Q132_2.surveylabelnumber='Q132_2' and fc.studentid=Q132_2.studentid limit 1 ) "Q132_2"
 ,(select responselabel from firstcontact_res Q132_3 where Q132_3.surveylabelnumber='Q132_3' and fc.studentid=Q132_3.studentid limit 1 ) "Q132_3"
 ,(select responselabel from firstcontact_res Q132_4 where Q132_4.surveylabelnumber='Q132_4' and fc.studentid=Q132_4.studentid limit 1 ) "Q132_4"
 ,(select responselabel from firstcontact_res Q133 where Q133.surveylabelnumber='Q133' and fc.studentid=Q133.studentid limit 1 ) "Q133"
 ,(select responselabel from firstcontact_res Q135 where Q135.surveylabelnumber='Q135' and fc.studentid=Q135.studentid limit 1 ) "Q135"
 ,(select responselabel from firstcontact_res Q139 where Q139.surveylabelnumber='Q139' and fc.studentid=Q139.studentid limit 1 ) "Q139"
 ,(select responselabel from firstcontact_res Q142 where Q142.surveylabelnumber='Q142' and fc.studentid=Q142.studentid limit 1 ) "Q142"
 ,(select responselabel from firstcontact_res Q143 where Q143.surveylabelnumber='Q143' and fc.studentid=Q143.studentid limit 1 ) "Q143"
 ,(select responselabel from firstcontact_res Q146 where Q146.surveylabelnumber='Q146' and fc.studentid=Q146.studentid limit 1 ) "Q146"
 ,(select responselabel from firstcontact_res Q147 where Q147.surveylabelnumber='Q147' and fc.studentid=Q147.studentid limit 1 ) "Q147"
 ,(select responselabel from firstcontact_res Q151_1 where Q151_1.surveylabelnumber='Q151_1' and fc.studentid=Q151_1.studentid limit 1 ) "Q151_1"
 ,(select responselabel from firstcontact_res Q151_2 where Q151_2.surveylabelnumber='Q151_2' and fc.studentid=Q151_2.studentid limit 1 ) "Q151_2"
 ,(select responselabel from firstcontact_res Q151_3 where Q151_3.surveylabelnumber='Q151_3' and fc.studentid=Q151_3.studentid limit 1 ) "Q151_3"
 ,(select responselabel from firstcontact_res Q153 where Q153.surveylabelnumber='Q153' and fc.studentid=Q153.studentid limit 1 ) "Q153"
 ,(select responselabel from firstcontact_res Q154_TEXT where Q154_TEXT.surveylabelnumber='Q154_TEXT' and fc.studentid=Q154_TEXT.studentid limit 1 ) "Q154_TEXT"
 ,(select responselabel from firstcontact_res Q16_1 where Q16_1.surveylabelnumber='Q16_1' and fc.studentid=Q16_1.studentid limit 1 ) "Q16_1"
 ,(select responselabel from firstcontact_res Q17 where Q17.surveylabelnumber='Q17' and fc.studentid=Q17.studentid limit 1 ) "Q17"
 ,(select responselabel from firstcontact_res Q19 where Q19.surveylabelnumber='Q19' and fc.studentid=Q19.studentid limit 1 ) "Q19"
 ,(select responselabel from firstcontact_res Q20_1 where Q20_1.surveylabelnumber='Q20_1' and fc.studentid=Q20_1.studentid limit 1 ) "Q20_1"
 ,(select responselabel from firstcontact_res Q20_2 where Q20_2.surveylabelnumber='Q20_2' and fc.studentid=Q20_2.studentid limit 1 ) "Q20_2"
 ,(select responselabel from firstcontact_res Q20_3 where Q20_3.surveylabelnumber='Q20_3' and fc.studentid=Q20_3.studentid limit 1 ) "Q20_3"
 ,(select responselabel from firstcontact_res Q20_4 where Q20_4.surveylabelnumber='Q20_4' and fc.studentid=Q20_4.studentid limit 1 ) "Q20_4"
 ,(select responselabel from firstcontact_res Q22 where Q22.surveylabelnumber='Q22' and fc.studentid=Q22.studentid limit 1 ) "Q22"
 ,(select responselabel from firstcontact_res Q23_1 where Q23_1.surveylabelnumber='Q23_1' and fc.studentid=Q23_1.studentid limit 1 ) "Q23_1"
 ,(select responselabel from firstcontact_res Q23_2 where Q23_2.surveylabelnumber='Q23_2' and fc.studentid=Q23_2.studentid limit 1 ) "Q23_2"
 ,(select responselabel from firstcontact_res Q23_3 where Q23_3.surveylabelnumber='Q23_3' and fc.studentid=Q23_3.studentid limit 1 ) "Q23_3"
 ,(select responselabel from firstcontact_res Q24 where Q24.surveylabelnumber='Q24' and fc.studentid=Q24.studentid limit 1 ) "Q24"
 ,(select responselabel from firstcontact_res Q25_1 where Q25_1.surveylabelnumber='Q25_1' and fc.studentid=Q25_1.studentid limit 1 ) "Q25_1"
 ,(select responselabel from firstcontact_res Q25_10 where Q25_10.surveylabelnumber='Q25_10' and fc.studentid=Q25_10.studentid limit 1 ) "Q25_10"
 ,(select responselabel from firstcontact_res Q25_2 where Q25_2.surveylabelnumber='Q25_2' and fc.studentid=Q25_2.studentid limit 1 ) "Q25_2"
 ,(select responselabel from firstcontact_res Q25_3 where Q25_3.surveylabelnumber='Q25_3' and fc.studentid=Q25_3.studentid limit 1 ) "Q25_3"
 ,(select responselabel from firstcontact_res Q25_4 where Q25_4.surveylabelnumber='Q25_4' and fc.studentid=Q25_4.studentid limit 1 ) "Q25_4"
 ,(select responselabel from firstcontact_res Q25_5 where Q25_5.surveylabelnumber='Q25_5' and fc.studentid=Q25_5.studentid limit 1 ) "Q25_5"
 ,(select responselabel from firstcontact_res Q25_6 where Q25_6.surveylabelnumber='Q25_6' and fc.studentid=Q25_6.studentid limit 1 ) "Q25_6"
 ,(select responselabel from firstcontact_res Q25_7 where Q25_7.surveylabelnumber='Q25_7' and fc.studentid=Q25_7.studentid limit 1 ) "Q25_7"
 ,(select responselabel from firstcontact_res Q25_8 where Q25_8.surveylabelnumber='Q25_8' and fc.studentid=Q25_8.studentid limit 1 ) "Q25_8"
 ,(select responselabel from firstcontact_res Q25_9 where Q25_9.surveylabelnumber='Q25_9' and fc.studentid=Q25_9.studentid limit 1 ) "Q25_9"
 ,(select responselabel from firstcontact_res Q27_1 where Q27_1.surveylabelnumber='Q27_1' and fc.studentid=Q27_1.studentid limit 1 ) "Q27_1"
 ,(select responselabel from firstcontact_res Q27_2 where Q27_2.surveylabelnumber='Q27_2' and fc.studentid=Q27_2.studentid limit 1 ) "Q27_2"
 ,(select responselabel from firstcontact_res Q27_3 where Q27_3.surveylabelnumber='Q27_3' and fc.studentid=Q27_3.studentid limit 1 ) "Q27_3"
 ,(select responselabel from firstcontact_res Q27_4 where Q27_4.surveylabelnumber='Q27_4' and fc.studentid=Q27_4.studentid limit 1 ) "Q27_4"
 ,(select responselabel from firstcontact_res Q29_1 where Q29_1.surveylabelnumber='Q29_1' and fc.studentid=Q29_1.studentid limit 1 ) "Q29_1"
 ,(select responselabel from firstcontact_res Q29_2 where Q29_2.surveylabelnumber='Q29_2' and fc.studentid=Q29_2.studentid limit 1 ) "Q29_2"
 ,(select responselabel from firstcontact_res Q29_3 where Q29_3.surveylabelnumber='Q29_3' and fc.studentid=Q29_3.studentid limit 1 ) "Q29_3"
 ,(select responselabel from firstcontact_res Q29_4 where Q29_4.surveylabelnumber='Q29_4' and fc.studentid=Q29_4.studentid limit 1 ) "Q29_4"
 ,(select responselabel from firstcontact_res Q3 where Q3.surveylabelnumber='Q3' and fc.studentid=Q3.studentid limit 1 ) "Q3"
 ,(select responselabel from firstcontact_res Q31_1 where Q31_1.surveylabelnumber='Q31_1' and fc.studentid=Q31_1.studentid limit 1 ) "Q31_1"
 ,(select responselabel from firstcontact_res Q31_2 where Q31_2.surveylabelnumber='Q31_2' and fc.studentid=Q31_2.studentid limit 1 ) "Q31_2"
 ,(select responselabel from firstcontact_res Q31_3 where Q31_3.surveylabelnumber='Q31_3' and fc.studentid=Q31_3.studentid limit 1 ) "Q31_3"
 ,(select responselabel from firstcontact_res Q33_1 where Q33_1.surveylabelnumber='Q33_1' and fc.studentid=Q33_1.studentid limit 1 ) "Q33_1"
 ,(select responselabel from firstcontact_res Q33_10 where Q33_10.surveylabelnumber='Q33_10' and fc.studentid=Q33_10.studentid limit 1 ) "Q33_10"
 ,(select responselabel from firstcontact_res Q33_11 where Q33_11.surveylabelnumber='Q33_11' and fc.studentid=Q33_11.studentid limit 1 ) "Q33_11"
 ,(select responselabel from firstcontact_res Q33_2 where Q33_2.surveylabelnumber='Q33_2' and fc.studentid=Q33_2.studentid limit 1 ) "Q33_2"
 ,(select responselabel from firstcontact_res Q33_3 where Q33_3.surveylabelnumber='Q33_3' and fc.studentid=Q33_3.studentid limit 1 ) "Q33_3"
 ,(select responselabel from firstcontact_res Q33_4 where Q33_4.surveylabelnumber='Q33_4' and fc.studentid=Q33_4.studentid limit 1 ) "Q33_4"
 ,(select responselabel from firstcontact_res Q33_5 where Q33_5.surveylabelnumber='Q33_5' and fc.studentid=Q33_5.studentid limit 1 ) "Q33_5"
 ,(select responselabel from firstcontact_res Q33_6 where Q33_6.surveylabelnumber='Q33_6' and fc.studentid=Q33_6.studentid limit 1 ) "Q33_6"
 ,(select responselabel from firstcontact_res Q33_7 where Q33_7.surveylabelnumber='Q33_7' and fc.studentid=Q33_7.studentid limit 1 ) "Q33_7"
 ,(select responselabel from firstcontact_res Q33_8 where Q33_8.surveylabelnumber='Q33_8' and fc.studentid=Q33_8.studentid limit 1 ) "Q33_8"
 ,(select responselabel from firstcontact_res Q33_9 where Q33_9.surveylabelnumber='Q33_9' and fc.studentid=Q33_9.studentid limit 1 ) "Q33_9"
 ,(select responselabel from firstcontact_res Q34_1 where Q34_1.surveylabelnumber='Q34_1' and fc.studentid=Q34_1.studentid limit 1 ) "Q34_1"
 ,(select responselabel from firstcontact_res Q34_2 where Q34_2.surveylabelnumber='Q34_2' and fc.studentid=Q34_2.studentid limit 1 ) "Q34_2"
 ,(select responselabel from firstcontact_res Q34_3 where Q34_3.surveylabelnumber='Q34_3' and fc.studentid=Q34_3.studentid limit 1 ) "Q34_3"
 ,(select responselabel from firstcontact_res Q36 where Q36.surveylabelnumber='Q36' and fc.studentid=Q36.studentid limit 1 ) "Q36"
 ,(select responselabel from firstcontact_res Q37 where Q37.surveylabelnumber='Q37' and fc.studentid=Q37.studentid limit 1 ) "Q37"
 ,(select responselabel from firstcontact_res Q39 where Q39.surveylabelnumber='Q39' and fc.studentid=Q39.studentid limit 1 ) "Q39"
 ,(select responselabel from firstcontact_res Q40 where Q40.surveylabelnumber='Q40' and fc.studentid=Q40.studentid limit 1 ) "Q40"
 ,(select responselabel from firstcontact_res Q41 where Q41.surveylabelnumber='Q41' and fc.studentid=Q41.studentid limit 1 ) "Q41"
 ,(select responselabel from firstcontact_res Q43 where Q43.surveylabelnumber='Q43' and fc.studentid=Q43.studentid limit 1 ) "Q43"
 ,(select responselabel from firstcontact_res Q44 where Q44.surveylabelnumber='Q44' and fc.studentid=Q44.studentid limit 1 ) "Q44"
 ,(select responselabel from firstcontact_res Q45_1 where Q45_1.surveylabelnumber='Q45_1' and fc.studentid=Q45_1.studentid limit 1 ) "Q45_1"
 ,(select responselabel from firstcontact_res Q45_10 where Q45_10.surveylabelnumber='Q45_10' and fc.studentid=Q45_10.studentid limit 1 ) "Q45_10"
 ,(select responselabel from firstcontact_res Q45_11 where Q45_11.surveylabelnumber='Q45_11' and fc.studentid=Q45_11.studentid limit 1 ) "Q45_11"
 ,(select responselabel from firstcontact_res Q45_12 where Q45_12.surveylabelnumber='Q45_12' and fc.studentid=Q45_12.studentid limit 1 ) "Q45_12"
 ,(select responselabel from firstcontact_res Q45_2 where Q45_2.surveylabelnumber='Q45_2' and fc.studentid=Q45_2.studentid limit 1 ) "Q45_2"
 ,(select responselabel from firstcontact_res Q45_3 where Q45_3.surveylabelnumber='Q45_3' and fc.studentid=Q45_3.studentid limit 1 ) "Q45_3"
 ,(select responselabel from firstcontact_res Q45_4 where Q45_4.surveylabelnumber='Q45_4' and fc.studentid=Q45_4.studentid limit 1 ) "Q45_4"
 ,(select responselabel from firstcontact_res Q45_5 where Q45_5.surveylabelnumber='Q45_5' and fc.studentid=Q45_5.studentid limit 1 ) "Q45_5"
 ,(select responselabel from firstcontact_res Q45_6 where Q45_6.surveylabelnumber='Q45_6' and fc.studentid=Q45_6.studentid limit 1 ) "Q45_6"
 ,(select responselabel from firstcontact_res Q45_7 where Q45_7.surveylabelnumber='Q45_7' and fc.studentid=Q45_7.studentid limit 1 ) "Q45_7"
 ,(select responselabel from firstcontact_res Q45_8 where Q45_8.surveylabelnumber='Q45_8' and fc.studentid=Q45_8.studentid limit 1 ) "Q45_8"
 ,(select responselabel from firstcontact_res Q45_9 where Q45_9.surveylabelnumber='Q45_9' and fc.studentid=Q45_9.studentid limit 1 ) "Q45_9"
 ,(select responselabel from firstcontact_res Q47 where Q47.surveylabelnumber='Q47' and fc.studentid=Q47.studentid limit 1 ) "Q47"
 ,(select responselabel from firstcontact_res Q49_1 where Q49_1.surveylabelnumber='Q49_1' and fc.studentid=Q49_1.studentid limit 1 ) "Q49_1"
 ,(select responselabel from firstcontact_res Q49_2 where Q49_2.surveylabelnumber='Q49_2' and fc.studentid=Q49_2.studentid limit 1 ) "Q49_2"
 ,(select responselabel from firstcontact_res Q49_3 where Q49_3.surveylabelnumber='Q49_3' and fc.studentid=Q49_3.studentid limit 1 ) "Q49_3"
 ,(select responselabel from firstcontact_res Q49_4 where Q49_4.surveylabelnumber='Q49_4' and fc.studentid=Q49_4.studentid limit 1 ) "Q49_4"
 ,(select responselabel from firstcontact_res Q49_5 where Q49_5.surveylabelnumber='Q49_5' and fc.studentid=Q49_5.studentid limit 1 ) "Q49_5"
 ,(select responselabel from firstcontact_res Q49_6 where Q49_6.surveylabelnumber='Q49_6' and fc.studentid=Q49_6.studentid limit 1 ) "Q49_6"
 ,(select responselabel from firstcontact_res Q51_1 where Q51_1.surveylabelnumber='Q51_1' and fc.studentid=Q51_1.studentid limit 1 ) "Q51_1"
 ,(select responselabel from firstcontact_res Q51_2 where Q51_2.surveylabelnumber='Q51_2' and fc.studentid=Q51_2.studentid limit 1 ) "Q51_2"
 ,(select responselabel from firstcontact_res Q51_3 where Q51_3.surveylabelnumber='Q51_3' and fc.studentid=Q51_3.studentid limit 1 ) "Q51_3"
 ,(select responselabel from firstcontact_res Q51_4 where Q51_4.surveylabelnumber='Q51_4' and fc.studentid=Q51_4.studentid limit 1 ) "Q51_4"
 ,(select responselabel from firstcontact_res Q51_5 where Q51_5.surveylabelnumber='Q51_5' and fc.studentid=Q51_5.studentid limit 1 ) "Q51_5"
 ,(select responselabel from firstcontact_res Q51_6 where Q51_6.surveylabelnumber='Q51_6' and fc.studentid=Q51_6.studentid limit 1 ) "Q51_6"
 ,(select responselabel from firstcontact_res Q51_7 where Q51_7.surveylabelnumber='Q51_7' and fc.studentid=Q51_7.studentid limit 1 ) "Q51_7"
 ,(select responselabel from firstcontact_res Q51_8 where Q51_8.surveylabelnumber='Q51_8' and fc.studentid=Q51_8.studentid limit 1 ) "Q51_8"
 ,(select responselabel from firstcontact_res Q52 where Q52.surveylabelnumber='Q52' and fc.studentid=Q52.studentid limit 1 ) "Q52"
 ,(select responselabel from firstcontact_res Q54_1 where Q54_1.surveylabelnumber='Q54_1' and fc.studentid=Q54_1.studentid limit 1 ) "Q54_1"
 ,(select responselabel from firstcontact_res Q54_10 where Q54_10.surveylabelnumber='Q54_10' and fc.studentid=Q54_10.studentid limit 1 ) "Q54_10"
 ,(select responselabel from firstcontact_res Q54_11 where Q54_11.surveylabelnumber='Q54_11' and fc.studentid=Q54_11.studentid limit 1 ) "Q54_11"
 ,(select responselabel from firstcontact_res Q54_12 where Q54_12.surveylabelnumber='Q54_12' and fc.studentid=Q54_12.studentid limit 1 ) "Q54_12"
 ,(select responselabel from firstcontact_res Q54_13 where Q54_13.surveylabelnumber='Q54_13' and fc.studentid=Q54_13.studentid limit 1 ) "Q54_13"
 ,(select responselabel from firstcontact_res Q54_2 where Q54_2.surveylabelnumber='Q54_2' and fc.studentid=Q54_2.studentid limit 1 ) "Q54_2"
 ,(select responselabel from firstcontact_res Q54_3 where Q54_3.surveylabelnumber='Q54_3' and fc.studentid=Q54_3.studentid limit 1 ) "Q54_3"
 ,(select responselabel from firstcontact_res Q54_4 where Q54_4.surveylabelnumber='Q54_4' and fc.studentid=Q54_4.studentid limit 1 ) "Q54_4"
 ,(select responselabel from firstcontact_res Q54_5 where Q54_5.surveylabelnumber='Q54_5' and fc.studentid=Q54_5.studentid limit 1 ) "Q54_5"
 ,(select responselabel from firstcontact_res Q54_6 where Q54_6.surveylabelnumber='Q54_6' and fc.studentid=Q54_6.studentid limit 1 ) "Q54_6"
 ,(select responselabel from firstcontact_res Q54_7 where Q54_7.surveylabelnumber='Q54_7' and fc.studentid=Q54_7.studentid limit 1 ) "Q54_7"
 ,(select responselabel from firstcontact_res Q54_8 where Q54_8.surveylabelnumber='Q54_8' and fc.studentid=Q54_8.studentid limit 1 ) "Q54_8"
 ,(select responselabel from firstcontact_res Q54_9 where Q54_9.surveylabelnumber='Q54_9' and fc.studentid=Q54_9.studentid limit 1 ) "Q54_9"
 ,(select responselabel from firstcontact_res Q56_1 where Q56_1.surveylabelnumber='Q56_1' and fc.studentid=Q56_1.studentid limit 1 ) "Q56_1"
 ,(select responselabel from firstcontact_res Q56_2 where Q56_2.surveylabelnumber='Q56_2' and fc.studentid=Q56_2.studentid limit 1 ) "Q56_2"
 ,(select responselabel from firstcontact_res Q56_3 where Q56_3.surveylabelnumber='Q56_3' and fc.studentid=Q56_3.studentid limit 1 ) "Q56_3"
 ,(select responselabel from firstcontact_res Q56_4 where Q56_4.surveylabelnumber='Q56_4' and fc.studentid=Q56_4.studentid limit 1 ) "Q56_4"
 ,(select responselabel from firstcontact_res Q56_5 where Q56_5.surveylabelnumber='Q56_5' and fc.studentid=Q56_5.studentid limit 1 ) "Q56_5"
 ,(select responselabel from firstcontact_res Q56_6 where Q56_6.surveylabelnumber='Q56_6' and fc.studentid=Q56_6.studentid limit 1 ) "Q56_6"
 ,(select responselabel from firstcontact_res Q56_7 where Q56_7.surveylabelnumber='Q56_7' and fc.studentid=Q56_7.studentid limit 1 ) "Q56_7"
 ,(select responselabel from firstcontact_res Q56_8 where Q56_8.surveylabelnumber='Q56_8' and fc.studentid=Q56_8.studentid limit 1 ) "Q56_8"
 ,(select responselabel from firstcontact_res Q58_1 where Q58_1.surveylabelnumber='Q58_1' and fc.studentid=Q58_1.studentid limit 1 ) "Q58_1"
 ,(select responselabel from firstcontact_res Q58_2 where Q58_2.surveylabelnumber='Q58_2' and fc.studentid=Q58_2.studentid limit 1 ) "Q58_2"
 ,(select responselabel from firstcontact_res Q58_3 where Q58_3.surveylabelnumber='Q58_3' and fc.studentid=Q58_3.studentid limit 1 ) "Q58_3"
 ,(select responselabel from firstcontact_res Q58_4 where Q58_4.surveylabelnumber='Q58_4' and fc.studentid=Q58_4.studentid limit 1 ) "Q58_4"
 ,(select responselabel from firstcontact_res Q60 where Q60.surveylabelnumber='Q60' and fc.studentid=Q60.studentid limit 1 ) "Q60"
 ,(select responselabel from firstcontact_res Q62 where Q62.surveylabelnumber='Q62' and fc.studentid=Q62.studentid limit 1 ) "Q62"
 ,(select responselabel from firstcontact_res Q62_TEXT where Q62_TEXT.surveylabelnumber='Q62_TEXT' and fc.studentid=Q62_TEXT.studentid limit 1 ) "Q62_TEXT"
 ,(select responselabel from firstcontact_res Q63_TEXT where Q63_TEXT.surveylabelnumber='Q63_TEXT' and fc.studentid=Q63_TEXT.studentid limit 1 ) "Q63_TEXT"
 ,(select responselabel from firstcontact_res Q64 where Q64.surveylabelnumber='Q64' and fc.studentid=Q64.studentid limit 1 ) "Q64"
 ,(select responselabel from firstcontact_res Q65_TEXT where Q65_TEXT.surveylabelnumber='Q65_TEXT' and fc.studentid=Q65_TEXT.studentid limit 1 ) "Q65_TEXT"
 into temp tmp_report_2015
 from firstcontact_std fc ; 

--step5:
truncate table tmp_report_2015;
select   studentid         
             ,date(min(createddate))  createddate        
             ,date(max(modifieddate)) modifieddate
             into temp firstcontact_std
              from firstcontact 
              group by studentid;
-- logic 2: above logic looks like running long time use the one row into fcs_report_2015 for table creation then loop
do 
$$
declare  tmp_table record;
begin
FOR tmp_table IN (select studentid from firstcontact_std order by studentid )
  LOOP  
  raise info 'id:%',tmp_table.studentid;
  insert into tmp_report_2015 
  with firstcontact_res
   as 
   ( select    fc.studentid         
               ,fc.responselabel
               ,fc.surveylabelnumber
              from firstcontact fc where fc.studentid=tmp_table.studentid) 
  select 
  fc.studentid            "studentid"
 ,fc.createddate          "createddate"
 ,fc.modifieddate         "modifieddate"
 ,(select responselabel from firstcontact_res Q13_1 where Q13_1.surveylabelnumber='Q13_1' and fc.studentid=Q13_1.studentid limit 1 ) "Q13_1"
 ,(select responselabel from firstcontact_res Q132_1 where Q132_1.surveylabelnumber='Q132_1' and fc.studentid=Q132_1.studentid limit 1 ) "Q132_1"
 ,(select responselabel from firstcontact_res Q132_2 where Q132_2.surveylabelnumber='Q132_2' and fc.studentid=Q132_2.studentid limit 1 ) "Q132_2"
 ,(select responselabel from firstcontact_res Q132_3 where Q132_3.surveylabelnumber='Q132_3' and fc.studentid=Q132_3.studentid limit 1 ) "Q132_3"
 ,(select responselabel from firstcontact_res Q132_4 where Q132_4.surveylabelnumber='Q132_4' and fc.studentid=Q132_4.studentid limit 1 ) "Q132_4"
 ,(select responselabel from firstcontact_res Q133 where Q133.surveylabelnumber='Q133' and fc.studentid=Q133.studentid limit 1 ) "Q133"
 ,(select responselabel from firstcontact_res Q135 where Q135.surveylabelnumber='Q135' and fc.studentid=Q135.studentid limit 1 ) "Q135"
 ,(select responselabel from firstcontact_res Q139 where Q139.surveylabelnumber='Q139' and fc.studentid=Q139.studentid limit 1 ) "Q139"
 ,(select responselabel from firstcontact_res Q142 where Q142.surveylabelnumber='Q142' and fc.studentid=Q142.studentid limit 1 ) "Q142"
 ,(select responselabel from firstcontact_res Q143 where Q143.surveylabelnumber='Q143' and fc.studentid=Q143.studentid limit 1 ) "Q143"
 ,(select responselabel from firstcontact_res Q146 where Q146.surveylabelnumber='Q146' and fc.studentid=Q146.studentid limit 1 ) "Q146"
 ,(select responselabel from firstcontact_res Q147 where Q147.surveylabelnumber='Q147' and fc.studentid=Q147.studentid limit 1 ) "Q147"
 ,(select responselabel from firstcontact_res Q151_1 where Q151_1.surveylabelnumber='Q151_1' and fc.studentid=Q151_1.studentid limit 1 ) "Q151_1"
 ,(select responselabel from firstcontact_res Q151_2 where Q151_2.surveylabelnumber='Q151_2' and fc.studentid=Q151_2.studentid limit 1 ) "Q151_2"
 ,(select responselabel from firstcontact_res Q151_3 where Q151_3.surveylabelnumber='Q151_3' and fc.studentid=Q151_3.studentid limit 1 ) "Q151_3"
 ,(select responselabel from firstcontact_res Q153 where Q153.surveylabelnumber='Q153' and fc.studentid=Q153.studentid limit 1 ) "Q153"
 ,(select responselabel from firstcontact_res Q154_TEXT where Q154_TEXT.surveylabelnumber='Q154_TEXT' and fc.studentid=Q154_TEXT.studentid limit 1 ) "Q154_TEXT"
 ,(select responselabel from firstcontact_res Q16_1 where Q16_1.surveylabelnumber='Q16_1' and fc.studentid=Q16_1.studentid limit 1 ) "Q16_1"
 ,(select responselabel from firstcontact_res Q17 where Q17.surveylabelnumber='Q17' and fc.studentid=Q17.studentid limit 1 ) "Q17"
 ,(select responselabel from firstcontact_res Q19 where Q19.surveylabelnumber='Q19' and fc.studentid=Q19.studentid limit 1 ) "Q19"
 ,(select responselabel from firstcontact_res Q20_1 where Q20_1.surveylabelnumber='Q20_1' and fc.studentid=Q20_1.studentid limit 1 ) "Q20_1"
 ,(select responselabel from firstcontact_res Q20_2 where Q20_2.surveylabelnumber='Q20_2' and fc.studentid=Q20_2.studentid limit 1 ) "Q20_2"
 ,(select responselabel from firstcontact_res Q20_3 where Q20_3.surveylabelnumber='Q20_3' and fc.studentid=Q20_3.studentid limit 1 ) "Q20_3"
 ,(select responselabel from firstcontact_res Q20_4 where Q20_4.surveylabelnumber='Q20_4' and fc.studentid=Q20_4.studentid limit 1 ) "Q20_4"
 ,(select responselabel from firstcontact_res Q22 where Q22.surveylabelnumber='Q22' and fc.studentid=Q22.studentid limit 1 ) "Q22"
 ,(select responselabel from firstcontact_res Q23_1 where Q23_1.surveylabelnumber='Q23_1' and fc.studentid=Q23_1.studentid limit 1 ) "Q23_1"
 ,(select responselabel from firstcontact_res Q23_2 where Q23_2.surveylabelnumber='Q23_2' and fc.studentid=Q23_2.studentid limit 1 ) "Q23_2"
 ,(select responselabel from firstcontact_res Q23_3 where Q23_3.surveylabelnumber='Q23_3' and fc.studentid=Q23_3.studentid limit 1 ) "Q23_3"
 ,(select responselabel from firstcontact_res Q24 where Q24.surveylabelnumber='Q24' and fc.studentid=Q24.studentid limit 1 ) "Q24"
 ,(select responselabel from firstcontact_res Q25_1 where Q25_1.surveylabelnumber='Q25_1' and fc.studentid=Q25_1.studentid limit 1 ) "Q25_1"
 ,(select responselabel from firstcontact_res Q25_10 where Q25_10.surveylabelnumber='Q25_10' and fc.studentid=Q25_10.studentid limit 1 ) "Q25_10"
 ,(select responselabel from firstcontact_res Q25_2 where Q25_2.surveylabelnumber='Q25_2' and fc.studentid=Q25_2.studentid limit 1 ) "Q25_2"
 ,(select responselabel from firstcontact_res Q25_3 where Q25_3.surveylabelnumber='Q25_3' and fc.studentid=Q25_3.studentid limit 1 ) "Q25_3"
 ,(select responselabel from firstcontact_res Q25_4 where Q25_4.surveylabelnumber='Q25_4' and fc.studentid=Q25_4.studentid limit 1 ) "Q25_4"
 ,(select responselabel from firstcontact_res Q25_5 where Q25_5.surveylabelnumber='Q25_5' and fc.studentid=Q25_5.studentid limit 1 ) "Q25_5"
 ,(select responselabel from firstcontact_res Q25_6 where Q25_6.surveylabelnumber='Q25_6' and fc.studentid=Q25_6.studentid limit 1 ) "Q25_6"
 ,(select responselabel from firstcontact_res Q25_7 where Q25_7.surveylabelnumber='Q25_7' and fc.studentid=Q25_7.studentid limit 1 ) "Q25_7"
 ,(select responselabel from firstcontact_res Q25_8 where Q25_8.surveylabelnumber='Q25_8' and fc.studentid=Q25_8.studentid limit 1 ) "Q25_8"
 ,(select responselabel from firstcontact_res Q25_9 where Q25_9.surveylabelnumber='Q25_9' and fc.studentid=Q25_9.studentid limit 1 ) "Q25_9"
 ,(select responselabel from firstcontact_res Q27_1 where Q27_1.surveylabelnumber='Q27_1' and fc.studentid=Q27_1.studentid limit 1 ) "Q27_1"
 ,(select responselabel from firstcontact_res Q27_2 where Q27_2.surveylabelnumber='Q27_2' and fc.studentid=Q27_2.studentid limit 1 ) "Q27_2"
 ,(select responselabel from firstcontact_res Q27_3 where Q27_3.surveylabelnumber='Q27_3' and fc.studentid=Q27_3.studentid limit 1 ) "Q27_3"
 ,(select responselabel from firstcontact_res Q27_4 where Q27_4.surveylabelnumber='Q27_4' and fc.studentid=Q27_4.studentid limit 1 ) "Q27_4"
 ,(select responselabel from firstcontact_res Q29_1 where Q29_1.surveylabelnumber='Q29_1' and fc.studentid=Q29_1.studentid limit 1 ) "Q29_1"
 ,(select responselabel from firstcontact_res Q29_2 where Q29_2.surveylabelnumber='Q29_2' and fc.studentid=Q29_2.studentid limit 1 ) "Q29_2"
 ,(select responselabel from firstcontact_res Q29_3 where Q29_3.surveylabelnumber='Q29_3' and fc.studentid=Q29_3.studentid limit 1 ) "Q29_3"
 ,(select responselabel from firstcontact_res Q29_4 where Q29_4.surveylabelnumber='Q29_4' and fc.studentid=Q29_4.studentid limit 1 ) "Q29_4"
 ,(select responselabel from firstcontact_res Q3 where Q3.surveylabelnumber='Q3' and fc.studentid=Q3.studentid limit 1 ) "Q3"
 ,(select responselabel from firstcontact_res Q31_1 where Q31_1.surveylabelnumber='Q31_1' and fc.studentid=Q31_1.studentid limit 1 ) "Q31_1"
 ,(select responselabel from firstcontact_res Q31_2 where Q31_2.surveylabelnumber='Q31_2' and fc.studentid=Q31_2.studentid limit 1 ) "Q31_2"
 ,(select responselabel from firstcontact_res Q31_3 where Q31_3.surveylabelnumber='Q31_3' and fc.studentid=Q31_3.studentid limit 1 ) "Q31_3"
 ,(select responselabel from firstcontact_res Q33_1 where Q33_1.surveylabelnumber='Q33_1' and fc.studentid=Q33_1.studentid limit 1 ) "Q33_1"
 ,(select responselabel from firstcontact_res Q33_10 where Q33_10.surveylabelnumber='Q33_10' and fc.studentid=Q33_10.studentid limit 1 ) "Q33_10"
 ,(select responselabel from firstcontact_res Q33_11 where Q33_11.surveylabelnumber='Q33_11' and fc.studentid=Q33_11.studentid limit 1 ) "Q33_11"
 ,(select responselabel from firstcontact_res Q33_2 where Q33_2.surveylabelnumber='Q33_2' and fc.studentid=Q33_2.studentid limit 1 ) "Q33_2"
 ,(select responselabel from firstcontact_res Q33_3 where Q33_3.surveylabelnumber='Q33_3' and fc.studentid=Q33_3.studentid limit 1 ) "Q33_3"
 ,(select responselabel from firstcontact_res Q33_4 where Q33_4.surveylabelnumber='Q33_4' and fc.studentid=Q33_4.studentid limit 1 ) "Q33_4"
 ,(select responselabel from firstcontact_res Q33_5 where Q33_5.surveylabelnumber='Q33_5' and fc.studentid=Q33_5.studentid limit 1 ) "Q33_5"
 ,(select responselabel from firstcontact_res Q33_6 where Q33_6.surveylabelnumber='Q33_6' and fc.studentid=Q33_6.studentid limit 1 ) "Q33_6"
 ,(select responselabel from firstcontact_res Q33_7 where Q33_7.surveylabelnumber='Q33_7' and fc.studentid=Q33_7.studentid limit 1 ) "Q33_7"
 ,(select responselabel from firstcontact_res Q33_8 where Q33_8.surveylabelnumber='Q33_8' and fc.studentid=Q33_8.studentid limit 1 ) "Q33_8"
 ,(select responselabel from firstcontact_res Q33_9 where Q33_9.surveylabelnumber='Q33_9' and fc.studentid=Q33_9.studentid limit 1 ) "Q33_9"
 ,(select responselabel from firstcontact_res Q34_1 where Q34_1.surveylabelnumber='Q34_1' and fc.studentid=Q34_1.studentid limit 1 ) "Q34_1"
 ,(select responselabel from firstcontact_res Q34_2 where Q34_2.surveylabelnumber='Q34_2' and fc.studentid=Q34_2.studentid limit 1 ) "Q34_2"
 ,(select responselabel from firstcontact_res Q34_3 where Q34_3.surveylabelnumber='Q34_3' and fc.studentid=Q34_3.studentid limit 1 ) "Q34_3"
 ,(select responselabel from firstcontact_res Q36 where Q36.surveylabelnumber='Q36' and fc.studentid=Q36.studentid limit 1 ) "Q36"
 ,(select responselabel from firstcontact_res Q37 where Q37.surveylabelnumber='Q37' and fc.studentid=Q37.studentid limit 1 ) "Q37"
 ,(select responselabel from firstcontact_res Q39 where Q39.surveylabelnumber='Q39' and fc.studentid=Q39.studentid limit 1 ) "Q39"
 ,(select responselabel from firstcontact_res Q40 where Q40.surveylabelnumber='Q40' and fc.studentid=Q40.studentid limit 1 ) "Q40"
 ,(select responselabel from firstcontact_res Q41 where Q41.surveylabelnumber='Q41' and fc.studentid=Q41.studentid limit 1 ) "Q41"
 ,(select responselabel from firstcontact_res Q43 where Q43.surveylabelnumber='Q43' and fc.studentid=Q43.studentid limit 1 ) "Q43"
 ,(select responselabel from firstcontact_res Q44 where Q44.surveylabelnumber='Q44' and fc.studentid=Q44.studentid limit 1 ) "Q44"
 ,(select responselabel from firstcontact_res Q45_1 where Q45_1.surveylabelnumber='Q45_1' and fc.studentid=Q45_1.studentid limit 1 ) "Q45_1"
 ,(select responselabel from firstcontact_res Q45_10 where Q45_10.surveylabelnumber='Q45_10' and fc.studentid=Q45_10.studentid limit 1 ) "Q45_10"
 ,(select responselabel from firstcontact_res Q45_11 where Q45_11.surveylabelnumber='Q45_11' and fc.studentid=Q45_11.studentid limit 1 ) "Q45_11"
 ,(select responselabel from firstcontact_res Q45_12 where Q45_12.surveylabelnumber='Q45_12' and fc.studentid=Q45_12.studentid limit 1 ) "Q45_12"
 ,(select responselabel from firstcontact_res Q45_2 where Q45_2.surveylabelnumber='Q45_2' and fc.studentid=Q45_2.studentid limit 1 ) "Q45_2"
 ,(select responselabel from firstcontact_res Q45_3 where Q45_3.surveylabelnumber='Q45_3' and fc.studentid=Q45_3.studentid limit 1 ) "Q45_3"
 ,(select responselabel from firstcontact_res Q45_4 where Q45_4.surveylabelnumber='Q45_4' and fc.studentid=Q45_4.studentid limit 1 ) "Q45_4"
 ,(select responselabel from firstcontact_res Q45_5 where Q45_5.surveylabelnumber='Q45_5' and fc.studentid=Q45_5.studentid limit 1 ) "Q45_5"
 ,(select responselabel from firstcontact_res Q45_6 where Q45_6.surveylabelnumber='Q45_6' and fc.studentid=Q45_6.studentid limit 1 ) "Q45_6"
 ,(select responselabel from firstcontact_res Q45_7 where Q45_7.surveylabelnumber='Q45_7' and fc.studentid=Q45_7.studentid limit 1 ) "Q45_7"
 ,(select responselabel from firstcontact_res Q45_8 where Q45_8.surveylabelnumber='Q45_8' and fc.studentid=Q45_8.studentid limit 1 ) "Q45_8"
 ,(select responselabel from firstcontact_res Q45_9 where Q45_9.surveylabelnumber='Q45_9' and fc.studentid=Q45_9.studentid limit 1 ) "Q45_9"
 ,(select responselabel from firstcontact_res Q47 where Q47.surveylabelnumber='Q47' and fc.studentid=Q47.studentid limit 1 ) "Q47"
 ,(select responselabel from firstcontact_res Q49_1 where Q49_1.surveylabelnumber='Q49_1' and fc.studentid=Q49_1.studentid limit 1 ) "Q49_1"
 ,(select responselabel from firstcontact_res Q49_2 where Q49_2.surveylabelnumber='Q49_2' and fc.studentid=Q49_2.studentid limit 1 ) "Q49_2"
 ,(select responselabel from firstcontact_res Q49_3 where Q49_3.surveylabelnumber='Q49_3' and fc.studentid=Q49_3.studentid limit 1 ) "Q49_3"
 ,(select responselabel from firstcontact_res Q49_4 where Q49_4.surveylabelnumber='Q49_4' and fc.studentid=Q49_4.studentid limit 1 ) "Q49_4"
 ,(select responselabel from firstcontact_res Q49_5 where Q49_5.surveylabelnumber='Q49_5' and fc.studentid=Q49_5.studentid limit 1 ) "Q49_5"
 ,(select responselabel from firstcontact_res Q49_6 where Q49_6.surveylabelnumber='Q49_6' and fc.studentid=Q49_6.studentid limit 1 ) "Q49_6"
 ,(select responselabel from firstcontact_res Q51_1 where Q51_1.surveylabelnumber='Q51_1' and fc.studentid=Q51_1.studentid limit 1 ) "Q51_1"
 ,(select responselabel from firstcontact_res Q51_2 where Q51_2.surveylabelnumber='Q51_2' and fc.studentid=Q51_2.studentid limit 1 ) "Q51_2"
 ,(select responselabel from firstcontact_res Q51_3 where Q51_3.surveylabelnumber='Q51_3' and fc.studentid=Q51_3.studentid limit 1 ) "Q51_3"
 ,(select responselabel from firstcontact_res Q51_4 where Q51_4.surveylabelnumber='Q51_4' and fc.studentid=Q51_4.studentid limit 1 ) "Q51_4"
 ,(select responselabel from firstcontact_res Q51_5 where Q51_5.surveylabelnumber='Q51_5' and fc.studentid=Q51_5.studentid limit 1 ) "Q51_5"
 ,(select responselabel from firstcontact_res Q51_6 where Q51_6.surveylabelnumber='Q51_6' and fc.studentid=Q51_6.studentid limit 1 ) "Q51_6"
 ,(select responselabel from firstcontact_res Q51_7 where Q51_7.surveylabelnumber='Q51_7' and fc.studentid=Q51_7.studentid limit 1 ) "Q51_7"
 ,(select responselabel from firstcontact_res Q51_8 where Q51_8.surveylabelnumber='Q51_8' and fc.studentid=Q51_8.studentid limit 1 ) "Q51_8"
 ,(select responselabel from firstcontact_res Q52 where Q52.surveylabelnumber='Q52' and fc.studentid=Q52.studentid limit 1 ) "Q52"
 ,(select responselabel from firstcontact_res Q54_1 where Q54_1.surveylabelnumber='Q54_1' and fc.studentid=Q54_1.studentid limit 1 ) "Q54_1"
 ,(select responselabel from firstcontact_res Q54_10 where Q54_10.surveylabelnumber='Q54_10' and fc.studentid=Q54_10.studentid limit 1 ) "Q54_10"
 ,(select responselabel from firstcontact_res Q54_11 where Q54_11.surveylabelnumber='Q54_11' and fc.studentid=Q54_11.studentid limit 1 ) "Q54_11"
 ,(select responselabel from firstcontact_res Q54_12 where Q54_12.surveylabelnumber='Q54_12' and fc.studentid=Q54_12.studentid limit 1 ) "Q54_12"
 ,(select responselabel from firstcontact_res Q54_13 where Q54_13.surveylabelnumber='Q54_13' and fc.studentid=Q54_13.studentid limit 1 ) "Q54_13"
 ,(select responselabel from firstcontact_res Q54_2 where Q54_2.surveylabelnumber='Q54_2' and fc.studentid=Q54_2.studentid limit 1 ) "Q54_2"
 ,(select responselabel from firstcontact_res Q54_3 where Q54_3.surveylabelnumber='Q54_3' and fc.studentid=Q54_3.studentid limit 1 ) "Q54_3"
 ,(select responselabel from firstcontact_res Q54_4 where Q54_4.surveylabelnumber='Q54_4' and fc.studentid=Q54_4.studentid limit 1 ) "Q54_4"
 ,(select responselabel from firstcontact_res Q54_5 where Q54_5.surveylabelnumber='Q54_5' and fc.studentid=Q54_5.studentid limit 1 ) "Q54_5"
 ,(select responselabel from firstcontact_res Q54_6 where Q54_6.surveylabelnumber='Q54_6' and fc.studentid=Q54_6.studentid limit 1 ) "Q54_6"
 ,(select responselabel from firstcontact_res Q54_7 where Q54_7.surveylabelnumber='Q54_7' and fc.studentid=Q54_7.studentid limit 1 ) "Q54_7"
 ,(select responselabel from firstcontact_res Q54_8 where Q54_8.surveylabelnumber='Q54_8' and fc.studentid=Q54_8.studentid limit 1 ) "Q54_8"
 ,(select responselabel from firstcontact_res Q54_9 where Q54_9.surveylabelnumber='Q54_9' and fc.studentid=Q54_9.studentid limit 1 ) "Q54_9"
 ,(select responselabel from firstcontact_res Q56_1 where Q56_1.surveylabelnumber='Q56_1' and fc.studentid=Q56_1.studentid limit 1 ) "Q56_1"
 ,(select responselabel from firstcontact_res Q56_2 where Q56_2.surveylabelnumber='Q56_2' and fc.studentid=Q56_2.studentid limit 1 ) "Q56_2"
 ,(select responselabel from firstcontact_res Q56_3 where Q56_3.surveylabelnumber='Q56_3' and fc.studentid=Q56_3.studentid limit 1 ) "Q56_3"
 ,(select responselabel from firstcontact_res Q56_4 where Q56_4.surveylabelnumber='Q56_4' and fc.studentid=Q56_4.studentid limit 1 ) "Q56_4"
 ,(select responselabel from firstcontact_res Q56_5 where Q56_5.surveylabelnumber='Q56_5' and fc.studentid=Q56_5.studentid limit 1 ) "Q56_5"
 ,(select responselabel from firstcontact_res Q56_6 where Q56_6.surveylabelnumber='Q56_6' and fc.studentid=Q56_6.studentid limit 1 ) "Q56_6"
 ,(select responselabel from firstcontact_res Q56_7 where Q56_7.surveylabelnumber='Q56_7' and fc.studentid=Q56_7.studentid limit 1 ) "Q56_7"
 ,(select responselabel from firstcontact_res Q56_8 where Q56_8.surveylabelnumber='Q56_8' and fc.studentid=Q56_8.studentid limit 1 ) "Q56_8"
 ,(select responselabel from firstcontact_res Q58_1 where Q58_1.surveylabelnumber='Q58_1' and fc.studentid=Q58_1.studentid limit 1 ) "Q58_1"
 ,(select responselabel from firstcontact_res Q58_2 where Q58_2.surveylabelnumber='Q58_2' and fc.studentid=Q58_2.studentid limit 1 ) "Q58_2"
 ,(select responselabel from firstcontact_res Q58_3 where Q58_3.surveylabelnumber='Q58_3' and fc.studentid=Q58_3.studentid limit 1 ) "Q58_3"
 ,(select responselabel from firstcontact_res Q58_4 where Q58_4.surveylabelnumber='Q58_4' and fc.studentid=Q58_4.studentid limit 1 ) "Q58_4"
 ,(select responselabel from firstcontact_res Q60 where Q60.surveylabelnumber='Q60' and fc.studentid=Q60.studentid limit 1 ) "Q60"
 ,(select responselabel from firstcontact_res Q62 where Q62.surveylabelnumber='Q62' and fc.studentid=Q62.studentid limit 1 ) "Q62"
 ,(select responselabel from firstcontact_res Q62_TEXT where Q62_TEXT.surveylabelnumber='Q62_TEXT' and fc.studentid=Q62_TEXT.studentid limit 1 ) "Q62_TEXT"
 ,(select responselabel from firstcontact_res Q63_TEXT where Q63_TEXT.surveylabelnumber='Q63_TEXT' and fc.studentid=Q63_TEXT.studentid limit 1 ) "Q63_TEXT"
 ,(select responselabel from firstcontact_res Q64 where Q64.surveylabelnumber='Q64' and fc.studentid=Q64.studentid limit 1 ) "Q64"
 ,(select responselabel from firstcontact_res Q65_TEXT where Q65_TEXT.surveylabelnumber='Q65_TEXT' and fc.studentid=Q65_TEXT.studentid limit 1 ) "Q65_TEXT"
 from firstcontact_std fc where fc.studentid=tmp_table.studentid;                    		        
   end loop;
end;
$$; 

\copy (select * from tmp_report_2015) to 'tmp_report_20150327.csv' (FORMAT CSV,header true, FORCE_QUOTE *);


