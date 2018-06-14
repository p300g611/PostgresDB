
drop table if exists tmp_reports;
select distinct 
s.id                                           "KITE Student ID"
,s.statestudentidentifier                      "State Student ID"
,ort.statename                                 "State"
,ort.schooldisplayidentifier                   "School ID"
,ort.districtdisplayidentifier                 "District ID"
,aart.id                                       "KITE Educator ID"
,ca.abbreviatedname                            "Roster Content Area"
,e.activeflag                                  "Enrollment Flag"
,er.activeflag                                 "Enrollmentsroster Flag"
into temp tmp_reports
from student s 
join enrollment e on e.studentid=s.id
join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id 
join enrollmentsrosters er on er.enrollmentid=e.id
join roster r on r.id=er.rosterid
join contentarea ca on ca.id =r.statesubjectareaid
join aartuser aart on aart.id=r.teacherid
where s.activeflag is true and e.currentschoolyear=2018 and assessmentprogramid=3
and ort.statename not IN ('flatland', 'DLM QC State', 'AMP QC State', 'KAP QC State', 'Playground QC State', 'Flatland',
        'DLM QC YE State', 'DLM QC IM State', 'DLM QC IM State ', 'DLM QC EOY State','Service Desk QC State','NY Training State','QA QC State')
and ca.abbreviatedname<>'ELP'
order by s.id,ort.schooldisplayidentifier,ort.districtdisplayidentifier;
\copy (select * from tmp_reports) to 'Enrollment_contentarea04252018.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


