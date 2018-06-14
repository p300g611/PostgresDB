BEGIN;


update  enrollment 
set     activeflag = false,
        modifieddate = now(),
		modifieduser =12
where id in (select  distinct enr.enrollmentid from student stu
             inner join enrollment en on en.studentid=stu.id
			 inner join enrollmentsrosters enr on enr.enrollmentid=en.id
             where enr.id in (15094609,
							14774748,
							14838789,
							14744443,
							14776121,
							14797910,
							14927891,
							14774125,
							14952984,
							14917280,
							14798936,
							14744540,
							14639556,
							15094636,
							14913874,
							15094963,
							14738177,
							14740090,
							14806926,
							14685323,
							15256934,
							14963771,
							14809837,
							14802037,
							14929186,
							14970082) and stateid =51 and stu.activeflag is true and en.activeflag is true) and activeflag is true and currentschoolyear =2017;
							



update enrollmentsrosters 
set    activeflag =false,
       modifieddate =now(),
       modifieduser =12
where  enrollmentid in (select enrollmentid from enrollmentsrosters where id in(15094609,
																				14774748,
																				14838789,
																				14744443,
																				14776121,
																				14797910,
																				14927891,
																				14774125,
																				14952984,
																				14917280,
																				14798936,
																				14744540,
																				14639556,
																				15094636,
																				14913874,
																				15094963,
																				14738177,
																				14740090,
																				14806926,
																				14685323,
																				15256934,
																				14963771,
																				14809837,
																				14802037,
																				14929186,
																				14970082));
																			
--enrollment more than two schools																				
update  enrollment 
set     activeflag = false,
        modifieddate = now(),
		modifieduser =12
where id in (2648330,2648378,2648337,2648359);

update enrollmentsrosters 
set    activeflag =false,
       modifieddate =now(),
       modifieduser =12
where enrollmentid in (2648330,2648378,2648337,2648359);

COMMIT;																				
							
	   				
