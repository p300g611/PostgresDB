--================================================================================
--5) Rules for :science flag
--================================================================================ 
-- a.The includescience flag should reflect the state science flag setting.
  --CASE 1: no need run update for this (state science flag is true and student science flag is false)

-- validation : 
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.includescienceflag is false  and fcss.scienceflag is true
 group by o.organizationname;

-- report \f ',' \a  \o 'validation_5a_case1.csv' 
 select distinct o.organizationname,sv.studentid,sv.id surveyid, o1.organizationname, s.legalfirstname
 from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on o1.id=e.attendanceschoolid and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.includescienceflag is false  and fcss.scienceflag is true
 order by 1,2,3;

-- update script : uncomment if want to run this after validation 
-- Rajendra ::: includescienceflag need to be updated to true, If science page has any question unanswered the survey status should be in In Progress. 
-- Need query to update if any survey in Complete or Ready to Submit and science page has any question unanswered, then change to In Progress.
-- Rajendra ::: Required for final update.
-- datateam ::: script updated on stage .
-- UPDATE 135

begin;
update survey
set includescienceflag =true,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct sv.id   
 from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.includescienceflag is false  and fcss.scienceflag is true);
 commit;
 
-- CASE 2: no need run update for this ( state science flag is false and student science flag is true)
-- Rajendra ::: We are good with this and there is no malformed data.
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.includescienceflag is true  and fcss.scienceflag is false
 group by o.organizationname;

---------------------------------------------------------------------------------------------------------------------------

--  b.	If the student’s FCS has science survey page status entry, then it should be active. If survey page status entry not exists in database, no need to worry.
--  need to apply only for page 16(science)
-- validation
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus spf on spf.surveyid=sv.id  and spf.activeflag is false and spf.globalpagenum =16   -- inactive science page
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer join Surveypagestatus spa on spa.surveyid=sv.id and spa.activeflag is true and spa.globalpagenum =16 -- active science page
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and spf.activeflag is false and spa.id is null
 and fcss.scienceflag is true -- we need to check this only for states which have science flag enabled.
  --and o.displayidentifier='NJ'
 group by o.organizationname;

-- report \f ',' \a  \o 'validation_5b.csv' 
 select distinct o.organizationname,sv.studentid,sv.id surveyid,spf.id pageid,spf.globalpagenum  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus spf on spf.surveyid=sv.id  and spf.activeflag is false and spf.globalpagenum =16   -- inactive science page
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer join Surveypagestatus spa on spa.surveyid=sv.id and spa.activeflag is true and spa.globalpagenum =16 -- active science page
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and spf.activeflag is false and spa.id is null
 and fcss.scienceflag is true -- we need to check this only for states which have science flag enabled.
 order by 1;

-- validation for to eliminate duplicate update ( we should be good no dup's on prod)
with find_dups as 
(
 select distinct o.organizationname,sv.studentid,sv.id surveyid,spf.id pageid,spf.globalpagenum  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus spf on spf.surveyid=sv.id  and spf.activeflag is false and spf.globalpagenum =16   -- inactive science page
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer join Surveypagestatus spa on spa.surveyid=sv.id and spa.activeflag is true and spa.globalpagenum =16 -- active science page
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and spf.activeflag is false and spa.id is null
 )
 select studentid,surveyid,globalpagenum,count(*) from find_dups
 group by studentid,surveyid,globalpagenum
 having count(*)>1;

-- update script : uncomment if want to run this after validation 
-- Rajendra ::: We are good with this update
-- dateteam ::: script updated on stage .
-- UPDATE 2167

begin;
update surveypagestatus
set activeflag =true,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct spf.id   from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus spf on spf.surveyid=sv.id  and spf.activeflag is false and spf.globalpagenum =16   -- inactive science page
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer join Surveypagestatus spa on spa.surveyid=sv.id and spa.activeflag is true and spa.globalpagenum =16 -- active science page
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and spf.activeflag is false and spa.id is null
 );
 commit;

--========================================================
--1) Rules for :CORE_SET --567
--=========================================================
--a. Allquestionsflag should be false on survey table
--validation 
--Allquestionsflag should be true on survey table --no error records  
-- Rajendra ::: We are good with this.
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.allquestionsflag is true and fcss.categoryid=567 
 group by o.organizationname;

---------------------------------------------------------------------------------------------------------------------------

--b.Iscompleted column of any page that has only non-mandatory questions may have either true or false 
--validation 
-- Rajendra ::: We are good with this  nothing is required
--Iscompleted column of any page that has only mandatory questions may have either true or false (mandartory is false)
--no error records
select iscompleted,count(*) from  Surveypagestatus
group by iscompleted;
---------------------------------------------------------------------------------------------------------------------------

-- c.Iscompleted column of any page with mandatory questions is set to true only if all the mandatory questions are answered.
--case 1: all mandatory questions answered and iscompleted set to false
--validation
select o.organizationname, count(distinct sv.studentid)  from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner join enrollment as e  on e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id --and sl.activeflag is true
inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=567 and optional is false
group by o.organizationname;
 
--report \f ',' \a  \o 'validation_1c_case1.csv'    
select distinct o.organizationname, sv.studentid,sv.id surveyid,sp.id pageid,sp.globalpagenum , o1.organizationname , s.legalfirstname from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner join enrollment as e  on e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id --and sl.activeflag is true
inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=567 and optional is false
order by o.organizationname;


-- Rajendra :::: The list shows page 12 and 14 has student survey responses but the corresponding survey label is inactivated and merged with next. 
-- (i.e. 0% exhibit is inactivated and merged with 0%-20% exhibit). Need to update studentsurveyresponses with new option for the FCS which has 
-- already answered with inactivated option(i.e. 0% exhibit). Following query update is not required
/*
begin;
update surveypagestatus
set iscompleted = true,
    modifieddate = now(),
    modifieduser = 12
where id in ( select distinct sp.id  from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner join enrollment as e  on e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join studentsurveyresponse ssr on sv.id = ssr.surveyid and ssr.activeflag is true
inner join surveyresponse sr on ssr.surveyresponseid = sr.id and sr.activeflag is true
inner join surveylabel sl on sr.labelid = sl.id
inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=567 and optional is false);
 commit;
 */

 -- case two: Iscompleted column of any page with mandatory questions is set to true all the mandatory questions are not answered
 --validation
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true 
 inner join enrollment as e  on e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
  inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer join studentsurveyresponse ssr on sv.id = ssr.surveyid
 left outer join surveyresponse sr on ssr.surveyresponseid = sr.id
 left outer join surveylabel sl on sr.labelid = sl.id and optional is false
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is true and fcss.categoryid=567 and ssr.id is null
  --and o.displayidentifier='ks'
 group by o.organizationname;
 
 --report \f ',' \a  \o 'validation_1c_case2.csv' 
select distinct o.organizationname, sv.studentid,sv.id surveyid,sp.id pageid,sp.globalpagenum, o1.organizationname , s.legalfirstname from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true 
 inner join enrollment as e  on e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer join studentsurveyresponse ssr on sv.id = ssr.surveyid
 left outer join surveyresponse sr on ssr.surveyresponseid = sr.id
 left outer join surveylabel sl on sr.labelid = sl.id and optional is false
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is true and fcss.categoryid=567 and ssr.id is null
  --and o.displayidentifier='ks'
 order by o.organizationname;

-- Rajendra ::: This update is good as FCS is converted from All Questions to Core Set and code updated pages that are not navigated by user.
-- datateam ::: script updated on stage .
-- UPDATE 91

begin;
update surveypagestatus
set iscompleted = false,
    modifieddate = now(),
    modifieduser = 12
where id in (select distinct sp.id  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true 
 inner join enrollment as e  on e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer join studentsurveyresponse ssr on sv.id = ssr.surveyid
 left outer join surveyresponse sr on ssr.surveyresponseid = sr.id
 left outer join surveylabel sl on sr.labelid = sl.id and optional is false
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is true and fcss.categoryid=567 and ssr.id is null);
commit;
---------------------------------------------------------------------------------------------------------------------------

--d.If any of the page status (active) entries iscompleted flag is false, then the FCS survey status should be “In Progress"
--case one: If any of the page status (active) entries iscompleted flag is false, then the FCS survey status should not be  “In Progress 

 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567
       and sps.iscompleted is false  and ca.categorycode not in ('IN_PROGRESS')
 group by o.organizationname;
 
 -- case two:If any of the page status (active) entries iscompleted flag is true, then the FCS survey status should be  “In Progress"
  select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=567
       and sps.iscompleted is true  and ca.categorycode = 'IN_PROGRESS'
 group by o.organizationname;
 -- report \f ',' \a  \o 'validation_1d_case2.csv' 
 select distinct o.organizationname, sv.studentid,sv.id surveyid,sps.id pageid,sps.globalpagenum , o1.organizationname , s.legalfirstname  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and fcss.categoryid=568
       and sps.iscompleted is true  and ca.categorycode = 'IN_PROGRESS'
 order by o.organizationname;

-- Rajendra ::: This update is not requried. The reason is if a survey is in In Progress it may have pages with iscompleted with value true.
-- The other way is need to be updated (i.e. if FCS status is not In Progress and page with iscompleted as false then that FCS should be In Progress)
/*
begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct sps.id  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and fcss.categoryid=568
       and sps.iscompleted is true  and ca.categorycode = 'IN_PROGRESS'
 );
 commit;
 */

---------------------------------------------------------------------------------------------------------------------------

-- e.If all of the page status (active) entries iscompleted flag is true, then the FCS survey status should be in either “In Progress” , “Ready to Submit” or “Completed”
--case one:if any one page in flase be in either “In Progress” , “Ready to Submit” or “Completed”
--validation
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=567 and ca.categorycode in ('READY_TO_SUBMIT','COMPLETE')
 group by o.organizationname;

 --report  \f ',' \a  \o 'validation_1e_case1.csv'
 select distinct o.organizationname, sv.studentid,sv.id surveyid,sp.id pageid,sp.globalpagenum , o1.organizationname , s.legalfirstname from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=567 and ca.categorycode in ('READY_TO_SUBMIT','COMPLETE')
 order by 1;

 /* -- we need verify this 
 -- Rajendra ::: No need to update this.
begin;
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct sp.id  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=567 and ca.categorycode in ('IN_PROGRESS','READY_TO_SUBMIT','COMPLETE')
 );
 commit;
 */
 --case two:If all of the page status (active) entries iscompleted flag is false, then the FCS survey status should be in either “In Progress” , “Ready to Submit” or “Completed”
 --validation
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 left outer join surveypagestatus spf on spf.surveyid=sv.id and spf.iscompleted is false and spf.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and fcss.categoryid=567 and ca.categorycode not in ('IN_PROGRESS','READY_TO_SUBMIT','COMPLETE')
   and spf.id is null
 group by o.organizationname;
 
--================================================================================
--2)Rules for :ALL_QUESTIONS--568 note :: all questions are mandatory
--================================================================================
-- a.	Allquestionsflag should be true on survey table.  --verfied
--validation 
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.allquestionsflag is false and fcss.categoryid=568 
 group by o.organizationname;
-- report \f ',' \a  \o 'validation_2a.csv'
 select distinct o.organizationname, sv.studentid,sv.id surveyid,sv.allquestionsflag,fcss.categoryid  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.allquestionsflag is false and fcss.categoryid=568 
 order by o.organizationname;
-- update script : uncomment if want to run this after validation
-- Rajendra ::: This update is good if any rows exists (none in stage db)
-- datateam ::: script updated on stage .
-- UPDATE 0

begin;
update survey
set allquestionsflag =true,
    modifieddate=now(),
    modifieduser=12,
    lasteditedoption=568
where id in (   
 select distinct sv.id   
 from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sv.allquestionsflag is false and fcss.categoryid=568);
 commit;

 --optional check 
 select allquestionsflag,count(*)  from survey
 group by allquestionsflag;

 select lasteditedoption,count(*)  from survey
 group by lasteditedoption;

---------------------------------------------------------------------------------------------------------------------------
-- b.	All questions in the FCS are considered as mandatory questions. no script need for this
---------------------------------------------------------------------------------------------------------------------------
-- c.	Iscompleted column of any page with mandatory questions is set to true only if all the mandatory questions are answered.
  -- case one: all mandatory questions are completed and iscompleted set false( question have active responses but flag still set to false)
  --validation
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=568
 group by o.organizationname;
 
  -- report \f ',' \a  \o 'validation_2c_case1.csv' 
 select distinct o.organizationname, sv.studentid,sv.id surveyid,sp.id pageid,sp.globalpagenum , o1.organizationname , s.legalfirstname from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=568
 order by o.organizationname;
-- update script : uncomment if want to run this after validation 
-- Rajendra :::: DO not execute this script
/*
begin;
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct sp.id from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=568
 );
 commit;
 */
 -- case two: all mandatory questions are not completed and iscompleted set true(some time surveyresponse is inactive)
 --validation
 
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true  -- we are just joining by survey because do not have page numer due to number due to inactive surveyresponse
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 left outer JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 left outer JOIN surveylabel sl ON sr.labelid = sl.id 
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is true and fcss.categoryid=568 and sl.id is null
  --and o.displayidentifier='KS'
 group by o.organizationname;

 -- report \f ',' \a  \o 'validation_2c_case2.csv' 
 select distinct o.organizationname, sv.studentid,sv.id surveyid,sp.id pageid,sp.globalpagenum , o1.organizationname , s.legalfirstname from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true 
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 left outer JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 left outer JOIN surveylabel sl ON sr.labelid = sl.id 
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is true and fcss.categoryid=568 and sl.id is null
  --and o.displayidentifier='KS'
 order by o.organizationname;
-- update script : uncomment if want to run this after validation 

-- Rajendra ::: This need to  be updated (This one is main culprit for bubble issue.)
-- datateam ::: script updated on stage .
-- UPDATE 97

begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct sp.id from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true 
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 left outer JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 left outer JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 left outer JOIN surveylabel sl ON sr.labelid = sl.id 
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is true and fcss.categoryid=568 and sl.id is null
 );
 commit;

 
---------------------------------------------------------------------------------------------------------------------------
 --d.If any of the page status (active) entries iscompleted flag is false, then the FCS survey status should be “In Progress"
--case one: If any of the page status (active) entries iscompleted flag is false, then the FCS survey status should not be  “In Progress 

 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568
       and sps.iscompleted is false  and ca.categorycode not in ('IN_PROGRESS')
 group by o.organizationname;
 
 -- case two:If any of the page status (active) entries iscompleted flag is true, then the FCS survey status should be  “In Progress"
  select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017  and fcss.categoryid=568
       and sps.iscompleted is true  and ca.categorycode = 'IN_PROGRESS'
 group by o.organizationname;
 -- report \f ',' \a  \o 'validation_2d_case2.csv' 
 select distinct o.organizationname, sv.studentid,sv.id surveyid,sps.id pageid,sps.globalpagenum  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and fcss.categoryid=568
       and sps.iscompleted is true  and ca.categorycode = 'IN_PROGRESS'
 order by o.organizationname;

-- Rajendra ::: This update is not required. This one can be a valid scenario.
/*
begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct sps.id from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner join Surveypagestatus sps on sps.surveyid=sv.id and sps.activeflag is true -- and sl.globalpagenum=sps.globalpagenum 
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and fcss.categoryid=568
       and sps.iscompleted is true  and ca.categorycode = 'IN_PROGRESS'
 );
 commit;
 */

---------------------------------------------------------------------------------------------------------------------------

-- e.If all of the page status (active) entries iscompleted flag is true, then the FCS survey status should be in either “In Progress” , “Ready to Submit” or “Completed”
--case one:if any one page in flase be in either “In Progress” , “Ready to Submit” or “Completed”
--validation
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=568 and ca.categorycode in ('READY_TO_SUBMIT','COMPLETE')
 group by o.organizationname;

 --report  \f ',' \a  \o 'validation_2e_case1.csv'
 select distinct o.organizationname, sv.studentid,sv.id surveyid,sp.id pageid,sp.globalpagenum from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=568 and ca.categorycode in ('READY_TO_SUBMIT','COMPLETE')
 order by 1;

-- Rajendra ::: This is not required. should be categorycode update if exists such rows
 /* -- we need verify this 
begin;
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where id in (   
 select distinct sp.id  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and fcss.categoryid=568 and ca.categorycode in ('IN_PROGRESS','READY_TO_SUBMIT','COMPLETE')
 );
 commit;
 */
 --case two:If all of the page status (active) entries iscompleted flag is false, then the FCS survey status should be in either “In Progress” , “Ready to Submit” or “Completed”
 --validation
 select o.organizationname, count(distinct sv.studentid)  from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id
 inner join Surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 left outer join surveypagestatus spf on spf.surveyid=sv.id and spf.iscompleted is false and spf.activeflag is true
 where e.currentschoolyear=2017 and fcss.schoolyear=2017 and fcss.categoryid=568 and ca.categorycode not in ('IN_PROGRESS','READY_TO_SUBMIT','COMPLETE')
   and spf.id is null
 group by o.organizationname;

-- 6: this logic need to run last and apply to all -- need to verify with Scriptbee(count is zero pending for review)
-- select * from category where id in (223,224,522,222)  or categorytypeid=50;
-- after eliminate atleast any one iscompleted is false survey and status in 224 | NOT_STARTED  similar to below condition
-- e.If all of the page status (active) entries iscompleted flag is true, then the FCS survey status should be in either “In Progress” , “Ready to Submit” or “Completed”--- 
-- we need to find out what we need to do with this (no need to worry count is zero)
with  svfalse as
(
select sv.id  from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner join enrollment as e  on e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join Surveypagestatus sp on sp.surveyid=sv.id  and sp.activeflag is true-- and sl.globalpagenum=sp.globalpagenum
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false --and fcss.categoryid=567 and optional is false
group by sv.id
)
select  sv.id,ca.categorycode,sv.studentid from survey sv
inner join category ca on ca.id = sv.status
left outer join svfalse svf on svf.id =sv.id
where sv.activeflag is true and ca.categorycode='NOT_STARTED' and svf.id is null ;




 