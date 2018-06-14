drop table if exists tmp_student_survey;
with stu_srv as
  (Select 
   (select  organizationname from organization_parent(o.id) where organizationtypeid=2  limit 1 )  statename,
   (select  organizationname from organization_parent(o.id) where organizationtypeid=5  limit 1 )  districtname,
   (select  displayidentifier from organization_parent(o.id) where organizationtypeid=5  limit 1 ) districidentifier,
   o.organizationname  attendanceschoolname,
   o.displayidentifier attendanceschoolidentifier, 
   s.statestudentidentifier,
   s.id studentid,
   coalesce(c.categorycode,'NOT_STARTED') surveystatus
     from student s
	     inner join enrollment e  on s.id=e.studentid
	     inner join organization o on o.id=e.attendanceschoolid
	     left outer join survey sr on sr.studentid=s.id 
	     left outer join category c on c.id=sr.status 
	     left join categorytype ctype on ctype.id = c.categorytypeid and ctype.typecode = 'SURVEY_STATUS'
	     inner join (select distinct s.id from student s
				    inner join studentassessmentprogram sap ON sap.studentid = s.id
				    inner join assessmentprogram a ON a.id = sap.assessmentprogramid
				where s.activeflag is true and sap.activeflag is true and a.abbreviatedname ='DLM' and a.activeflag is true
				  and s.stateid in (select id from organization where organizationtypeid=2 and displayidentifier in ('AK','KS'))) dlm on s.id=dlm.id
             left outer join (select distinct s.id from student s
				    inner join studentassessmentprogram sap ON sap.studentid = s.id
				    inner join assessmentprogram a ON a.id = sap.assessmentprogramid
			      where   s.activeflag   is true 
				  and sap.activeflag is true  
				  and a.activeflag   is true
				  and (  (s.stateid in (select id from organization where organizationtypeid=2 and displayidentifier in ('AK')) and a.abbreviatedname ='AMP')
				      or (s.stateid in (select id from organization where organizationtypeid=2 and displayidentifier in ('KS')) and a.abbreviatedname ='KAP')
				       )) amkap on amkap.id=s.id
	    where   s.activeflag is true and e.activeflag is true and amkap.id is null
	        and s.stateid in (select id from organization where organizationtypeid=2 and displayidentifier in ('AK','KS'))
   union 
   Select 
   (select  organizationname from organization_parent(o.id) where organizationtypeid=2  limit 1 )  statename,
   (select  organizationname from organization_parent(o.id) where organizationtypeid=5  limit 1 )  districtnameidentifier,
   (select  displayidentifier from organization_parent(o.id) where organizationtypeid=5 limit 1 ) distric,
   o.organizationname  attendanceschoolname,
   o.displayidentifier attendanceschoolidentifier, 
   s.statestudentidentifier,
   s.id studentid,
   coalesce(c.categorycode,'NOT_STARTED') surveystatus
      from student s
	     inner join enrollment e  on s.id=e.studentid
	     inner join organization o on o.id=e.attendanceschoolid
	     left outer join survey sr on sr.studentid=s.id 
	     left outer join category c on c.id=sr.status 
	     left join categorytype ctype on ctype.id = c.categorytypeid and ctype.typecode = 'SURVEY_STATUS'
	    where s.activeflag is true and e.activeflag is true and s.stateid not in (select id from organization where organizationtypeid=2 and displayidentifier in ('AK','KS'))       
     )
select *  into temp tmp_student_survey from stu_srv where surveystatus<>'COMPLETE' order by 1;
\COPY (select * from tmp_student_survey) To 'tmp_student_survey_03172016.csv' DELIMITER '|' CSV HEADER;
drop table if exists tmp_student_survey;



