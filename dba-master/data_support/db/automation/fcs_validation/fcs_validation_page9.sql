--1.a:validation: Find the all mandatory questions were not answered and iscompleted set true (note:not answered at least one question)
with all_ques as
(
select sv.id surveyid,sl.globalpagenum,count(distinct sl.labelnumber) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
cross join surveylabel  sl 
where e.currentschoolyear=2017  and sl.activeflag is true 
and cafcss.categorycode<>'CORE_SET_QUESTIONS'
and sl.globalpagenum=9 
group by sv.id,sl.globalpagenum
)
,all_answ as
(
select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and sl.globalpagenum=9
group by sv.id,sp.globalpagenum
)
select tgt.surveyid,tgt.globalpagenum,sp.id pageid,tgt.cnt questionscount, src.cnt answerscount
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where coalesce(src.cnt,0)<1 and sp.iscompleted is true; 


--1.b:validation: Find the all mandatory questions were answered and iscompleted set false (note:ALL response No)
with all_ques as
(
select sv.id surveyid,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end,count(distinct sl.id) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and optional= case when cafcss.categorycode='CORE_SET_QUESTIONS' then false else sl.optional end
and sl.globalpagenum in (6,7,8) and sl.id in (3,5,8) --(Q39,Q39,Q43)
and sr.id in (17,22,30)                              --(No)
group by sv.id,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end
having count(distinct sl.id)=3
)
,all_answ as
(
select sv.id surveyid,sl.globalpagenum,count(distinct sl.id) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and optional= case when cafcss.categorycode='CORE_SET_QUESTIONS' then false else sl.optional end
and sl.globalpagenum=9 and sl.id =23 --(Q47)
group by sv.id,sl.globalpagenum
)
select tgt.surveyid,tgt.globalpagenum,sp.id pageid,tgt.cnt questionscount, src.cnt answerscount
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where coalesce(src.cnt,0)=1 and coalesce(tgt.cnt,0)=3 and sp.iscompleted is false; 

--1.c:validation: Find the all mandatory questions were not answered and iscompleted set true (note:ALL response No)
with all_ques as
(
select sv.id surveyid,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end,count(distinct sl.id) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and optional= case when cafcss.categorycode='CORE_SET_QUESTIONS' then false else sl.optional end
and sl.globalpagenum in (6,7,8) and sl.id in (3,5,8) --(Q36,Q39,Q43)
and sr.id in (17,22,30)                              --(No)
group by sv.id,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end
having count(distinct sl.id)=3
)
,all_answ as
(
select sv.id surveyid,sl.globalpagenum,count(distinct sl.id) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and optional= case when cafcss.categorycode='CORE_SET_QUESTIONS' then false else sl.optional end
and sl.globalpagenum=9 and sl.id =23 --(Q47)
group by sv.id,sl.globalpagenum
)
select tgt.surveyid,tgt.globalpagenum,sp.id pageid,tgt.cnt questionscount, src.cnt answerscount
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where coalesce(src.cnt,0)<1 and coalesce(tgt.cnt,0)=3 and sp.iscompleted is true;

--1.d:validation: Find the all mandatory questions were answered and iscompleted set false (note:at least on one response yes)
with all_ques as
(
select sv.id surveyid,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end,
count(distinct case when sl.id in (6,7,8) then 9 else sl.id end) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and cafcss.categorycode<>'CORE_SET_QUESTIONS' 
and (
sl.globalpagenum =6 and sl.id =3 and sr.id =16 or                        --(Q36,Q39,Q43) --(Yes)
sl.globalpagenum =7 and sl.id =5 and sr.id =21 or                        --(Q36,Q39,Q43) --(Yes)
sl.globalpagenum =8 and sl.id =8 and sr.id =29                           --(Q36,Q39,Q43) --(Yes)
)
group by sv.id,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end
)
,all_answ as
(
select sv.id surveyid,sl.globalpagenum,
count(distinct case when sl.id in (141,142,143,144,145) then 141 
when sl.id in (146,147,148,149) then 146 else sl.id end ) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and cafcss.categorycode<>'CORE_SET_QUESTIONS' 
and sl.globalpagenum=9 and sl.id in (140,141,142,143,144,145,146,147,148,149)      --(Q210,Q211_1,Q211_2,Q211_3,Q211_4,Q211_5,Q300_1,Q300_2,Q300_3,Q300_4,Q47)
group by sv.id,sl.globalpagenum
)
select tgt.surveyid,tgt.globalpagenum,sp.id pageid,tgt.cnt questionscount, src.cnt answerscount
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where coalesce(src.cnt,0)>= 3 and sp.iscompleted is false; 

--1.e:validation: Find the all mandatory questions were not answered and iscompleted set true (note:at least on one response yes)
with all_ques as
(
select sv.id surveyid,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end,
count(distinct case when sl.id in (6,7,8) then 9 else sl.id end) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and cafcss.categorycode<>'CORE_SET_QUESTIONS' 
and (
sl.globalpagenum =6 and sl.id =3 and sr.id =16 or                        --(Q36,Q39,Q43) --(Yes)
sl.globalpagenum =7 and sl.id =5 and sr.id =21 or                        --(Q36,Q39,Q43) --(Yes)
sl.globalpagenum =8 and sl.id =8 and sr.id =29                           --(Q36,Q39,Q43) --(Yes)
)
group by sv.id,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end
)
,all_answ as
(
select sv.id surveyid,sl.globalpagenum,
count(distinct case when sl.id in (141,142,143,144,145) then 141 
when sl.id in (146,147,148,149) then 146 else sl.id end ) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and cafcss.categorycode<>'CORE_SET_QUESTIONS' 
and sl.globalpagenum=9 and sl.id in (140,141,142,143,144,145,146,147,148,149)      --(Q210,Q211_1,Q211_2,Q211_3,Q211_4,Q211_5,Q300_1,Q300_2,Q300_3,Q300_4,Q47)
group by sv.id,sl.globalpagenum
)
select tgt.surveyid,tgt.globalpagenum,sp.id pageid,tgt.cnt questionscount, src.cnt answerscount
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where coalesce(src.cnt,0)< 3 and sp.iscompleted is true;

--1.f page9 is mandatory except core set and any one response from page 6,7,8 yes 
with all_ques as
(
select sv.id surveyid,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end,
count(distinct case when sl.id in (6,7,8) then 9 else sl.id end) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner JOIN studentsurveyresponse ssr       ON sv.id = ssr.surveyid and ssr.activeflag is true
inner JOIN surveyresponse sr               ON ssr.surveyresponseid = sr.id and sr.activeflag is true
inner JOIN surveylabel sl                  ON sr.labelid = sl.id and sl.activeflag is true
inner join surveypagestatus sp             on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
where e.currentschoolyear=2017  and sl.activeflag is true 
and cafcss.categorycode='CORE_SET_QUESTIONS'
and (
sl.globalpagenum =6 and sl.id =3 and sr.id =16 or                        --(Q36,Q39,Q43) --(Yes)
sl.globalpagenum =7 and sl.id =5 and sr.id =21 or                        --(Q36,Q39,Q43) --(Yes)
sl.globalpagenum =8 and sl.id =8 and sr.id =29                           --(Q36,Q39,Q43) --(Yes)
)
group by sv.id,case when sl.globalpagenum in (6,7,8) then 9 else sl.globalpagenum end
)
select tgt.surveyid,tgt.globalpagenum,sp.id pageid,tgt.cnt questionscount
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
where sp.iscompleted is false;



