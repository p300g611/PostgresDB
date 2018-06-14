--================================================================================
--3) a)If a page has mandatory question and if it a prerequisite question--567 (Core Set) 
--In Core set mode we dont' have any mandatory questions in page 2,3,5 but 6,7,8 has mandatory questiosn 
-- core set apply for mandatory questions only
-- due to this settting flag is true or false in (2,3,5,6,7,8,9)
--================================================================================ 
-- case1p2:list of pages has false condition and has prequisites pages has answered 

--validation 
select sl.labelnumber,globalpagenum,slp.*,optional,sr.responseorder,responselabel from surveylabel  sl 
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
inner join surveyresponse sr on sr.labelid = sl.id
where  sl.globalpagenum=3
order by 1,responseorder;



 select  sp.globalpagenum,count(*) from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is false
    and sp.globalpagenum in (2,3,5,6,7,8,9)
    group by sp.globalpagenum order by 1;
    
--  globalpagenum | count
-- ---------------+-------
--              2 |     9
--              3 |     9
--              5 |    12
--              6 |    13
--              7 |    14
--              8 |    14
--              9 |   377
-- (7 rows)
-- we did not find any record so no need to set true
-- by page level --page2
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is false
    and sp.globalpagenum=2             
)
select  distinct sl.labelnumber,sp.id from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  optional is false and sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;
--page3,5,6,7,8 do not have records

with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is false
    and sp.globalpagenum=3              
)
select  distinct sl.labelnumber,sp.id from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  optional is false and sl.globalpagenum=tmp.globalpagenum --and prerequisitecondition  is null
;

--page9
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is false
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
-- from the above script survey has only q47 so we need to validate if they have page 6,7,8 following response Q36_NO and Q39_NO and Q43_NO

-- we found 55 pages on 9 need to set active 
-- report \f ',' \a  \o 'validation_3_case1_p9.csv' 
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is false
    and sp.globalpagenum=9             
),page9 as 
(
select  distinct sl.labelnumber,sp.id ,sp.surveyid from page tmp
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
       ,sp.*
       ,ssr.activeflag,sr.activeflag
 FROM student s
 JOIN enrollment AS e  ON (e.studentid = s.id)
 JOIN survey sv ON s.id = sv.studentid
 JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid --and ssr.activeflag is true
 JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id --and sr.activeflag is true
 JOIN surveylabel sl ON sr.labelid = sl.id 
 left outer join Surveypagestatus sp on sp.surveyid=sv.id and sp.globalpagenum =sl.globalpagenum
 WHERE  sv.id=54476 and sl.labelnumber in ('Q36','Q39','Q43','Q47') and sp.globalpagenum in (6,7,8,9)
 order by 3;
*/
-- update script : uncomment if want to run this after validation
-- Rajendra ::: This is good 
-- datateam ::: script executed on stage
-- UPDATE 0

begin;
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where id in (   with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is false
    and sp.globalpagenum=9             
),page9 as 
(
select  distinct sl.labelnumber,sp.id,sp.surveyid from page tmp
inner join surveypagestatus sp on tmp.id=sp.id
inner join studentsurveyresponse ssr on sp.surveyid = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=tmp.globalpagenum )
select distinct page9.id from survey sv
inner join page9 on page9.surveyid=sv.id
inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
where case when sl.labelnumber ='Q36' then sr.responsevalue='No' 
           when sl.labelnumber ='Q39' then sr.responsevalue='No'
           when sl.labelnumber ='Q43' then sr.responsevalue='No' end
 
 ) and iscompleted is false;
 commit;
           
---------------------------------------------------------------------------------------------------------------------------
-- case2:list of pages has true condition and has prequisites pages question are not answered 
--validation 

 select  sp.globalpagenum,count(distinct sp.id) from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
    and sp.globalpagenum in (2,3,5,6,7,8,9)
    group by sp.globalpagenum order by 1;

--  globalpagenum | count(distinct)
-- ---------------+-------
--              2 | 10568
--              3 | 10568
--              5 | 10565
--              6 | 10564
--              7 | 10564
--              8 | 10564
--              9 | 10204
-- (7 rows)


-- by page level --page2 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
--  labelnumber | optional | count
-- -------------+----------+-------
--  Q19         | t        |  8592
--  Q20_1       | t        |    75
--  Q20_2       | t        |    48
--  Q20_3       | t        |    95
--  Q20_4       | t        |    28
--  Q20_5       | t        |   130
--  Q20_6       | t        |    89
--  Q330        | t        |   282
-- (8 rows)

-- we need to find if any Q20* or Q330 answered and not answered Q19


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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber <>'Q19'  )
-- select tgt.id pageid ,src.surveyid, 
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
--detail level by response (did not answer the dependent question if they have for 

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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in ('Q330','Q20_1' ,'Q20_2','Q20_3','Q20_4','Q20_5','Q20_6') )
-- select tgt.id pageid ,src.surveyid, 
select tgt.*
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null; 

-- select *
--  from page2_nq19 tgt
-- full outer join page2_q19 src on tgt.surveyid=src.surveyid
-- where src.surveyid is null or tgt.surveyid is null; 

-- select tgt.*
--  from page2_nq19 tgt
-- full outer join page2_q19 src on tgt.surveyid=src.surveyid
-- where src.surveyid is null or tgt.surveyid is null; 

-- need to test this becaus optional is false (a.	If a page has mandatory question and if it a prerequisite question )
-- Rajendra ::: Does page 2 has mandatory questions in core set option mode?
--   pageid | surveyid | globalpagenum
-- ---------+----------+---------------
--  1077833 |    56499 |             2
--  2260490 |   131420 |             2
--  2268449 |   131888 |             2
--  1637047 |    86927 |             2
--  1589012 |    83551 |             2
--  2265624 |   131720 |             2
--  1611567 |    85107 |             2
-- (7 rows)

--example
-- SELECT  distinct ssr.id,ssr.activeflag ,sr.activeflag,s.id, ssr.createddate, ssr.modifieddate,
--         sl.labelnumber AS "Survey Label Number",
--         sr.responsevalue  AS "Survey Response",sr.responseorder
--        ,sp.globalpagenum
--        ,ssr.activeflag,sr.activeflag
--  FROM student s
--  JOIN enrollment AS e  ON (e.studentid = s.id)
--  JOIN survey sv ON s.id = sv.studentid
--  JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid --and ssr.activeflag is true
--  JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id --and sr.activeflag is true
--  JOIN surveylabel sl ON sr.labelid = sl.id 
--  left outer join Surveypagestatus sp on sp.surveyid=sv.id and sp.globalpagenum =sl.globalpagenum
--  WHERE  sv.id=131720 and sp.globalpagenum in (3)
--  order by 3;
-------------------------------------------------------------------------------------------------------------

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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=2 and sl.labelnumber ='Q19'  and sr.responselabel='3' and optional is false
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
    and sp.globalpagenum=2 and sl.labelnumber in ('Q20_1' ,'Q20_2','Q20_3','Q20_4','Q20_5','Q20_6') )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page2_q19 tgt
left outer join page2_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null; 

------------------------------------------------------------------------------------------------------------
-- by page level --page3 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
--  labelnumber | optional | count
-- -------------+----------+-------
--  Q22         | t        |  8579
--  Q23_1       | t        |   323
--  Q23_2       | t        |   287
--  Q23_3       | t        |    15
--  Q24_1       | t        |    18
--  Q24_2       | t        |     5
--  Q24_3       | t        |     4
--  Q25_1       | t        |    83
--  Q25_2       | t        |    10
--  Q25_3       | t        |    81
--  Q25_4       | t        |    13
--  Q25_5       | t        |     1
--  Q25_6       | t        |   114
--  Q25_7       | t        |     8
--  Q429_1      | t        |   170
--  Q429_2      | t        |   107
--  Q429_3      | t        |    29
--  Q429_4      | t        |    45
--  Q429_5      | t        |   145
-- (19 rows)
    

with page3_q19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q22'  and sr.responselabel='3' and optional is false
),page3_nq19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
  'Q23_1','Q23_2', 'Q23_3', 
  --'Q24_1','Q24_2', 'Q24_3',  
  'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
  'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5')
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page3_q19 tgt
left outer join page3_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null; 

--for 

with page3_q19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q22'  and sr.responselabel='4' and optional is false
),page3_nq19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
  'Q23_1','Q23_2', 'Q23_3'--, 
  --'Q24_1','Q24_2', 'Q24_3',  
  --'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
  --'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5'
  )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page3_q19 tgt
left outer join page3_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null; 


with page3_q19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=3 and sl.labelnumber ='Q23'  and sr.responselabel='3' and optional is false
),page3_nq19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=3 and sl.labelnumber in  (      
  --'Q23_1','Q23_2', 'Q23_3'--, 
  'Q24_1','Q24_2', 'Q24_3'--,  
  --'Q25_1', 'Q25_2', 'Q25_3','Q25_4','Q25_5','Q25_6', 'Q25_7',
  --'Q429_1','Q429_2','Q429_3','Q429_4','Q429_5'
  )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page3_q19 tgt
left outer join page3_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null ; 
------------------------------------------------------------------------------------------------------------

-- by page level --page5 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
--  labelnumber | optional | count
-- -------------+----------+-------
--  Q143        | t        |  8649
--  Q147        | t        |   554
--  Q201        | t        |  5496
--  Q202        | t        |  6148
--  Q33_1       | t        |  4458
--  Q33_11      | t        |   114
--  Q33_3       | t        |   272
--  Q33_5       | t        |  2557
--  Q33_6       | t        |  2804
--  Q33_8       | t        |    31
-- (10 rows)
-- )
    

with page5_q19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel='3' and optional is false  -- for response 1,2,3 we did not find any records
),page5_nq19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 'Q33_1','Q33_2','Q33_3','Q33_5','Q33_6','Q33_8','Q33_11','Q201'--,
 --'Q147'
 )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page5_q19 tgt
left outer join page5_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;


with page5_q19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=5 and sl.labelnumber ='Q143'  and sr.responselabel='4' and optional is false  -- for response 4,5 we did not find any records
),page5_nq19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=5 and sl.labelnumber in  (      
 'Q147'
 )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
 from page5_q19 tgt
left outer join page5_nq19 src on tgt.surveyid=src.surveyid
where src.surveyid is null;
------------------------------------------------------------------------------------------------------------

-- by page level --page6 --validation
with page as 
(
 select distinct sp.id ,sp.globalpagenum from survey sv
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true --and sl.globalpagenum=sp.globalpagenum 
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
--  labelnumber | optional | count
-- -------------+----------+-------
--  Q34_1       | t        |    99
--  Q34_2       | t        |   195
--  Q34_3       | t        |    82
--  Q36         | f        | 10573
--  Q37         | f        |  8034
-- (5 rows)

-- select sl.labelnumber,globalpagenum,slp.*,optional,sr.responseorder,sr.responsevalue from surveylabel  sl 
-- left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
-- inner join surveyresponse sr on sr.labelid = sl.id
-- where  sl.globalpagenum=6 and 'Q36'=labelnumber
-- order by 1,responseorder    
-- Rajendra ::: This is for Q36 instead of Q19 :) 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=6 and sl.labelnumber ='Q36'  and sr.responsevalue='Yes' and optional is false  -- for response 1,2,3 we did not find any records
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=6 and sl.labelnumber in  (      
 'Q37'
 )
  )
-- select tgt.id pageid ,src.surveyid, 
select count(*)
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
--  labelnumber | optional | count
-- -------------+----------+-------
--  Q39         | f        | 10573
--  Q40         | f        |   883
--  Q41         | t        |   856
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=7 and sl.labelnumber ='Q39'  and sr.responsevalue='Yes' and optional is false  -- for response 1,2,3 we did not find any records
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
--  labelnumber | optional | count
-- -------------+----------+-------
--  Q43         | f        | 10573
--  Q44         | f        |  2141
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
    and sp.globalpagenum=8 and sl.labelnumber ='Q43'  and sr.responsevalue='Yes' and optional is false  -- for response 1,2,3 we did not find any records
),page8_nq19 as 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
    and sp.globalpagenum=9             
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
-- labelnumber | optional | count
-- -------------+----------+-------
--  Q210        | t        |  7357
--  Q211_1      | t        |  4276
--  Q211_2      | t        |  1856
--  Q211_3      | t        |  4361
--  Q211_4      | t        |  2667
--  Q211_5      | t        |  2654
--  Q300_1      | t        |   418
--  Q300_2      | t        |   402
--  Q300_3      | t        |   551
--  Q300_4      | t        |  6209
--  Q47         | f        |  1054
-- (11 rows)


-- select sl.labelnumber,globalpagenum,slp.*,optional,sr.responseorder,sr.responsevalue from surveylabel  sl 
-- left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
-- inner join surveyresponse sr on sr.labelid = sl.id
-- where  sl.globalpagenum=6 and 'Q36'=labelnumber
-- order by 1,responseorder    

-- survey completed for 6,7,8  with No values but no response for page 9 Q47  (need to find out if need to change iscompleted false for 6,7,8)
-- Rajendra ::: if 6,7,8 with No values but no response for page 9, then no need to falsify pages 6,7,8. This is ok
-- Rajendra ::: If 6,7,8 with No values and single dependent question is also answered and page 10 has atlease one question answered, then iscompleted should be true for page 9.
-- report \f ',' \a  \o 'validation_3_case2_p9_q47.csv'
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
 and sl.labelnumber in ('Q43','Q39','Q36') and sr.responsevalue='No' and optional is false 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=9 and sl.labelnumber='Q47' 
 )
 --select tgt.id pageid ,src.surveyid, 
--select tgt.surveyid ,sp.globalpagenum,sp.iscompleted,sp.id pageid
select count(distinct tgt.surveyid)
 from page678 tgt
left outer join page9_nq19 src on tgt.surveyid=src.surveyid
left outer join surveypagestatus sp on sp.surveyid=tgt.surveyid and sp.globalpagenum in (9,6,7,8)  and sp.globalpagenum in (9)  and sp.iscompleted is false
where src.surveyid is null;
-- Rajendra : need to write an update query for above query and prod has some 49 surveys. iscompleted set to true on surveypagestatus.
-- datateam: script executed on stage
-- UPDATE 0

begin;
update surveypagestatus
set iscompleted =true,
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
 and sl.labelnumber in ('Q43','Q39','Q36') and sr.responsevalue='No' and optional is false 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
 and sp.globalpagenum=9 and sl.labelnumber='Q47' 
 )
 --select tgt.id pageid ,src.surveyid, 
--select tgt.surveyid ,sp.globalpagenum,sp.iscompleted,sp.id pageid
select distinct tgt.surveyid
 from page678 tgt
left outer join page9_nq19 src on tgt.surveyid=src.surveyid
left outer join surveypagestatus sp on sp.surveyid=tgt.surveyid and sp.globalpagenum in (9,6,7,8)  and sp.globalpagenum in (9)  and sp.iscompleted is false
where src.surveyid is null
  ) and iscompleted is false and globalpagenum =9 ;
 commit;
-----------------------
-- Rajendra : NO need to update for below query.
--report \f ',' \a  \o 'validation_3_case2_p9_nq47.csv'
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true 
 and ((sl.labelnumber ='Q43' and sr.responsevalue='Yes')  or
      (sl.labelnumber ='Q39' and sr.responsevalue='Yes')  or
      (sl.labelnumber ='Q36' and sr.responsevalue='Yes') )
 and optional is false 
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
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567 and sp.iscompleted is true
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
select tgt.surveyid ,sp.globalpagenum,sp.iscompleted,sp.id pageid
 --select count(distinct tgt.surveyid)
 from page678 tgt
left outer join page9_nq19 src on tgt.surveyid=src.surveyid
left outer join surveypagestatus sp on sp.surveyid=tgt.surveyid 
and sp.globalpagenum in (9,6,7,8) 
 --and sp.globalpagenum in (9)  and sp.iscompleted is true
where src.surveyid is null;
