\set VERBOSITY terse
create temp table dlm_student_testsession_today(studentid bigint,state text,testsession_cnt bigint,gradedbids text);							  
\COPY dlm_student_testsession_today FROM '/srv/extracts/helpdesk/dailyvalidation/data/dlm_student_testsession_today.csv' DELIMITER ',' CSV HEADER ; 
create temp table dlm_student_testsession_yesterday(studentid bigint,state text,testsession_cnt bigint,gradedbids text);							  
\COPY dlm_student_testsession_yesterday FROM '/srv/extracts/helpdesk/dailyvalidation/data/dlm_student_testsession_yesterday.csv' DELIMITER ',' CSV HEADER ;
DO
$BODY$
DECLARE
       row_count integer;
       row_value text;
       tmp_count record;
       start_date timestamp with time zone;
       end_date timestamp with time zone;
       run_time interval;
BEGIN
     row_count:=0;
     start_date:=clock_timestamp();     
     RAISE NOTICE 'Validation process started:%',start_date;
     RAISE NOTICE 'Validation schoolyear:%',2018;
     RAISE NOTICE 'files location:%',' S:\ATS_SFD\ValidationLists';
     create temp table tmp_orgyear (orgid bigint ,orgyear int);
     insert into tmp_orgyear
     select schoolid orgid,2018 orgyear from organizationtreedetail 
	 where coalesce(organization_school_year(stateid),extract(year from now()))=2018 
	 and stateid not in (select id from organization where  organizationtypeid=2 
	                     and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
	                                              ,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
	                                              ,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland','Service Desk QC State','QA QC State'));      
--Validation(1)
     select  count(*) into row_count from (select s.id,count(distinct sap.assessmentprogramid) cnt  
						 from student s 
						 inner join enrollment en on s.id=en.studentid 
						 inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
						 inner join organizationtreedetail ot on ot.schoolid=en.attendanceschoolid  
						 inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
						 inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
						 where ot.statedisplayidentifier='KS' and s.activeflag is true and ap.abbreviatedname in ('KAP','DLM') 
						   group by s.id
						   having count(distinct sap.assessmentprogramid)>1) sub;
     RAISE NOTICE 'Validation(1) Kansas students active in both KAP and DLM total count:%',row_count;						   
     FOR tmp_count IN (select  s.statestudentidentifier ssid,s.id id,count(distinct sap.assessmentprogramid) cnt  
		         from student s 
		         inner join enrollment en on s.id=en.studentid and en.activeflag is true
			 inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear 
		         inner join organizationtreedetail ot on ot.schoolid=en.attendanceschoolid
		         inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
		         inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
		         where ot.statedisplayidentifier='KS' and s.activeflag is true and ap.abbreviatedname in ('KAP','DLM')
			   group by s.id,s.statestudentidentifier
			   having count(distinct sap.assessmentprogramid)>1 order by s.id desc limit 5)
      		LOOP
			RAISE NOTICE 'Validation(1) Kansas students active in both KAP and DLM sample data out of % (issue studentSSID is):%',row_count,tmp_count.id;
		END LOOP;	   
 --Validation(2)
     select  count(*) into row_count from (select distinct en.studentid from enrollment en
                            inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
							inner join studentstests st on en.id = st.enrollmentid
							inner join student s on s.id=st.studentid and s.activeflag is true
							inner join test t on st.testid = t.id
							inner join gradecourse tgc on tgc.id=t.gradecourseid and tgc.abbreviatedname<>'OTH'
							inner join gradecourse egc on egc.id=en.currentgradelevel
							left outer join testcollectionstests tct ON t.id = tct.testid
						        left outer join testcollection tc ON tc.id = tct.testcollectionid
						        left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
						        left outer join assessment a ON atc.assessmentid = a.id
						        left outer join testingprogram tp ON a.testingprogramid = tp.id
							left outer join (select distinct tc.id 
									     from  testcollection tc 
									    inner join contentarea ca ON ca.id = tc.contentareaid
									    inner join assessmentstestcollections atc ON tc.id = atc.testcollectionid
									    inner join assessment a ON atc.assessmentid = a.id
									    inner join testingprogram tp ON a.testingprogramid = tp.id
									    inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
									        where ap.abbreviatedname ilike '%CPASS%') cpass on st.testcollectionid=cpass.id
							where en.activeflag is true and st.activeflag is true and t.activeflag = true and t.gradecourseid is not null and cpass.id is null
				and egc.abbreviatedname <> tgc.abbreviatedname and 'Interim'<>coalesce(tp.programname,'')
				group by en.studentid) sub;
     RAISE NOTICE 'Validation(2) Grade in enrollment table does not match grade on test table total count:%',row_count;						   
     FOR tmp_count IN (select s.statestudentidentifier ssid,s.id id from enrollment en
                                                        inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
							inner join studentstests st on en.id = st.enrollmentid 
							inner join student s on s.id=st.studentid and s.activeflag is true
							inner join test t on st.testid = t.id
							inner join gradecourse tgc on tgc.id=t.gradecourseid and tgc.abbreviatedname<>'OTH'
							inner join gradecourse egc on egc.id=en.currentgradelevel
							left outer join testcollectionstests tct ON t.id = tct.testid
						        left outer join testcollection tc ON tc.id = tct.testcollectionid
						        left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
						        left outer join assessment a ON atc.assessmentid = a.id
						        left outer join testingprogram tp ON a.testingprogramid = tp.id
							left outer join (select distinct tc.id 
									     from  testcollection tc 
									    inner join contentarea ca ON ca.id = tc.contentareaid
									    inner join assessmentstestcollections atc ON tc.id = atc.testcollectionid
									    inner join assessment a ON atc.assessmentid = a.id
									    inner join testingprogram tp ON a.testingprogramid = tp.id
									    inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
									        where ap.abbreviatedname ilike '%CPASS%') cpass on st.testcollectionid=cpass.id
							where en.activeflag is true and st.activeflag is true and t.activeflag = true and t.gradecourseid is not null and cpass.id is null
				and egc.abbreviatedname <> tgc.abbreviatedname and 'Interim'<>coalesce(tp.programname,'')
				group by s.id,s.statestudentidentifier order by s.id desc limit 5)
      		LOOP
			RAISE NOTICE 'Validation(2) Grade in enrollment table does not match grade on student test table sample data out of % (issue studentID is):%',row_count,tmp_count.id;
		END LOOP; 
 --Validation(3)
     select  count(distinct studentid) cnt into row_count from (select studentid,statesubjectareaid,count(distinct e.id)
						 from enrollment e 
						 inner join student s on s.id=e.studentid and s.activeflag is true
						 inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
						 inner join enrollmentsrosters er on e.id=er.enrollmentid
						 inner join roster r on r.id=er.rosterid
					   where e.activeflag is true and er.activeflag is true and r.activeflag is true
					   group by  studentid,statesubjectareaid
					   having count(distinct e.id)>1) sub;
     RAISE NOTICE 'Validation(3) Student actively enrolled in two schools for same subject total count:%',row_count;						   
     FOR tmp_count IN (select s.id,s.statestudentidentifier ssid,statesubjectareaid,count(distinct e.id)
						 from enrollment e
						 inner join student s on s.id=e.studentid and s.activeflag is true
						 inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
						 inner join enrollmentsrosters er on e.id=er.enrollmentid
						 inner join roster r on r.id=er.rosterid
					   where e.activeflag is true and er.activeflag is true and r.activeflag is true
					   group by  s.id,s.statestudentidentifier,statesubjectareaid
					   having count(distinct e.id)>1 order by s.id desc limit 5)
      		LOOP
			RAISE NOTICE 'Validation(3) Student actively enrolled in two schools for same subject sample data out of % (issue studentID,subject):%,%',row_count,tmp_count.id,tmp_count.statesubjectareaid;
		END LOOP;
 --Validation(4)
 select  count(distinct studentid) cnt into row_count from (select st.studentid,ap.abbreviatedname assessment,c.id,count(distinct gc.abbreviatedname) cnt
                                                                         from studentstests st 
                                                                          inner join enrollment e on e.id = st.enrollmentid
                                                                          inner join student s on s.id=e.studentid and s.activeflag is true
						                          inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
									  inner join test t         on t.id=st.testid and t.activeflag is true
									  left outer join testcollectionstests tct ON t.id = tct.testid
									  left outer join testcollection tc ON tc.id = tct.testcollectionid
									  left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
									  left outer join assessment a ON atc.assessmentid = a.id
									  left outer join testingprogram tp ON a.testingprogramid = tp.id
									  inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
									  inner join gradecourse gc on t.gradecourseid=gc.id and gc.activeflag is true
									  inner join contentarea c  on t.contentareaid=c.id and c.activeflag is true
										where st.activeflag is true and 'Interim'<>coalesce(tp.programname,'')
										and ap.abbreviatedname <> 'MSS' and ap.abbreviatedname<>'CPASS'
									  group by st.studentid,c.id,ap.abbreviatedname 
									  having count(distinct gc.abbreviatedname)>1) dups;
     RAISE NOTICE 'Validation(4) Student with tests for two different grades for same subject total count:%',row_count;						   
     if (row_count>0)       
      then 
	FOR tmp_count IN (select assessment,count(distinct studentid) cnt from (select st.studentid,ap.abbreviatedname assessment,c.id,count(distinct gc.abbreviatedname) cnt
                                                                         from studentstests st 
                                                                          inner join enrollment e on e.id = st.enrollmentid
                                                                          inner join student s on s.id=e.studentid and s.activeflag is true
						                          inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
									  inner join test t         on t.id=st.testid and t.activeflag is true
									  left outer join testcollectionstests tct ON t.id = tct.testid
									  left outer join testcollection tc ON tc.id = tct.testcollectionid
									  left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
									  left outer join assessment a ON atc.assessmentid = a.id
									  left outer join testingprogram tp ON a.testingprogramid = tp.id
									  inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
									  inner join gradecourse gc on t.gradecourseid=gc.id and gc.activeflag is true
									  inner join contentarea c  on t.contentareaid=c.id and c.activeflag is true
										where st.activeflag is true and 'Interim'<>coalesce(tp.programname,'')
										and ap.abbreviatedname <> 'MSS' and ap.abbreviatedname<>'CPASS'
									  group by st.studentid,c.id,ap.abbreviatedname
									  having count(distinct gc.abbreviatedname)>1)dups group by assessment)   

			LOOP
			RAISE NOTICE 'Validation(4) Student with tests for two different grades for same subject assessmentprogram:%,count:%',tmp_count.assessment,tmp_count.cnt;
		END LOOP;			   	            
		END IF;					
 --Validation(5)
     select  cnt into row_count from (select count(distinct s.id) cnt from student s
                                                inner join enrollment en on s.id=en.studentid and en.activeflag is true
			                        inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear 
						LEFT OUTER JOIN (select distinct studentid from studentassessmentprogram sap 
									 where sap.activeflag is true) sact on sact.studentid=s.id
						where s.activeflag is true and sact.studentid is null) sub;
     RAISE NOTICE 'Validation(5) Active student with no assessment program affiliation total count:%',row_count;						   
     FOR tmp_count IN (select distinct s.id,s.statestudentidentifier ssid from student s
                                                inner join enrollment en on s.id=en.studentid and en.activeflag is true
			                        inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear     
						LEFT OUTER JOIN (select distinct studentid from studentassessmentprogram sap 
									 where sap.activeflag is true) sact on sact.studentid=s.id
						where s.activeflag is true and sact.studentid is null order by s.id desc limit 5)
      		LOOP
			RAISE NOTICE 'Validation(5) Active student with no assessment program affiliation sample data out of % (issue studentID is):%',row_count,tmp_count.id;
		END LOOP;
/*				
 --Validation(6)
     select  cnt into row_count from (select count(distinct a.id) cnt
						from aartuser a
						LEFT OUTER JOIN (select distinct a.id from aartuser a
									  INNER JOIN userassessmentprogram uo on a.id=uo.aartuserid
									  WHERE a.activeflag is true and uo.activeflag is true) aact on aact.id=a.id
						where a.activeflag is true and aact.id is null) sub;
     RAISE NOTICE 'Validation(6) Active users with no assessment program affiliation total count:%',row_count;						   
     FOR tmp_count IN (select distinct a.id 
						from aartuser a
						LEFT OUTER JOIN (select distinct a.id from aartuser a
									  INNER JOIN userassessmentprogram uo on a.id=uo.aartuserid
									  WHERE a.activeflag is true and uo.activeflag is true) aact on aact.id=a.id
						where a.activeflag is true and aact.id is null order by a.id desc limit 5)
      		LOOP
			RAISE NOTICE 'Validation(6) Active users with no assessment program affiliation sample data out of % (issue userid is):%',row_count,tmp_count.id;
		END LOOP;		       
 --Validation(7)
     select  cnt into row_count from (select count(distinct s.id) cnt from student s
     		                                inner join organization o on o.id=s.stateid 
                                                inner join tmp_orgyear tmp on o.id=tmp.orgid and o.activeflag is true    
						LEFT OUTER JOIN (select distinct e.studentid from  enrollment e   
									 INNER JOIN organization o on o.id=e.attendanceschoolid
									 where e.activeflag is true and o.activeflag is true) sact on sact.studentid=s.id
						where s.activeflag is true and s.stateid is not null and sact.studentid is null) sub;
     RAISE NOTICE 'Validation(7) Active student with no organization affiliation total count:%',row_count;						   
     FOR tmp_count IN (select distinct s.statestudentidentifier ssid,s.id id from student s
                                                inner join organization o on o.id=s.stateid 
                                                inner join tmp_orgyear tmp on o.id=tmp.orgid and o.activeflag is true     
						LEFT OUTER JOIN (select distinct e.studentid from  enrollment e 
						                         inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear  
									 INNER JOIN organization o on o.id=e.attendanceschoolid
									 where e.activeflag is true and o.activeflag is true) sact on sact.studentid=s.id
						where s.activeflag is true and s.stateid is not null and sact.studentid is null order by s.id desc limit 5)
      		LOOP
			RAISE NOTICE 'Validation(7) Active student with no organization affiliation sample data out of % (issue studentID is):%',row_count,tmp_count.id;
		END LOOP;
 --Validation(8)
     select  cnt into row_count from (select count(distinct a.id) cnt
						from aartuser a
						LEFT OUTER JOIN (select distinct a.id from aartuser a
									  INNER JOIN usersorganizations uo on a.id=uo.aartuserid
									  INNER JOIN organization o on o.id=uo.organizationid
									  WHERE a.activeflag is true and o.activeflag is true and uo.activeflag is true) aact on aact.id=a.id
						where a.activeflag is true and aact.id is null) sub;
     RAISE NOTICE 'Validation(8) Active users with no organization affiliation total count:%',row_count;						   
     FOR tmp_count IN (select distinct a.id 
						from aartuser a
						LEFT OUTER JOIN (select distinct a.id from aartuser a
									  INNER JOIN usersorganizations uo on a.id=uo.aartuserid
									  INNER JOIN organization o on o.id=uo.organizationid
									  WHERE a.activeflag is true and o.activeflag is true and uo.activeflag is true) aact on aact.id=a.id
						where a.activeflag is true and aact.id is null order by a.id desc limit 5)
      		LOOP
			RAISE NOTICE 'Validation(8) Active users with no organization affiliation total sample data out of % (issue userid is):%',row_count,tmp_count.id;
		END LOOP; 
*/		
 --Validation(9)
     select  count(distinct studentid) cnt into row_count from (SELECT st.studentid,ca.id,ap.id,stg.name,count(*)
						       FROM studentstests st
						       inner join testsession ts on st.testsessionid =ts.id
						       inner join operationaltestwindow opw on opw.id=ts.operationaltestwindowid
						       inner join assessmentprogram ap on ap.id=opw.assessmentprogramid
						       inner join enrollment e on e.id = st.enrollmentid
						       inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true						       
						       inner join student s on s.id=e.studentid and s.activeflag is true
						       INNER JOIN test t         ON t.id=st.testid
						       INNER JOIN contentarea ca ON t.contentareaid =ca.id
						       INNER JOIN gradecourse gc ON gc.id=t.gradecourseid
						       INNER JOIN stage stg      ON ts.stageid =stg.id
						       where st.activeflag is true and ts.activeflag is true AND ap.abbreviatedname<>'CPASS'
						group by st.studentid,ca.id,ap.id,stg.name
						having count(*)>1) sub;
     RAISE NOTICE 'Validation(9) Student with test active status = true on two tests for same stage/subject total count:%',row_count;
     if (row_count>0)       
      then 
	FOR tmp_count IN (select assessment,count(distinct studentid) cnt from (SELECT st.studentid,ap.abbreviatedname assessment,ca.id,stg.name,count(*) cnt
						       FROM studentstests st
						       inner join testsession ts on st.testsessionid =ts.id
						       inner join operationaltestwindow opw on opw.id=ts.operationaltestwindowid
						       inner join assessmentprogram ap on ap.id=opw.assessmentprogramid
						       inner join enrollment e on e.id = st.enrollmentid
						       inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true						       
						       inner join student s on s.id=e.studentid and s.activeflag is true
						       INNER JOIN test t         ON t.id=st.testid
						       INNER JOIN contentarea ca ON t.contentareaid =ca.id
						       INNER JOIN gradecourse gc ON gc.id=t.gradecourseid
						       INNER JOIN stage stg      ON ts.stageid =stg.id
						       where st.activeflag is true and ts.activeflag is true AND ap.abbreviatedname<>'CPASS'
						group by st.studentid,ap.abbreviatedname,ca.id,stg.name
						having count(*)>1)dups group by assessment)   

			LOOP
			RAISE NOTICE 'Validation(9) Student with test active status = true on two tests for same stage/subject assessmentprogram:%,count:%',tmp_count.assessment,tmp_count.cnt;
		END LOOP;			   	            
		END IF;						   
--Validation(10)
      select count(*) into row_count from pg_catalog.pg_tables where tablename not in ('tmp_orgyear','dlm_student_testsession_today','dlm_student_testsession_yesterday')  and tableowner not in ('postgres','aart','rdsadmin');	
      RAISE NOTICE 'Validation(10) temp tables created by manually count:%',row_count;      
--Validation(11)
      select count(distinct s.id) into row_count from enrollment e
      inner join student s on s.id=e.studentid and s.activeflag is true
      inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
      inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
      where currentgradelevel is null ;
      RAISE NOTICE 'Validation(11) null grade for active enrollments total count:%',row_count;
      FOR tmp_count IN (select s.statestudentidentifier ssid,s.id id, e.id enrollmentid from enrollment e
                              inner join student s on s.id=e.studentid and s.activeflag is true
                              inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
                              inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
                              where currentgradelevel is null order by s.id desc limit 5) 
      		LOOP
			RAISE NOTICE 'Validation(11) null grade for active enrollments sample data out of % (issue studentID is):%',row_count,tmp_count.id;
		END LOOP;
--Validation(12)
     select  count(*) cnt into tmp_count from student s
                           			       inner join enrollment e on e.studentid = s.id  and s.activeflag is true
                           			       inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
						       inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
			   where primarydisabilitycode not in (select categorycode
								from category c 
								inner join categorytype ct on  c.categorytypeid=ct.id
								where typecode='PRIMARY_DISABILITY_CODES' union select '' categorycode)
			     and primarydisabilitycode  is not null;
      RAISE NOTICE 'Validation(12) lower case primarydisabilitycode or Invalid count:%',tmp_count.cnt;		     
      FOR tmp_count IN (select  primarydisabilitycode,count(*) cnt from student s
                           			       inner join enrollment e on e.studentid = s.id  and s.activeflag is true
                           			       inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
						       inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
			   where primarydisabilitycode not in (select categorycode
								from category c 
								inner join categorytype ct on  c.categorytypeid=ct.id
								where typecode='PRIMARY_DISABILITY_CODES' union select '' categorycode)
			     and primarydisabilitycode  is not null
			   group by primarydisabilitycode order by 1)
		LOOP
			RAISE NOTICE 'Validation(12) lower case primarydisabilitycode or Invalid PD:%,sample:%',tmp_count.primarydisabilitycode,tmp_count.cnt;
		END LOOP;
--Validation(13)
     select  count(distinct s.id) into row_count from studentstests st 
					inner join enrollment e on e.id=st.enrollmentid and e.activeflag is true and st.activeflag is true
					inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
					inner join student s on s.id=e.studentid and s.activeflag is true 
					inner join testsession ts on ts.id = st.testsessionid  and ts.activeflag is true and ts.schoolyear=2018
					inner join roster r on r.id = ts.rosterid and r.activeflag is true 
					inner join contentarea car on car.id= r.statesubjectareaid
					inner JOIN test t ON st.testid = t.id
					inner join testcollectionstests tct ON t.id = tct.testid
					inner join testcollection tc ON tc.id = tct.testcollectionid
					inner JOIN contentarea ca ON ca.id = tc.contentareaid and ca.abbreviatedname<>'OTH'
					left outer join testcollectionstests itct ON t.id = itct.testid
					left outer join testcollection itc ON itc.id = itct.testcollectionid
					left outer join assessmentstestcollections atc ON itc.id = atc.testcollectionid
					left outer join assessment a ON atc.assessmentid = a.id
					left outer join testingprogram tp ON a.testingprogramid = tp.id
					where e.currentschoolyear =2018 and t.externalid not in (2961,2981,2982)
					and coalesce(r.statesubjectareaid,ca.id,0)<>coalesce(ca.id,r.statesubjectareaid,0) and 'Interim'<>coalesce(tp.programname,'');
      RAISE NOTICE 'Validation(13) Mismatch on roster subject and student test subject total count:%',row_count;    
 
/*
--Validation(14)
     select  count(distinct s.id)  into row_count from student s 
					inner join enrollment e on e.studentid=s.id and e.activeflag is true and s.activeflag is true
					left outer join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true 
					inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
					inner join studentassessmentprogram sa on s.id=sa.studentid and sa.activeflag is true and assessmentprogramid=3
					inner join survey sv on s.id=sv.studentid and sv.activeflag is true 
					inner join category c on c.id=sv.status and c.activeflag  is true and c.categorycode='COMPLETE'
					left outer join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true
					left outer join roster r on er.rosterid=r.id and r.activeflag is true
					left outer join studentstests st on st.enrollmentid=e.id and st.activeflag is true
					left outer join contentarea sub on sub.id=r.statesubjectareaid and sub.activeflag is true
					 where st.id is null;
      RAISE NOTICE 'Validation(14) DLM students who have FCS completed but have not gotten a test total count:%',row_count;		     
      FOR tmp_count IN (select distinct s.id as studentid,e.id as enrollid,sv.id surveyid,sv.modifieddate survey_last_modified,c.categorycode status,r.coursesectionname,gc.name grade, sub.abbreviatedname subject
			from student s 
					inner join enrollment e on e.studentid=s.id and e.activeflag is true and s.activeflag is true
					left outer join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true 
					inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
					inner join studentassessmentprogram sa on s.id=sa.studentid and sa.activeflag is true and assessmentprogramid=3
					inner join survey sv on s.id=sv.studentid and sv.activeflag is true 
					inner join category c on c.id=sv.status and c.activeflag  is true and c.categorycode='COMPLETE'
					left outer join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true
					left outer join roster r on er.rosterid=r.id and r.activeflag is true
					left outer join studentstests st on st.enrollmentid=e.id and st.activeflag is true
					left outer join contentarea sub on sub.id=r.statesubjectareaid and sub.activeflag is true
					 where st.id is null limit 5)
		LOOP
			RAISE NOTICE 'Validation(14) DLM students who have FCS completed but have not gotten a test sample data out of % (issue studentID,enrollid,categorycode,subject):%,%,%,%',row_count,tmp_count.studentid,tmp_count.status,tmp_count.surveyid,tmp_count.subject;
		END LOOP;
*/
/*
 --dailyvalidation(15):1st Grade Writing test, and the rubric displaying in Educator Portal for Question #15 score should be <=2
select count(distinct scs.studentid) into row_count			
			from scoringassignmentstudent scs 
			inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
			inner join testsession ts on ts.id = sc.testsessionid and ts.activeflag is true
			inner join tmp_orgyear tmp on ts.attendanceschoolid=tmp.orgid and ts.schoolyear=tmp.orgyear 
			inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
			inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sc.id and ccq.activeflag is true
			inner join ccqscoreitem ccqi on ccqi.ccqscoreid=ccq.id and ccqi.activeflag is true
			left outer join rubriccategory rc on rc.id=ccqi.rubriccategoryid
			where ccqi.taskvariantid=439519 and ccqi.score>2;	
 RAISE NOTICE 'Validation(15)KELPA 1st Grade Writing test, and the rubric displaying in EP for Question #15 score>2 students count:%',row_count;
*/ 
 --dailyvalidation(16):Find Non-ASCII characters in SSID
			select count(distinct s.id) into row_count		   
                                    from student s
                                    inner join enrollment en on s.id=en.studentid and en.activeflag is true
				    inner join organizationtreedetail o on o.schoolid = en.attendanceschoolid
			            inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear
				    where s.statestudentidentifier  ~* '[^a-z" "A-Z"-"0-9"_"/\!:''-DUPLICATE''''z_'']' and s.activeflag is true;	
RAISE NOTICE 'Validation(16) Number of students has Non-ASCII characters in SSID:%',row_count;		
 --dailyvalidation(17):DLM students-duplicate roster count
			select count(distinct id) into row_count		   
                                    from (select contentareaid,s.id,count(distinct ts.rosterid) 
						from studentstests st 
						inner join student s on s.id=st.studentid
						inner join enrollment e on e.studentid=s.id and e.id = st.enrollmentid  and s.activeflag is true
						inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
						inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear --and e.activeflag is true
						inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true 
					        inner JOIN testcollectionstests tct ON st.testid = tct.testid
					        inner JOIN testcollection tc ON tc.id = tct.testcollectionid and contentareaid in (441,440,3)
					        inner JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
					        inner JOIN assessment a ON atc.assessmentid = a.id
					        inner JOIN testingprogram tp ON a.testingprogramid = tp.id
					        inner JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id and ap.id=3
						where st.activeflag is true and st.status=86 and ts.activeflag is true 
						group by contentareaid,s.id
						having count(distinct ts.rosterid)>1) dups;	
RAISE NOTICE 'Validation(17) Number of DLM students has duplicate rosters :%',row_count;
 --dailyvalidation(18):DLM students-missing FCS bands
				select count(distinct s.id) into row_count
					from studentstests st 
					inner join student s on s.id=st.studentid and st.activeflag is true and st.status=86 
					inner join enrollment e on e.studentid=s.id and e.id = st.enrollmentid --and e.activeflag is true --and s.activeflag is true
					inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear --and e.activeflag is true
					left outer join firstcontactsurveysettings fcs on fcs.organizationid=o.stateid and fcs.schoolyear=tmp.orgyear and fcs.activeflag is true
					inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true 
					inner JOIN testcollectionstests tct ON st.testid = tct.testid
					inner JOIN testcollection tc ON tc.id = tct.testcollectionid and contentareaid in (441,440,3)
					inner JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
					inner JOIN assessment a ON atc.assessmentid = a.id
					inner JOIN testingprogram tp ON a.testingprogramid = tp.id
					inner JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id and ap.id=3
					where ((commbandid is null or finalelabandid is null or finalmathbandid is null) and contentareaid in (440,3))
					     or (scienceflag is true and s.finalscibandid is null and contentareaid=441);	
RAISE NOTICE 'Validation(18) Number of DLM students has missing FCS bands :%',row_count;
 --dailyvalidation(19):DLM inprogress tests from a long time
				select COUNT(distinct st.studentid) into row_count
					FROM studentstests st
					inner join student s on s.id=st.studentid and s.activeflag is true 
					inner join enrollment e ON st.enrollmentid = e.id
					inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
					inner join testcollectionstests tct ON st.testid = tct.testid
					inner join testcollection tc ON tc.id = tct.testcollectionid
					inner join contentarea ca ON ca.id = tc.contentareaid
					inner join assessmentstestcollections atc ON tc.id = atc.testcollectionid
					inner join assessment a ON atc.assessmentid = a.id
					inner join testingprogram tp ON a.testingprogramid = tp.id
					inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
					inner join testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id
					WHERE ap.id=3 AND st.activeflag='t' and st.status=85
					and (st.startdatetime ) AT TIME ZONE 'US/Central' < (((current_timestamp at time zone 'US/Central')::date)-1);	
RAISE NOTICE 'Validation(19) Number of DLM inprogress tests from a long time:%',row_count;
 --dailyvalidation(20):DLM essentialelementlinkage is NA for assigned items
			      with std_dlm as
					(select st.id,st.studentid
					FROM studentstests st
					inner join testsession ts ON st.testsessionid = ts.id
					inner join enrollment e ON st.enrollmentid = e.id
					inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
					inner join testcollectionstests tct ON st.testid = tct.testid
					inner join testcollection tc ON tc.id = tct.testcollectionid
					inner join assessmentstestcollections atc ON tc.id = atc.testcollectionid
					inner join assessment a ON atc.assessmentid = a.id
					inner join testingprogram tp ON a.testingprogramid = tp.id
					inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
					WHERE ap.id=3 AND st.activeflag='t' and tc.contentareaid in (441,440,3))
					select count(distinct tmp.studentid) into row_count from std_dlm tmp 
						inner join  studentstestsections sts ON sts.studentstestid = tmp.id
						inner JOIN testsection tsec ON sts.testsectionid = tsec.id
						inner join testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
						left outer join taskvariantessentialelementlinkage tveel ON (tveel.taskvariantid = tstv.taskvariantid)
						where tveel.essentialelementlinkageid is null;	
RAISE NOTICE 'Validation(20) Number of DLM essentialelementlinkage is NA for assigned items:%',row_count;
 --dailyvalidation(21):Tests begun after 5:00 pm and excluded Sat,Sun, and Virtual
with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid,
case when c.categorycode='US/Eastern'  then st.startdatetime AT TIME ZONE 'US/Eastern'  
      when c.categorycode='US/Alaska'   then st.startdatetime AT TIME ZONE 'US/Alaska' 
      when c.categorycode='US/Mountain' then st.startdatetime AT TIME ZONE 'US/Mountain'
      when c.categorycode='US/Pacific'  then st.startdatetime AT TIME ZONE 'US/Pacific'  
      when c.categorycode='US/Hawaii'   then st.startdatetime AT TIME ZONE 'US/Hawaii'
      else st.startdatetime AT TIME ZONE 'US/Central'  end startdatetime_cst
 from studentstests st
 inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join organization ort on ort.id=e.attendanceschoolid
inner join category c on c.id=ort.timezoneid  
where  st.startdatetime >=now()-interval '24 hour'
and st.startdatetime is not null and st.activeflag is true) 
                          select count(distinct st.studentid) into row_count
		                      from tmp_std st 
					inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
					inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
					inner join testsession ts on st.testsessionid=ts.id 
					inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
					inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
					where ts.activeflag is true  
					and extract(dow from startdatetime_cst) not in (0,6)
					and (extract(HOUR from startdatetime_cst) >=17 
					     or extract(HOUR from startdatetime_cst)<6)
					and not exists (select 1 from organizationtreedetail tgt where tgt.schoolname ilike '%virtu%' and ort.schoolid=tgt.schoolid);	
RAISE NOTICE 'Validation(21) Tests begun after 5:00 pm and excluded Sat,Sun, and Virtual:%',row_count;
 --dailyvalidation(22):Tests ended after 5:00 pm and excluded Sat,Sun, and Virtual
with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid,
case when c.categorycode='US/Eastern'   then st.enddatetime AT TIME ZONE 'US/Eastern'  
      when c.categorycode='US/Alaska'   then st.enddatetime AT TIME ZONE 'US/Alaska' 
      when c.categorycode='US/Mountain' then st.enddatetime AT TIME ZONE 'US/Mountain'
      when c.categorycode='US/Pacific'  then st.enddatetime AT TIME ZONE 'US/Pacific'  
      when c.categorycode='US/Hawaii'   then st.enddatetime AT TIME ZONE 'US/Hawaii'
      else st.enddatetime AT TIME ZONE 'US/Central'  end enddatetime_cst
 from studentstests st
 inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join organization ort on ort.id=e.attendanceschoolid
inner join category c on c.id=ort.timezoneid  
where  st.enddatetime >=now()-interval '24 hour'
and st.enddatetime is not null and st.activeflag is true) 
                          select count(distinct st.studentid) into row_count
		                      from tmp_std st 
					inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
					inner join student s on s.id=e.studentid and s.activeflag is true
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
					inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
					inner join testsession ts on st.testsessionid=ts.id 
					inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
					inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
					where ts.activeflag is true  
					and extract(dow from enddatetime_cst) not in (0,6)
					and (extract(HOUR from enddatetime_cst) >=17 
					     or extract(HOUR from enddatetime_cst)<6)
					and not exists (select 1 from organizationtreedetail tgt where tgt.schoolname ilike '%virtu%' and ort.schoolid=tgt.schoolid);	
RAISE NOTICE 'Validation(22) Tests ended after 5:00 pm and excluded Sat,Sun, and Virtual:%',row_count;
 --dailyvalidation(23):Tests started on sat and sun and excluded virtual
with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid,(st.startdatetime ) AT TIME ZONE 'US/Central' startdatetime_cst  from studentstests st 
where (startdatetime ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour'
and st.startdatetime is not null and st.activeflag is true) 
                          select count(distinct st.studentid) into row_count
		                      from tmp_std st 
					inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
					inner join student s on s.id=e.studentid and s.activeflag is true
					inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
					inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
					inner join testsession ts on st.testsessionid=ts.id 
					inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
					inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
					where ts.activeflag is true  
					and extract(dow from startdatetime_cst) in (0,6)
					and not exists (select 1 from organizationtreedetail tgt where tgt.schoolname ilike '%virtu%' and ort.schoolid=tgt.schoolid);	     	
RAISE NOTICE 'Validation(23) Tests started on Sat and Sun and excluded Virtual:%',row_count;
 --dailyvalidation(24):Reactivated tests by users
 with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid from studentstests st 
       join studentstestshistory sth on sth.studentstestsid = st.id
                     where st.activeflag is true 
				and (sth.action='REACTIVATION')
				and (sth.acteddate ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour') 
                          select count(distinct st.studentid) into row_count
				     from tmp_std st
				inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
				inner join student s on s.id=e.studentid and s.activeflag is true
				inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
				inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
				inner join testsession ts on st.testsessionid=ts.id 
				inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true				 
				where ts.activeflag is true;
RAISE NOTICE 'Validation(24) Tests Reactivated by users:%',row_count;
 --dailyvalidation(25):CPASS kids outside of kansas 
select  count(distinct s.id) into row_count
		         from student s 
		         inner join enrollment en on s.id=en.studentid and en.activeflag is true
			 inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear 
		         inner join organizationtreedetail ot on ot.schoolid=en.attendanceschoolid
		         inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
		         inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
		         where ot.statedisplayidentifier<>'KS' and s.activeflag is true and ap.abbreviatedname ='CPASS'
		         and (sap.modifieddate ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour';
RAISE NOTICE 'Validation(25) CPASS kids outside of Kansas :%',row_count;
 --dailyvalidation(26):Reactivated tests by system
 with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid from studentstests st 
       join studentstestshistory sth on sth.studentstestsid = st.id
                     where st.activeflag is true 
				and (sth.action='SYSTEM_REACTIVATION')
				and (sth.acteddate ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour') 
                          select count(distinct st.studentid) into row_count
				     from tmp_std st
				inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
				inner join student s on s.id=e.studentid and s.activeflag is true
				inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
				inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
				inner join testsession ts on st.testsessionid=ts.id 
				inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true				 
				where ts.activeflag is true;
RAISE NOTICE 'Validation(26) Reactivated by system:%',row_count;
 --dailyvalidation(27):Interim Predictive Tests Complete with Unanswered Items
select count(distinct studentid) into row_count from
(select st.studentid FROM studentstests st
inner join testsession ts on ts.id =st.testsessionid
inner join test t on t.id=st.testid
inner JOIN testspecstatementofpurpose tstop on t.testspecificationid=tstop.testspecificationid
inner JOIN category ct on ct.id=tstop.statementofpurposeid 
inner JOIN enrollment e ON st.enrollmentid = e.id
inner join student s on s.id=e.studentid
inner JOIN gradecourse gc on gc.id = e.currentgradelevel
inner JOIN tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner JOIN organizationtreedetail ort on ort.schoolid=tmp.orgid
inner JOIN testcollectionstests tct ON st.testid = tct.testid
inner JOIN testcollection tc ON tc.id = tct.testcollectionid
inner JOIN contentarea ca on ca.id =tc.contentareaid
inner JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
inner JOIN assessment a ON atc.assessmentid = a.id
inner JOIN testingprogram tp ON a.testingprogramid = tp.id
inner JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
inner JOIN studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
inner join taskvariant tv on tv.id=tstv.taskvariantid
left outer JOIN studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tv.id 
WHERE  tp.programname ='Interim' and st.status =86 and st.startdatetime::date > '2017-10-27'
and ap.id=12 and ct.categorycode='PRDCTN' -- and (sres1.response is null and sres1.foilid is null)
group by t.id,ts.id,st.id,st.studentid,gc.abbreviatedname,ca.abbreviatedname
,ort.schoolname,ort.districtid,schoolid,districtname,s.statestudentidentifier
having count(sres1.taskvariantid)<count(tv.id))dups;
RAISE NOTICE 'Validation(27) Interim Predictive Tests Complete with Unanswered Items:%',row_count;
--dailyvalidation(28):For DLM, any students who have two active tests assigned for same subject/test number (for dailyvalidation.sql)
select count(distinct studentid) into row_count from (select ca.abbreviatedname,stud.id studentid,e.id,sts.currenttestnumber, count(*)
                             from student stud
                              join studenttracker st on st.studentid = stud.id
                             join studenttrackerband stb on stb.studenttrackerid = st.id
                             join testsession ts on ts.id = stb.testsessionid
                             join studentstests sts on sts.testsessionid = ts.id and sts.studentid = stud.id
                             join test t on t.id = sts.testid
                             join enrollment e on e.id=sts.enrollmentid 
			     join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
                             join studentassessmentprogram sap on sap.studentid=e.studentid 
                             join assessmentprogram ap on ap.id=sap.assessmentprogramid
                             join contentarea ca ON ca.id = st.contentareaid							 
                         where ap.abbreviatedname='DLM'  
                         and st.activeflag is true and ts.activeflag is true and stb.activeflag is true and stud.activeflag is true
                         and sts.activeflag is true 
                         group by  ca.abbreviatedname,stud.id,e.id,sts.currenttestnumber
                         having count(*)>1 ) dups;
 RAISE NOTICE 'Validation(28) For DLM, any students who have two active tests assigned for same subject/test number total count:%',row_count;
--dailyvalidation(29):The user who has duplicated roles  in organizaiton
select count(distinct aartid) into row_count from( select  a.id aartid,ap.id assessmentprogramid,g.id groupid,o.id orgid,count(*) FROM aartuser a
       JOIN usersorganizations uo ON a.id = uo.aartuserid
       JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
       JOIN organization o ON o.id = uo.organizationid
       JOIN groups g ON g.id = ug.groupid
       JOIN userassessmentprogram ua ON ua.userorganizationsgroupsid = ug.id
       join assessmentprogram ap on ap.id=ua.assessmentprogramid
        where a.activeflag is true and uo.activeflag is true 
       and ug.activeflag is true and ua.activeflag is true
      group by a.id,ap.id,g.id,o.id
   having count(*)>1) dups;
RAISE NOTICE 'Validation(29)the total number of the user who has duplicated roles in organizaton is:%',row_count;
--dailyvalidation(30):ETL Publishing issue duplicate testcollections 
select count(distinct testcollectionid) into row_count from(SELECT tc.id testcollectionid,count(tp.id) cnt FROM testpanel tp 
JOIN testpanelstage tps ON tp.id = tps.testpanelid 
JOIN testpanelstagetestcollection tpstc ON tpstc.testpanelstageid = tps.id 
JOIN testcollection tc ON tc.externalid = tpstc.externaltestcollectionid 
WHERE tp.activeflag is true and tps.activeflag is true and tpstc.activeflag is true 
group by tc.id having count(tp.id)>1) dups;
RAISE NOTICE 'Validation(30)ETL Publishing issue duplicate testcollections:%',row_count;
--dailyvalidation(31):DLM: Student is in Delaware, rostered where subject is Science, Course is BIO, and enrolled grade is anything other than (10,11,12).
select count(distinct stud.id) into row_count
from student stud
join enrollment e on e.studentid=stud.id
join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
join organizationtreedetail org on org.schoolid=tmp.orgid
join enrollmentsrosters enr on enr.enrollmentid =e.id
join roster r on r.id=enr.rosterid
join studentassessmentprogram sap on sap.studentid=e.studentid 
join assessmentprogram ap on ap.id=sap.assessmentprogramid	
join gradecourse gr on gr.id =e.currentgradelevel	
join contentarea ca on ca.id =r.statesubjectareaid	
where ap.abbreviatedname='DLM'  and stud.activeflag is true and org.statename='Delaware'
     and r.statecoursecode='BIO' and ca.abbreviatedname='Sci' and gr.abbreviatedname not in ('10','11','12');
 RAISE NOTICE 'Validation(31) DLM: Student is in Delaware, rostered where subject is Science, Course is BIO, and enrolled grade is anything other than (10,11,12)number total count:%',row_count;
--dailyvalidation(32):KAP kids processed time (KANSAS_SCHEDULED_WEB_SERVICE_END_TIME).
select categoryname into row_value from category where categorycode ='KANSAS_SCHEDULED_WEB_SERVICE_END_TIME';
 RAISE NOTICE 'Validation(32) KAP kids processed time (KANSAS_SCHEDULED_WEB_SERVICE_END_TIME):%',row_value;
 --dailyvalidation(33):Extract reports are in IN_QUEUE or IN_PROGRESS.
select count(*) into row_count from modulereport m
inner join category c on c.id=m.statusid 
where c.categorycode in ('IN_QUEUE','IN_PROGRESS') and m.activeflag is true 
and m.createddate<now()-interval '1 hour';
 RAISE NOTICE 'Validation(33) Extract reports are in IN_QUEUE or IN_PROGRESS:%',row_count; 
   --dailyvalidation(34) DLM:Completed test sessions were decreased for students
 select count(distinct yest.studentid) cnt into row_count
 from dlm_student_testsession_yesterday yest
left outer join dlm_student_testsession_today tday on yest.studentid=tday.studentid
where coalesce(yest.testsession_cnt,0)>coalesce(tday.testsession_cnt,0);
 RAISE NOTICE 'Validation(34) DLM:Completed test sessions were decreased for students:%',row_count;
   --dailyvalidation(35) DLM:Completed test sessions were decreased for states
select count(distinct yest.state) cnt into row_count
 from dlm_student_testsession_yesterday yest
left outer join dlm_student_testsession_today tday on yest.studentid=tday.studentid
where coalesce(yest.testsession_cnt,0)>coalesce(tday.testsession_cnt,0);
 RAISE NOTICE 'Validation(35) DLM:Completed test sessions were decreased for states:%',row_count;
     FOR tmp_count IN (select yest.state,count(distinct yest.studentid) cnt 
					 from dlm_student_testsession_yesterday yest
					left outer join dlm_student_testsession_today tday on yest.studentid=tday.studentid
					where coalesce(yest.testsession_cnt,0)>coalesce(tday.testsession_cnt,0)
					group by yest.state)
		LOOP
			  RAISE NOTICE 'Validation(35) DLM:Completed test sessions were decreased for state:%,count:%',tmp_count.state,tmp_count.cnt;
		END LOOP;
--Validation(36) Drop down issue for PNP Magnification		
with std as (		
select s.id,count(distinct selectedvalue) cnt  
FROM student s
inner JOIN enrollment e ON (e.studentid = s.id)
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
inner JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and attributecontainer='Magnification'
and (( attributename='activateByDefault' and selectedvalue='true')
or ( attributename='magnification' and selectedvalue='null'))
group by s.id
having count(distinct selectedvalue)>1)
select  count(distinct id) into row_count  from std;	
 RAISE NOTICE 'Validation(36) Drop down issue for student PNP Magnification:%',row_count;	
--Validation(37)Internal Server Error on survey
select count(distinct studentid) into row_count from (select distinct su.studentid, count(su.studentid) from survey su
                                      where activeflag is true
                                      group by su.studentid 
                                     having count(su.studentid) > 1 order by su.studentid )dup;
RAISE NOTICE 'Validation(37) Internal Server Error on survey:%',row_count; 
--Validation(38)DLM enrollment grade mismatched on tests grade brand 
select count(distinct studentid) into row_count from (select st.studentid
from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.schoolyear=2018 and ts.activeflag is true 
inner join enrollment en on en.id = st.enrollmentid
inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
inner join student s on s.id=st.studentid and s.activeflag is true
inner join gradecourse egc on egc.id=en.currentgradelevel
inner join testcollectionstests tct ON st.testid = tct.testid
inner join testcollection tc ON tc.id = tct.testcollectionid
left outer join gradebandgradecourse gbc on tc.gradebandid=gbc.gradebandid 
left outer join gradecourse ggc on ggc.id=gbc.gradecourseid and ggc.abbreviatedname<>'OTH'
inner join assessmentstestcollections atc ON tc.id = atc.testcollectionid
inner join assessment a ON atc.assessmentid = a.id
inner join testingprogram tp ON a.testingprogramid = tp.id
inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
where  ap.id=3
group by en.studentid,st.id,(replace(egc.abbreviatedname,'K','0'))::int
having (replace(egc.abbreviatedname,'K','0'))::int <min(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int) or 
       (replace(egc.abbreviatedname,'K','0'))::int >max(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int) ) dup;
RAISE NOTICE 'Validation(38) DLM enrollment grade mismatched on tests grade brand:%',row_count;     

--Validation(39)DLM duplicate roster or enrollment on students tests
with dup as (
select e.studentid,r.statesubjectareaid,count(distinct r.id) from enrollment e
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on er.enrollmentid=e.id 
inner join studentassessmentprogram sap on sap.studentid=e.studentid and sap.assessmentprogramid=3 and sap.activeflag is true
inner join roster r on r.id=er.rosterid 
group by e.studentid,r.statesubjectareaid
having count(distinct r.id)>1)
select count(distinct studentid) into row_count from (select st.studentid
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
inner join enrollment e on st.studentid=e.studentid and e.currentschoolyear=2018 and e.activeflag is true 
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true 
inner join roster r on r.id=er.rosterid and r.activeflag is true 
where st.status in (86,494,679,681) and tc.contentareaid=r.statesubjectareaid 
and exists (select 1 from dup where dup.studentid=st.studentid) and 
 (st.enrollmentid<>e.id or er.rosterid<>ts.rosterid)) std;
RAISE NOTICE 'Validation(39) DLM duplicate roster or enrollment on students tests:%',row_count;

--Validation(40) Sci band missing on completed or ready to submit FCS survey
select count(distinct s.id) cnt into row_count
from student s
join enrollment e on s.id = e.studentid and e.currentschoolyear=2018 and e.activeflag is true
inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
join firstcontactsurveysettings fcs on fcs.organizationid=o.stateid and fcs.schoolyear=tmp.orgyear and fcs.activeflag is true
join survey srv on s.id = srv.studentid and srv.activeflag is true
where srv.status in (222)
and fcs.scienceflag is true
and s.activeflag is true
and (s.finalscibandid is null or s.scibandid is null);
RAISE NOTICE 'Validation(40) Sci band missing on completed or ready to submit FCS survey:%',row_count;  
/*
--validation(41) For DLM missing educator information
select count(distinct studentid) cnt into row_count(select distinct en.studentid,r.statesubjectareaid,r.teacherid,count(*)
from enrollment en
join enrollmentsrosters er on er.enrollmentid =en.id and er.activeflag is true
join roster r on r.id=er.rosterid and r.activeflag is true 
join studentassessmentprogram sap on sap.studentid =en.studentid and sap.activeflag is true 
left outer join  aartuser aart on aart.id=r.teacherid and aart.activeflag is true
where en.activeflag is true and en.currentschoolyear =2018 and sap.assessmentprogramid =3
group by en.studentid,r.statesubjectareaid,r.teacherid
having coalesce(count(*),0)=0)dup;
RAISE NOTICE 'Validation(41)For DLM missing educator information:%,row_count;
*/
end_date:=clock_timestamp();    
     RAISE NOTICE 'Validation process ended:%',end_date;
     run_time := (extract(epoch from end_date) - extract(epoch from start_date));
     RAISE NOTICE 'script run time=%', run_time; 
END;
$BODY$;	


