--================================================================================
--3) b) If a page has mandatory question and if it a prerequisite question--568
-- all_questions -- all are madatory questions
-- Due to this settting flag is true or false in  (2,3,5,6,7,8,9)
--================================================================================
-- case1p2:list of pages has false condition and has prequisites pages has answered 
-- we did not find any record so no need to set true
--validation --(note pending 9 in case 3,4)
select sl.labelnumber,globalpagenum,slp.*,optional from surveylabel  sl 
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=13
order by 1

 select  sp.globalpagenum,count(*) from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum in (1,2,3,5,6,7,8,9)
    group by sp.globalpagenum order by 1;
    
-- globalpagenum │ count │
-- ├───────────────┼───────┤
-- │             2 │    37 │
-- │             3 │    39 │
-- │             5 │    46 │
-- │             6 │    42 │
-- │             7 │    43 │
-- │             8 │    47 │
-- │             9 │   239 │
-- └───────────────┴───────┘
-- (7 rows)

-- by page level 
--page2
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=2            
)
select  distinct sl.labelnumber,sp.id from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;
--  labelnumber │   id    │
-- ├─────────────┼─────────┤
-- │ Q19         │  352594 │
-- │ Q19         │ 1616957 │
-- │ Q19         │ 1095674 │
-- │ Q19         │ 2254651 │

-- depending questions, are not answered so we do not need to set true

-- 
--page3
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=3           
)
select  distinct sl.labelnumber,sp.id from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;
 -- labelnumber │   id    │
-- ├─────────────┼─────────┤
-- │ Q22         │ 2277039 │
-- depending questions, are not answered so we do not need to set true

--page5
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=5          
)
select  distinct sl.labelnumber,sp.id from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;

-- labelnumber │   id   │
-- ├─────────────┼────────┤
-- │ Q143        │ 322322 
-- depending questions, are not answered so we do not need to set true

--page 6 has no record

--page 7
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=7          
)
select  distinct sl.labelnumber,sp.id from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;
-- │ labelnumber │   id   │
-- ├─────────────┼────────┤
-- │ Q39         │ 613669
-- depending questions, are not answered so we do not need to set true

--page 8
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=8          
)
select  distinct sl.labelnumber,sp.id from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;
-- labelnumber │   id   │
-- ├─────────────┼────────┤
-- │ Q43         │ 468500 │
-- │ Q43         │ 368997 │
--depending questions are not answered so we do not need to set true

--page9 
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=9             
)
select  distinct sl.labelnumber,sp.id,sp.surveyid from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;
-- │ labelnumber │   id   │ surveyid │
-- ├─────────────┼────────┼──────────┤
-- │ Q47         │ 206339 │    10602 │
-- │ Q47         │ 211108 │    10853 │
-- │ Q211_5      │ 157015 │     8004 │
-- │ Q300_4      │ 396320 │    20582 │
-- │ Q47         │  62090 │     3152 │
-- │ Q47         │ 212723 │    10940 │
-- │ Q47         │ 427081 │    22209 │
-- │ Q300_4      │ 157015 │     8004 │
-- │ Q47         │  18790 │      943 │
-- │ Q300_4      │  21850 │     1096 │
-- │ Q47         │ 206472 │    10609 │
-- │ Q47         │ 656802 │    34309 │
-- │ Q47         │ 146413 │     7446 │
-- │ Q47         │ 507736 │    26460 │
-- │ Q47         │ 690147 │    36068 │
-- │ Q210        │  21850 │     1096 │
-- │ Q211_3      │  21850 │     1096 │
-- │ Q47         │ 558179 │    29123 │
-- │ Q47         │ 663851 │    34683 │
-- │ Q47         │  82691 │     4183 │
-- │ Q211_5      │  21850 │     1096 │
-- │ Q47         │  35530 │     1819 │
-- │ Q47         │ 241774 │    12471 │
-- │ Q211_1      │  21850 │     1096 │
-- │ Q47         │  70030 │     3549 

-- from the above script survey have q47,q211,q300 so we need to validate.


-- report \f ',' \a  \o 'validation_3_case3_p9_nq47.csv' 
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=9  and  sl.labelnumber ='Q47'          
),page9 as 
(
select  distinct sl.labelnumber,sp.id,sp.surveyid from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id and sl.globalpagenum=sp.globalpagenum
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum )
select distinct page9.id pageid,page9.surveyid from survey sv
inner join page9 on page9.surveyid=sv.id
inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id 
where case when sl.labelnumber ='Q36' then sr.responsevalue='No' 
           when sl.labelnumber ='Q39' then sr.responsevalue='No'
           when sl.labelnumber ='Q43' then sr.responsevalue='No' end;


-- we found 25 pages on 9 need to set active 
-- report \f ',' \a  \o 'validation_3_case3_p9_nq47.csv' 
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is false
    and sp.globalpagenum=9  and  sl.labelnumber in ('Q211_5','Q300_4' ,'Q211_5', 'Q211_3','Q211_1')      
),page9 as 
(
select  distinct sl.labelnumber,sp.id,sp.surveyid from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id and sl.globalpagenum=sp.globalpagenum
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum )
select distinct page9.id pageid,page9.surveyid from survey sv
inner join page9 on page9.surveyid=sv.id
inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id 
where case when sl.labelnumber ='Q36' then sr.responsevalue<>'No' 
           when sl.labelnumber ='Q39' then sr.responsevalue<>'No'
           when sl.labelnumber ='Q43' then sr.responsevalue<>'No' end;

           
-- where case when sl.labelnumber ='Q36' then sr.responsevalue='Yes' 
--            when sl.labelnumber ='Q39' then sr.responsevalue='Yes'
--            when sl.labelnumber ='Q43' then sr.responsevalue='Yes' end;
-- 
-- where      case when sl.labelnumber ='Q43' then sr.responsevalue<>'No' end and 
--            case when sl.labelnumber ='Q39' then sr.responsevalue<>'No' end and 
--            case when sl.labelnumber ='Q36' then sr.responsevalue<>'No' end;
--  pageid | surveyid
-- --------+----------
--   21850 |     1096
--  157015 |     8004
--  396320 |    20582

--example:
/*
select sl.labelnumber,globalpagenum,sp.*,optional from surveylabel  sl 
left outer join surveylabelprerequisite sp on sp.surveylabelid=sl.id
where globalpagenum in (6,7,8,9)
order by 2;
select * from surveyresponse where id in (17,22,30);

SELECT  distinct ssr.activeflag ,sr.activeflag,s.id, ssr.createddate, ssr.modifieddate,
        sl.labelnumber AS "Survey Label Number",
        sr.responsevalue  AS "Survey Response"
       ,sp.globalpagenum
       --,sp.*
       ,ssr.activeflag,sr.activeflag
 FROM student s
 JOIN enrollment AS e  ON (e.studentid = s.id)
 JOIN survey sv ON s.id = sv.studentid
 JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid --and ssr.activeflag is true
 JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id --and sr.activeflag is true
 JOIN surveylabel sl ON sr.labelid = sl.id 
 left outer join Surveypagestatus sp on sp.surveyid=sv.id and sp.globalpagenum =sl.globalpagenum
 WHERE  sv.id=1096  and sp.globalpagenum in (6,7,8,9)
 order by 3;
*/

-----------------------------------------------------------------------------
--case2:list of pages has true condition and has prequisites pages question are not answered .
--validation 
select  sp.globalpagenum,count(distinct sp.id) from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum in (2,3,5,6,7,8,9)
    group by sp.globalpagenum order by 1;
    
--  globalpagenum │ count │
-- ├───────────────┼───────┤
-- │             2 │  6824 │
-- │             3 │  6822 │
-- │             5 │  6813 │
-- │             6 │  6817 │
-- │             7 │  6816 │
-- │             8 │  6812 │
-- │             9 │  6617
-- (7 rows)

-- by page level 
--page2 --------------------------------
--validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2             
)
select  sl.labelnumber,optional,count(distinct sp.id) from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
group by sl.labelnumber,optional
;
 -- labelnumber │ optional │ count │
-- ├─────────────┼──────────┼───────┤
-- │ Q19         │ t        │  5863 │
-- │ Q20_1       │ t        │    89 │
-- │ Q20_2       │ t        │    37 │
-- │ Q20_3       │ t        │   121 │
-- │ Q20_4       │ t        │    32 │
-- │ Q20_5       │ t        │   215 │
-- │ Q20_6       │ t        │   102 │
-- │ Q330        │ t        │   286 
-- select globalpagenum,activeflag,surveyid,count(*) from surveypagestatus
-- group by globalpagenum,surveyid,activeflag
-- having count(*)>1 limit 10;
-- all Question Labels which has prerequisites answered which are prequisites for page2

with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  
),page2_nq19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber <>'Q19' )
-- select tgt.id pageid ,src.surveyid 
select tgt.*
 from page2_nq19 tgt
left outer join page2_q19 src on tgt.surveyid=src.surveyid
where src.surveyid is null; 
/*
--fix test 

begin;
update studentsurveyresponse
set activeflag =false
where  id=8241567;
commit;
SELECT  distinct ssr.id,ssr.activeflag ,sr.activeflag,s.id, ssr.createddate, ssr.modifieddate,
        sl.labelnumber AS "Survey Label Number",
        sr.responsevalue  AS "Survey Response",sr.responseorder
       ,sp.globalpagenum
       ,sp.*
       ,ssr.activeflag,sr.activeflag
 FROM student s
 JOIN enrollment AS e  ON (e.studentid = s.id)
 JOIN survey sv ON s.id = sv.studentid
 JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid --and ssr.activeflag is true
 JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id --and sr.activeflag is true
 JOIN surveylabel sl ON sr.labelid = sl.id 
 left outer join Surveypagestatus sp on sp.surveyid=sv.id and sp.globalpagenum =sl.globalpagenum
 WHERE  sv.id=131113 and sp.globalpagenum in (2)
 order by 3;

*/

-- Rajendra : need update query to set iscompleted to false.
--datateam :script executed on stage
-- UPDATE 0
--detail level by response (did not answer the dependent question if they have for 
--Q19_2 validation
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  and sr.responselabel='2' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in  (      
 'Q20_1','Q20_2','Q20_3','Q20_4','Q20_5','Q20_6',
 'Q330'
 )
  )
---************************************************---------

begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in ( 
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  and sr.responselabel='2' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in  (      
 'Q20_1','Q20_2','Q20_3','Q20_4','Q20_5','Q20_6',
 'Q330'
 )
  )
select tgt.id 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null
  ) and iscompleted is true;
commit;
---*******************************************----------------------------------------------------------  

  
-- select tgt.id pageid ,src.surveyid 
select count(*)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;

 
-- │ count │
-- ├───────┤
-- │     4 │
-- └───────┘
-- (1 row)

-- report \f ',' \a  \o 'vvalidation_3_case4_p2_q19_2.csv' 
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  and sr.responselabel='2' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in  (      
 'Q20_1','Q20_2','Q20_3','Q20_4','Q20_5','Q20_6',
 'Q330'
 )
  )
select tgt.id pageid ,tgt.surveyid 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;



--Q19_3 validation
-- Rajendra : Need update query for the following. set iscompleted to false
-- datateam : script executed on stage
-- UPDATE 203

 with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  and sr.responselabel='3' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in  (      
 'Q20_1','Q20_2','Q20_3','Q20_4','Q20_5','Q20_6'--,
 --'Q330'
 )
  ) 
   --select tgt.id pageid ,tgt.surveyid 
select count(distinct tgt.surveyid)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null limit 10; 

-- │ count │
-- ├───────┤
-- │  5403 │
-- └───────┘
-- (1 row)
--**********************************--
begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
 with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  and sr.responselabel='3' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in  (      
 'Q20_1','Q20_2','Q20_3','Q20_4','Q20_5','Q20_6'--,
 --'Q330'
 )
  ) 
 select tgt.id 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null
  ) and iscompleted is true;

commit;
--**********************************--

-- report \f ',' \a  \o 'vvalidation_3_case4_p2_q19_3.csv' 
 with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  and sr.responselabel='3' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in  (      
 'Q20_1','Q20_2','Q20_3','Q20_4','Q20_5','Q20_6'--,
 --'Q330'
 )
  )
select tgt.id pageid ,tgt.surveyid 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null; 



--page3------------------------------ 
--validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=3             
)
select  sl.labelnumber,optional,count(distinct sp.id) from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
group by sl.labelnumber,optional
;

│--  labelnumber │ optional │ count │
-- ├─────────────┼──────────┼───────┤
-- │ Q22         │ t        │  5832 │
-- │ Q23_1       │ t        │   322 │
-- │ Q23_2       │ t        │   281 │
-- │ Q23_3       │ t        │    12 │
-- │ Q24_1       │ t        │    16 │
-- │ Q24_2       │ t        │    10 │
-- │ Q24_3       │ t        │     7 │
-- │ Q25_1       │ t        │   113 │
-- │ Q25_2       │ t        │    14 │
-- │ Q25_3       │ t        │   132 │
-- │ Q25_4       │ t        │    10 │
-- │ Q25_5       │ t        │     3 │
-- │ Q25_6       │ t        │    74 │
-- │ Q25_7       │ t        │    10 │
-- │ Q429_1      │ t        │   109 │
-- │ Q429_2      │ t        │    73 │
-- │ Q429_3      │ t        │    16 │
-- │ Q429_4      │ t        │    37 │
-- │ Q429_5      │ t        │   118 │
-- └─────────────┴──────────┴───────┘
-- (19 rows)
-- Rajendra : Need update query for the below scenario
-- UPDATE 1
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q22'  and sr.responselabel='3' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
  'Q23_1','Q23_2', 'Q23_3', 
  --'Q24_1','Q24_2', 'Q24_3',  
  'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
  'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5')
  )
-- select tgt.id pageid ,src.surveyid 
select count(*)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
; 
-- count │ 37 │
-- └───────┴────┘
--*******************************************--


begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q22'  and sr.responselabel='3' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
  'Q23_1','Q23_2', 'Q23_3', 
  --'Q24_1','Q24_2', 'Q24_3',  
  'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
  'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5')
  )
   select tgt.id 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null
  ) and iscompleted is true;

commit;
--***************************************--

--Q22-4
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q22'  and sr.responselabel='4' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
  'Q23_1','Q23_2', 'Q23_3'--, 
  --'Q24_1','Q24_2', 'Q24_3',  
  --'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
 -- 'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5'
 )
  )
-- select tgt.id pageid ,src.surveyid 
select count(*)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
; 

---=====================================================================================
-- UPDATE 11

begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
 with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q22'  and sr.responselabel='4' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
  'Q23_1','Q23_2', 'Q23_3'--, 
  --'Q24_1','Q24_2', 'Q24_3',  
  --'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
 -- 'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5'
 )
  )
 select tgt.id 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
  ) and iscompleted is true;

commit;
-------------------------------------------------------------------------

--Q23-3
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q23'  and sr.responselabel='3' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
 -- 'Q23_1','Q23_2', 'Q23_3', 
  'Q24_1','Q24_2', 'Q24_3'--,  
  --'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
 -- 'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5'
 )
  )
-- select tgt.id pageid ,src.surveyid
select count(*)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
;

---=====================================================================================
-- UPDATE 0

begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q23'  and sr.responselabel='3' --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
 -- 'Q23_1','Q23_2', 'Q23_3', 
  'Q24_1','Q24_2', 'Q24_3'--,  
  --'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
 -- 'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5'
 )
  )
 select tgt.id 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
  ) and iscompleted is true;

commit;
-------------------------------------------------------------------------

 --page5------------------------
 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=5             
)
select  sl.labelnumber,optional,count(distinct sp.id) from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
group by sl.labelnumber,optional
;

-- │ labelnumber │ optional │ count │
-- ├─────────────┼──────────┼───────┤
-- │ Q143        │ t        │  5859 │
-- │ Q147        │ t        │   289 │
-- │ Q201        │ t        │  4613 │
-- │ Q202        │ t        │  4913 │
-- │ Q33_1       │ t        │  3528 │
-- │ Q33_11      │ t        │   130 │
-- │ Q33_2       │ t        │     3 │
-- │ Q33_3       │ t        │   267 │
-- │ Q33_5       │ t        │  2153 │
-- │ Q33_6       │ t        │  1869 │
-- │ Q33_8       │ t        │    48 │
-- └─────────────┴──────────┴───────┘
-- (11 rows)
--Q143_1 and Q143_2 and Q143_3
-- Rajendra : Update query required. 
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel in ('1','2','3') --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 'Q33_1','Q33_2','Q33_3','Q33_5','Q33_6','Q33_8','Q33_11','Q201'--,
 --'Q147'
  )
  )
  -- select tgt.id pageid ,src.surveyid 
select count(*)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
;

-- │ count │
-- ├───────┤
-- │   869 │
-- └───────┘
-- (1 row)
--******************************************--
-- UPDATE 39
begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel in ('1','2','3') --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 'Q33_1','Q33_2','Q33_3','Q33_5','Q33_6','Q33_8','Q33_11','Q201'--,
 --'Q147'
  )
  )
select tgt.id 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null
  ) and iscompleted is true; 

commit;
--******************************************--


-- report \f ',' \a  \o 'validation_3_case4_p5_q143_1_2_3.csv' 
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel in ('1','2','3') --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 'Q33_1','Q33_2','Q33_3','Q33_5','Q33_6','Q33_8','Q33_11','Q201'--,
 --'Q147'
  )
  )

select tgt.id pageid ,tgt.surveyid
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
;
--Q143_5 and Q143_5
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel in ('4','5') --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 --'Q33_1','Q33_2','Q33_3','Q33_5','Q33_6','Q33_8','Q33_11','Q201',
 'Q147'
  )
  )

-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
;



-- │ count │
-- ├───────┤
-- │    19 │

--******************************************--
-- UPDATE 0

begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel in ('4','5') --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 --'Q33_1','Q33_2','Q33_3','Q33_5','Q33_6','Q33_8','Q33_11','Q201',
 'Q147'
  )
  )

select tgt.id 
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
  ) and iscompleted is true; 

commit;
--******************************************--


-- report \f ',' \a  \o 'validation_3_case4_p5_q143_4_5.csv' 
with page2_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel in ('4','5') --and optional is false
),page2_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 --'Q33_1','Q33_2','Q33_3','Q33_5','Q33_6','Q33_8','Q33_11','Q201',
 'Q147'
  ) 
)
select tgt.id pageid ,tgt.surveyid
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null 
;



 --page6------------------------
 --validation
 with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=6             
)
select  sl.labelnumber,optional,count(distinct sp.id) from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
group by sl.labelnumber,optional
;
-- │ labelnumber │ optional │ count │
-- ├─────────────┼──────────┼───────┤
-- │ Q34_1       │ t        │    68 │
-- │ Q34_2       │ t        │   134 │
-- │ Q34_3       │ t        │    47 │
-- │ Q36         │ f        │  6821 │
-- │ Q37         │ f        │  5041 │

-- select sl.labelnumber,globalpagenum,slp.*,optional,sr.responseorder,sr.responsevalue from surveylabel  sl 
-- left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
-- inner join surveyresponse sr on sr.labelid = sl.id
-- where  sl.globalpagenum=6 and 'Q36'=labelnumber
-- order by 1,responseorder   
with page6_q19 as 
( 
select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=6 and sl.labelnumber ='Q36'  and sr.responsevalue='Yes' --and optional is false  -- for response 1,2,3 we did not find any records
),page6_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=6 and sl.labelnumber in  (      
 'Q37'
 )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page6_q19 tgt
left outer join page6_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;
--  count │
-- ├───────┤
-- │     1 

--******************************************--
-- UPDATE 0

begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with page6_q19 as 
( 
select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=6 and sl.labelnumber ='Q36'  and sr.responsevalue='Yes' --and optional is false  -- for response 1,2,3 we did not find any records
),page6_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=6 and sl.labelnumber in  (      
 'Q37'
 )
  )
select tgt.id 
 from page6_q19 tgt
left outer join page6_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null
  ) and iscompleted is true; 

commit;
--******************************************--
-- report \f ',' \a  \o 'validation_3_case2_p6_q36.csv' 
with page6_q19 as 
( 
select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=6 and sl.labelnumber ='Q36'  and sr.responsevalue='Yes' --and optional is false  -- for response 1,2,3 we did not find any records
),page6_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=6 and sl.labelnumber in  (      
 'Q37'
 )
  )
select tgt.id pageid ,tgt.surveyid
 from page6_q19 tgt
left outer join page6_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;
------------------------------------------------------------------------------------------------------------
-- by page level --page7 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=7             
)
select  sl.labelnumber,optional,count(distinct sp.id) from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
group by sl.labelnumber,optional
;
-- │ labelnumber │ optional │ count │
-- ├─────────────┼──────────┼───────┤
-- │ Q39         │ f        │  6821 │
-- │ Q40         │ f        │   537 │
-- │ Q41         │ t        │   523 │
-- └─────────────┴──────────┴───────┘
-- (3 rows)



-- select sl.labelnumber,globalpagenum,slp.*,optional,sr.responseorder,sr.responsevalue from surveylabel  sl 
-- left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
-- inner join surveyresponse sr on sr.labelid = sl.id
-- where  sl.globalpagenum=6 and 'Q36'=labelnumber
-- order by 1,responseorder    

with page7_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=7 and sl.labelnumber ='Q39'  and sr.responsevalue='Yes' --and optional is false  -- for response 1,2,3 we did not find any records
),page7_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=7 and sl.labelnumber in  (      
 'Q40','Q41'
 )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page7_q19 tgt
left outer join page7_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;

------------------------------------------------------------------------------------------------------------
-- by page level --page8 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=8             
)
select  sl.labelnumber,optional,count(distinct sp.id) from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
group by sl.labelnumber,optional
;
-- │ labelnumber │ optional │ count │
-- ├─────────────┼──────────┼───────┤
-- │ Q43         │ f        │  6817 │
-- │ Q44         │ f        │  1742 │
-- └─────────────┴──────────┴───────┘
-- (2 rows)



-- select sl.labelnumber,globalpagenum,slp.*,optional,sr.responseorder,sr.responsevalue from surveylabel  sl 
-- left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
-- inner join surveyresponse sr on sr.labelid = sl.id
-- where  sl.globalpagenum=6 and 'Q36'=labelnumber
-- order by 1,responseorder    

with page8_q19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum  
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
    and sp.globalpagenum=8 and sl.labelnumber ='Q43'  and sr.responsevalue='Yes' --and optional is false  -- for response 1,2,3 we did not find any records
),page8_nq19 as 
(
 select distinct sp.id pageid,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=8 and sl.labelnumber in  (      
 'Q44'
 )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page8_q19 tgt
left outer join page8_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;
------------------------------------------------------------------------------------------------------------
-- by page level --page9 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
    and sp.globalpagenum=9             
)
select  sl.labelnumber,optional,count(distinct sp.id) from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
group by sl.labelnumber,optional;
--  labelnumber | optional | count
-- -------------+----------+-------
--  Q210        | t        |  5597
--  Q211_1      | t        |  2969
--  Q211_2      | t        |  1462
--  Q211_3      | t        |  3355
--  Q211_4      | t        |  2862
--  Q211_5      | t        |  2337
--  Q300_1      | t        |   284
--  Q300_2      | t        |   290
--  Q300_3      | t        |   562
--  Q300_4      | t        |  4479
--  Q47         | f        |   575
-- (11 rows)


-- select sl.labelnumber,globalpagenum,slp.*,optional,sr.responseorder,sr.responsevalue from surveylabel  sl 
-- left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
-- inner join surveyresponse sr on sr.labelid = sl.id
-- where  sl.globalpagenum=6 and 'Q36'=labelnumber
-- order by 1,responseorder    

-- Rajendra : Required update query for the below scenario.
-- survey completed for 6,7,8  with No values but no response for page 9 Q47  (need to find out if need to change iscompleted false for 6,7,8)
-- report \f ',' \a  \o 'validation_3_case4_p9_q47.csv'
with page9_q19 as 
(
 select distinct sp.surveyid,sl.labelnumber 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
 and sl.labelnumber in ('Q43','Q39','Q36') and sr.responsevalue='No'-- and optional is false 
)
,page678 as 
(
select surveyid,count(distinct labelnumber) from page9_q19
group by surveyid 
having count(distinct labelnumber)=3
)
,page9_nq19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=9 and sl.labelnumber='Q47' 
 )
 --select tgt.id pageid ,src.surveyid, 
--select tgt.surveyid ,sp.globalpagenum,sp.iscompleted,sp.id pageid
 select count(distinct tgt.surveyid)
 from page678 tgt
left outer join page9_nq19 src on tgt.surveyid=src.surveyid
left outer join surveypagestatus sp on sp.surveyid=tgt.surveyid 
and sp.globalpagenum in (9,6,7,8) 
 --and sp.globalpagenum in (9)  --and sp.iscompleted is true
where src.surveyid is null;

-- ─[ RECORD 1 ]─┐
-- │ count │ 13 │

 --***************************************--
--  UPDATE 1
begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where surveyid in (
with page9_q19 as 
(
 select distinct sp.surveyid,sl.labelnumber 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
 and sl.labelnumber in ('Q43','Q39','Q36') and sr.responsevalue='No'-- and optional is false 
)
,page678 as 
(
select surveyid,count(distinct labelnumber) from page9_q19
group by surveyid 
having count(distinct labelnumber)=3
)
,page9_nq19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=9 and sl.labelnumber='Q47' 
 ) 
 select  tgt.surveyid
 from page678 tgt
left outer join page9_nq19 src on tgt.surveyid=src.surveyid
left outer join surveypagestatus sp on sp.surveyid=tgt.surveyid 
and sp.globalpagenum in (9,6,7,8) 
 --and sp.globalpagenum in (9)  --and sp.iscompleted is true
where src.surveyid is null) and iscompleted is true and globalpagenum=9;
commit;
 --****************************************--
 

-- Rajendra : Need update query.
--report \f ',' \a  \o 'validation_3_case4_p9_nq47.csv'
with page9_q19 as 
(
 select distinct sp.surveyid,sl.labelnumber 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
 and ((sl.labelnumber ='Q43' and sr.responsevalue='Yes')  or
      (sl.labelnumber ='Q39' and sr.responsevalue='Yes')  or
      (sl.labelnumber ='Q36' and sr.responsevalue='Yes') )
 --and optional is false 
)
,page678 as 
(
select surveyid,count(labelnumber) from page9_q19
group by surveyid 
having count(distinct labelnumber)=3
)
,page9_nq19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=9 and sl.labelnumber in ('Q210',    
'Q211_1',   
'Q211_2',   
'Q211_3',   
'Q211_4',   
'Q211_5',   
'Q300_1',   
'Q300_2',   
'Q300_3',   
'Q300_4'   
)
 )
 --select tgt.id pageid ,src.surveyid, 
--select tgt.surveyid ,sp.globalpagenum,sp.iscompleted,sp.id pageid
 select count(distinct tgt.surveyid)
 from page678 tgt
left outer join page9_nq19 src on tgt.surveyid=src.surveyid
left outer join surveypagestatus sp on sp.surveyid=tgt.surveyid 
--and sp.globalpagenum in (9,6,7,8) 
 and sp.globalpagenum in (9)  --and sp.iscompleted is true
where src.surveyid is null;

-- ─[ RECORD 1 ]─┐
-- │ count │ 15 │
-- └───────┴────┘

--*********************************************--
-- UPDATE 10

begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where surveyid in (
with page9_q19 as 
(
 select distinct sp.surveyid,sl.labelnumber 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true 
 and ((sl.labelnumber ='Q43' and sr.responsevalue='Yes')  or
      (sl.labelnumber ='Q39' and sr.responsevalue='Yes')  or
      (sl.labelnumber ='Q36' and sr.responsevalue='Yes') )
 --and optional is false 
)
,page678 as 
(
select surveyid,count(labelnumber) from page9_q19
group by surveyid 
having count(distinct labelnumber)=3
)
,page9_nq19 as 
(
 select distinct sp.id,sp.surveyid,sp.globalpagenum 
 from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
 inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner join surveylabel sl on sr.labelid = sl.id and sp.globalpagenum=sl.globalpagenum
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568 and sp.iscompleted is true
 and sp.globalpagenum=9 and sl.labelnumber in ('Q210',    
'Q211_1',   
'Q211_2',   
'Q211_3',   
'Q211_4',   
'Q211_5',   
'Q300_1',   
'Q300_2',   
'Q300_3',   
'Q300_4'   
)
 )
select tgt.surveyid
 from page678 tgt
left outer join page9_nq19 src on tgt.surveyid=src.surveyid
left outer join surveypagestatus sp on sp.surveyid=tgt.surveyid 
--and sp.globalpagenum in (9,6,7,8) 
 and sp.globalpagenum in (9)  --and sp.iscompleted is true
where src.surveyid is null) and iscompleted is true and globalpagenum=9;
commit;
--**********************************************--