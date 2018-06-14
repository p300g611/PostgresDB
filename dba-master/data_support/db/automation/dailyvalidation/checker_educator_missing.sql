--check educator not in eductors in sqlite, but in enrollmentcontentarea.
with tmp_roster as (select distinct s.id studentid,ca.abbreviatedname ,r.id rosterid        
,aart.id educatorid 
from student s 
inner join enrollment e on e.studentid=s.id
inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id 
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
inner join contentarea ca on ca.id =r.statesubjectareaid
inner join aartuser aart on aart.id=r.teacherid
where s.activeflag is true and assessmentprogramid=3 and e.currentschoolyear=2018
and ort.statename not IN ('flatland', 'DLM QC State', 'AMP QC State', 'KAP QC State', 'Playground QC State', 'Flatland',
'DLM QC YE State', 'DLM QC IM State', 'DLM QC IM State ', 'DLM QC EOY State','Service Desk QC State','NY Training State','QA QC State')
and ca.abbreviatedname<>'ELP'),
 tmp_default as (select aa.id,count(distinct usg.isdefault)
from aartuser aa
JOIN usersorganizations ug on aa.id = ug.aartuserid
JOIN userorganizationsgroups usg on ug.id = usg.userorganizationid
JOIN groups g on usg.groupid = g.id
JOIN userassessmentprogram usm on aa.id = usm.aartuserid  and usm.userorganizationsgroupsid = usg.id
JOIN assessmentprogram asm on asm.id = usm.assessmentprogramid 
where aa.activeflag is true 
group by aa.id
having count(distinct usg.isdefault)=1
)
select tmp.studentid,tmp1.id,tmp.abbreviatedname
from tmp_roster tmp 
join tmp_default tmp1 on tmp1.id=tmp.educatorid
join aartuser aa on aa.id =tmp1.id
JOIN usersorganizations ug on aa.id = ug.aartuserid
 JOIN userorganizationsgroups usg on ug.id = usg.userorganizationid
 JOIN groups g on usg.groupid = g.id
 JOIN userassessmentprogram usm on aa.id = usm.aartuserid  and usm.userorganizationsgroupsid = usg.id
 JOIN assessmentprogram asm on asm.id = usm.assessmentprogramid 
where aa.activeflag is true and usg.isdefault is false;

---verify the educator in sqlite
SELECT  au.id, au.activeflag, au.uniquecommonidentifier, au.username,
            au.firstname, au.surname,
            o.organizationname, o.displayidentifier, o.id, o.organizationtypeid,
            po.organizationname, po.displayidentifier, po.id,
                po.organizationtypeid,
            gpo.organizationname, gpo.displayidentifier, gpo.id,
                gpo.organizationtypeid,
            gpo1.organizationname, gpo1.displayidentifier, gpo1.id,
                gpo1.organizationtypeid,
            gpo2.organizationname, gpo2.displayidentifier, gpo2.id,
                gpo2.organizationtypeid,
            gpo3.organizationname, gpo3.displayidentifier, gpo3.id,
                gpo3.organizationtypeid,
            gpo4.organizationname, gpo4.displayidentifier, gpo4.id,
                gpo4.organizationtypeid,
            g.groupname, o.schoolstartdate,
            usa.agreementelection, usa.agreementsigneddate,
            o.schoolenddate
FROM aartuser au
JOIN usersorganizations uo ON uo.aartuserid = au.id
JOIN organization o ON uo.organizationid = o.id
JOIN organizationrelation por ON o.id = por.organizationid
JOIN organization po ON por.parentorganizationid = po.id
LEFT JOIN organizationrelation gpor ON po.id = gpor.organizationid
LEFT JOIN organization gpo ON gpor.parentorganizationid = gpo.id
lEFT JOIN organizationrelation gpor1 ON gpo.id = gpor1.organizationid
LEFT JOIN organization gpo1 ON gpor1.parentorganizationid = gpo1.id
LEFT JOIN organizationrelation gpor2 ON gpo1.id = gpor2.organizationid
LEFT JOIN organization gpo2 ON gpor2.parentorganizationid = gpo2.id
LEFT JOIN organizationrelation gpor3 ON gpo2.id = gpor3.organizationid
LEFT JOIN organization gpo3 ON gpor3.parentorganizationid = gpo3.id
LEFT JOIN organizationrelation gpor4 ON gpo3.id = gpor4.organizationid
LEFT JOIN organization gpo4 ON gpor4.parentorganizationid = gpo4.id
LEFT JOIN usersecurityagreement usa ON au.id = usa.aartuserid
JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
JOIN groups g ON uog.groupid = g.id
WHERE au.activeflag = TRUE AND uog.isdefault = TRUE and au.id=80780