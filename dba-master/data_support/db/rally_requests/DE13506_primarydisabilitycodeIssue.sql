/*
--validation 
select  primarydisabilitycode,count(*) from student s
--where primarydisabilitycode in ('am','id','sl','md')
group by primarydisabilitycode
order by 1;

select s.id,modifieduser,modifieddate,primarydisabilitycode current_primarydisabilitycode,
case when primarydisabilitycode='am'  then 'AM'
     when primarydisabilitycode='id'  then 'ID'
     when primarydisabilitycode='sl'  then 'SL'
     when primarydisabilitycode='md'  then 'MD'
     else primarydisabilitycode end updated_primarydisabilitycode
 from student s
where primarydisabilitycode in ('am','id','sl','md');
--report attached to DE13506(orginalUS16711)
*/
begin;
update student 
set modifieddate=now(),
    modifieduser=12,
    primarydisabilitycode=case when primarydisabilitycode='am'  then 'AM'
			       when primarydisabilitycode='id'  then 'ID'
			       when primarydisabilitycode='sl'  then 'SL'
			       when primarydisabilitycode='md'  then 'MD'
			      else primarydisabilitycode end
 where 	primarydisabilitycode in ('am','id','sl','md');
commit;
 	      
     

