District Name	School Name	# of Users	DLM Y/N	KAP Y/N	KELPA Y/N	cPass Y/N	# of Students	DLM Tests Y/N	KAP Tests Y/N	Interim Tests Y/N	KELPA Tests Y/N	 cPass Tests Y/N

--validation school 
select * from tmp_dupschool tmp 
where tmp.schoolnum not in (select tmp.schoolnum from tmp_dupschool tmp
 join  organizationtreedetail ort on ort.schooldisplayidentifier=tmp.schoolnum and ort.districtdisplayidentifier = tmp.districtnum
where ort.stateid=51 );
--four school inactive
│           schoolname            │ schoolnum │   districtname   │ districtnum │
├─────────────────────────────────┼───────────┼──────────────────┼─────────────┤
│ Chisholm Middle                 │ 4805      │ Newton           │ D0373       │
│ Richard W. Warren Middle School │ 7017      │ Leavenworth      │ D0453       │
│ South Breeze Elem               │ 4800      │ Newton           │ D0373       │
│ St. Paul High School            │ 8371      │ Chetopa St. Paul │ D0505   
--select id, abbreviatedname from assessmentprogram where id in (3,12,47,11)
│ id │ abbreviatedname │
├────┼─────────────────┤
│ 11 │ CPASS           │
│ 12 │ KAP             │
│  3 │ DLM             │
│ 47 │ K-ELPA          │
└────┴─────────────────┘
(4 rows)


BEGIN;

drop table if exists tmp_rawschool;
drop table if exists tmp_dupschool;
create  temporary table tmp_rawschool(schoolname text, schoolnum text, districtname text, districtnum text);
\COPY tmp_rawschool from 'dupschool.csv' DELIMITER ',' CSV HEADER;

select trim(schoolname) schoolname,trim(schoolnum) schoolnum,trim(districtname) districtname,trim(districtnum) districtnum into temp tmp_dupschool from tmp_rawschool;




with tmp_asprog as (
select distinct aart.id aartid,usm.id usmid

from aartuser aart 
JOIN usersorganizations ug on aart.id = ug.aartuserid and ug.activeflag is true
JOIN organizationtreedetail ort ON (ug.organizationid = ort.schoolid)
join tmp_dupschool tmp on tmp.schoolnum=ort.schooldisplayidentifier and tmp.districtnum =ort.districtdisplayidentifier
JOIN userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag is true
JOIN groups g on usg.groupid = g.id and g.activeflag is true
JOIN userassessmentprogram usm on aart.id = usm.aartuserid  and usm.userorganizationsgroupsid = usg.id and usm.activeflag is true
JOIN assessmentprogram asm on asm.id = usm.assessmentprogramid  and asm.activeflag is true
where aart.activeflag is true and asm.abbreviatedname in ('CPASS','KAP','DLM','K-ELPA') and ort.stateid=51

)


select distinct org.districtname, org.schoolname, aart.id aartuserid,
case when usm.assessmentprogramid = 3 then 'Y' 
     else 'N' END "DLM Y/N",
case when usm.assessmentprogramid = 12 then 'Y' 
     else 'N' END "KAP Y/N",
case when usm.assessmentprogramid = 47 then 'Y' 
     else 'N' END "KELPA Y/N",
case when usm.assessmentprogramid = 11 then 'Y' 
     else 'N' END "CPASS Y/N",
	 
st.studentid,
case when tp.assessmentprogramid = 3 then 'Y' 
     else 'N' END "DLM Tests Y/N",

case when tp.assessmentprogramid = 12 then 'Y' 
     else 'N' END "KAP Tests Y/N",
	 
case when tp.assessmentprogramid = 47 then 'Y' 
     else 'N' END "KELPA Tests Y/N",
	 
case when tp.assessmentprogramid = 11 then 'Y' 
     else 'N' END "CPASS Tests Y/N",
	 	 
case when tp.programname = 'Interim' then 'Y' 
     else 'N' END "Interim Tests Y/N"	 
	 
	 
	 
into temp dup_infr


from studentstests st
join student stu on stu.id =st.studentid and stu.activeflag is true
join enrollment en on en.studentid=stu.id and en.activeflag is true
join organizationtreedetail org on org.schoolid=en.attendanceschoolid
join tmp_dupschool tmp on  tmp.schoolnum=org.schooldisplayidentifier and tmp.districtnum =org.districtdisplayidentifier
join enrollmentsrosters enr on  enr.enrollmentid = en.id and enr.activeflag is true
join roster r on r.id =enr.rosterid and r.activeflag is true
join aartuser aart on aart.id =r.teacherid and aart.activeflag is true
join tmp_asprog tmpa on tmpa.aartid = aart.id 
join userassessmentprogram usm on usm.aartuserid = tmpa.aartid and usm.id =tmpa.usmid
inner join test t on t.id = st.testid and t.activeflag is true
inner join testsession tss on tss.id =st.testsessionid and tss.activeflag is true
left outer join testcollectionstests tct ON t.id = tct.testid 
left outer join testcollection tc ON tc.id = tct.testcollectionid and tc.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid and atc.activeflag is true
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id	 

where st.activeflag is true and en.currentschoolyear =2017 and (tp.assessmentprogramid in (3,12,11,47)or tp.programname='Interim')
order by org.districtname, org.schoolname;

\COPY (select * from dup_infr) to 'dup_school_user.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);






