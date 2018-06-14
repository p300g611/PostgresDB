--update student ID. incorrect ID: 2800012349, correct ID:280012349

BEGIN;


update student
set statestudentidentifier = statestudentidentifier||'_old',
    modifieddate = now(),
      activeflag=false,
	modifieduser =12
	where id = 912137;
 
update student
set statestudentidentifier = '280012349',
    modifieddate = now(),
	modifieduser =12
	where id = 1209096;
	
	
COMMIT;