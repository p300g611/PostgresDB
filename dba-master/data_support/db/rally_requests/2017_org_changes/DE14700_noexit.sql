
--prod
select *  from enrollmentsrosters where enrollmentid =2648357;
select * from enrollment  where id=2648357;
select * from enrollment  where studentid=171897;

select *  from enrollmentsrosters where enrollmentid =2425808;
select * from enrollment  where id=2425808;
select * from enrollment  where studentid=1096370;

select *  from enrollmentsrosters where enrollmentid =2648459;
select * from enrollment  where id=2648459;
select * from enrollment  where studentid=1329963;


begin;
update enrollmentsrosters
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
   where enrollmentid =2648357;  
   
update enrollment
set activeflag=false,
    modifieddate=now(),
    modifieduser=12,
    notes='DE14700 EP: Prod - TASC upload not allow for students to be enrolled in 2 schools for different'
   where id =2648357; 
    

update enrollmentsrosters
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
   where enrollmentid =2425808;  
   
update enrollment
set activeflag=false,
    modifieddate=now(),
    modifieduser=12,
    notes='DE14700 EP: Prod - TASC upload not allow for students to be enrolled in 2 schools for different'
   where id =2425808; 

update enrollmentsrosters
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
   where enrollmentid =2648459;  
   
update enrollment
set activeflag=false,
    modifieddate=now(),
    modifieduser=12,
    notes='DE14700 EP: Prod - TASC upload not allow for students to be enrolled in 2 schools for different'
   where id =2648459; 

  commit; 



 --stage
select *  from enrollmentsrosters where enrollmentid =2468642;
select * from enrollment  where id=2468642;
select * from enrollment  where studentid=171897;

select *  from enrollmentsrosters where enrollmentid =2425808;
select * from enrollment  where id=2425808;
select * from enrollment  where studentid=1096370;

select *  from enrollmentsrosters where enrollmentid =2606782;
select * from enrollment  where id=2606782;
select * from enrollment  where studentid=1329963;


begin;
update enrollmentsrosters
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
   where enrollmentid =2468642;  
   
update enrollment
set activeflag=false,
    modifieddate=now(),
    modifieduser=12,
    notes='DE14700 EP: Prod - TASC upload not allow for students to be enrolled in 2 schools for different'
   where id =2468642; 
    

update enrollmentsrosters
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
   where enrollmentid =2425808;  
   
update enrollment
set activeflag=false,
    modifieddate=now(),
    modifieduser=12,
    notes='DE14700 EP: Prod - TASC upload not allow for students to be enrolled in 2 schools for different'
   where id =2425808; 

update enrollmentsrosters
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
   where enrollmentid =2606782;  
   
update enrollment
set activeflag=false,
    modifieddate=now(),
    modifieduser=12,
    notes='DE14700 EP: Prod - TASC upload not allow for students to be enrolled in 2 schools for different'
   where id =2606782; 

  commit;  