--Need more infromation
-- All attribut list
select *
 --piac.attributecontainer,pia.attributename,nonselectedvalue
FROM profileitemattributenameattributecontainer pianc 
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
order by piac.id;

-- scenario1: validation: Remove option Dictate answers to a Scribe
select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,piac.attributecontainer,pia.attributename
,spiav.selectedvalue,a.abbreviatedname,pianc.id,spiav.activeflag,spiav.id
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE 
s.stateid=51  and piac.attributecontainer='response'
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017 
and s.statestudentidentifier in ('7894193615','9491352032','7493420963','9943828676')
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;

-- scenario1: Update script: Remove option Dictate answers to a Scribe

begin;

update studentprofileitemattributevalue 
set activeflag=false,
    modifieddate=now(),
    modifieduser=174744
where id in (4431930,4432495,4431654,1144797) and activeflag is true;

commit;


-- scenario2: validation: Remove auditory background and additional time options, no longer available.
select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,pianc.id,piac.attributecontainer,piac.id,pia.attributename,e.id enrollid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE 
s.stateid=51  
and piac.attributecontainer='AuditoryBackground'
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017 
and s.statestudentidentifier in ('8903899695')
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;

-- scenario2: Update script: Remove auditory background and additional time options, no longer available.

begin;

update studentprofileitemattributevalue 
set activeflag=false,
    modifieddate=now(),
    modifieduser=174744
where id in (1541328,1541327) and activeflag is true;

commit;

-- scenario3: validation: Remove Read Aloud to Self, option no longer available
select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,pianc.id,piac.attributecontainer,piac.id,pia.attributename,e.id enrollid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE 
s.stateid=51  
and piac.attributecontainer='presentation'
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017 
and s.statestudentidentifier in ('3134157675')
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;

-- scenario3: Update script: Remove Read Aloud to Self, option no longer available
--*********need to verify after remove EP says Custom but no settings show when you view the PNP itself

begin;

update studentprofileitemattributevalue 
set activeflag=false,
    modifieddate=now(),
    modifieduser=174744
where id in (5364281) and activeflag is true;

update student set profilestatus = 'NO SETTINGS',
modifieddate = now(),
modifieduser = (select id from aartuser where username='cetesysadmin')
where id =384767;

commit;

-- scenario4: validation: EP says Custom but no settings show when you view the PNP itself

select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,pianc.id,piac.attributecontainer,piac.id,pia.attributename,e.id enrollid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE 
s.stateid=51  
-- and piac.attributecontainer='presentation'
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017 
and s.statestudentidentifier in ('7073135131','3950647201','4821319152','1316459713')
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;

-- scenario4: Update script: EP says Custom but no settings show when you view the PNP itself
--need to verify with rules for this (Simple rule is that if any of the selectedvalue column contains a value 'true' then need CUSTOM else 'NO SETTINGS')
update student set profilestatus = 'NO SETTINGS',
modifieddate = now(),
modifieduser = (select id from aartuser where username='cetesysadmin')
where id in (694855, 694865, 847206, 847191) and activeflag is true;


-- scenario5: validation: EP says No Settings but if you go into the PNP, you see category headers for Presentation and Response.
-- Rajendra : Required code change. The issue is with the way code is checking the existing values. 

-- scenario6: validation: Student has auditory background checked.  The option is greyed out now since it is no longer available to choose for KAP. Please remove this setting from the student.
-- scenario2: validation: Remove auditory background and additional time options, no longer available.
select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,pianc.id,piac.attributecontainer,piac.id,pia.attributename,e.id enrollid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE 
s.stateid=51  
and piac.attributecontainer in ('AuditoryBackground','AdditionalTestingTime')
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017 
and s.statestudentidentifier in ('8903899695')
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;

begin;
update studentprofileitemattributevalue set activeflag = false,
modifieddate = now(),
modifieduser = (select id from aartuser where username='cetesysadmin')
where id in (372926,372927,1541315,1541358,1541356) and activeflag is true;
commit;

--372914,372954,372952(8937337169)


--remove decicated "Student dictated his/her answers to a scribe"


 select spiav.selectedvalue,count(distinct s.id)
 FROM student s
 JOIN enrollment e ON (e.studentid = s.id)
 inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
 JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
 JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
 LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
 LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
 LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
 LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
 WHERE  piac.attributecontainer='response' AND attributename='dictated'
 and spiav.activeflag is true
 and s.activeflag is true and e.activeflag is true
 and e.currentschoolyear=2017
 group by spiav.selectedvalue;

--           selectedvalue           | count
-- ----------------------------------+-------
--                                   | 71489
--  communication                    |    36
--  communication,responses          |     4
--  dictated                         |   810
--  dictated,communication           |     6
--  dictated,communication,responses |     2
--  dictated,responses               |     2
--  false                            | 50699
--  responses                        |     5
--  true                             |     3
-- (10 rows)


select *
 --piac.attributecontainer,pia.attributename,nonselectedvalue
FROM profileitemattributenameattributecontainer pianc 
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
where  piac.attributecontainer='response'
order by piac.id;

select piac.attributecontainer,piac.id,pia.attributename--,e.id enrollid
,spiav.selectedvalue,spiav.activeflag,spiav.id
FROM student s
inner 
JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.id=62246 and spiav.id=1376913

--list1: Remove the all KS-KAP student and actively enrolled

select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,pianc.id,piac.attributecontainer,piac.id,pia.attributename,e.id enrollid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51  
and piac.attributecontainer='response' AND attributename='dictated'
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017 
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;

select spiav.selectedvalue,count(distinct s.id)
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51  
and piac.attributecontainer='response' AND attributename='dictated'
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017
 group by spiav.selectedvalue;


--        selectedvalue      | count
-- -------------------------+-------
--                          | 31327
--  communication           |    24
--  communication,responses |     1
--  dictated                |   787
--  dictated,communication  |     4
--  false                   | 18184
--  responses               |     3
--  true                    |     3
-- (8 rows)



select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,pianc.id,piac.attributecontainer,piac.id,pia.attributename,e.id enrollid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id
FROM student s
JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51  
and piac.attributecontainer='response' AND attributename='dictated' and selectedvalue='dictated'
and spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2017 
order by e.currentschoolyear desc,statename,districtname,schoolname,s.statestudentidentifier;


-- PNP option, “Student dictated his/her answers to a scribe 
--find the list
select spiav.selectedvalue,e.activeflag,count(distinct s.id)
FROM student s
left outer JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51 and sap.assessmentprogramid=12
and piac.attributecontainer='response' AND attributename='dictated' and selectedvalue ilike '%dictated%'
and spiav.activeflag is true
and s.activeflag is true
-- e.currentschoolyear=2017
 group by spiav.selectedvalue,e.activeflag
 order by e.activeflag;



 select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,pianc.id,piac.attributecontainer,piac.id,pia.attributename,e.id enrollid
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag,spiav.id
into temp tmp_pnp_list
FROM student s
left outer JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51 and sap.assessmentprogramid=12
and piac.attributecontainer='response' AND attributename='dictated' and selectedvalue ilike '%dictated%'
and spiav.activeflag is true
and s.activeflag is true
 order by statename,districtname,schoolname;


 select e.currentschoolyear,statename,districtname,schoolname,s.statestudentidentifier,s.id studentid,piac.attributecontainer,pia.attributename,e.id enrollid,e.activeflag enrollactive
,spiav.selectedvalue,a.abbreviatedname,spiav.activeflag spiav_active,spiav.id
into temp tmp_pnp_list
FROM student s
left outer JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE s.stateid=51 and sap.assessmentprogramid=12
and piac.attributecontainer='response' AND attributename='dictated' and selectedvalue ilike '%dictated%'
and spiav.activeflag is true
and s.activeflag is true
 order by statename,districtname,schoolname;



\copy (select * from tmp_pnp_list) to 'prod_pnp_response_dictated_scribe.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

begin;

update studentprofileitemattributevalue 
set activeflag=false,
    modifieddate=now(),
    modifieduser=174744
where id in (select id from tmp_pnp_list) and activeflag is true;

commit;


