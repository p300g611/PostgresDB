--1.a:sampledate: view student response by surveyid
SELECT distinct 
 ssr.id             ssrid
,ssr.activeflag     ssractive
,sr.activeflag      sractive
,sl.activeflag      slactive
,s.id               studentid
,sl.labelnumber     labelnumber
,sl.optional        optional
,sl.label::char(10) label_10
,sp.globalpagenum   globalpagenum
,sp.iscompleted     iscompleted
,sr.responsevalue::char(10) value_10
,sr.responselabel
FROM student s
inner join enrollment AS e  ON (e.studentid = s.id)
inner join survey sv ON s.id = sv.studentid
inner join studentsurveyresponse ssr ON sv.id = ssr.surveyid --and ssr.activeflag is true
inner join surveyresponse sr ON ssr.surveyresponseid = sr.id --and sr.activeflag is true
inner join surveylabel sl ON sr.labelid = sl.id -- and sl.activeflag is true
left outer join Surveypagestatus sp on sp.surveyid=sv.id and sp.globalpagenum =sl.globalpagenum
WHERE sv.id=8040 
and sp.globalpagenum in (12)
-- and sl.optional is false 
order by sp.globalpagenum,sl.labelnumber,sr.responselabel;

--1.b:sampledate: view no of mandatory questions in page
select sl.labelnumber,globalpagenum,optional,label::char(10)
from surveylabel  sl 
where  sl.globalpagenum=14 and sl.activeflag is true
order by 1;

--1.c:sampledate: view no of mandatory questions in page with responses
select sl.id labelid,sr.id responseid, sl.labelnumber,globalpagenum,optional,label::char(10)
,slp.surveylabelid
,slp.surveyresponseid
,slp.prerequisitecondition
,sr.responsevalue::char(10) value_10
,sr.responselabel
from surveylabel  sl 
inner join surveyresponse sr ON sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=1 and sl.activeflag is true and sr.activeflag is true
order by sl.labelnumber,sr.responselabel,slp.surveyresponseid;

--1.d:sampledate: view no of mandatory questions in page with responses and eliminate prerequisite
select sl.id labelid,sr.id responseid, sl.labelnumber,sl.globalpagenum,optional,label,pre.surveyresponseid pre
,slp.surveylabelid
,slp.surveyresponseid
,slp.prerequisitecondition
,sr.responsevalue::char(10) value_10
,sr.responselabel
from surveylabel  sl 
inner join surveyresponse sr ON sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
left outer join (select distinct globalpagenum,slp.surveyresponseid
from surveylabel  sl 
inner join surveyresponse sr ON sr.labelid = sl.id
inner join surveylabelprerequisite slp on slp.surveylabelid=sl.id) pre on pre.surveyresponseid=sr.id and pre.globalpagenum=sl.globalpagenum
where ( sl.globalpagenum=6) and sl.activeflag is true and sr.activeflag is true
and pre.surveyresponseid is null
order by sl.labelnumber,sr.responselabel,slp.surveyresponseid;





