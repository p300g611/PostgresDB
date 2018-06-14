/*
select stu.id studentid, en.id enrollmentid, en.activeflag enrollflag, enr.id enrollmentrosterid, enr.createddate, enr.modifieddate,
r.coursesectionname,r.statesubjectareaid,en.currentschoolyear

from student stu
inner join enrollment en on en.studentid=stu.id
inner join enrollmentsrosters enr on enr.enrollmentid=en.id
inner join roster r on r.id=enr.rosterid
where stu.statestudentidentifier ='9821089356' and en.currentschoolyear=2017
*/



BEGIN;

update enrollment
set    activeflag =false,
       modifieddate =now(),
	   modifieduser =12
where id= 2714353;


update enrollmentsrosters 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =12
	where id = 15257978;
	
	
COMMIT;
