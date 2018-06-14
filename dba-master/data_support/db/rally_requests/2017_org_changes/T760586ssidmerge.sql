/*
validation
select tmpa.keptid,count(*)  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true
group by tmpa.keptid
having count(*)>1 ;

 keptid   | count
------------+-------
 7532148483 |     2
 3577608064 |     4

  6341538723 | 7532148483
 3826346696 | 7532148483
(2 rows)

aart-prod=> select * from tmp_merge where keptid='3577608064';
 retiredid  |   keptid
------------+------------
 6494265243 | 3577608064
 9245625745 | 3577608064


select * from (
 select s.id,s.statestudentidentifier,s.activeflag,s.modifieddate,legalfirstname,legallastname,st.testcount,''||'retired' actions  from student s
   inner join  (select retiredid  retiredid from  tmp_merge ) tmp on s.statestudentidentifier=tmp.retiredid  
     left outer join (select studentid,count(*) testcount from studentstests st 
                     group by studentid ) st on st.studentid=s.id
                     where s.stateid=51                     
   union 
    select s.id,s.statestudentidentifier,s.activeflag,s.modifieddate,legalfirstname,legallastname,st.testcount,''||'keptid' actions  from student s
   inner join  (select keptid  keptid from  tmp_merge ) tmp on s.statestudentidentifier=tmp.keptid  
     left outer join (select studentid,count(*) testcount from studentstests st 
                     group by studentid ) st on st.studentid=s.id
                     where s.stateid=51 ) sub 
                     order by statestudentidentifier,modifieddate;
                                       

select distinct s.id, s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true;

select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true) sub on keptid=s.statestudentidentifier;


select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true) sub on keptid=s.statestudentidentifier) sub on retiredid=s.statestudentidentifier
where st.status=86;


select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true) sub on keptid=s.statestudentidentifier;

select count(*) from student s
 inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
 where s.activeflag is true and stateid=51;



select count(distinct statestudentidentifier) from student s
 inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
 where s.activeflag is true and stateid=51;

select count(*) from student s
 inner join tmp_merge tmp on s.statestudentidentifier=tmp.keptid 
 where s.activeflag is true and stateid=51 --and modifieddate='2016-09-08 15:32:53.662999+00';



 select statestudentidentifier,count(*) from student s
 inner join tmp_merge tmp on s.statestudentidentifier=tmp.keptid 
 where s.activeflag is true and stateid=51 --and modifieddate='2016-09-08 15:32:53.662999+00'
 group by statestudentidentifier
 having count(*)>1;


 statestudentidentifier | count
------------------------+-------
 7532148483             |     2
(1 row)
*/
Drop table if exists tmp_merge_raw;
create temporary table tmp_merge_raw (retiredid text, keptid text, rdate text);
\copy tmp_merge_raw from '760586ssid.csv' DELIMITER ',' CSV HEADER;
select trim(retiredid) retiredid,trim(keptid) keptid into temp tmp_merge from tmp_merge_raw;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  select 'DATA_SUPPORT', 'STUDENT', s.id, 12, now(), 'MERGE', tmp.retiredid::JSON,  tmpa.keptid::JSON from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true
  and tmp.retiredid not in ('5175018965',
						'9784842661',
						'9436237383',
						'3579655264',
						'7516953598',
						'5946291416',
						'5964725112',
						'6996981441',
						'1871934494',
						'3488420701',
						'9245625745',
						'5972286343',
						'4882359901',
						'7018286794',
						'7649784886',
						'8292919538',
						'6494265243') ;

update student 
set activeflag=false,
   modifieduser=12,
   modifieddate=now()
where stateid=51 and statestudentidentifier in ('5175018965',
						'9784842661',
						'9436237383',
						'3579655264',
						'7516953598',
						'5946291416',
						'5964725112',
						'6996981441',
						'1871934494',
						'3488420701',
						'9245625745',
						'5972286343',
						'4882359901',
						'7018286794',
						'7649784886',
						'8292919538',
						'6494265243',
						'7532148483');

update student 
set activeflag=false,
   modifieduser=12,
   modifieddate=now()
where stateid=51 and activeflag is true and statestudentidentifier in (
select tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true
  and tmp.retiredid not in ('5175018965',
						'9784842661',
						'9436237383',
						'3579655264',
						'7516953598',
						'5946291416',
						'5964725112',
						'6996981441',
						'1871934494',
						'3488420701',
						'9245625745',
						'5972286343',
						'4882359901',
						'7018286794',
						'7649784886',
						'8292919538',
						'6494265243'));

update student
set statestudentidentifier=keptid,
   modifieduser=12,
   modifieddate=now()
from (select distinct s.id, s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true
  and tmp.retiredid not in ('5175018965',
						'9784842661',
						'9436237383',
						'3579655264',
						'7516953598',
						'5946291416',
						'5964725112',
						'6996981441',
						'1871934494',
						'3488420701',
						'9245625745',
						'5972286343',
						'4882359901',
						'7018286794',
						'7649784886',
						'8292919538',
						'6494265243')) sub where sub.id=student.id;					