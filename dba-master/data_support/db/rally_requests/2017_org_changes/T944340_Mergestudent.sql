select * from student  where statestudentidentifier='40049381';
select * from student  where statestudentidentifier='40049382';


begin;

update student 
set  activeflag=false 
    ,modifieddate =now()
    ,modifieduser=174744
where id=1133224;


update enrollment 
set activeflag=false 
    ,modifieddate =now()
    ,notes ='Ticket #944340'
    ,modifieduser=174744
where studentid=1133224;

update student 
set  statestudentidentifier='40049381'
    ,modifieddate =now()
    ,modifieduser=174744
where id=1396990;

commit;