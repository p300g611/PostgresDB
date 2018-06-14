--before sanitization transaction
\copy (select id,statestudentidentifier from student) to 'tmp_student.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--audit database 
drop table if exists tmp_student;
create temp table tmp_student (sid bigint,ssid character varying(50));
\COPY tmp_student FROM 'tmp_student.csv' DELIMITER ',' CSV HEADER ;

UPDATE uploadgrffile SET studentlegalfirstname = 'First' || sid, studentlegalmiddlename = 'M' || sid, studentlegallastname = 'Last' || sid, username = 'first.last' || sid, statestudentidentifier = sid,educatorfirstname='Fisrt'||id, educatorlastname='Last'||id, educatorusername='first.last'||id 
from tmp_student tmp where ssid=statestudentidentifier;
UPDATE uploadgrffile SET studentlegalfirstname = 'First' || sid, studentlegalmiddlename = 'M' || sid, studentlegallastname = 'Last' || sid, statestudentidentifier=sid
from tmp_student tmp where ssid=statestudentidentifier;
UPDATE uploadincidentfile SET studentlegalfirstname = 'First' || sid, studentlegallastname = 'Last' || sid, studentlegalmiddlename = 'M' || sid, statestudentidentifier = sid
from tmp_student tmp where ssid=statestudentidentifier;
UPDATE uploadsccodefile SET studentlegalfirstname = 'First' || sid, studentlegallastname = 'Last' || sid, studentlegalmiddlename = 'M' || sid, statestudentidentifier = sid
from tmp_student tmp where ssid=statestudentidentifier;
UPDATE firstcontactsurveyaudithistory SET studentfirstname = 'First' || sid, studentlastname = 'Last' || sid, statestudentidentifier=sid
from tmp_student tmp where ssid=statestudentidentifier;
UPDATE kids_record_staging SET legal_first_name = 'First' || sid, legal_middle_name = 'M' || sid, legal_last_name = 'Last' || sid, state_student_identifier=sid
from tmp_student tmp where ssid=state_student_identifier;   
UPDATE kidsdashboardrecord SET legalfirstname = 'First' || sid, legallastname = 'Last' || sid, legalmiddlename = 'M' || sid, statestudentidentifier = sid
from tmp_student tmp where ssid=statestudentidentifier; 
UPDATE studentaudittrailhistory SET studentfirstname = 'First' || sid, studentlastname = 'Last' || sid, statestudentid = sid
from tmp_student tmp where ssid=statestudentid;
UPDATE studentpnpsaudithistory SET studentfirstname = 'First' || sid, studentlastname = 'Last' || sid, statestudentidentifier = sid
from tmp_student tmp where ssid=statestudentidentifier;
UPDATE tasc_record_staging  SET student_legal_first_name = 'First' || sid, student_legal_middle_name = 'M' || sid, student_legal_last_name = 'Last' || sid, state_student_identifier=sid
from tmp_student tmp where ssid=state_student_identifier;
UPDATE firstcontactsurveyaudithistory SET beforevalue = NULL, currentvalue = NULL;  
UPDATE studentpnpsaudithistory SET beforevalue = NULL, currentvalue = NULL;
UPDATE rosteraudittrailhistory SET beforevalue = NULL, currentvalue = NULL; 
UPDATE useraudittrailhistory SET  beforevalue = NULL, currentvalue = NULL;
UPDATE studentaudittrailhistory SET  beforevalue = NULL, currentvalue = NULL;
UPDATE domainaudithistory  SET objectbeforevalues = NULL, objectaftervalues = NULL;
update batchregistration set status='FAILED',modifieddate=now()  where status='IN-PROGRESS';
update batchupload set status='FAILED',modifieddate=now()  where status='IN-PROGRESS';
update ksdexmlaudit set processedcode='NOTPROCESSED',xml='' where processedcode<>'COMPLETED';
update ksdexmlaudit set xml = '';

/*
issue corrected for ssid updated with studentid instead of id.
update ksdexmlaudit set xml = '';
UPDATE uploadgrffile SET studentlegalfirstname = 'First' || id, studentlegalmiddlename = 'M' || id, studentlegallastname = 'Last' || id, username = 'first.last' || id, statestudentidentifier = id,educatorfirstname='Fisrt'||id, educatorlastname='Last'||id, educatorusername='first.last'||id ;
UPDATE domainaudithistory  SET objectbeforevalues = NULL, objectaftervalues = NULL;
UPDATE firstcontactsurveyaudithistory SET studentfirstname = 'First' || id, studentlastname = 'Last' || id, statestudentidentifier=id::text;
UPDATE firstcontactsurveyaudithistory SET beforevalue = NULL, currentvalue = NULL;                
UPDATE kids_record_staging SET legal_first_name = 'First' || id, legal_middle_name = 'M' || id, legal_last_name = 'Last' || id, state_student_identifier=id::text; --might need to updated id for studentid
UPDATE kidsdashboardrecord SET legalfirstname = 'First' || id, legallastname = 'Last' || id, legalmiddlename = 'M' || id, statestudentidentifier = id; --might need to updated id for studentid
UPDATE rosteraudittrailhistory SET beforevalue = NULL, currentvalue = NULL; 
UPDATE studentaudittrailhistory SET studentfirstname = 'First' || id, studentlastname = 'Last' || id, statestudentid = id;
UPDATE studentaudittrailhistory SET  beforevalue = NULL, currentvalue = NULL; 
UPDATE studentpnpsaudithistory SET studentfirstname = 'First' || id, studentlastname = 'Last' || id, statestudentidentifier = id;
UPDATE studentpnpsaudithistory SET beforevalue = NULL, currentvalue = NULL;
UPDATE tasc_record_staging SET student_legal_first_name = 'First' || id, student_legal_middle_name = 'M' || id, student_legal_last_name = 'Last' || id, state_student_identifier=id::text;
UPDATE uploadgrffile SET studentlegalfirstname = 'First' || id, studentlegalmiddlename = 'M' || id, studentlegallastname = 'Last' || id, statestudentidentifier=id::text;
UPDATE uploadincidentfile SET studentlegalfirstname = 'First' || id, studentlegallastname = 'Last' || id, studentlegalmiddlename = 'M' || id, statestudentidentifier = id;
UPDATE uploadsccodefile SET studentlegalfirstname = 'First' || id, studentlegallastname = 'Last' || id, studentlegalmiddlename = 'M' || id, statestudentidentifier = id;
UPDATE useraudittrailhistory SET  beforevalue = NULL, currentvalue = NULL;
update batchregistration set status='FAILED',modifieddate=now()  where status='IN-PROGRESS';
update batchupload set status='FAILED',modifieddate=now()  where status='IN-PROGRESS';
update ksdexmlaudit set processedcode='NOTPROCESSED',xml='' where processedcode<>'COMPLETED';
*/

--aart database
update batchjobschedule set allowedserver='ep1.fix.cete.us' where id in(select id from batchjobschedule where (id % 2) != 0);
update batchjobschedule set allowedserver='ep2.fix.cete.us' where id in(select id from batchjobschedule where (id % 2) = 0);
update batchjobschedule set scheduled=false where id not in (select id from batchjobschedule where scheduled=true and jobrefname in ('reportExtractScheduler','batchUploadRunScheduler','auditLogScheduler'));
update modulereport set activeflag=false, modifieddate =now(),modifieduser =12 where activeflag=true;
UPDATE student SET legalfirstname = 'First' || id, legalmiddlename = 'M' || id, legallastname = 'Last' || id, username = 'first.last' || id, statestudentidentifier = id;
UPDATE kelpastudentpreid SET studentfirstname = 'First' || studentid,studentmiddlename = 'M' || studentid, studentlastname = 'Last' || studentid;
UPDATE kelpastatestudentscore SET studentfirstname = 'First' || statestudentid,studentmiddleinitial = 'M' || statestudentid, studentlastname = 'Last' || statestudentid;
UPDATE category set categoryname='https://ep-wsdl-stage.cete.us/KidsMockService/services/KIDS_WebServiceSoap12' where id=34 and categorycode='KANSAS_WEB_SERVICE_URL_CODE';
update student set username = 'tde.user.lcs' where id = 742384;
update modulereport m  set statusid =486,modifieddate=now(),modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
from category c  where c.id=m.statusid  and  c.categorycode in ('IN_QUEUE','IN_PROGRESS');
update aartuser  set username = id || '_' || username  where internaluserindicator is false;


--aart database(stage-ON premises)-- Please verify with schedule time with EP
update batchjobschedule set allowedserver='epbp1.stageku.cete.us';

--aart database(AWS-QA only)
update batchjobschedule set allowedserver='eaqepap01.qa.east.cete.us';
UPDATE category set categoryname='https://ep-wsdl-qa.cete.us/KidsMockService/services/KIDS_WebServiceSoap12' where id=34 and categorycode='KANSAS_WEB_SERVICE_URL_CODE';

--aart database(AWS-stage only)
update batchjobschedule set allowedserver='easepbp01.stage.east.cete.us' where id in(select id from batchjobschedule where (id % 2) != 0);
update batchjobschedule set allowedserver='easepbp02.stage.east.cete.us' where id in(select id from batchjobschedule where (id % 2) = 0);

update batchjobschedule set  scheduled = false where scheduled = true;

update batchjobschedule
set  scheduled = true
where jobname in (
'Upload Scheduler',
 'Audit Log scheduler',
 'DLM Student Tracker Only Untracked',
 'Report Upload Scheduler',
 'Auto Scoring Assignment Scheduler',
 'State Data Extract Scheduler',
 'District Data Extract Scheduler',
 'School Extract Scheduler',
 'KELPA Auto Registration Job Scheduler') and scheduled = false;
 
 --duplicate by jobname(DLM Student Tracker Only Untracked)
 update batchjobschedule set  scheduled = false where scheduled = true and id=19 and jobname='DLM Student Tracker Only Untracked';

--aartdw database
UPDATE student SET legalfirstname = 'First' || id, legalmiddlename = 'M' || id, legallastname = 'Last' || id, username = 'first.last' || id, statestudentidentifier = id;
update dashboardreactivations tgt set studentname=s.legalfirstname || ' '|| s.legallastname,statestudentidentifier=s.statestudentidentifier from student s where s.id=tgt.studentid;
update dashboardreactivationsarchive tgt set studentname=s.legalfirstname || ' '|| s.legallastname,statestudentidentifier=s.statestudentidentifier from student s where s.id=tgt.studentid;
update dashboardtestingoutsidehours tgt set studentname=s.legalfirstname || ' '|| s.legallastname,statestudentidentifier=s.statestudentidentifier from student s where s.id=tgt.studentid;
update dashboardtestingoutsidehoursarchive tgt set studentname=s.legalfirstname || ' '|| s.legallastname,statestudentidentifier=s.statestudentidentifier from student s where s.id=tgt.studentid;
update aartuser  set username = id || '_' || username  where internaluserindicator is false;
--all
ALTER TABLE aartuser DROP CONSTRAINT uk_email;
update aartuser set email ='ats_kite_messages@ku.edu' where internaluserindicator is false;

--date field need to updated for this.
update userpasswordreset set createddate='2016-01-01' where createddate>'2016-01-01';

--global sys admin access for qa team after copy from prod to stage.

https://code.cete.us/svn/dlm/aart/trunk/aart-web-dependencies/data_support/db/rally_requests/EPQA/global_admin.sql

--AWS only (Need to change the server names)
https://source.cete.us/kite/aartdw/blob/master/db/other/aws_foreign_server_configure.sql

--ops need to remove report files
/reports/2017/
/reports/external/DLM/2017/
/reports/external/CPASS/2017/
/reports/2018/IPSR/

