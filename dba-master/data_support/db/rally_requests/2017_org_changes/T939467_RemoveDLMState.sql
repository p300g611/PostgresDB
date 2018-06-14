/*
--Validition 
select id,organizationname, organizationtypeid from organization where  organizationname in ('BIE-Choctaw','Delaware','Mississippi','MY ORGANIZATION ','North Carolina','Virginia')
and organizationtypeid=2 ;

┌───────┬──────────────────┬────────────────────┐
│  id   │ organizationname │ organizationtypeid │
├───────┼──────────────────┼────────────────────┤
│ 42667 │ North Carolina   │                  2 │
│ 58510 │ Delaware         │                  2 │
│  3907 │ Mississippi      │                  2 │
│ 68376 │ BIE-Choctaw      │                  2 │
│ 69163 │ MY ORGANIZATION  │                  2 │
│ 21814 │ Virginia         │                  2 │
└───────┴──────────────────┴────────────────────┘
(6 rows)



SELECT * FROM orgassessmentprogram 
where organizationid in (select id from organization where organizationname in ('BIE-Choctaw','Delaware','Mississippi','MY ORGANIZATION ','North Carolina','Virginia')
and organizationtypeid=2) and assessmentprogramid=3;


│ id  │ organizationid │ assessmentprogramid │         createddate          │ createduser │ activeflag │         modifieddate         │ modifieduser │ isdefault │
├─────┼────────────────┼─────────────────────┼──────────────────────────────┼─────────────┼────────────┼──────────────────────────────┼──────────────┼───────────┤
│ 237 │          42667 │                   3 │ 2014-02-18 07:12:11.242+00   │          12 │ t          │ 2014-02-18 07:12:11.242+00   │           12 │ t         │
│ 343 │          58510 │                   3 │ 2016-08-19 21:55:48.46261+00 │          12 │ t          │ 2016-08-19 21:55:48.46261+00 │           12 │ t         │
│ 201 │           3907 │                   3 │ 2013-09-23 14:09:48.434+00   │          12 │ t          │ 2013-09-23 14:09:48.434+00   │           12 │ t         │
│ 322 │          68376 │                   3 │ 2015-01-22 19:03:14.496+00   │          12 │ t          │ 2015-01-22 19:03:14.496+00   │           12 │ t         │
│ 324 │          69163 │                   3 │ 2015-08-07 05:02:56.916+00   │      124120 │ t          │ 2015-08-07 05:02:56.916+00   │       124120 │ t         │
│ 205 │          21814 │                   3 │ 2013-10-21 01:52:48.419+00   │          12 │ t          │ 2013-10-21 01:52:48.419+00   │           12 │ t         │
└─────┴────────────────┴─────────────────────┴──────────────────────────────┴─────────────┴────────────┴──────────────────────────────┴──────────────┴───────────┘
(6 rows)
--verify user in different assessmentprogram but use the same organizationid

select tmp.userorganizationid,count(*) from tmp_user tmp --(tmp_user including all active user in ep)
join userassessmentprogram usp on usp.id =tmp.uspid
where tmp.stateid in (42667,58510,3907,68376,69163,21814)and usp.assessmentprogramid<>tmp.assessmentprogramid and usp.activeflag is true
group by tmp.userorganizationid
having count(*)>1;
*/



--find the all user in DLM at states('BIE-Choctaw','Delaware','Mississippi','MY ORGANIZATION ','North Carolina','Virginia')
drop table if exists tmp_user;
select aart.id aartid, aart.firstname,aart.surname,us.id usorgid, us.activeflag usflag, us.isdefault usdefault,
usp.id uspid, usp.assessmentprogramid,usp.activeflag,usp.isdefault,
ort.schoolid,
case when ort.schoolid is not null then districtid
     else dt.id end as districtid,
case when  ort.schoolid is not null then ort.stateid
     when dt.id is not null then (select id from organization_parent(dt.id) where organizationtypeid =2)
	 else st.id end as stateid
into temp tmp_user

from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
left outer  join organizationtreedetail ort on ort.schoolid = us.organizationid 
left outer  join organization dt on (dt.id =us.organizationid and dt.organizationtypeid =5)
left outer  join organization st on (st.id=us.organizationid  and st.organizationtypeid =2)
inner join userorganizationsgroups usg on usg.userorganizationid = us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id and usp.activeflag is true
where aart.activeflag is true and usp.assessmentprogramid=3 
order by aart.id;


\copy (select * from tmp_user where stateid in (42667,58510,3907,68376,69163,21814)) to 'T939467_remvoedlm_before_stage_2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

\copy (select * from tmp_user where stateid in (42667,58510,3907,68376,69163,21814)) to 'T939467_remvoedlm_before_prod.csv' DELIMITER ',' CSV HEADER; --count:5577


\copy (select * from tmp_user) to 'T939467_remvoedlm_before_1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);--complete in stage


--select count(*) from tmp_user where stateid in (42667,58510,3907,68376,69163,21814)--914 stage_2--count:5577(prod_before)
--find the activeflag and isdefault are both ture in userassessmentprogram and doesn't belong to DLM

select usp.aartuserid,count(usp.id)  from userassessmentprogram usp
where usp.activeflag is true and usp.isdefault is false
and usp.aartuserid in (select tmp.aartid from tmp_user tmp where tmp.activeflag is true and tmp.isdefault is true
                and tmp.stateid in (42667,58510,3907,68376,69163,21814)
                and tmp.assessmentprogramid=3 and tmp.schoolid is null and tmp.districtid is null)
 group by usp.aartuserid
 having count(usp.id)>1
 order by usp.aartuserid;
  aartuserid | count
------------+-------
      43784 |     4
      55583 |     2
      64191 |    27
     143744 |    36
     143776 |    26

--find the activeflag and isdefualt are both true in usersorganizations
select us.aartuserid, count(us.id) from usersorganizations us
where us.activeflag is true and us.isdefault is false 
and us.aartuserid in (select tmp.aartid from tmp_user tmp where tmp.activeflag is true and tmp.isdefault is true
                and tmp.stateid in (42667,58510,3907,68376,69163,21814)
                and tmp.assessmentprogramid=3 and tmp.schoolid is null and tmp.districtid is null)
 group by us.aartuserid
 having count(us.id)>1
 order by us.aartuserid;
  aartuserid | count
------------+-------
      43784 |     4 --school, district and state 
      55583 |     2 --school, district and state
      64191 |    23
     143744 |    27
     143776 |    23
(5 rows)
--find the information about five users that which isdefault should be inactivate

select aart.id,us.id usorgid, us.organizationid,us.activeflag usflag,us.isdefault usdefault, usp.id uspid,
usp.activeflag uspflag,usp.isdefault uspdefault,usp.assessmentprogramid from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
inner join userorganizationsgroups usg on usg.userorganizationid = us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id and usp.activeflag is true
where aart.id in (64191,143744,143776) and usp.assessmentprogramid =3
order by aart.id;


BEGIN;

--update orgassessmentprogram
update orgassessmentprogram
set   activeflag =false,
      isdefault=false,
	  modifieddate=now(),
	  modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (237,343,201,322,324,205);


--SELECT * FROM orgassessmentprogram where id in (237,343,201,322,324,205);

--update usersorganizations update 5026-fix. 850--stage_2--5032--prod
update usersorganizations
set    activeflag =false,
       isdefault =false,
	   modifieddate=now(),
	   modifieduser = (select id from aartuser where email='ats_dba_team@ku.edu')
where id in (select distinct  usorgid from tmp_user where  assessmentprogramid=3 and stateid in (42667,58510,3907,68376,69163,21814));  

	   

--update userassessmentprogram update 5579-fix. 914 -stage_2 prod:5577
update userassessmentprogram 
set   activeflag =false,
      isdefault =false,
      modifieddate =now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (select distinct uspid from tmp_user where  assessmentprogramid=3 and stateid in (42667,58510,3907,68376,69163,21814));


--three user's isdefault is active

update usersorganizations
set    isdefault =true,
	   modifieddate=now(),
	   modifieduser = (select id from aartuser where email='ats_dba_team@ku.edu')
where id in(64736,158120,158063);


update userassessmentprogram
set   isdefault =true,
      modifieddate =now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (268719,413505,341339);

--inactivate school and district in organization (stage--2741--schoolid,294--districtid)(prod:schoo-5325,district-514)
update organization  
set    activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (select distinct schoolid from organizationtreedetail where stateid in (42667,58510,3907,68376,69163,21814) )
      and activeflag is true;
	  
update organization 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (select distinct districtid from organizationtreedetail where stateid in (42667,58510,3907,68376,69163,21814) )
      and activeflag is true;	
	  
select refresh_organization_detail();

COMMIT;


--validate the result after run script
drop table if exists tmp_user;
select aart.id aartid, aart.firstname,aart.surname,us.id usorgid, us.activeflag usflag, us.isdefault usdefault,
usp.id uspid, usp.assessmentprogramid,usp.activeflag,usp.isdefault,
ort.schoolid,
case when ort.schoolid is not null then districtid
     else dt.id end as districtid,
case when  ort.schoolid is not null then ort.stateid
     when dt.id is not null then (select id from organization_parent(dt.id) where organizationtypeid =2)
	 else st.id end as stateid
into temp tmp_user

from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
left outer  join organizationtreedetail ort on ort.schoolid = us.organizationid 
left outer  join organization dt on (dt.id =us.organizationid and dt.organizationtypeid =5)
left outer  join organization st on (st.id=us.organizationid  and st.organizationtypeid =2)
inner join userorganizationsgroups usg on usg.userorganizationid = us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id and usp.activeflag is true
where aart.activeflag is true and usp.assessmentprogramid=3 
order by aart.id;

--count should be zero
select count(*) from tmp_user where  assessmentprogramid=3 and stateid in (42667,58510,3907,68376,69163,21814);








