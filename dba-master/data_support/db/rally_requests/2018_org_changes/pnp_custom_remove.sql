-- PNP custom setting remove  for KAP kids)
--It is for KAP and for KELPA2, removing:Human Read Aloud Test Admin Enders Responses for Student Both on the "Other Supports" tab

select piac.attributecontainer,pia.attributename,nonselectedvalue
FROM profileitemattributenameattributecontainer pianc 
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
where  pia.attributename ilike '%supportsTestAdminEnteredResponses%' 
 or pia.attributename ilike '%supportsHumanReadAloud%';

drop table if exists tmp_report;
select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,piac.attributecontainer,pia.attributename,e.id enrollid,e.studentid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id,sap.assessmentprogramid,sap.activeflag assessmentactive
into temp tmp_report
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.assessmentprogramid in (12,47)
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE piac.attributecontainer in ('supportsProvidedOutsideSystem')
 and pia.attributename in ('supportsTestAdminEnteredResponses','supportsHumanReadAloud')
and spiav.activeflag is true and s.activeflag is true 
and not exists (select 1 from studentassessmentprogram sapdlm where sapdlm.studentid=s.id and sapdlm.assessmentprogramid = 3 and sapdlm.activeflag is true);

\copy (select * from tmp_report) to 'KAP_KELPA_PNP_stage06122018.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;
update studentprofileitemattributevalue set activeflag = false,
modifieddate = now(),
modifieduser = (select id from aartuser where username='ats_dba_team@ku.edu')
where id in (select distinct id from tmp_report) and activeflag is true;
commit;


drop table if exists tmp_std_custom;
SELECT DISTINCT s.id studentid,enrl.currentschoolyear,s.stateid
into temp tmp_std_custom
FROM student s
INNER JOIN enrollment enrl ON enrl.studentid = s.id
inner JOIN studentassessmentprogram sap ON (sap.studentid = s.id)
WHERE sap.assessmentprogramid in (12,47) --and s.stateid=51 and AND enrl.currentschoolyear =2018
AND s.profilestatus = 'CUSTOM'
 AND s.activeflag = TRUE
and not exists (select 1 from studentassessmentprogram sapdlm where sapdlm.studentid=s.id and sapdlm.assessmentprogramid = 3 and sapdlm.activeflag is true);

select count(distinct s.studentid) from tmp_std_custom s
left outer join studentprofileitemattributevalue spiav ON s.studentid = spiav.studentid and spiav.activeflag is true
where spiav.id is null;


select distinct s.studentid from tmp_std_custom s
where not exists (select 1 from studentprofileitemattributevalue spiav where s.studentid = spiav.studentid and spiav.activeflag is true)
limit 10;


-- select count(distinct studentid) from tmp_std_custom
-- where studentid in (select studentid from studentprofileitemattributevalue where modifieddate='2018-06-12 13:57:14.296427+00' and modifieduser=174744);
-- 
-- 
-- select count(distinct s.studentid) from tmp_std_custom s
-- where not exists (select 1 from studentprofileitemattributevalue spiav where s.studentid = spiav.studentid and spiav.activeflag is true and upper(coalesce(selectedvalue,''))='TRUE')
-- and s.studentid in ( select studentid from studentprofileitemattributevalue where modifieddate='2018-06-12 13:57:14.296427+00' and modifieduser=174744); 
-- 
-- 
-- select distinct s.studentid from tmp_std_custom s
-- where not exists (select 1 from studentprofileitemattributevalue spiav where s.studentid = spiav.studentid and spiav.activeflag is true and upper(coalesce(selectedvalue,''))='TRUE')
-- and s.studentid in ( select studentid from studentprofileitemattributevalue where modifieddate='2018-06-12 13:57:14.296427+00' and modifieduser=174744)
-- limit 10;

drop table if exists tmp_std_inactive;
select distinct e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,s.id studentid,s.profilestatus
into temp tmp_std_inactive
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid and sap.assessmentprogramid in (12,47)
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
where s.id in (select distinct s.studentid from tmp_std_custom s
where not exists (select 1 from studentprofileitemattributevalue spiav where s.studentid = spiav.studentid and spiav.activeflag is true and upper(coalesce(selectedvalue,''))='TRUE')
--and s.studentid in (select studentid from studentprofileitemattributevalue where modifieddate='2018-06-12 13:57:14.296427+00' and modifieduser=174744)
)
and not exists (select 1 from studentassessmentprogram sapdlm where sapdlm.studentid=s.id and sapdlm.assessmentprogramid = 3 and sapdlm.activeflag is true)
;

\copy (select * from tmp_std_inactive) to 'KAP_KELPA_PNP_custom_stage06122018_v3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

update student set profilestatus = 'NO SETTINGS',
modifieddate = now(),
modifieduser = (select id from aartuser where username='cetesysadmin')
where profilestatus='CUSTOM' and 
id in (select distinct studentid from tmp_std_inactive);

