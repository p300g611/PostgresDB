select e.studentid,statestudentidentifier, e.id enrollid,e.modifieddate,e.activeflag enroll_active, er.id erid,o.displayidentifier,o.activeflag enroll_ord 
 from enrollment  e
inner join organization o on o.id=e.attendanceschoolid
inner join student s on s.id=e.studentid 
left outer join enrollmentsrosters er on er.enrollmentid=e.id
where s.statestudentidentifier in ('1000317438',
'1000269117',
'1000290230',
'1000246506',
'1000292832',
'1000303414',
'1000281091',
'1000321055',
'1000335516',
'1000333207',
'1000195207',
'1000549731',
'1000530347',
'1000245617',
'1000450296',
'1000298892',
'1000337362',
'1000249121',
'1000320813',
'1000260715',
'1000297875',
'1000272460',
'1000249697',
'1000307397',
'1000290403',
'1000268443');


update enrollment  
set activeflag =false,modifieddate=now(),modifieduser=(select id from aartuser  where email ='ats_dba_team@ku.edu')
where id in (3204637,
3204638,
3204639,
3204640,
3204641,
3204642,
3204643,
3204644,
3204645,
3204646,
3204647,
3204648,
3204649,
3204650,
3204651,
3204652,
3204653,
3204654,
3204655,
3204656,
3204657,
3204658,
3204659,
3204660,
3204664,
3204665);




