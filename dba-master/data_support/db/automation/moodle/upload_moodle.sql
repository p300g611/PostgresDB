DROP TABLE IF EXISTS tmp_state_roles;
DROP TABLE IF EXISTS tmp_upload_moodle;
DROP TABLE IF EXISTS tmp_RT_completed;
DROP TABLE IF EXISTS tmp_process_user;
DROP TABLE IF EXISTS tmp_courses;
CREATE TEMP TABLE tmp_state_roles(state text,roles text,course text); --we will get file from DLM 
CREATE TEMP TABLE tmp_RT_completed(userid bigint,Rtcomplete text);    --we will get file from DLM 
CREATE TEMP TABLE tmp_courses(courses character varying(254));        --Course List
--\COPY tmp_state_roles from  'state_roles.csv' DELIMITER ',' CSV HEADER; 
--\COPY tmp_RT_completed from  'RTcompleted.csv' DELIMITER ',' CSV HEADER; 
\COPY tmp_state_roles from '/srv/extracts/helpdesk/moodle/state_roles/state_roles.csv' DELIMITER ',' CSV HEADER;
\COPY tmp_RT_completed from '/srv/extracts/helpdesk/moodle/state_roles/RTcompleted.csv' DELIMITER ',' CSV HEADER;
/*
Insert into tmp_state_roles         
select st.state,g.groupcode,'' course
 from aartuser a
    inner join usersorganizations uo on a.id=uo.aartuserid
    inner join userorganizationsgroups uog on uog.userorganizationid=uo.id
    inner join (select o.id,case when o.organizationtypeid=(select id from organizationtype where typecode ='ST') then o.displayidentifier 
                 else (select displayidentifier from organization_parent(o.id) where organizationtypeid=(select id from organizationtype where typecode ='ST')) 
                 end state from organization o where o.activeflag is true) st on state is not null and st.id=uo.organizationid
    inner join groups g on g.id=uog.groupid
    inner join (select uap.aartuserid from userassessmentprogram uap 
			     inner join assessmentprogram ap on ap.id=uap.assessmentprogramid
			     where ap.abbreviatedname='DLM' and uap.activeflag is true
			     group by uap.aartuserid) dlm_user on dlm_user.aartuserid=a.id
       where  a.activeflag is true
          and uo.activeflag is true
          and uog.activeflag is true
          and g.activeflag is true
          and st.state in ( 'state','AK','BIE-Choctaw','BIE-Miccosukee','CO','DLMQCEOYST','DLMQCIMST',
			    'DLMQCST','DLMQCYEST','IA','IL','KS','MO','MS','NC','ND','NH','NJ','NY',
			    'OK','PA','UT','VA','VT','WI','WV')
          group by st.state,g.groupcode
          order by st.state,g.groupcode;

--DLM states
select o.displayidentifier state from orgassessmentprogram  oap
			inner join assessmentprogram ap on ap.id=oap.assessmentprogramid
						     and ap.abbreviatedname='DLM' and oap.activeflag is true
			inner join organization o on o.id=oap.organizationid 
			group by o.displayidentifier;
*/			
--Upload to moodle
alter table tmp_state_roles add school_year int;
insert into tmp_courses 
select 'NewReturning'
union
select 'Facilitators';

--update tmp_state_roles set school_year= (select organization_school_year(o.id))
 --from organization o where o.displayidentifier=tmp_state_roles.state;

update tmp_state_roles set school_year= 2018;

with dlm_user as ( 
select a.id aartuserid,a.email --into temp tmp_process_user
from aartuser a
inner join userassessmentprogram uap on a.id=uap.aartuserid
inner join assessmentprogram ap on ap.id=uap.assessmentprogramid
where ap.abbreviatedname='DLM' and uap.activeflag is true and a.activeflag is true
group by a.id,a.email)
select dlm.aartuserid,dlm.email,dlm.courses 
into temp tmp_process_user
from
(select aartuserid,email,courses  from dlm_user 
cross join tmp_courses) dlm
left outer join moodleupload up on up.aartuserid=dlm.aartuserid and up.course=dlm.courses and up.schoolyear=2018 --and up.email=dlm.email
where up.aartuserid is null;

WITH user_list AS 
       (select a.aartuserid,
	       row_number() over(partition by a.aartuserid order by uo.id) row_num,
	       Schoolname,
	       DistrictName,
	       tmp.state||' - '|| case when tmp.course='Test Admin' then 'Test Admin - 2018'
	                               when tmp.course='Facilitators' then 'Facilitators - 2018'
	                               when upper(cast(cmp.Rtcomplete as char(1)))='Y' then 'Returning - 2018'
	                                    else 'New - 2018' end course     
	   from tmp_process_user a
	    inner join usersorganizations uo on a.aartuserid=uo.aartuserid
	    inner join userorganizationsgroups uog on uog.userorganizationid=uo.id
	    inner join (select o.id,o.organizationtypeid
			      ,case when o.organizationtypeid=(select id from organizationtype where typecode ='SCH') then o.organizationname
				    else null end Schoolname
			      ,case when o.organizationtypeid=(select id from organizationtype where typecode ='DT') then o.organizationname
				    else (select organizationname from organization_parent(o.id) where organizationtypeid=(select id from organizationtype where typecode ='DT') limit 1) 
				    end DistrictName        
			      ,case when o.organizationtypeid=(select id from organizationtype where typecode ='ST') then o.displayidentifier 
				    else (select displayidentifier from organization_parent(o.id) where organizationtypeid=(select id from organizationtype where typecode ='ST') limit 1) 
				    end state
				     from organization o where o.activeflag is true) st on state is not null and st.id=uo.organizationid
	    inner join groups g on g.id=uog.groupid
	    inner join tmp_state_roles tmp on tmp.state=st.state and tmp.roles=g.groupcode and a.courses=case when tmp.course='Facilitators' then 'Facilitators' else 'NewReturning' end
	    left outer join tmp_RT_completed cmp on cmp.userid=a.aartuserid
	       where uo.activeflag is true
		  and uog.activeflag is true
		  and g.activeflag is true
		--  and not exists (select 1 from userpdtrainingdetail updt 
		--			   where a.id=updt.userid 
		--			   and updt.currentschoolyear=tmp.school_year 
		--			   and updt.trainingcompleted is true)
           )
	select username                Username,
	       surname                 LastName,
	       firstname               FirstName,
	       email                   Email,
	       a.id                    IdNumber,
	       split_part(email,'@',1) "Password",
	       ul.DistrictName         Profile_field_district,    
	       ul.SchoolName           Profile_field_school, 
	       ul.course               Course1, 
	       'A'::char(1)            Addremove      
	         into temp tmp_upload_moodle     
	    from aartuser a
	    inner join user_list ul on ul.aartuserid=a.id
	    where row_num=1;	     
\COPY (select * from tmp_upload_moodle) to '/srv/extracts/helpdesk/moodle/processed/upload_moodle/tmp_upload_moodle.csv' DELIMITER ',' CSV HEADER; 
--\COPY (select * from tmp_upload_moodle) to 'tmp_upload_moodle.csv' DELIMITER ',' CSV HEADER;
insert into moodleupload(aartuserid,schoolyear,email,course,createddate,createduser,modifieddate,modifieduser,usertrainingtype)
select IdNumber aartuserid,
       2018 schoolyear,
       Email email,
       case when Course1 ilike  '%Facilitators%' then 'Facilitators' 
            else 'NewReturning' end course,
       now() createddate,
       (select id from aartuser  where email='ats_dba_team@ku.edu') createduser,
       now() modifieddate,
       (select id from aartuser  where email='ats_dba_team@ku.edu') modifieduser,
       Course1 usertrainingtype
from tmp_upload_moodle a;
DROP TABLE IF EXISTS tmp_state_roles;
DROP TABLE IF EXISTS tmp_upload_moodle;	
DROP TABLE IF EXISTS tmp_RT_completed;  
DROP TABLE IF EXISTS tmp_process_user;  
DROP TABLE IF EXISTS tmp_courses;
   