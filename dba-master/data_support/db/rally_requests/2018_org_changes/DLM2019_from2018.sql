--state KS and OK. 
--For Kansas, if grade = 8, advance grade to 10. If District name = "Wichita" and grade = 3, keep the grade at 3.
--For Oklahoma, advance 8th graders to 11th grade.  If District name = "Tulsa" and grade = 3, keep the grade at 3.

BEGIN;
select distinct statedisplayidentifier from organizationtreedetail where statedisplayidentifier in ('IA','WI','MD','NY','DE','OK','KS');
INSERT INTO enrollment(
            aypschoolidentifier, residencedistrictidentifier, currentgradelevel, 
            localstudentidentifier, currentschoolyear, fundingschool, schoolentrydate, 
            districtentrydate, stateentrydate, exitwithdrawaldate, exitwithdrawaltype, 
            specialcircumstancestransferchoice, giftedstudent, specialedprogramendingdate, 
            qualifiedfor504, studentid, attendanceschoolid, restrictionid, 
            createddate, createduser, activeflag, modifieddate, modifieduser, 
            source, aypschoolid, sourcetype, notes)
select      distinct 
            e.aypschoolidentifier, e.residencedistrictidentifier,
            case when stateid =51   and districtname='Wichita' and gc.abbreviatedname='3' then e.currentgradelevel 
                 when stateid =51   and gc.abbreviatedname='8' then 90 --Grade 10
				 when stateid =9592 and districtname='Tulsa'   and gc.abbreviatedname='3' then e.currentgradelevel
				 when stateid =9592 and gc.abbreviatedname='8' then 29 --Grade 11
                 else gc_new.id end currentgradelevel, 
            e.localstudentidentifier,
            2019 currentschoolyear, e.fundingschool, e.schoolentrydate, 
            e.districtentrydate, e.stateentrydate, e.exitwithdrawaldate, e.exitwithdrawaltype, 
            e.specialcircumstancestransferchoice, e.giftedstudent, e.specialedprogramendingdate, 
            e.qualifiedfor504, e.studentid, e.attendanceschoolid, e.restrictionid, 
            now() createddate,
            (select id from aartuser where email='ats_dba_team@ku.edu') createduser, e.activeflag,
            now() modifieddate,
            (select id from aartuser where email='ats_dba_team@ku.edu') modifieduser, 
            e.source, e.aypschoolid, e.sourcetype,e.id::text||'#$2019$#'|| coalesce(e.notes,'') notes
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join gradecourse gc on e.currentgradelevel=gc.id
left outer join (select distinct gc.id,gc.name,gc.abbreviatedname,gc.gradelevel from enrollment  e 
inner join gradecourse gc on e.currentgradelevel=gc.id) gc_new on gc_new.gradelevel=gc.gradelevel+1
where ot.statedisplayidentifier in ('OK','KS') and ap.abbreviatedname='DLM' and e.currentschoolyear=2018
      and sap.activeflag is true and gc.abbreviatedname in ('3','4','5','6','7','8','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%');
    
/*
INSERT INTO enrollmenttesttypesubjectarea(
            enrollmentid, testtypeid, subjectareaid, createddate, modifieddate, 
            createduser, modifieduser, activeflag, groupingindicator1, groupingindicator2, 
            exited)
select distinct 
            enew.id, ets.testtypeid, ets.subjectareaid,now() createddate,now() modifieddate, 
            (select id from aartuser where email='ats_dba_team@ku.edu') createduser,
            (select id from aartuser where email='ats_dba_team@ku.edu') modifieduser,
             ets.activeflag, ets.groupingindicator1, ets.groupingindicator2, 
            ets.exited
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join enrollment  enew on split_part(enew.notes,'#$2018$#',1)::text=e.id::text
inner join gradecourse gc on e.currentgradelevel=gc.id
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear=2017
      and sap.activeflag is true and gc.abbreviatedname in ('3','4','5','6','7','8','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%');

*/
INSERT INTO public.roster(
            coursesectionname, coursesectiondescription, teacherid, statesubjectareaid, 
            courseenrollmentstatusid, statecourseid, restrictionid, createddate, 
            createduser, activeflag, modifieddate, modifieduser, statesubjectcourseidentifier, 
            localcourseid, educatorschooldisplayidentifier, attendanceschoolid, 
            prevstatesubjectareaid, statecoursecode, source, sourcetype, 
            statecoursesid, currentschoolyear, aypschoolid, notes, tempoldrid)
select      distinct
            r.coursesectionname, r.coursesectiondescription, r.teacherid, r.statesubjectareaid, 
            r.courseenrollmentstatusid, r.statecourseid, r.restrictionid,now() createddate, 
            (select id from aartuser where email='ats_dba_team@ku.edu') createduser, r.activeflag,now() modifieddate
            ,(select id from aartuser where email='ats_dba_team@ku.edu') modifieduser, r.statesubjectcourseidentifier, 
            r.localcourseid, r.educatorschooldisplayidentifier, r.attendanceschoolid, 
            r.prevstatesubjectareaid, r.statecoursecode, r.source, r.sourcetype, 
            r.statecoursesid, 2019 currentschoolyear, r.aypschoolid, r.id::text||'#$2019$#'|| coalesce(r.notes,'') notes , r.tempoldrid
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join gradecourse gc on e.currentgradelevel=gc.id
where ot.statedisplayidentifier in ('OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear=2018
      and sap.activeflag is true and r.currentschoolyear=2018 and gc.abbreviatedname in ('3','4','5','6','7','8','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%');

INSERT INTO public.enrollmentsrosters(
            enrollmentid, rosterid, createddate, createduser, activeflag, 
            modifieddate, modifieduser, courseenrollmentstatusid, source, 
            trackerstatus)
select   distinct
           enew.id enrollmentid,rnew.id rosterid,now() createddate
            ,(select id from aartuser where email='ats_dba_team@ku.edu') createduser, er.activeflag, 
             now() modifieddate
            ,(select id from aartuser where email='ats_dba_team@ku.edu') modifieduser, er.courseenrollmentstatusid, er.source, 
            er.trackerstatus
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join gradecourse gc on e.currentgradelevel=gc.id
inner join enrollment  enew on split_part(enew.notes,'#$2019$#',1)::text=e.id::text
inner join roster rnew on split_part(rnew.notes,'#$2019$#',1)::text=r.id::text
where ot.statedisplayidentifier in ('OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear=2018
      and sap.activeflag is true and r.currentschoolyear=2018 and gc.abbreviatedname in ('3','4','5','6','7','8','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%');

  
          
-- Validation 

select e.currentschoolyear,count( e.id)
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join gradecourse gc on e.currentgradelevel=gc.id
where ot.statedisplayidentifier in ('IA','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear in (2018,2019)
and sap.activeflag is true and case when e.currentschoolyear =2018 then  gc.abbreviatedname in ('3','4','5','6','7','8','9','10') else gc.abbreviatedname in ('3','4','5','6','7','8','9','10','11') end
and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%')
group by e.currentschoolyear;

/*
select e.currentschoolyear,count( ets.id) 
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join gradecourse gc on e.currentgradelevel=gc.id
-- inner join enrollment  enew on split_part(enew.notes,'#$2018$#',1)::text=e.id::text
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear in (2017,2018)
      and sap.activeflag is true  and case when e.currentschoolyear =2017 then  gc.abbreviatedname in ('3','4','5','6','7','8','10') else gc.abbreviatedname in ('3','4','5','6','7','8','10','11') end
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%')
group by e.currentschoolyear;      
*/
select e.currentschoolyear,r.currentschoolyear,count( distinct r.id)
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join gradecourse gc on e.currentgradelevel=gc.id
where ot.statedisplayidentifier in ('IA','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear in (2017,2018)
      and sap.activeflag is true and r.currentschoolyear in (2018,2019) 
      and case when e.currentschoolyear =2018 then  gc.abbreviatedname in ('3','4','5','6','7','8','10') else gc.abbreviatedname in ('3','4','5','6','7','8','10','11') end
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%')
 group by e.currentschoolyear,r.currentschoolyear;
      
select e.currentschoolyear,r.currentschoolyear, count( er.id)
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join gradecourse gc on e.currentgradelevel=gc.id
-- inner join enrollment  enew on split_part(enew.notes,'#$2018$#',1)::text=e.id::text
-- inner join roster rnew on split_part(rnew.notes,'#$2018$#',1)::text=r.id::text
where ot.statedisplayidentifier in ('IA','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear in (2018,2019)
      and sap.activeflag is true and r.currentschoolyear in (2018,2019) 
      and case when e.currentschoolyear =2018 then  gc.abbreviatedname in ('3','4','5','6','7','8','10') else gc.abbreviatedname in ('3','4','5','6','7','8','10','11') end
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%')
 group by e.currentschoolyear,r.currentschoolyear;           

 commit;
 
 --state DE,IA,MD,NY AND WI---
--For Delaware, if grade = 8, advance grade to 10.  If District name = "Indian River School District" and grade = 3, keep the grade at 3.
--For Iowa, if District name = "Des Moines Independent Comm School District" and grade = 3, keep the grade at 3.
--For Maryland, keep all students in their current grade.
--For New York, if grade = 9, keep grade at 9.  If District name = "Albany City SD" and grade = 3, keep the grade at 3.
--For Wisconsin, if District name = "Milwaukee School District" and grade = 3, keep the grade at 3.
BEGIN;

INSERT INTO enrollment(
            aypschoolidentifier, residencedistrictidentifier, currentgradelevel, 
            localstudentidentifier, currentschoolyear, fundingschool, schoolentrydate, 
            districtentrydate, stateentrydate, exitwithdrawaldate, exitwithdrawaltype, 
            specialcircumstancestransferchoice, giftedstudent, specialedprogramendingdate, 
            qualifiedfor504, studentid, attendanceschoolid, restrictionid, 
            createddate, createduser, activeflag, modifieddate, modifieduser, 
            source, aypschoolid, sourcetype, notes)
select      distinct 
            e.aypschoolidentifier, e.residencedistrictidentifier,
            case when stateid =58510  and districtname='Indian River School District' and gc.abbreviatedname='3' then e.currentgradelevel 
                 when stateid =58510  and gc.abbreviatedname='8' then 90 --Grade 10
				 when stateid =9633   and districtname='Des Moines Independent Comm School District'   and gc.abbreviatedname='3' then e.currentgradelevel
				 when stateid =82933  then e.currentgradelevel 
				 when stateid =69352  and districtname='ALBANY CITY SD' and gc.abbreviatedname='3' then e.currentgradelevel 
				 when stateid =69352  and gc.abbreviatedname='9' then 31 --Grade 9
				 when stateid =9631   and districtname='Milwaukee School District' and gc.abbreviatedname='3' then e.currentgradelevel
                 else gc_new.id       end currentgradelevel, 
            e.localstudentidentifier,
            2019 currentschoolyear, e.fundingschool, e.schoolentrydate, 
            e.districtentrydate, e.stateentrydate, e.exitwithdrawaldate, e.exitwithdrawaltype, 
            e.specialcircumstancestransferchoice, e.giftedstudent, e.specialedprogramendingdate, 
            e.qualifiedfor504, e.studentid, e.attendanceschoolid, e.restrictionid, 
            now() createddate,
            (select id from aartuser where email='ats_dba_team@ku.edu') createduser, e.activeflag,
            now() modifieddate,
            (select id from aartuser where email='ats_dba_team@ku.edu') modifieduser, 
            e.source, e.aypschoolid, e.sourcetype,e.id::text||'#$2019$#'|| coalesce(e.notes,'') notes
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join gradecourse gc on e.currentgradelevel=gc.id
left outer join (select distinct gc.id,gc.name,gc.abbreviatedname,gc.gradelevel from enrollment  e 
inner join gradecourse gc on e.currentgradelevel=gc.id) gc_new on gc_new.gradelevel=gc.gradelevel+1
where ot.statedisplayidentifier in ('IA','WI','MD','NY','DE') and ap.abbreviatedname='DLM' and e.currentschoolyear=2018
      and sap.activeflag is true and gc.abbreviatedname in ('3','4','5','6','7','8','9','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%');
	  
	  
INSERT INTO public.roster(
            coursesectionname, coursesectiondescription, teacherid, statesubjectareaid, 
            courseenrollmentstatusid, statecourseid, restrictionid, createddate, 
            createduser, activeflag, modifieddate, modifieduser, statesubjectcourseidentifier, 
            localcourseid, educatorschooldisplayidentifier, attendanceschoolid, 
            prevstatesubjectareaid, statecoursecode, source, sourcetype, 
            statecoursesid, currentschoolyear, aypschoolid, notes, tempoldrid)
select      distinct
            r.coursesectionname, r.coursesectiondescription, r.teacherid, r.statesubjectareaid, 
            r.courseenrollmentstatusid, r.statecourseid, r.restrictionid,now() createddate, 
            (select id from aartuser where email='ats_dba_team@ku.edu') createduser, r.activeflag,now() modifieddate
            ,(select id from aartuser where email='ats_dba_team@ku.edu') modifieduser, r.statesubjectcourseidentifier, 
            r.localcourseid, r.educatorschooldisplayidentifier, r.attendanceschoolid, 
            r.prevstatesubjectareaid, r.statecoursecode, r.source, r.sourcetype, 
            r.statecoursesid, 2019 currentschoolyear, r.aypschoolid, r.id::text||'#$2019$#'|| coalesce(r.notes,'') notes , r.tempoldrid
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join gradecourse gc on e.currentgradelevel=gc.id
where ot.statedisplayidentifier in ('IA','WI','MD','NY','DE')  and ap.abbreviatedname='DLM' and e.currentschoolyear=2018
      and sap.activeflag is true and r.currentschoolyear=2018 and gc.abbreviatedname in ('3','4','5','6','7','8','9','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%');

	  
INSERT INTO public.enrollmentsrosters(
            enrollmentid, rosterid, createddate, createduser, activeflag, 
            modifieddate, modifieduser, courseenrollmentstatusid, source, 
            trackerstatus)
select   distinct
           enew.id enrollmentid,rnew.id rosterid,now() createddate
            ,(select id from aartuser where email='ats_dba_team@ku.edu') createduser, er.activeflag, 
             now() modifieddate
            ,(select id from aartuser where email='ats_dba_team@ku.edu') modifieduser, er.courseenrollmentstatusid, er.source, 
            er.trackerstatus
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join gradecourse gc on e.currentgradelevel=gc.id
inner join enrollment  enew on split_part(enew.notes,'#$2019$#',1)::text=e.id::text
inner join roster rnew on split_part(rnew.notes,'#$2019$#',1)::text=r.id::text
where ot.statedisplayidentifier in ('IA','WI','MD','NY','DE')  and ap.abbreviatedname='DLM' and e.currentschoolyear=2018
      and sap.activeflag is true and r.currentschoolyear=2018 and gc.abbreviatedname in ('3','4','5','6','7','8','9','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2019 and enrl.notes not like '%#$2019$#%');
	  
	  
	  
	  
	  
	  
	  
	  
	  
