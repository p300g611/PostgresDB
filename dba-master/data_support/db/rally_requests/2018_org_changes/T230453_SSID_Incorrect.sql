begin;

update  enrollment e
set    modifieddate =now(),
       modifieduser =174744,
       activeflag =false, 
       notes =coalesce(notes,'')||'ticket#230453'
where id 
in ( select e.id from enrollment e 
 inner join student s on s.id=e.studentid 
 where s.statestudentidentifier  in 
('2197622009'
,'8168895780'
,'8149048633'
,'9909057526'
,'5936619975'
,'4344660579'
,'9600375404'
,'6027643154'
,'7462552304'
,'4318353445'
,'9747357743'
,'5868711927'
,'7289391795'
,'9882314915'
) and s.stateid=9633 and s.activeflag is true )
and e.activeflag is true;

update  student s
set    modifieddate =now(),
       modifieduser =174744,
       activeflag =false
where id 
in ( select s.id from student s
 where s.statestudentidentifier  in 
('2197622009'
,'8168895780'
,'8149048633'
,'9909057526'
,'5936619975'
,'4344660579'
,'9600375404'
,'6027643154'
,'7462552304'
,'4318353445'
,'9747357743'
,'5868711927'
,'7289391795'
,'9882314915'
,'2204185158') and s.stateid=9633 and s.activeflag is true )
and s.activeflag is true;


update  student 
set    modifieddate =now(),
       modifieduser =174744,
       statestudentidentifier= case
            when statestudentidentifier='25076'     then'2197622009'
     when statestudentidentifier='2025500' then 	   '8168895780'
     when statestudentidentifier='2025523' then 	   '8149048633'
     when statestudentidentifier='20225122' then 	   '9909057526'
     when statestudentidentifier='20235115' then 	   '5936619975'
     when statestudentidentifier='20266523' then 	   '4344660579'
     when statestudentidentifier='485336746' then 	   '9600375404'
     when statestudentidentifier='602764315' then 	   '6027643154'
     when statestudentidentifier='746255230' then 	   '7462552304'
     when statestudentidentifier='4318353442' then 	   '4318353445'
     when statestudentidentifier='4571281277' then 	   '9747357743'
     when statestudentidentifier='7647968838' then 	   '5868711927'
     when statestudentidentifier='9195108452' then 	   '7289391795'
     when statestudentidentifier='9882314916' then 	   '9882314915' 
     when statestudentidentifier='220418515'  then 	   '2204185158' 
	 end 
where id 
in ( select s.id from student s
 where s.statestudentidentifier  in 
('25076'    
,'2025500'
,'2025523'
,'20225122'
,'20235115'
,'20266523'
,'485336746'
,'602764315'
,'746255230'
,'4318353442'
,'4571281277'
,'7647968838'
,'9195108452'
,'9882314916'
,'220418515') and s.stateid=9633) and s.activeflag is true;


commit;



