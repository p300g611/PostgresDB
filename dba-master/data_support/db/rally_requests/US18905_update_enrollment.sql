--US18905 SR Prod: Student tied to two districts; one school. 
BEGIN;
UPDATE enrollment 
SET  activeflag = FALSE
   , modifieduser = 12
   , modifieddate = now() 
   , notes='As per US18905 enrollment inactivated'
WHERE id = 2390655 ;
COMMIT;

