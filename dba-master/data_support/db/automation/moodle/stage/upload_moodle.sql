BEGIN;
DROP TABLE IF EXISTS tmp_state_roles;
DROP TABLE IF EXISTS tmp_upload_moodle;
DROP TABLE IF EXISTS tmp_RT_completed;
CREATE TEMP TABLE tmp_state_roles(state text,roles text,course text); --we will get file from DLM 
CREATE TEMP TABLE tmp_RT_completed(userid bigint,Rtcomplete text);    --we will get file from DLM 
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

update tmp_state_roles set school_year= (select organization_school_year(o.id))
 from organization o where o.displayidentifier=tmp_state_roles.state;
  
WITH user_list AS 
       (select a.id,
	       row_number() over(partition by a.id order by uo.id) row_num,
	       Schoolname,
	       DistrictName,
	       tmp.state||' - '|| case when tmp.course='Test Admin' then 'Test Admin - 2017'
	                               when upper(cast(cmp.Rtcomplete as char(1)))='Y' then 'Returning - 2017'
	                                    else 'New - 2017' end course     
	   from aartuser a
	    inner join usersorganizations uo on a.id=uo.aartuserid
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
	    inner join tmp_state_roles tmp on tmp.state=st.state and tmp.roles=g.groupcode
	    inner join (select uap.aartuserid from userassessmentprogram uap 
			     inner join assessmentprogram ap on ap.id=uap.assessmentprogramid
			     where ap.abbreviatedname='DLM' and uap.activeflag is true
			     group by uap.aartuserid) dlm_user on dlm_user.aartuserid=a.id
	    left outer join tmp_RT_completed cmp on cmp.userid=a.id
	       where  a.activeflag is true
		  and uo.activeflag is true
		  and uog.activeflag is true
		  and g.activeflag is true
		  and not exists (select 1 from userpdtrainingdetail updt 
					   where a.id=updt.userid 
					   and updt.currentschoolyear=tmp.school_year 
					   and updt.trainingcompleted is true)
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
	       'A'                     Addremove      
	         into temp tmp_upload_moodle     
	    from aartuser a
	    inner join user_list ul on ul.id=a.id
	    left outer join domainaudithistory d on d.objectid=a.id and d.source='MOODLE' and d.objecttype='aartuser' and d.action='EXTRACT'
	    where row_num=1 and d.objectid is null
	    order by ul.course,ul.DistrictName,ul.SchoolName,a.id;	    
\COPY (select * from tmp_upload_moodle) to '/srv/extracts/helpdesk/moodle/processed/upload_moodle/tmp_upload_moodle.csv' DELIMITER ',' CSV HEADER; 
--\COPY (select * from tmp_upload_moodle) to 'tmp_upload_moodle.csv' DELIMITER ',' CSV HEADER;
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action)
SELECT 'MOODLE', 'aartuser', IdNumber, 12, now(), 'EXTRACT' FROM tmp_upload_moodle; 
DROP TABLE IF EXISTS tmp_state_roles;
DROP TABLE IF EXISTS tmp_upload_moodle;	
DROP TABLE IF EXISTS tmp_RT_completed;    
COMMIT;	   