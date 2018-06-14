-- organizationtreedetail
\f ',' \a  \o 'organizationtreedetail.csv' 
select * from organizationtreedetail ot order by ot.statename,ot.districtname,ot.schoolname;
\o 'studentreport.csv' 
select distinct 
s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,ca.abbreviatedname reportcontentarea,a.abbreviatedname assessment 
,srst.organizationname state,srdt.organizationname district
,srsch.organizationname school,schoolyear,generated
from  student s                       
inner join studentreport sr on s.id= sr.studentid
inner join assessmentprogram a on a.id= sr.assessmentprogramid
left outer JOIN gradecourse gc ON gc.id = sr.gradeid
inner join organization srsch on srsch.id=sr.attendanceschoolid
inner join organization srdt  on srdt.id=sr.districtid
inner join organization srst  on srst.id=sr.districtid
left outer join contentarea ca  on ca.id=sr.contentareaid;
--f365B1_1
--1.District A, School 1/2017::ELA, Math Dist A, School 1/2015::ELA, Math,Dist A, School 2/2016  Show all reports
\o 'f365B1_1.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and sr15.districtid=sr16.districtid
and (select id from organization_parent(ot.schoolid) where organizationtypeid=5 limit 1)=sr16.districtid
and ot.schoolid=sr15.attendanceschoolid
and sr15.attendanceschoolid<>sr16.attendanceschoolid
--and s.id=950783
limit 1000
;
--f365B1_2
--2.District A, School 1/2017::ELA, Math Dist B, School 20/2015::ELA, Math Dist B, School 20/2016
\o 'f365B1_2.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and sr15.attendanceschoolid=sr16.attendanceschoolid
and ot.schoolid<>sr15.attendanceschoolid
and ot.districtid<>sr15.districtid
limit 1000
;
--f365B1_3
--3.not enrolled /2017::ELA, Math Dist A, School 1/2015::ELA, Math,Dist A, School 2/2016  Show all reports
\o 'f365B1_3.csv' 
select distinct 
--ot.statename,ot.districtname,ot.schoolname
 s.id studentid, s.statestudentidentifier ssid
,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
left outer join  enrollment e   ON e.studentid = s.id and e.activeflag is true and e.currentschoolyear=2017
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id --and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where  a.abbreviatedname='KAP' and s.activeflag is true
and e.id is null
and sr15.attendanceschoolid<>sr16.attendanceschoolid
and sr15.districtid=sr16.districtid
limit 1000
;
--f365B1_4
--4.not enrolled /2017::ELA, Math Dist A, School 1/2015::ELA, Math,Dist B, School 2/2016  Show all reports
\o 'f365B1_4.csv' 
select distinct 
--ot.statename,ot.districtname,ot.schoolname
 s.id studentid, s.statestudentidentifier ssid
,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
left outer join  enrollment e   ON e.studentid = s.id and e.activeflag is true and e.currentschoolyear=2017
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id --and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where  a.abbreviatedname='KAP' and s.activeflag is true
and e.id is null
and sr15.attendanceschoolid<>sr16.attendanceschoolid
and sr15.districtid<>sr16.districtid
limit 1000
;

--f365B1_5 --same as above script if not need to get more details
--5.not enrolled /2017::ELA, Math Dist B, School 2/2015::ELA, Math,Dist A, School 1/2016  Show all reports
\o 'f365B1_5.csv' 
select distinct 
--ot.statename,ot.districtname,ot.schoolname
 s.id studentid, s.statestudentidentifier ssid
,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
left outer join  enrollment e   ON e.studentid = s.id and e.activeflag is true and e.currentschoolyear=2017
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id --and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where  a.abbreviatedname='KAP' and s.activeflag is true
and e.id is null
and sr15.attendanceschoolid<>sr16.attendanceschoolid
and sr15.districtid<>sr16.districtid
limit 1000
;
\o 'f365B1_6.csv' 
--f365B1_6 --same as above script if not need to get more details
--6.Dist B, School 20 /2017::ELA, Math Dist B, School 20/2015::ELA, Math,Dist A, School 1/2016  Show all reports
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and sr15.districtid<>sr16.districtid
and ot.schoolid=sr16.attendanceschoolid
and sr15.attendanceschoolid<>sr16.attendanceschoolid
limit 1000
;

\o 'f365B1_7.csv' 
--f365B1_7 --need to discuss with kathy
--7.ELA, Math Dist B, School 20 /2017::ELA, Math Dist B, School 20/2015::ELA, Math,Dist B, School 20/2016  Show all reports
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid  
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and ot.schoolid=sr16.attendanceschoolid
and sr15.attendanceschoolid=sr16.attendanceschoolid
limit 1000
;

\o 'f365B1_8.csv' 
--f365B1_8
--8. Dist A, School 1 /2017::none Dist A, School 1/2015::None,Dist A, School 1/2016  Show all reports
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
left outer jOIN (select distinct studentid
from studentreport ) str on s.id=str.studentid 
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and str.studentid is null
limit 1000
;

\o 'f365B1_9.csv' 
--f365B1_9
--9. Dist A, School 1 /2017::none Dist A, School 1/2015::ELA\M,Dist A, School 1/2016  Show all reports
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment ,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
left outer jOIN (select distinct studentid,generated from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 on s.id=sr15.studentid 
left outer jOIN (select distinct studentid,generated from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 on s.id=sr16.studentid 
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and sr15.studentid is null and sr16.studentid is not null
limit 1000
;
\o 'f365B1_10.csv' 
--f365B1_10
--10. Dist A, School 1 /2017::ELA\M,Dist A, School 1 Dist A, School 1/2015::none /2016  Show all reports
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment ,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
left outer jOIN (select distinct studentid,generated from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 on s.id=sr15.studentid 
left outer jOIN (select distinct studentid,generated from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 on s.id=sr16.studentid 
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and sr15.studentid is not null and sr16.studentid is null
limit 1000
;
\o 'f365B1_11a.csv' 
--f365B1_11 --need to discuss with kathy
--11.ELA, Math Dist B, School 20 /2017::ELA, Math Dist B, School 20/2015:Sci,SS Dist B, School 20/2016  Show all reports
drop table if exists  tmp_studentreport15 ;
drop table if exists  tmp_studentreport16 ;
select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
into temp tmp_studentreport16
from studentreport where schoolyear=2016 and assessmentprogramid=12 and contentareaid in (441,443);
select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
into temp tmp_studentreport15
from studentreport where schoolyear=2015 and assessmentprogramid=12 ;

\o f365B1_11.csv
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment,ca15.abbreviatedname reportcontentarea15,ca16.abbreviatedname reportcontentarea16
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true 
and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN tmp_studentreport15 sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN tmp_studentreport16 sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca16  on ca16.id=sr16.contentareaid
inner join contentarea ca15 on ca15.id=sr15.contentareaid
where e.currentschoolyear=2017 and a.abbreviatedname='KAP' 
--and ot.schoolid=sr16.attendanceschoolid
--and sr15.attendanceschoolid=sr16.attendanceschoolid
 limit 1000
;

\o f365B1_12a.csv
--f365B1_12 --need to discuss with kathy
--12.ELA, Math Dist B, School 20 /2017::Sci,SS  Dist B, School 20/2015:ELA, Math Dist B, School 20/2016  Show all reports
drop table if exists  tmp_studentreport15 ;
drop table if exists  tmp_studentreport16 ;
select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
into temp tmp_studentreport16
from studentreport where schoolyear=2016 and assessmentprogramid=12 ;
select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
into temp tmp_studentreport15
from studentreport where schoolyear=2015 and assessmentprogramid=12 and contentareaid in (441,443);

\o f365B1_12.csv
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment,ca15.abbreviatedname reportcontentarea15,ca16.abbreviatedname reportcontentarea16
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true 
and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN tmp_studentreport15 sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN tmp_studentreport16 sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca16  on ca16.id=sr16.contentareaid
inner join contentarea ca15 on ca15.id=sr15.contentareaid
where e.currentschoolyear=2017 and a.abbreviatedname='KAP' 
--and ot.schoolid=sr16.attendanceschoolid
--and sr15.attendanceschoolid=sr16.attendanceschoolid
limit 1000
;

--27.Student has reports in different districts in different school years.
\o 'line27_diff_dt_diff_sch.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment,ca.abbreviatedname reportcontentarea
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015,sr16.generated generated2016
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2015 and assessmentprogramid=12) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated
from studentreport where schoolyear=2016 and assessmentprogramid=12) sr16 ON s.id = sr16.studentid and sr15.contentareaid = sr16.contentareaid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
inner join contentarea ca  on ca.id=sr16.contentareaid
where e.currentschoolyear=2017 and a.abbreviatedname='KAP'
and sr15.attendanceschoolid<>sr16.attendanceschoolid
and ot.schoolid<>sr15.attendanceschoolid
and ot.districtid<>sr15.districtid
and ot.districtid<>sr16.districtid
limit 1000
;


--30.Student is currently enrolled, is not associated with assessment program X now, but has reports for assessment program X. 
\o 'line30_diff_assessment.csv' 
select distinct 
ot.statename,ot.districtname,ot.schoolname,a.id,asr.id
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname enroll_assessment,asr.abbreviatedname report_assessment,ca.abbreviatedname reportcontentarea
,sr15.schoolyear,sr15dt.organizationname district
,sr15sch.organizationname school,sr15.generated
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated,assessmentprogramid,schoolyear
from studentreport) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner join contentarea ca  on ca.id=sr15.contentareaid
inner jOIN assessmentprogram asr ON asr.id = sr15.assessmentprogramid
where e.currentschoolyear=2017 and a.id<>sr15.assessmentprogramid and a.id <>47
order by asr.abbreviatedname
limit 1000;

--31.Student is not currently enrolled, , but has reports for assessment program X.   
\o 'line31_unenroll_assessment.csv' 
select distinct 
s.id studentid, s.statestudentidentifier ssid
,asr.abbreviatedname report_assessment,ca.abbreviatedname reportcontentarea
,sr15.schoolyear,sr15dt.organizationname district
,sr15sch.organizationname school,sr15.generated
from  student s                       
left outer JOIN enrollment e    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true and e.currentschoolyear=2017
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated,assessmentprogramid,schoolyear
from studentreport) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner join contentarea ca  on ca.id=sr15.contentareaid
inner jOIN assessmentprogram asr ON asr.id = sr15.assessmentprogramid
where  e.id is null  and asr.id <>47
limit 1000;

--65.Student reported in school A for a prior year, school A is now inactive 
\o 'line65a_inactive_org_enrolled.csv' 
select
 ot.statename,ot.districtname,ot.schoolname,a.id
,s.id studentid, s.statestudentidentifier ssid
,a.abbreviatedname enroll_assessment
,sr15.schoolyear,sr15dt.organizationname district
,sr15sch.organizationname school,sr15.generated 
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated,assessmentprogramid,schoolyear
from studentreport) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner join organization sr15st  on sr15st.id=sr15.stateid
where sr15sch.activeflag is false and  e.currentschoolyear=2017
limit 1000;

--65.Student reported in school A for a prior year, school A is now inactive 
\o 'line65b_inactive_org_unenrolled.csv' 
select distinct 
s.id studentid, s.statestudentidentifier ssid
,asr.abbreviatedname report_assessment,ca.abbreviatedname reportcontentarea
,sr15.schoolyear,sr15dt.organizationname district
,sr15sch.organizationname school,sr15.generated
from  student s                       
left outer JOIN enrollment e    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true and e.currentschoolyear=2017
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,contentareaid,generated,assessmentprogramid,schoolyear
from studentreport) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner join contentarea ca  on ca.id=sr15.contentareaid
inner jOIN assessmentprogram asr ON asr.id = sr15.assessmentprogramid
where  e.id is null  and asr.id <>47 and sr15sch.activeflag is false
limit 1000;


--71.User is associated with assessment program X only, student has reports for assessment programs X and Y.
\o 'tmp_enrollment.csv' 
drop table if exists tmp_std;
select distinct 
ot.statename,ot.districtname,ot.schoolname,r.teacherid,au.uniquecommonidentifier teacher_uniquecommonidentifier,r.coursesectionname
,s.id studentid, s.statestudentidentifier ssid,e.currentschoolyear
,gc.name gradename,a.abbreviatedname enroll_assessment
into temp tmp_std
from  student s                       
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true 
inner join roster r on er.rosterid=r.id and r.activeflag is true and e.currentschoolyear=2017
inner join aartuser au on au.id=r.teacherid
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
where e.currentschoolyear=2017
;

\o 'line71_user_oneprog_student_twoprog.csv'
with dupuser as
(select aa.id,count(distinct asm.id)
from aartuser aa
INNER join usersorganizations ug on aa.id = ug.aartuserid and ug.activeflag is true
INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag is true
INNER join groups g on usg.groupid = g.id 
INNER join organization og on og.id = ug.organizationid and og.activeflag is true
INNER join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag is true
INNER join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag is true
where aa.activeflag is true
group by aa.id
having count(distinct asm.id)=1) 
,nodup as
(select studentid,count(distinct assessmentprogramid)
from (select studentid,assessmentprogramid from externalstudentreports  
union 
select studentid,assessmentprogramid from studentreport where generated is true ) sr
group by studentid
having  count(distinct assessmentprogramid)=2)
select distinct s.statename,s.districtname,s.schoolname,s.teacherid,s.teacher_uniquecommonidentifier,s.coursesectionname
,s.studentid, s.ssid
,s.gradename,s.enroll_assessment
from  tmp_std s
inner jOIN nodup std on std.studentid=s.studentid
inner join dupuser on dupuser.id=s.teacherid
limit 1000;

--72.User is associated with assessment programx X and Y, student has reports for assessment programs X only. 
\o 'line72_user_twoprog_student_oneprog.csv' 
with dupuser as
(select aa.id,count(distinct asm.id)
from aartuser aa
INNER join usersorganizations ug on aa.id = ug.aartuserid and ug.activeflag is true
INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag is true
INNER join groups g on usg.groupid = g.id 
INNER join organization og on og.id = ug.organizationid and og.activeflag is true
INNER join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag is true
INNER join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag is true
where aa.activeflag is true
group by aa.id
having count(distinct asm.id)=1) 
,nodup as
(select studentid,count(distinct assessmentprogramid)
from (select studentid,assessmentprogramid from externalstudentreports  
union 
select studentid,assessmentprogramid from studentreport where generated is true ) sr
group by studentid
having  count(distinct assessmentprogramid)=2)
select distinct s.statename,s.districtname,s.schoolname,s.teacherid,s.teacher_uniquecommonidentifier,s.coursesectionname
,s.studentid, s.ssid
,s.gradename,s.enroll_assessment
from  tmp_std s
inner jOIN nodup std on std.studentid=s.studentid
inner join dupuser on dupuser.id=s.teacherid
limit 1000;

--73.User is associated with KAP,  cPass, student has reports in both assessments.
\o 'line73_user_twoprog_student_twoprog.csv'
with dupuser as
(select aa.id,count(distinct asm.id)
from aartuser aa
INNER join usersorganizations ug on aa.id = ug.aartuserid and ug.activeflag is true
INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag is true
INNER join groups g on usg.groupid = g.id 
INNER join organization og on og.id = ug.organizationid and og.activeflag is true
INNER join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag is true
INNER join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag is true 
where aa.activeflag is true and asm.id in (12,11)
group by aa.id
having count(distinct asm.id)=2) 
,nodup as
(select studentid,count(distinct assessmentprogramid)
from (select studentid,assessmentprogramid from externalstudentreports  where assessmentprogramid=11
union 
select studentid,assessmentprogramid from studentreport where generated is true and assessmentprogramid=12) sr
group by studentid 
having  count(distinct assessmentprogramid)=2)
select distinct s.statename,s.districtname,s.schoolname,s.teacherid,s.teacher_uniquecommonidentifier,s.coursesectionname
,s.studentid, s.ssid
,s.gradename,s.enroll_assessment
from  tmp_std s
inner jOIN nodup std on std.studentid=s.studentid
inner join dupuser on dupuser.id=s.teacherid
limit 1000;


--74.User is associated with KAP, K-ELPA, cPass, DLM, student has reports in both KAP and DLM (different years) .
--a. Find the dtc exists in all three assessments(kap,dlm,cpass)
\o 'line74a_user_multiprog_dtc.csv'
with users as
(
select aa.id dtcid,count(distinct asm.id),email,uniquecommonidentifier,og.id dtid---need  org details
from aartuser aa
INNER join usersorganizations ug on aa.id = ug.aartuserid and ug.activeflag is true
INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag is true
INNER join groups g on usg.groupid = g.id 
INNER join organization og on og.id = ug.organizationid and og.activeflag is true
INNER join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag is true
INNER join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag is true 
where aa.activeflag is true and asm.id in (11,3,12)  and og.organizationtypeid=5
group by aa.id,email,og.id,uniquecommonidentifier
having count(distinct asm.id)=3
)
select u.*,statename from users u
inner join organizationtreedetail ot on ot.districtid=u.dtid ;

 --74b student report exists for cpass 2016 and kap 2015
 \o 'line74b_cpass2016_kap2015.csv'
 with std as
 (
select studentid,count(distinct assessmentprogramid)
from (select studentid,assessmentprogramid from externalstudentreports  where assessmentprogramid=11 and schoolyear=2016
union
select studentid,assessmentprogramid from studentreport where generated is true and assessmentprogramid=12 and schoolyear=2015
) sr
group by studentid 
having  count(distinct assessmentprogramid)=2
)
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015
from  student s 
inner join std std on s.id=std.studentid                      
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,generated
from studentreport where generated is true and assessmentprogramid=12 and schoolyear=2015) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid
from externalstudentreports  where assessmentprogramid=11 and schoolyear=2016) sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
limit 1000
;

--74c student report exists for cpass 2016 and kap 2015
 \o 'line74c_dlm2016_kap2015.csv'
 with std as
 (
select studentid,count(distinct assessmentprogramid)
from (select studentid,assessmentprogramid from externalstudentreports  where assessmentprogramid=3 and schoolyear=2016
union
select studentid,assessmentprogramid from studentreport where generated is true and assessmentprogramid=12 and schoolyear=2015
) sr
group by studentid 
having  count(distinct assessmentprogramid)=2
)
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015
from  student s 
inner join std std on s.id=std.studentid                      
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,generated
from studentreport where generated is true and assessmentprogramid=12 and schoolyear=2015) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid
from externalstudentreports  where assessmentprogramid=3 and schoolyear=2016) sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
limit 1000
;


--68 DLM student report imported with text in Level 1 text
 \o 'line68_level1_text.csv'
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016,level1_text,level2_text
from  student s 
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,level1_text,level2_text
from externalstudentreports  where level1_text  is not  null) sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
limit 1000;

--68 DLM student report imported with text in Level 1 text
 \o 'line68_level2_text.csv'
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid
,gc.name gradename,a.abbreviatedname assessment
,sr16dt.organizationname districtdbid2016
,sr16sch.organizationname schooldbid2016,level1_text,level2_text
from  student s 
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid,level1_text,level2_text
from externalstudentreports  where level2_text  is not  null) sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
limit 1000;


--User enters few chars such as "Son" in last name.  Multiple students with names that include "son" text are students where user should have access to 1 or more years of reports.  
\o 'line16_students_samelastname_prod.csv'
with std as
(
select s.id studentid ,s.legallastname,cnt lastnamecount from ( select legallastname,count(*) cnt  from student 
group by legallastname) a
inner join student s on s.legallastname=a.legallastname where cnt between 100 and 200
)
select distinct 
ot.statename,ot.districtname,ot.schoolname
,s.id studentid, s.statestudentidentifier ssid,s.legallastname,lastnamecount
,gc.name gradename,a.abbreviatedname assessment
,sr15dt.organizationname districtdbid2015,sr16dt.organizationname districtdbid2016
,sr15sch.organizationname schooldbid2015,sr16sch.organizationname schooldbid2016,sr15.generated generated2015
from  student s 
inner join std std on s.id=std.studentid                      
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true and s.activeflag is true
inner JOIN gradecourse gc ON gc.id = e.currentgradelevel
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true 
inner jOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner jOIN (select distinct studentid,attendanceschoolid,districtid,stateid,generated
from studentreport where generated is true ) sr15 ON s.id = sr15.studentid 
inner join organization sr15sch on sr15sch.id=sr15.attendanceschoolid
inner join organization sr15dt  on sr15dt.id=sr15.districtid
inner jOIN (select distinct studentid,schoolid attendanceschoolid,districtid,stateid
from externalstudentreports ) sr16 ON s.id = sr16.studentid 
inner join organization sr16sch on sr16sch.id=sr16.attendanceschoolid
inner join organization sr16dt  on sr16dt.id=sr16.districtid
where e.currentschoolyear=2017 
limit 1000
;























