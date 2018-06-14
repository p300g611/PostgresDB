select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,piac.attributecontainer,pia.attributename,spiav.selectedvalue,a.abbreviatedname
 into temp tmp_pnp_maskingtype
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51  and piac.attributecontainer='Masking'
and  (coalesce(spiav.selectedvalue,'')='TRUE' or coalesce(spiav.selectedvalue,'')='true') and spiav.activeflag is true
and s.id not in (select studentid from studentassessmentprogram where assessmentprogramid<>12 and activeflag is true)
and s.activeflag is true and e.activeflag is true
-- and e.currentschoolyear=2017 
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;

\copy (select * from tmp_pnp_maskingtype) to 'pnp_maskingtype.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;
update studentprofileitemattributevalue
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
where id in ( select distinct spiav.id
--,e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,piac.attributecontainer,pia.attributename,spiav.selectedvalue,a.abbreviatedname
 FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51  and piac.attributecontainer='Masking'
and  (coalesce(spiav.selectedvalue,'')='TRUE' or coalesce(spiav.selectedvalue,'')='true') and spiav.activeflag is true
and s.id not in (select studentid from studentassessmentprogram where assessmentprogramid<>12 and activeflag is true)
and s.activeflag is true and e.activeflag is true
-- and e.currentschoolyear=2017 
)
commit;

-- find the students for true value
select  studentid,id
 into temp tmp_sps 
from studentprofileitemattributevalue s
where  profileitemattributenameattributecontainerid in (23,24,25) 
and activeflag is true and (selectedvalue='TRUE' or selectedvalue='true');


with sap_one as(
select sap.studentid,count(distinct assessmentprogramid)  
from studentassessmentprogram sap where activeflag is true
group by sap.studentid 
having count(distinct assessmentprogramid) =1)
select s.studentid
 into temp tmp_kap
 from studentassessmentprogram s
 inner join sap_one tmp 
on tmp.studentid=s.studentid and s.assessmentprogramid=12
 and s.activeflag is true;


 -- validation : make sure all students in kap
select * from tmp_kap tmp 
inner join studentassessmentprogram sap on tmp.studentid=sap.studentid
where sap.activeflag is true
and assessmentprogramid<>12;

select count(*) from tmp_kap;
select count(distinct studentid) from tmp_kap;

select msk.id,msk.studentid from tmp_kap tmp
inner join tmp_sps msk on msk.studentid=tmp.studentid;


select id,studentid,selectedvalue from studentprofileitemattributevalue where id in ( select distinct msk.id from tmp_kap tmp inner join tmp_sps msk on msk.studentid=tmp.studentid)

\copy ( select id,studentid,selectedvalue from studentprofileitemattributevalue where id in ( select distinct msk.id from tmp_kap tmp inner join tmp_sps msk on msk.studentid=tmp.studentid)) to 'pnp_maskingtype_prod.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

begin;
update studentprofileitemattributevalue
set selectedvalue='false',
    modifieddate=now(),
    modifieduser=12
where id in ( select distinct msk.id from tmp_kap tmp
inner join tmp_sps msk on msk.studentid=tmp.studentid);
commit;
