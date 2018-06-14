
-- validation
-- select  s.id,count(distinct sap.assessmentprogramid) cnt  
-- 		         from student s
-- 		         inner join enrollment e on e.studentid=s.id 
-- 		         inner join organization o on o.id=s.stateid 
-- 		         inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
-- 		         inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
-- 		         where o.displayidentifier='KS' and e.activeflag is true and s.activeflag is true and currentschoolyear=2017 and ap.abbreviatedname in ('KAP','DLM')
-- 			   group by s.id
-- 			   having count(distinct sap.assessmentprogramid)>1
begin;
update  studentassessmentprogram
   set activeflag=false
   where studentid in (
	 select s.id from student  s
	 inner join enrollment e on e.studentid=s.id
	 inner join studentassessmentprogram sa on s.id=sa.studentid
	 inner join (
		 select distinct s.id from student  s
		 inner join enrollment e on e.studentid=s.id
		 inner join studentassessmentprogram sa on s.id=sa.studentid
		 where s.stateid=51 and assessmentprogramid=3 
		  and currentschoolyear=2017 and s.activeflag is true and e.activeflag is true and sa.activeflag is true) dlm on dlm.id=s.id
	where s.stateid=51 and assessmentprogramid=12
	  and currentschoolyear=2017 and s.activeflag is true and e.activeflag is true and sa.activeflag is true) 
  and assessmentprogramid=12 and activeflag is true 
commit;