-- F730 New column add for moodle upload table 
--ALTER TABLE moodleupload ADD COLUMN if not exists usertrainingtype VARCHAR(50);
drop table if exists tmp_upload_moodle_2018;
create temp table tmp_upload_moodle_2018
(username text,lastname text,firstname text,email text,idnumber bigint,Password text,profile_field_district text,profile_field_school text,course1 text,addremove text);

\COPY tmp_upload_moodle_2018 from '/srv/extracts/helpdesk/moodle/processed/upload_moodle/tmp_upload_moodle_2018.csv' DELIMITER ',' CSV HEADER;


update moodleupload tgt
set usertrainingtype =src.course1
from tmp_upload_moodle_2018 src where src.idnumber=tgt.aartuserid 
  and case when src.course1 ilike  '%Facilitators%' then 'Facilitators' else 'NewReturning' end=tgt.course and tgt.schoolyear=2018
  and tgt.usertrainingtype is null  and src.course1 ilike '%2018%';

insert into moodleupload(aartuserid,schoolyear,email,course,createddate,createduser,modifieddate,modifieduser,usertrainingtype)
select src.idnumber aartuserid,
       2018 schoolyear,
       src.email email,
       case when src.course1 ilike  '%Facilitators%' then 'Facilitators' 
            else 'NewReturning' end course,
       now() createddate,
       (select id from aartuser  where email='ats_dba_team@ku.edu') createduser,
       now() modifieddate,
       (select id from aartuser  where email='ats_dba_team@ku.edu') modifieduser,
       src.course1
from tmp_upload_moodle_2018 src 
left outer join  moodleupload tgt on src.idnumber=tgt.aartuserid 
  and case when src.course1 ilike  '%Facilitators%' then 'Facilitators' else 'NewReturning' end=tgt.course and tgt.schoolyear=2018
where tgt.aartuserid is null and src.course1 ilike '%2018%';

--ALTER TABLE moodleupload ALTER COLUMN usertrainingtype SET NOT NULL;