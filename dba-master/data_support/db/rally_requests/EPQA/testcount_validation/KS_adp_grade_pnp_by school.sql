--Enrolled students (with PNP) in each subject and grade
--step1:
drop table if exists tmp_pnp_std;
with subjects as (select unnest(ARRAY['ELA', 'M', 'Sci']) as subjects),
grades as (select unnest(ARRAY['3', '4', '5', '6', '7', '8', '9', '10', '11']) as grades),
pnpstudents as (
    select * from (
        select s.id as studentid, ca.abbreviatedname as subject, gc.abbreviatedname as grade,e.attendanceschoolid, array_agg(
            piac.attributecontainer||'/'||pia.attributename||'='||spiav.selectedvalue order by piac.attributecontainer, pia.attributename
        ) as selections
        from profileitemattributenameattributecontainer pianac
        join profileitemattributecontainer piac on pianac.attributecontainerid = piac.id
        join profileitemattribute pia on pianac.attributenameid = pia.id
        join studentprofileitemattributevalue spiav on pianac.id = spiav.profileitemattributenameattributecontainerid and spiav.activeflag = true
        join student s on spiav.studentid = s.id and s.activeflag = true
        join studentassessmentprogram sap on s.id = sap.studentid and sap.activeflag = true
        join assessmentprogram ap on sap.assessmentprogramid = ap.id and ap.abbreviatedname = 'KAP'
        join enrollment e on s.id = e.studentid and e.currentschoolyear = 2017 and e.activeflag = true
        join gradecourse gc on e.currentgradelevel = gc.id and gc.abbreviatedname in (select grades from grades)
        join enrollmenttesttypesubjectarea ettsa on e.id = ettsa.enrollmentid and ettsa.activeflag = true
        join testtypesubjectarea ttsa on ettsa.testtypeid = ttsa.testtypeid and ettsa.subjectareaid = ttsa.subjectareaid and ttsa.activeflag = true
        join contentareatesttypesubjectarea cattsa on ttsa.id = cattsa.testtypesubjectareaid and cattsa.activeflag = true
        join contentarea ca on cattsa.contentareaid = ca.id and ca.abbreviatedname in (select subjects from subjects)
        where piac.attributecontainer in (
            'keywordTranslationDisplay', 'Spoken', 'Signing', 'Magnification', 'supportsTwoSwitch', 'Braille', 'supportsProvidedByAlternateForm'
        )
        and pia.attributename in (
            'assignedSupport', 'Language', 'UserSpokenPreference', 'SigningType', 'magnification', 'paperAndPencil', 'largePrintBooklet'
        )
        group by s.id, ca.abbreviatedname, gc.abbreviatedname,e.attendanceschoolid
    ) foo
    where (
        selections @> ARRAY['keywordTranslationDisplay/assignedSupport=true']
        and
        selections @> ARRAY['keywordTranslationDisplay/Language=spa']
    )
    or (
        selections @> ARRAY['Spoken/assignedSupport=true']
        and (
            selections @> ARRAY['Spoken/UserSpokenPreference=nonvisual']
            or
            selections @> ARRAY['Spoken/UserSpokenPreference=textandgraphics']
            or
            selections @> ARRAY['Spoken/UserSpokenPreference=textonly']
        )
    )
    or (
        selections @> ARRAY['Signing/assignedSupport=true']
        and
        selections @> ARRAY['Signing/SigningType=asl']
    )
    or (
        selections @> ARRAY['Magnification/assignedSupport=true']
    )
    or (
        selections @> ARRAY['onscreenKeyboard/assignedSupport=true']
    )
    or (
        selections @> ARRAY['supportsTwoSwitch/assignedSupport=true']
    )
    or (
        selections @> ARRAY['paperAndPencil/assignedSupport=true']
    )
    or (
        selections @> ARRAY['largePrintBooklet/assignedSupport=true']
    )
)
select pnpst.subject, pnpst.grade,attendanceschoolid, count(distinct pnpst.studentid) cnt
into temp tmp_pnp_std 
from pnpstudents pnpst
group by pnpst.subject, pnpst.grade,attendanceschoolid
order by pnpst.subject, pnpst.grade::integer;

--step2:
drop table if exists tmp_pnp_st;
with subjects as (select unnest(ARRAY['ELA', 'M', 'Sci']) as subjects),
grades as (select unnest(ARRAY['3', '4', '5', '6', '7', '8', '9', '10', '11']) as grades),
pnpstudents as (
    select * from (
        select s.id as studentid, array_agg(
            piac.attributecontainer||'/'||pia.attributename||'='||spiav.selectedvalue order by piac.attributecontainer, pia.attributename
        ) as selections
        from profileitemattributenameattributecontainer pianac
        join profileitemattributecontainer piac on pianac.attributecontainerid = piac.id
        join profileitemattribute pia on pianac.attributenameid = pia.id
        join studentprofileitemattributevalue spiav on pianac.id = spiav.profileitemattributenameattributecontainerid and spiav.activeflag = true
        join student s on spiav.studentid = s.id and s.activeflag = true
        join studentassessmentprogram sap on s.id = sap.studentid and sap.activeflag = true
        join assessmentprogram ap on sap.assessmentprogramid = ap.id and ap.abbreviatedname = 'KAP'
        join enrollment e on s.id = e.studentid and e.currentschoolyear = 2017 and e.activeflag = true
        join gradecourse gc on e.currentgradelevel = gc.id and gc.abbreviatedname in (select grades from grades)
        where piac.attributecontainer in (
            'keywordTranslationDisplay', 'Spoken', 'Signing', 'Magnification', 'supportsTwoSwitch', 'Braille', 'supportsProvidedByAlternateForm'
        )
        and pia.attributename in (
            'assignedSupport', 'Language', 'UserSpokenPreference', 'SigningType', 'magnification', 'paperAndPencil', 'largePrintBooklet'
        )
        group by s.id
    ) foo
    where (
        selections @> ARRAY['keywordTranslationDisplay/assignedSupport=true']
        and
        selections @> ARRAY['keywordTranslationDisplay/Language=spa']
    )
    or (
        selections @> ARRAY['Spoken/assignedSupport=true']
        and (
            selections @> ARRAY['Spoken/UserSpokenPreference=nonvisual']
            or
            selections @> ARRAY['Spoken/UserSpokenPreference=textandgraphics']
            or
            selections @> ARRAY['Spoken/UserSpokenPreference=textonly']
        )
    )
    or (
        selections @> ARRAY['Signing/assignedSupport=true']
        and
        selections @> ARRAY['Signing/SigningType=asl']
    )
    or (
        selections @> ARRAY['Magnification/assignedSupport=true']
    )
    or (
        selections @> ARRAY['onscreenKeyboard/assignedSupport=true']
    )
    or (
        selections @> ARRAY['supportsTwoSwitch/assignedSupport=true']
    )
    or (
        selections @> ARRAY['paperAndPencil/assignedSupport=true']
    )
    or (
        selections @> ARRAY['largePrintBooklet/assignedSupport=true']
    )
)
select otw.id as otwid, ca.abbreviatedname as subject, gc.abbreviatedname as grade, stg.code, t.accessibleform::text,ts.attendanceschoolid,
    count(distinct st.studentid) as cnt
	into temp tmp_pnp_st
from operationaltestwindow otw
join operationaltestwindowstestcollections otwtc on otw.id = otwtc.operationaltestwindowid
join testcollection tc on otwtc.testcollectionid = tc.id
join contentarea ca on tc.contentareaid = ca.id and ca.abbreviatedname in (select subjects from subjects)
join gradecourse gc on tc.gradecourseid = gc.id and gc.abbreviatedname in (select grades from grades)
join testsession ts on otw.id = ts.operationaltestwindowid
    and tc.id = ts.testcollectionid
    and ts.source = 'BATCHAUTO'
    and ts.activeflag = true
join studentstests st on ts.id = st.testsessionid and st.activeflag = true
join pnpstudents pnpst on st.studentid = pnpst.studentid
join test t on st.testid = t.id
join stage stg on tc.stageid = stg.id
where otw.id in (10172, 10174)
and t.accessibleform = true
group by otw.id, ca.abbreviatedname, gc.abbreviatedname, stg.code, t.accessibleform,ts.attendanceschoolid
order by otw.id, ca.abbreviatedname, gc.abbreviatedname::integer, stg.code, t.accessibleform;

--step3:
drop table if exists tmp_epqa;
with cte_st as (select st.id,st.status,st.enrollmentid,st.studentid,stg.code,gc.abbreviatedname grade
,case when tc.contentareaid=3 then  17 when tc.contentareaid=440 then 1 when tc.contentareaid=441 then 19 end subjectareaid 
,case when accessibleform is true then 1 else 0 end st_pnp 
from 
studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join test t on st.testid=t.id and t.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10172,10174))
,cte_std as(
select 
 s.id studentid
-- ,case when s.profilestatus = 'CUSTOM' then 1 else 0 end std_pnp 
,e.id enrollmentid
,gc.abbreviatedname        grade
,sub.id                    subjectareaid
,attendanceschoolid
from student s 
inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id in (17,1,19) and tt.id=2  
)
,tmp_merge as (
select 
 attendanceschoolid
,std.grade
,st.id
-- ,std.std_pnp
,st.st_pnp
,std.studentid std_studentid
,st.studentid  st_studentid
,st.enrollmentid std_enrollmentid
,st.enrollmentid st_enrollmentid
,st.status
,st.code
,std.subjectareaid std_subjectareaid 
,st.subjectareaid  st_subjectareaid
from cte_std std
left outer join cte_st st on st.enrollmentid=std.enrollmentid and st.studentid=std.studentid and st.grade=std.grade 
)
select
  ot.statedisplayidentifier state
 ,ot.districtname           districtname
 ,ot.schoolname             schoolname
 ,attendanceschoolid        attendanceschoolid
 ,std.grade Grade
,count(distinct  case when std_subjectareaid=17 then std_studentid else null end )                                          "ELA_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=17 and std.id is not null then st_studentid else null end )  "ELA_Stg1_Tests"
-- ,max(case when pstd.subject='ELA'  then pstd.cnt end)                                                 "ELA_PNP_Enrolled"
-- ,max(case when pst.subject='ELA' and pst.code='Stg1' then  pst.cnt end )                             "ELA_PNP_Stg1_Tests"
,count(distinct  case when std_subjectareaid=1 then std_studentid else null end )                                           "M_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=1 and std.id is not null then st_studentid else null end )   "M_Stg1_Tests"
-- ,coalesce((select cnt from tmp_pnp_std p where p.subject='M' and p.grade=std.grade and attendanceschoolid=std.attendanceschoolid ),0)                                     "M_PNP_Enrolled"
-- ,coalesce((select cnt from tmp_pnp_st p where p.subject='M' and p.code='Stg1' and p.grade=std.grade and attendanceschoolid=std.attendanceschoolid) ,0)                                "M_PNP_Stg1_Tests"
,count(distinct  case when std_subjectareaid=19 then std_studentid else null end )                                          "Sci_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=19 and std.id is not null then st_studentid else null end )  "Sci_Stg1_Tests"
,count(distinct case when std.code='Stg2' and st_subjectareaid=19 and std.id is not null then st_studentid else null end )  "Sci_Stg2_Tests"
-- ,coalesce((select cnt from tmp_pnp_std p where p.subject='Sci' and p.grade=std.grade and attendanceschoolid=std.attendanceschoolid),0)                                   "Sci_PNP_Enrolled"
-- ,coalesce((select cnt from tmp_pnp_st p where p.subject='Sci' and p.code='Stg1' and p.grade=std.grade and attendanceschoolid=std.attendanceschoolid) ,0)                 "Sci_PNP_Stg1_Tests"
-- ,coalesce((select cnt from tmp_pnp_st p where p.subject='Sci' and p.code='Stg2' and p.grade=std.grade and attendanceschoolid=std.attendanceschoolid) ,0)                 "Sci_PNP_Stg2_Tests"
  into temp tmp_epqa
 from tmp_merge std 
 inner join organizationtreedetail ot on ot.schoolid=std.attendanceschoolid 
--  left outer join  tmp_pnp_std pstd on pstd.grade=std.grade  and pstd.attendanceschoolid=std.attendanceschoolid
--  left outer join  tmp_pnp_st pst on pst.grade=std.grade  and pst.attendanceschoolid=std.attendanceschoolid
where ot.stateid=51
 group by ot.statedisplayidentifier,ot.districtname,ot.schoolname,std.grade,attendanceschoolid
--group by grade
order by REGEXP_REPLACE(COALESCE(std.grade, '0'), '[^0-9]*' ,'0')::integer;




--step:4
drop table if exists tmp_epqa_pnp;
select state,districtname,schoolname,std."Grade",std.attendanceschoolid
 ,"ELA_Enrolled"
 ,"ELA_Stg1_Tests"
 ,max(case when pstd.subject='ELA'  then pstd.cnt end )                                                "ELA_PNP_Enrolled"
 ,max(case when pst.subject='ELA' and pst.code='Stg1' then  pst.cnt end )                              "ELA_PNP_Stg1_Tests"
 ,"M_Enrolled"
 ,"M_Stg1_Tests"
 ,max(case when pstd.subject='M'  then pstd.cnt end)                                                   "M_PNP_Enrolled"
 ,max(case when pst.subject='M' and pst.code='Stg1' then  pst.cnt end)                                 "M_PNP_Stg1_Tests"
 ,"Sci_Enrolled"
 ,"Sci_Stg1_Tests"
 ,max(case when pstd.subject='Sci'  then pstd.cnt end )                                                "Sci_PNP_Enrolled"
 ,max(case when pst.subject='Sci' and pst.code='Stg1' then  pst.cnt end )                              "Sci_PNP_Stg1_Tests"
 ,max(case when pst.subject='Sci' and pst.code='Stg2' then  pst.cnt end)                               "Sci_PNP_Stg2_Tests"
into temp tmp_epqa_pnp
from tmp_epqa std
left outer join  tmp_pnp_std pstd on pstd.grade=std."Grade"  and pstd.attendanceschoolid=std.attendanceschoolid
left outer join  tmp_pnp_st pst on pst.grade=std."Grade"  and pst.attendanceschoolid=std.attendanceschoolid
group by state,districtname,schoolname,std."Grade",std.attendanceschoolid
,"ELA_Enrolled","ELA_Stg1_Tests"
 ,"M_Enrolled","M_Stg1_Tests"
 ,"Sci_Enrolled","Sci_Stg1_Tests";
\copy (select * from tmp_epqa_pnp) to 'KS_adp_grade_pnp_by_school.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

