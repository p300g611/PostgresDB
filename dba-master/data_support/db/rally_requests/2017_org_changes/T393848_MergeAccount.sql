BEGIN;
--validation
/*select stu.id, stu.statestudentidentifier,en.id, stu.legalfirstname,stu.legallastname, org.organizationname, asp.abbreviatedname

from student stu
inner join enrollment en on en.studentid = stu.id
inner join organization org on org.id =en.attendanceschoolid
inner join studentassessmentprogram sta on sta.studentid =stu.id
inner join assessmentprogram asp on asp.id =sta.assessmentprogramid
where org.id = 6201 and en.activeflag is true and stu.activeflag is true 
and asp.abbreviatedname='DLM'
order by stu.statestudentidentifier desc;

 */
 --update student 
 
 update student 
 set activeflag = false,
     modifieddate = now(),
	 modifieduser =12
where id in (1336812,1336813,1336811);


update enrollment 
set    activeflag = false,
       modifieddate = now(),
	   modifieduser =12
where id in (2541717,2541718,2541716);

update studentassessmentprogram
set activeflag =false
where id in (882723,882724,882725);

COMMIT;