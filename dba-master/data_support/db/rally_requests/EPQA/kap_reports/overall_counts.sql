select
  *,
  ((ela_with_tests - ela_with_score - ela_without_score) = 0) as ela_match,
  (ela_with_tests - ela_with_score - ela_without_score) as ela_diff,
  ((m_with_tests - m_with_score - m_without_score) = 0) as m_match,
  (m_with_tests - m_with_score - m_without_score) as m_diff,
  ((sci_with_tests - sci_with_score - sci_without_score) = 0) as sci_match,
  (sci_with_tests - sci_with_score - sci_without_score) as sci_diff
--into temp tmp_report_counts
from (
  select
    --otd.districtname, otd.schoolname,
    gc.abbreviatedname::integer as grade,
    --count(distinct case when ca.abbreviatedname = 'ELA' then e.studentid else null end) as ela_students,
    count(distinct case when ca.abbreviatedname = 'ELA' then st.studentid else null end) as ela_with_tests,
    count(distinct case when ca.abbreviatedname = 'ELA' and sr.status and sr.generated then sr.studentid else null end) as ela_with_score,
    count(distinct case when ca.abbreviatedname = 'ELA' and not sr.status and sr.generated then sr.studentid else null end) as ela_without_score,
    --count(distinct case when ca.abbreviatedname = 'M' then e.studentid else null end) as m_students,
    count(distinct case when ca.abbreviatedname = 'M' then st.studentid else null end) as m_with_tests,
    count(distinct case when ca.abbreviatedname = 'M' and sr.status and sr.generated then sr.studentid else null end) as m_with_score,
    count(distinct case when ca.abbreviatedname = 'M' and not sr.status and sr.generated then sr.studentid else null end) as m_without_score,
    --count(distinct case when ca.abbreviatedname = 'Sci' then e.studentid else null end) as sci_students,
    count(distinct case when ca.abbreviatedname = 'Sci' then st.studentid else null end) as sci_with_tests,
    count(distinct case when ca.abbreviatedname = 'Sci' and sr.status and sr.generated then sr.studentid else null end) as sci_with_score,
    count(distinct case when ca.abbreviatedname = 'Sci' and not sr.status and sr.generated then sr.studentid else null end) as sci_without_score
  from organizationtreedetail otd
  join enrollment e on e.attendanceschoolid = otd.schoolid
  join enrollmenttesttypesubjectarea ettsa on e.id = ettsa.enrollmentid
  join testtypesubjectarea ttsa on ettsa.testtypeid = ttsa.testtypeid and ettsa.subjectareaid = ttsa.subjectareaid
  join contentareatesttypesubjectarea cattsa on ttsa.id = cattsa.testtypesubjectareaid
  join contentarea ca on cattsa.contentareaid = ca.id
  join gradecourse gc on e.currentgradelevel = gc.id
  left join testsession ts
    on otd.schoolid = ts.attendanceschoolid
    and ts.subjectareaid = ttsa.subjectareaid
    and ts.gradecourseid in (select id from gradecourse where abbreviatedname = (select abbreviatedname from gradecourse where id = gc.id))
    and ts.operationaltestwindowid in (10172, 10174)
    and ts.stageid = (select id from stage where code = 'Stg1')
  left join studentstests st on ts.id = st.testsessionid and e.studentid = st.studentid and st.activeflag
  left join studentreport sr
    on otd.schoolid = sr.attendanceschoolid
    and e.studentid = sr.studentid
    and ca.id = sr.contentareaid
    and sr.gradeid in (select id from gradecourse where abbreviatedname = (select abbreviatedname from gradecourse where id = gc.id))
    and sr.schoolyear = 2017
  where otd.statedisplayidentifier = 'KS'
  and ca.abbreviatedname in ('ELA', 'M', 'Sci')
  and gc.abbreviatedname in ('3', '4', '5', '6', '7', '8', '10', '11')
  group by
    --otd.districtname, otd.schoolname,
    gc.abbreviatedname::integer
) tmp
order by
  --districtname, schoolname,
  grade
;
