BEGIn;
select distinct statedisplayidentifier from organizationtreedetail where statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS');
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
            case when stateid  =51 and districtname='Wichita' and gc.abbreviatedname='3' then e.currentgradelevel 
                 when  gc.abbreviatedname='8' then 90 --Grade 10
                 else gc_new.id end currentgradelevel, 
            e.localstudentidentifier,
            2018 currentschoolyear, e.fundingschool, e.schoolentrydate, 
            e.districtentrydate, e.stateentrydate, e.exitwithdrawaldate, e.exitwithdrawaltype, 
            e.specialcircumstancestransferchoice, e.giftedstudent, e.specialedprogramendingdate, 
            e.qualifiedfor504, e.studentid, e.attendanceschoolid, e.restrictionid, 
            now() createddate,
            (select id from aartuser where email='ats_dba_team@ku.edu') createduser, e.activeflag,
            now() modifieddate,
            (select id from aartuser where email='ats_dba_team@ku.edu') modifieduser, 
            e.source, e.aypschoolid, e.sourcetype,e.id::text||'#$2018$#'|| coalesce(e.notes,'') notes
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join gradecourse gc on e.currentgradelevel=gc.id
left outer join (select distinct gc.id,gc.name,gc.abbreviatedname,gc.gradelevel from enrollment  e 
inner join gradecourse gc on e.currentgradelevel=gc.id) gc_new on gc_new.gradelevel=gc.gradelevel+1
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS') and ap.abbreviatedname='DLM' and e.currentschoolyear=2017
      and sap.activeflag is true and gc.abbreviatedname in ('3','4','5','6','7','8','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%');
    
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
            r.statecoursesid, 2018 currentschoolyear, r.aypschoolid, r.id::text||'#$2018$#'|| coalesce(r.notes,'') notes , r.tempoldrid
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join gradecourse gc on e.currentgradelevel=gc.id
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear=2017
      and sap.activeflag is true and r.currentschoolyear=2017 and gc.abbreviatedname in ('3','4','5','6','7','8','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%');

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
inner join enrollment  enew on split_part(enew.notes,'#$2018$#',1)::text=e.id::text
inner join roster rnew on split_part(rnew.notes,'#$2018$#',1)::text=r.id::text
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear=2017
      and sap.activeflag is true and r.currentschoolyear=2017 and gc.abbreviatedname in ('3','4','5','6','7','8','10')
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%');

  
          
-- Validation 

select e.currentschoolyear,count( e.id)
 from enrollment  e 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=e.studentid
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid
inner join gradecourse gc on e.currentgradelevel=gc.id
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear in (2017,2018)
and sap.activeflag is true and case when e.currentschoolyear =2017 then  gc.abbreviatedname in ('3','4','5','6','7','8','10') else gc.abbreviatedname in ('3','4','5','6','7','8','10','11') end
and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%')
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
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear in (2017,2018)
      and sap.activeflag is true and r.currentschoolyear in (2017,2018) 
      and case when e.currentschoolyear =2017 then  gc.abbreviatedname in ('3','4','5','6','7','8','10') else gc.abbreviatedname in ('3','4','5','6','7','8','10','11') end
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%')
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
where ot.statedisplayidentifier in ('ND','WI','MD','NY','DE','OK','KS')  and ap.abbreviatedname='DLM' and e.currentschoolyear in (2017,2018)
      and sap.activeflag is true and r.currentschoolyear in (2017,2018) 
      and case when e.currentschoolyear =2017 then  gc.abbreviatedname in ('3','4','5','6','7','8','10') else gc.abbreviatedname in ('3','4','5','6','7','8','10','11') end
      and not exists (select 1 from enrollment enrl where enrl.studentid=e.studentid and enrl.currentschoolyear=2018 and enrl.notes not like '%#$2018$#%')
 group by e.currentschoolyear,r.currentschoolyear;           

 commit;