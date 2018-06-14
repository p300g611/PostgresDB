begin;

 update student 
 set activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where id =1285220 and activeflag = true;

 update enrollment 
 set activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where studentid =1285220 and activeflag = true;

 update student 
 set statestudentidentifier = '2521639395', modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
 where id =1474399 and statestudentidentifier = '205634959';


 commit;
