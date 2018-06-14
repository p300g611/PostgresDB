\f ',' \a  
--f365B1_1
--1.District A, School 1/2017::ELA, Math,Dist A, School 2/2016  Show all reports
\o 'f365B1_1_same_district_diff_school.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid
from externalstudentreports) sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
and (select id from organization_parent(ot.schoolid) where organizationtypeid=5 limit 1)=sr16.districtid
and ot.schoolid<>sr16.attendanceschoolid
--and s.id=950783
limit 1000
;

--f365B1_2
--2.District A, School 1/2017::ELA, Math,Dist B, School 2/2016  Show all reports
\o 'f365B1_2_diff_district_diff_school.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid
from externalstudentreports) sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
and (select id from organization_parent(ot.schoolid) where organizationtypeid=5 limit 1)<>sr16.districtid
and ot.schoolid<>sr16.attendanceschoolid
--and s.id=950783
limit 1000
;


--f365B1_3
--3.District A, School 1/2017::ELA, Math,Dist B, School 1/2016  Show all reports
\o 'f365B1_3_diff_district_same_school.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid
from externalstudentreports) sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
and (select id from organization_parent(ot.schoolid) where organizationtypeid=5 limit 1)<>sr16.districtid
and ot.schoolid<>sr16.attendanceschoolid
--and s.id=950783
limit 1000
;

--f365B1_4
--4.District A, School 1/2017::ELA, Math,Dist A, School 1/2016  Show all reports
\o 'f365B1_4_same_district_same_school.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid
from externalstudentreports) sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
and (select id from organization_parent(ot.schoolid) where organizationtypeid=5 limit 1)=sr16.districtid
and ot.schoolid=sr16.attendanceschoolid
--and s.id=950783
limit 1000
;

--f365B1_5
--5.not enrolled /2017::ELA, Math Dist A, School 1/2015::ELA, Math,Dist A, School 2/2016  Show all reports
\o 'f365B1_5_unenrolled_havereports.csv' 
select distinct 
 s.id studentid, s.statestudentidentifier ssid
,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016
from student s                       
left outer join  enrollment e   ON e.studentid = s.id and e.activeflag is true and e.currentschoolyear=2017
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id --and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid
from externalstudentreports) sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where   s.activeflag is true
and e.id is null
limit 1000
;


--f365B1_6
--6.enrolled /2017::ELA, Math Dist A, School 1/not have reports
\o 'f365B1_6_enrolled_not_have_reports.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
left outer jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid
from externalstudentreports) sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid 
where e.currentschoolyear=2017 and sr16.studentid is null
limit 1000
;

--7.enrolled /2017:: not in ELA, Math Dist A, School 1
\o 'f365B1_7_enrolled_Sci_ss_oth.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016,ca.abbreviatedname subject
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid,subjectid
from externalstudentreports where subjectid not in (440,3)) sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca on ca.id=sr16.subjectid
where e.currentschoolyear=2017 
;

--8.enrolled /2017:: not in ELA, Math Dist A, School 1
\o 'f365B1_8_unenrolled_Sci_ss_oth_havereports.csv' 
select distinct 
 s.id studentid, s.statestudentidentifier ssid
,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016,ca.abbreviatedname subject
from student s                       
left outer join  enrollment e   ON e.studentid = s.id and e.activeflag is true and e.currentschoolyear=2017
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id --and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,assessmentprogramid,subjectid
from externalstudentreports where subjectid not in (440,3) )sr16 ON s.id = sr16.studentid and a.id = sr16.assessmentprogramid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca on ca.id=sr16.subjectid
where   s.activeflag is true
and e.id is null
limit 1000
;
-- cpass
select distinct currentschoolyear,
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016,level1_text,level2_text
into temp tmp_ln70
from  student s 
left JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
left JOIN gradecourse gc ON gc.id = e.currentgradelevel
left join organization o                  on s.stateid=o.id and o.activeflag is true
left join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
left JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
left jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,level1_text,level2_text
from externalstudentreports  where (level2_text  is not  null or level1_text  is not null) and assessmentprogramid=11) sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
-- where e.currentschoolyear=2017 
order by s.id;

\copy (select * from tmp_ln70) to 'line70_level2_text.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

