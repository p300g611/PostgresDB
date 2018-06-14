create temp table tmp_orgyear (orgid bigint ,orgyear int);
     insert into tmp_orgyear
     select schoolid orgid,2018 orgyear from organizationtreedetail 
	 where coalesce(organization_school_year(stateid),extract(year from now()))=2018 
	 and stateid not in (select id from organization where  organizationtypeid=2 
	                     and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
	                                              ,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
	                                              ,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland','Service Desk QC State','QA QC State'));    
--Validation(1): Kansas students active in both KAP and DLM
with dup_assessment as 
( select s.id,count(distinct sap.assessmentprogramid) cnt  
						 from student s 
						 inner join enrollment en on s.id=en.studentid 
						 inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
						 inner join organizationtreedetail ot on ot.schoolid=en.attendanceschoolid
						 inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
						 inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
						 where ot.statedisplayidentifier='KS' and s.activeflag is true and ap.abbreviatedname in ('KAP','DLM') 
						   group by s.id
						   having count(distinct sap.assessmentprogramid)>1)
						   
   select s.id "1:Kansas students active in both KAP and DLM", s.statestudentidentifier ssid, schoolname, districtname, statename,sap.id studentassesmentid, ap.abbreviatedname
          into temp dailyvalidation1
						 from student s 
						 inner join enrollment en on s.id=en.studentid 
						 inner join organizationtreedetail ort on ort.schoolid = en.attendanceschoolid and ort.stateid=s.stateid
						 inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
						 inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
						 inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
						 where ort.statedisplayidentifier='KS' and s.activeflag is true and ap.abbreviatedname in ('KAP','DLM') 
						 and s.id in (select id from dup_assessment);						   
\copy (select * from dailyvalidation1 ) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);	
								 
--dailyvalidation2:Grade in enrollment table does not match grade on test table 
     select en.studentid "2:studentid Grade in enrollment does not match grade on test",s.statestudentidentifier ssid,egc.name enrollgrade , tgc.name testgrade ,t.testname,  en.currentschoolyear,schoolname,districtname,statename 
               into temp dailyvalidation2 
                            from enrollment en
                            inner join student s on s.id=en.studentid
                            inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
                            inner join organizationtreedetail o on o.schoolid=en.attendanceschoolid
							inner join studentstests st on en.id = st.enrollmentid 
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
				            and egc.abbreviatedname <> tgc.abbreviatedname and 'Interim'<>coalesce(tp.programname,''); 	
 \copy (select * from dailyvalidation2 ) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--dailyvalidation3:Student actively enrolled in two schools for same subject total
with dup_enroll
as (
    select studentid,statesubjectareaid,count(distinct e.id)
						 from enrollment e 
						 inner join student s on s.id=e.studentid and s.activeflag is true
						 inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
						 inner join enrollmentsrosters er on e.id=er.enrollmentid
						 inner join roster r on r.id=er.rosterid
					   where e.activeflag is true and er.activeflag is true and r.activeflag is true
					   group by  studentid,statesubjectareaid
					   having count(distinct e.id)>1)

select e.studentid "3:Studentid actively enrolled in two schools for same subject",s.statestudentidentifier ssid,e.currentschoolyear,schoolname,districtname,statename,
er.id enrollrosterid,r.coursesectionname,statesubjectareaid,statecoursecode,statecourseid ,e.modifieddate enrollmod, er.modifieddate enrollrostermod 
   into temp dailyvalidation3
                                             from enrollment e 
						 inner join student s on s.id=e.studentid and s.activeflag is true
						 inner join organizationtreedetail o on o.schoolid=e.attendanceschoolid
						 inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
						 inner join enrollmentsrosters er on e.id=er.enrollmentid
						 inner join roster r on r.id=er.rosterid
where s.id in ( select studentid from dup_enroll);
\copy (select * from dailyvalidation3 ) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 

 --dailyvalidation(4):Student with tests for two different grades for same subject
with dup_subject
AS (
	 select st.studentid,ap.abbreviatedname assessment,c.id contentareaid,count(distinct gc.abbreviatedname) 
	                                  from studentstests st 
                                      inner join enrollment e on e.id = st.enrollmentid
                                      inner join student s on s.id=e.studentid and s.activeflag is true
						              inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
									  inner join test t on t.id=st.testid and t.activeflag is true
									  inner join gradecourse gc on t.gradecourseid=gc.id and gc.activeflag is true
									  inner join contentarea c  on t.contentareaid=c.id and c.activeflag is true
									  left outer join testcollectionstests tct ON t.id = tct.testid
									left outer join testcollection tc ON tc.id = tct.testcollectionid
									left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
									left outer join assessment a ON atc.assessmentid = a.id
									left outer join testingprogram tp ON a.testingprogramid = tp.id
									left outer join assessmentprogram ap ON tp.assessmentprogramid = ap.id
								      where st.activeflag is true and 'Interim'<>coalesce(tp.programname,'')
									  and ap.abbreviatedname <> 'MSS' and ap.abbreviatedname<>'CPASS'
									  group by st.studentid,c.id,ap.abbreviatedname
									  having count(distinct gc.abbreviatedname)>1) 
select s.id "4:Studentid with tests for two diff grades for same subject",dup.assessment,s.statestudentidentifier ssid,schoolname,districtname,statename,st.id studentstestid, c.abbreviatedname contentname,gc.abbreviatedname gradecourse,t.id testid
			into temp dailyvalidation4
                      from studentstests st 
                      inner join enrollment e on e.id = st.enrollmentid
		      inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
                      inner join student s on s.id=e.studentid and s.activeflag is true
					  inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
					  inner join test t on t.id=st.testid and t.activeflag is true
					  inner join gradecourse gc on t.gradecourseid=gc.id and gc.activeflag is true
					  inner join contentarea c  on t.contentareaid=c.id and c.activeflag is true
					  inner join dup_subject dup on dup.studentid=s.id and dup.contentareaid=c.id
					  where st.activeflag is true;
\copy (select * from dailyvalidation4) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation4.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 		


 --dailyvalidation(5):Active student with no assessment program affiliation 					
select s.id "5:Active studentid with no assessment program affiliation", s.statestudentidentifier ssid, schoolname, districtname,statename,en.id enrollmentid
 			into temp dailyvalidation5			   
                                    from student s
                                    inner join enrollment en on s.id=en.studentid and en.activeflag is true
				    inner join organizationtreedetail o on o.schoolid = en.attendanceschoolid
			            inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear     
				    LEFT OUTER JOIN (select distinct studentid from studentassessmentprogram sap 
						       where sap.activeflag is true) sact on sact.studentid=s.id
						            where s.activeflag is true and sact.studentid is null;
                              
\copy (select * from dailyvalidation5) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation5.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

/*
--dailyvalidation(6):Active users with no assessment program affiliation 
select a.id "6:Active usersid with no assessment program affiliation", a.email useremail, a.firstname, a.middlename, a.surname,a.uniquecommonidentifier educatorID
		into temp  dailyvalidation6
						from aartuser a
						LEFT OUTER JOIN (select a.id,o.id oid from aartuser a
						                 inner join usersorganizations usg on usg.aartuserid = a.id
						                 inner join organization o on o.id = usg.organizationid
									     inner join userassessmentprogram uo on a.id=uo.aartuserid
									     WHERE a.activeflag is true and uo.activeflag is true) aact on aact.id=a.id
						where a.activeflag is true and aact.id is null;
						   
\copy (select * from dailyvalidation6) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation6.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);  


 --dailyvalidation(7):Active studentid with no organization affiliation
select s.id "7:Active studentid with no organization affiliation", s.statestudentidentifier ssid,o.organizationname statename
       into temp dailyvalidation7
                     from student s
                     inner join organization o on o.id=s.stateid 
                     inner join tmp_orgyear tmp on o.id=tmp.orgid and o.activeflag is true 
					 LEFT OUTER JOIN (select distinct e.studentid from  enrollment e   
									 INNER JOIN organization o on o.id=e.attendanceschoolid
									 where e.activeflag is true and o.activeflag is true) sact on sact.studentid=s.id
						where s.activeflag is true and sact.studentid is null 
						order by statename;
											
\copy (select * from dailyvalidation7) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation7.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 
      								   
									   
 --dailyvalidation(8):Active users with no organization affiliation
select a.id "8:Active usersid with no organization affiliation", a.email useremail, a.firstname, a.middlename, a.surname,a.uniquecommonidentifier educatorID
    into temp dailyvalidation8
						from aartuser a
						LEFT OUTER JOIN (select distinct a.id from aartuser a
									  INNER JOIN usersorganizations uo on a.id=uo.aartuserid
									  INNER JOIN organization o on o.id=uo.organizationid
									  WHERE a.activeflag is true and o.activeflag is true and uo.activeflag is true) aact on aact.id=a.id
						where a.activeflag is true and aact.id is null;

\copy (select * from dailyvalidation8) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation8.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 
*/
 --dailyvalidation(9):Student with test active status = true on two tests for same stage/subject 
 
with dup_test as (
 SELECT st.studentid,ca.id,ap.id,stg.name,count(*)
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
						having count(*)>1) 

select s.id "9:Studentid test active status=true on two tests stage/subject",ap.abbreviatedname assessment,s.statestudentidentifier ssid, schoolname, districtname, statename, st.id studentstestid,t.id testid, 
        t.testname, ts.id testsessionid, ca.abbreviatedname testcontentarea,stg.name stagename,gc.name gradecourse
            into temp dailyvalidation9  
						       FROM studentstests st
						       inner join testsession ts on st.testsessionid =ts.id
						       inner join operationaltestwindow opw on opw.id=ts.operationaltestwindowid
						       inner join assessmentprogram ap on ap.id=opw.assessmentprogramid
						       inner join enrollment e on e.id = st.enrollmentid
						       inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
						       inner join student s on s.id=e.studentid and s.activeflag is true
						       inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true						       
						       inner join test t         on t.id=st.testid						       
						       inner join contentarea ca on t.contentareaid =ca.id
						       inner join gradecourse gc on gc.id=t.gradecourseid
						       inner join stage stg      on ts.stageid =stg.id
						       where st.activeflag is true and ts.activeflag is true AND ap.abbreviatedname<>'CPASS'
							   and s.id in (select studentid from dup_test);
							   
\copy (select * from dailyvalidation9) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation9.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 

 --dailyvalidation(10):temp tables created by manually
	                                           select * 
	                                               into temp dailyvalidation10
	                                               from (select * from pg_catalog.pg_tables where  tableowner not in ('postgres','aart','rdsadmin') and tablename not ilike '%dailyvalidation%') tab
					               where  tablename<>'tmp_orgyear';

\copy (select * from dailyvalidation10) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation10.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 

 --dailyvalidation(11):Active users with no organization affiliation
				select s.id "11:null grade for active enrollments", s.statestudentidentifier ssid, schoolname, districtname, statename,currentgradelevel,e.id enrollid
						into temp dailyvalidation11
						      from enrollment e
						      inner join student s on s.id=e.studentid and s.activeflag is true
						      inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
						      inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
						      where currentgradelevel is null;

\copy (select * from dailyvalidation11) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation11.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 

 --dailyvalidation(12):Active users with no organization affiliation
select s.id "12:primarydisabilitycode Invalid stdid", s.statestudentidentifier ssid, schoolname, districtname, statename,primarydisabilitycode
    into temp dailyvalidation12
						from student s
                           			       inner join enrollment e on e.studentid = s.id  and s.activeflag is true
                           			       inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
						       inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
			   where primarydisabilitycode not in (select categorycode
								from category c 
								inner join categorytype ct on  c.categorytypeid=ct.id
								where typecode='PRIMARY_DISABILITY_CODES' union select '' categorycode)
			     and primarydisabilitycode  is not null;

\copy (select * from dailyvalidation12) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation12.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 

 --dailyvalidation(13):Active users with no organization affiliation
select s.id "13:Mismatch on roster subject and student test sid", s.statestudentidentifier ssid, schoolname, districtname, statename,r.id as rosterid,car.abbreviatedname as rostersubject,r.coursesectionname,st.id as studenttestid,
			t.testname testname,ts.rosterid testsessionroster, ca.abbreviatedname as testcollectionsubject
    into temp dailyvalidation13
			from studentstests st 
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

\copy (select * from dailyvalidation13) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation13.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
/*	
 --dailyvalidation(14):DLM student no tests after FCScompleted
select s.id "14:DLM student no tests after FCScompleted sid", s.statestudentidentifier ssid, schoolname, districtname, statename,
			e.id as enrollid,sv.id surveyid ,sv.modifieddate survey_last_modified,c.categorycode status,r.coursesectionname,gc.name grade, sub.abbreviatedname subject
			into temp dailyvalidation14
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
					 where st.id is null;
\copy (select * from dailyvalidation14) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation14.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);	
*/
/*
 --dailyvalidation(15):1st Grade Writing test, and the rubric displaying in Educator Portal for Question #15 score should be <=2
with item_score as (
select distinct          scs.studentid
			,scs.studentstestsid
			,sc.testsessionid
			,ts.name testsessionname
			,ts.schoolyear
			,ccqi.id ccqscoreitemid
			,ccqi.taskvariantid
			,ccqi.modifieddate
			,ccqi.score
			,rc.name rubriccategoryname
			from scoringassignmentstudent scs 
			inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
			inner join testsession ts on ts.id = sc.testsessionid and ts.activeflag is true
			inner join tmp_orgyear tmp on ts.attendanceschoolid=tmp.orgid and ts.schoolyear=tmp.orgyear 
			inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
			inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sc.id and ccq.activeflag is true
			inner join ccqscoreitem ccqi on ccqi.ccqscoreid=ccq.id and ccqi.activeflag is true
			left outer join rubriccategory rc on rc.id=ccqi.rubriccategoryid
			where ccqi.taskvariantid=439519 and ccqi.score>2)
			select s.id "15:studentid has score>2", s.statestudentidentifier ssid,o.schoolname,o.districtname,o.statename,en.id enrollmentid
			,tmp.studentstestsid,tmp.testsessionid,tmp.testsessionname,tmp.schoolyear,tmp.ccqscoreitemid,tmp.taskvariantid
			,tmp.modifieddate,tmp.score,tmp.rubriccategoryname into temp dailyvalidation15			   
                                    from item_score tmp 
                                    inner join student s on tmp.studentid=s.id and s.activeflag is true
                                    inner join enrollment en on s.id=en.studentid and en.activeflag is true and tmp.schoolyear=en.currentschoolyear                                    
				    inner join organizationtreedetail o on o.schoolid = en.attendanceschoolid;	
\copy (select * from dailyvalidation15) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation15.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
*/
 --dailyvalidation(16):Find Non-ASCII characters in SSID
			select s.id "16:studentid has Non-ASCII characters in SSID", s.statestudentidentifier ssid,o.schoolname,o.districtname,o.statename,en.id enrollmentid
			,s.source student_source,en.sourcetype enroll_sourcetype,en.modifieddate enrollmod into temp dailyvalidation16			   
                                    from student s
                                    inner join enrollment en on s.id=en.studentid and en.activeflag is true
				    inner join organizationtreedetail o on o.schoolid = en.attendanceschoolid
			            inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear
				    where s.statestudentidentifier  ~* '[^a-z" "A-Z"-"0-9"_"/\!:''-DUPLICATE''''z_'']' and s.activeflag is true;	
\copy (select * from dailyvalidation16) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation16.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --dailyvalidation(17):DLM students-duplicate roster count 
with dup_test as (
select contentareaid,s.id studentid,count(distinct ts.rosterid) 
						from studentstests st 
						inner join student s on s.id=st.studentid
						inner join enrollment e on e.studentid=s.id and e.id = st.enrollmentid and s.activeflag is true
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
						having count(distinct ts.rosterid)>1) 
select s.id "17:DLM students-duplicate roster count",s.statestudentidentifier ssid, schoolname, districtname, statename, st.id studentstestid,ts.id testsessionid,
     contentareaid,ts.rosterid 
            into temp dailyvalidation17 
						from studentstests st 
						inner join student s on s.id=st.studentid
						inner join enrollment e on e.studentid=s.id and e.id = st.enrollmentid and s.activeflag is true
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
							   and s.id in (select studentid from dup_test);							   
\copy (select * from dailyvalidation17) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation17.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 
 --dailyvalidation(18):DLM students-missing FCS bands 
select distinct s.id "18:DLM students-missing FCS bands",s.statestudentidentifier ssid, schoolname, districtname, statename, st.id studentstestid,st.status, ts.id testsessionid
     ,contentareaid,commbandid,finalelabandid,finalmathbandid,finalscibandid,scienceflag state_sci_setting
            into temp dailyvalidation18 
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
\copy (select * from dailyvalidation18) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation18.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--dailyvalidation(19):DLM in progress tests from a long time
select distinct s.id "19:DLM inprogress tests from a long time",s.statestudentidentifier ssid, schoolname, districtname, statename, st.id studentstestid,st.status, ts.id testsessionid
     ,st.startdatetime
            into temp dailyvalidation19
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
\copy (select * from dailyvalidation19) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation19.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);					
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
					select tmp.studentid "20:DLM essentialelementlinkage is NA",tmp.id studentstests into temp dailyvalidation20 from std_dlm tmp 
						inner join  studentstestsections sts ON sts.studentstestid = tmp.id
						inner JOIN testsection tsec ON sts.testsectionid = tsec.id
						inner join testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
						left outer join taskvariantessentialelementlinkage tveel ON (tveel.taskvariantid = tstv.taskvariantid)
						where tveel.essentialelementlinkageid is null;												   
\copy (select * from dailyvalidation20) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation20.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

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
                          select distinct s.id "21:Tests begun after 5pm sid", s.statestudentidentifier ssid, schoolname, districtname, statename,startdatetime_cst,studentstestsid
                                        into temp dailyvalidation21
		                      from tmp_std st 
					inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
					inner join student s on s.id=e.studentid and s.activeflag is true
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
\copy (select * from dailyvalidation21) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation21.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --dailyvalidation(22):Tests ended after 5:00 pm and excluded  Sat,Sun, and Virtual
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
                          select s.id "22:Tests ended after 5pm sid", s.statestudentidentifier ssid, schoolname, districtname, statename,enddatetime_cst,studentstestsid
                                        into temp dailyvalidation22
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
					and not exists (select 1 from organizationtreedetail tgt where tgt.schoolname ilike '%virtu%' and ort.schoolid=tgt.schoolid)     ;	
\copy (select * from dailyvalidation22) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation22.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --dailyvalidation(23):Tests started on Sat and Sun and excluded Virtual
with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid,(st.startdatetime ) AT TIME ZONE 'US/Central' startdatetime_cst, (st.enddatetime ) AT TIME ZONE 'US/Central' enddatetime_cst
from studentstests st 
where (startdatetime ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour'
and st.startdatetime is not null and st.activeflag is true) 
                          select s.id "23:Tests started on sat and sun sid", s.statestudentidentifier ssid, schoolname, districtname, statename,startdatetime_cst,enddatetime_cst,studentstestsid
                                        into temp dailyvalidation23
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
\copy (select * from dailyvalidation23) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation23.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --dailyvalidation(24):Reactivated tests by users
 with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid from studentstests st 
       join studentstestshistory sth on sth.studentstestsid = st.id
                     where st.activeflag is true 
				and (sth.action='REACTIVATION')
				and (sth.acteddate ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour') 
                          select s.id "24:Reactivated tests sid", s.statestudentidentifier ssid, studentstestsid ,schoolname, districtname, statename
                                        into temp dailyvalidation24
				     from tmp_std st
				inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
				inner join student s on s.id=e.studentid and s.activeflag is true
				inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
				inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
				inner join testsession ts on st.testsessionid=ts.id 
				inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true				 
				where ts.activeflag is true;
\copy (select * from dailyvalidation24) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation24.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --dailyvalidation(25):CPASS kids outside of kansas 
select  s.id "25:Tests begun after 6pm sid", s.statestudentidentifier ssid, schoolname, districtname, statename,ap.abbreviatedname programs
                                        into temp dailyvalidation25
		         from student s 
		         inner join enrollment en on s.id=en.studentid and en.activeflag is true
			 inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear 
		         inner join organizationtreedetail ot on ot.schoolid=en.attendanceschoolid
		         inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
		         inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
		         where ot.statedisplayidentifier<>'KS' and s.activeflag is true and ap.abbreviatedname ='CPASS'
		         and (sap.modifieddate ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour';
\copy (select * from dailyvalidation25) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation25.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --dailyvalidation(26):Reactivated tests by system
 with tmp_std as (select st.id studentstestsid,st.studentid,st.enrollmentid,testsessionid from studentstests st 
       join studentstestshistory sth on sth.studentstestsid = st.id
                     where st.activeflag is true 
				and (sth.action='SYSTEM_REACTIVATION')
				and (sth.acteddate ) AT TIME ZONE 'US/Central'>=current_timestamp at time zone 'US/Central'-interval '24 hour') 
                          select s.id "26:Reactivated tests sid", s.statestudentidentifier ssid, studentstestsid,schoolname, districtname, statename
                                        into temp dailyvalidation26
				     from tmp_std st
				inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
				inner join student s on s.id=e.studentid and s.activeflag is true
				inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear
				inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
				inner join testsession ts on st.testsessionid=ts.id 
				inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true				 
				where ts.activeflag is true;
\copy (select * from dailyvalidation26) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation26.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --dailyvalidation(27):Interim Predictive Tests Complete with Unanswered Items
select 
t.id         			"TestID"
,st.id                  "studentstestsid"
,ts.id        			"TestsessionID"
,st.studentid  			"StudentID"
,s.statestudentidentifier       "SSID"
,gc.abbreviatedname     	"Grade"
,ca.abbreviatedname     	"Subject"
,ort.schoolid           	"schoolid"
,ort.schoolname         	"SchoolName"
,ort.districtid         	"Districtid"
,ort.districtname         	"DistrictName"
,tv.id                       "taskvariantid"
,tv.externalid              "exteraltaskvariandid"
into temp dailyvalidation27
FROM studentstests st
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
WHERE  tp.programname ='Interim' and st.status =86  and st.startdatetime::date > '2017-10-27'
and ap.id=12 and ct.categorycode='PRDCTN' and sres1.taskvariantid is null --(sres1.response is null and sres1.foilid is null)
order by st.studentid, ts.id;
\copy (select * from dailyvalidation27) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation27.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);					     				    					   						
--Validation(28): For DLM, any students who have two active tests assigned for same subject/test number (for dailyvalidation_extracts.sql)
with dup_subject  as 
( select ca.abbreviatedname,stud.id studentid,e.id,sts.currenttestnumber, count(*)
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
                         where ap.abbreviatedname='DLM' and stud.activeflag is true
                         and st.activeflag is true and ts.activeflag is true and stb.activeflag is true
                         group by  ca.abbreviatedname,stud.id,e.id,sts.currenttestnumber
                         having count(*)>1 )
						   
   select stud.id "28:For DLM students:two active tests for same subject", stud.statestudentidentifier ssid, schoolname, districtname, statename,
                   sts.id studentstestsid, t.id testid, t.testname,ts.name testsessionname, ca.abbreviatedname subject, sap.id studentassesmentid, ap.abbreviatedname
          into temp dailyvalidation28
			    from student stud
			     join dup_subject dup on dup.studentid=stud.id
                             join studenttracker st on st.studentid = stud.id
                             join studenttrackerband stb on stb.studenttrackerid = st.id
                             join testsession ts on ts.id = stb.testsessionid
                             join studentstests sts on sts.testsessionid = ts.id and sts.studentid = stud.id and sts.currenttestnumber=dup.currenttestnumber
                             join test t on t.id = sts.testid 
                             join enrollment e on e.id=sts.enrollmentid
                             join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true 
                             join organizationtreedetail org on org.schoolid=tmp.orgid							 
                             join studentassessmentprogram sap on sap.studentid=e.studentid 
                             join assessmentprogram ap on ap.id=sap.assessmentprogramid
                             join contentarea ca ON ca.id = st.contentareaid							 
                         where ap.abbreviatedname='DLM' and stud.activeflag is true
                         and st.activeflag is true and ts.activeflag is true and stb.activeflag is true and sts.activeflag is true;						   
\copy (select * from dailyvalidation28) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation28.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);	
--validation(29): the number of the user who has duplicated roles  in organizaiton
    select a.id  "29:the user who has duplicated roles in organizaiton",ap.id assessmentprogramid,g.id groupid,o.id orgid,count(*)
into temp dailyvalidation29
	FROM aartuser a
       JOIN usersorganizations uo ON a.id = uo.aartuserid
       JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
       JOIN organization o ON o.id = uo.organizationid
       JOIN groups g ON g.id = ug.groupid
       JOIN userassessmentprogram ua ON ua.aartuserid=a.id and ua.userorganizationsgroupsid = ug.id
       join assessmentprogram ap on ap.id=ua.assessmentprogramid
        where a.activeflag is true and uo.activeflag is true 
       and ug.activeflag is true and ua.activeflag is true
      group by a.id,ap.id,g.id,o.id
      having count(*)>1 
      order by a.id;
\copy (select * from dailyvalidation29) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation29.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--dailyvalidation(30):ETL Publishing issue duplicate testcollections 
with dups as (
SELECT tc.id testcollectionid,count(tp.id) cnt FROM testpanel tp 
JOIN testpanelstage tps ON tp.id = tps.testpanelid 
JOIN testpanelstagetestcollection tpstc ON tpstc.testpanelstageid = tps.id 
JOIN testcollection tc ON tc.externalid = tpstc.externaltestcollectionid 
WHERE tp.activeflag is true and tps.activeflag is true and tpstc.activeflag is true 
group by tc.id having count(tp.id)>1)
select
tc.id "30:ETL Publishing issue testcollectionid",
tc.name testcollectionname,
tc.externalid   testcollectionexternalid,
tp.id testpanelid,
tp.externalid testpanelexternalid,
tp.panelname testpanel,
tps.id  testpanelstageid,
tps.stageid,
tps.externalid testpanelstageexternalid,
tpstc.id testpanelstagetestcollectionid,
tpstc.externalid testpanelstagetestcollectionexternalid
into temp dailyvalidation30
  FROM testpanel tp 
JOIN testpanelstage tps ON tp.id = tps.testpanelid 
JOIN testpanelstagetestcollection tpstc ON tpstc.testpanelstageid = tps.id 
JOIN testcollection tc ON tc.externalid = tpstc.externaltestcollectionid 
WHERE tp.activeflag is true and tps.activeflag is true and tpstc.activeflag is true
and tc.id in (select testcollectionid from dups)
order by tc.externalid, tc.id desc;
\copy (select * from dailyvalidation30) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation30.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--Validation(31) DLM: Student is in Delaware, rostered where subject is Science, Course is BIO, and enrolled grade is anything other than (10,11,12) 
select distinct stud.id "31:student in Delaware, rostered_Science_BIO",stud.statestudentidentifier ssid, schoolname, districtname, statename,r.id,r.statesubjectcourseidentifier subject,
ca.abbreviatedname course,gr.abbreviatedname grade into temp dailyvalidation31
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
\copy (select * from dailyvalidation31) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation31.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--Validation(34) DLM:Completed test sessions were decreased for students
create temp table dlm_student_testsession_today(studentid bigint,state text,testsession_cnt bigint,gradedbids text);							  
\COPY dlm_student_testsession_today FROM '/srv/extracts/helpdesk/dailyvalidation/data/dlm_student_testsession_today.csv' DELIMITER ',' CSV HEADER ; 
create temp table dlm_student_testsession_yesterday(studentid bigint,state text,testsession_cnt bigint,gradedbids text);							  
\COPY dlm_student_testsession_yesterday FROM '/srv/extracts/helpdesk/dailyvalidation/data/dlm_student_testsession_yesterday.csv' DELIMITER ',' CSV HEADER ;
with std_list as (
select
yest.studentid,
yest.state,
coalesce(yest.testsession_cnt,0) student_yesterday_cnt,
coalesce(tday.testsession_cnt,0) student_today_cnt,
now() AT TIME ZONE 'US/Central' validation_date,
yest.gradedbids gradedbids_yesterday,
tday.gradedbids gradedbids_today
from dlm_student_testsession_yesterday yest
left outer join dlm_student_testsession_today tday on yest.studentid=tday.studentid
where coalesce(yest.testsession_cnt,0)>coalesce(tday.testsession_cnt,0))
select std.studentid studentid, schoolname, districtname, state,e.activeflag enrollmentflag,0 schoollevel,e.attendanceschoolid schoolid
,student_yesterday_cnt,student_today_cnt,validation_date,gradedbids_yesterday,gradedbids_today
,e.currentgradelevel,e.exitwithdrawaldate,e.exitwithdrawaltype into temp dailyvalidation34
from std_list std 
inner join enrollment e on e.studentid=std.studentid 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear  
inner join organizationtreedetail org on org.schoolid=tmp.orgid
order by state,std.studentid;

with std as(
SELECT e.attendanceschoolid schoolid,st.studentid,count(distinct ts.id) testsession_cnt
FROM studentstests st
INNER JOIN enrollment e ON st.enrollmentid = e.id and st.studentid=e.studentid
inner join dailyvalidation34 tmp on tmp.schoolid=e.attendanceschoolid and e.studentid=tmp.studentid
INNER JOIN testsession ts ON st.testsessionid = ts.id 
WHERE e.currentschoolyear=2018 AND st.activeflag=true and st.status=86 and ts.activeflag is true 
group by e.attendanceschoolid,st.studentid)
update dailyvalidation34 tmp
set schoollevel =testsession_cnt
from std 
where tmp.studentid=std.studentid and tmp.schoolid=std.schoolid;

\copy (select * from dailyvalidation34) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation34.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);	   	
\copy (select * from dailyvalidation34) to '/srv/extracts/helpdesk/dailyvalidation/archive/dailyvalidation34.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);	

--Validation(35) DLM:Completed test sessions were decreased for state
with std_list as (
select
yest.state,
sum(coalesce(yest.testsession_cnt,0)) yesterday_cnt,
sum(coalesce(tday.testsession_cnt,0)) today_cnt,
now() AT TIME ZONE 'US/Central' validation_date
from dlm_student_testsession_yesterday yest
left outer join dlm_student_testsession_today tday on yest.studentid=tday.studentid
where coalesce(yest.testsession_cnt,0)>coalesce(tday.testsession_cnt,0)
group by yest.state)
select 
std.state "35:testsession decreased for state", 
yesterday_cnt,today_cnt,validation_date into temp dailyvalidation35
from std_list std 
order by state;
\copy (select * from dailyvalidation35) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation35.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from dailyvalidation35) to '/srv/extracts/helpdesk/dailyvalidation/archive/dailyvalidation35.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);	

--Validation(36) Drop down issue for PNP Magnification
with std_list as (
select s.id studentid,a.id assessmentid,e.id enrollmentid,count(distinct selectedvalue) cnt 
FROM student s
inner JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
inner JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
inner JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
inner JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and attributecontainer='Magnification'
and (( attributename='activateByDefault' and selectedvalue='true')
or ( attributename='magnification' and selectedvalue='null'))
group by s.id,a.id,e.id 
having count(distinct selectedvalue)>1)
 select en.studentid "36:PNP Magnification studentid", schoolname, districtname, statename,tmp.assessmentid
          into temp dailyvalidation36
						 from std_list tmp 
						 inner join enrollment en on tmp.studentid=en.studentid and en.id=tmp.enrollmentid
						 inner join organizationtreedetail ort on ort.schoolid = en.attendanceschoolid;
\copy (select * from dailyvalidation36) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation36.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--Validation(37)Internal Server Error on survey
select studentid 
          into temp dailyvalidation37
          from  (select distinct su.studentid, count(su.studentid) from survey su
                  where activeflag is true
                   group by su.studentid 
                  having count(su.studentid) > 1 order by su.studentid)dup;
\copy (select * from dailyvalidation37) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation37.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--Validation(38)DLM enrollment grade mismatched on tests grade brand 
select en.studentid "(38)DLM enrollment grade mismatched on tests grade brand",schoolname, districtname, statename,st.id studentstestsid
,(replace(egc.abbreviatedname,'K','0'))::int enrollgrade
,min(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int) min_test_gradeband
,max(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int) max_test_gradeband
into temp dailyvalidation38
from  studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.schoolyear=2018 and ts.activeflag is true 
inner join enrollment en on en.id = st.enrollmentid
inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
inner join student s on s.id=st.studentid and s.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=en.attendanceschoolid
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
group by en.studentid,schoolname, districtname, statename,st.id,(replace(egc.abbreviatedname,'K','0'))::int
having (replace(egc.abbreviatedname,'K','0'))::int <min(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int) or 
       (replace(egc.abbreviatedname,'K','0'))::int >max(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int);
\copy (select * from dailyvalidation38) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation38.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);     

--Validation(39)DLM duplicate roster or enrollment on students tests
with dup as (
select e.studentid,r.statesubjectareaid,count(distinct r.id) from enrollment e
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join enrollmentsrosters er on er.enrollmentid=e.id 
inner join studentassessmentprogram sap on sap.studentid=e.studentid and sap.assessmentprogramid=3 and sap.activeflag is true
inner join roster r on r.id=er.rosterid
group by e.studentid,r.statesubjectareaid
having count(distinct r.id)>1)
select st.studentid "39:DLM duplicate roster or enrollment on students tests",schoolname, districtname, statename,st.id studentstestsid,
    e.id curr_enrollment,r.id curr_rosterid,st.enrollmentid test_enrollment,ts.rosterid test_roster
into temp dailyvalidation39
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and ts.schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
inner join enrollment e on st.studentid=e.studentid and e.currentschoolyear=2018 and e.activeflag is true 
inner join tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true 
inner join roster r on r.id=er.rosterid and r.activeflag is true 
where st.status in (86,494,679,681) and tc.contentareaid=r.statesubjectareaid 
and exists (select 1 from dup where dup.studentid=st.studentid) and 
 (st.enrollmentid<>e.id or er.rosterid<>ts.rosterid);
\copy (select * from dailyvalidation39) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation39.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);  

--Validation(40) Sci band missing on completed or ready to submit FCS survey
select distinct s.id "40:Sci band missing for completed survey ",schoolname, districtname, statename,s.scibandid,s.finalscibandid,srv.status,e.id enrollmentid
into temp dailyvalidation40
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
\copy (select * from dailyvalidation40) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation40.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


