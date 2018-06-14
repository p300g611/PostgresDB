-- select username,* from student where statestudentidentifier ='9991' and stateid=58538;
-- select username,* from student where statestudentidentifier ='9992' and stateid=58538;
-- select username,* from student where statestudentidentifier ='9993' and stateid=58538;
-- select username,* from student where statestudentidentifier ='9994' and stateid=58538;
-- select username,* from student where statestudentidentifier ='9995' and stateid=58538;
-- select username,* from student where statestudentidentifier ='9996' and stateid=58538;


begin;

update student
set username='elem.demo'
,modifieddate=now()
,modifieduser=12
where statestudentidentifier ='9991' and stateid=58538;

update student
set username='middle.demo'
,modifieddate=now()
,modifieduser=12
where statestudentidentifier ='9992' and stateid=58538;

update student
set username='high.demo'
,modifieddate=now()
,modifieduser=12
where statestudentidentifier ='9993' and stateid=58538;

update student
set username='pnp.elem.demo'
,modifieddate=now()
,modifieduser=12
where statestudentidentifier ='9994' and stateid=58538;

update student
set username='pnp.middle.demo'
,modifieddate=now()
,modifieduser=12
where statestudentidentifier ='9995' and stateid=58538;

update student
set username='pnp.high.demo'
,modifieddate=now()
,modifieduser=12
where statestudentidentifier ='9996' and stateid=58538;

commit ;
