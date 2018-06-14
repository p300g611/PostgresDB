select distinct  a.id,a.email into temp tmp_aartuser
from aartuser  a
inner join usersorganizations ug on a.id=ug.aartuserid
inner join (select schoolid id from organizationtreedetail where statedisplayidentifier  ='VT'
union 
select districtid id from organizationtreedetail where statedisplayidentifier  ='VT'
union 
select stateid id from organizationtreedetail where statedisplayidentifier  ='VT') org on org.id=ug.organizationid
LEFT OUTER JOIN userorganizationsgroups usg on ug.id = usg.userorganizationid
LEFT OUTER JOIN userassessmentprogram usm on a.id = usm.aartuserid  and usm.userorganizationsgroupsid = usg.id
LEFT OUTER JOIN assessmentprogram asm on asm.id = usm.assessmentprogramid
where a.activeflag is true and email not ilike '%@ku.edu%'
order by a.email;  

\copy (select  * from tmp_aartuser ) to 'tmp_aartuser_ticket131150.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);

begin;
update aartuser 
set   activeflag =false,
      modifieddate =now(),
      modifieduser =(select id from aartuser where email ='ats_dba_team@ku.edu')
    where id in (select id from tmp_aartuser) and activeflag is true;
commit;