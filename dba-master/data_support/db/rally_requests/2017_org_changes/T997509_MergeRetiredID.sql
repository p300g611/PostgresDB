/*
Drop table if exists mergid;
Drop table if exists tmp_merge;

create temporary table mergid (retiredid text, keptid text);

\COPY mergid FROM merge_id.csv DELIMITER ',' CSV HEADER; 

select  trim(retiredid) retiredid, trim(keptid) keptid into temp tmp_merge from mergid;

validation
select distinct tmp.retiredid, tmpa.keptid from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
left outer join student st on st.statestudentidentifier = tmpa.keptid
where s.stateid=51 and s.activeflag is true;
│ retiredid  │   keptid   │
├────────────┼────────────┤
│ 8195302114 │ 3253289583 │
│ 9125859129 │ 2076605053 │
│ 2339297362 │ 5388115615 │
│ 1385545453 │ 8755938965 │
│ 9359582271 │ 8218537945 │
│ 7315738282 │ 6579597968 │
│ 6090642193 │ 4849334733 │
│ 6799232829 │ 7981737974 │
│ 9162964631 │ 2411455003 │
│ 3600123017 │ 7216592255 │
│ 5529823599 │ 1882102967 │
│ 8172172672 │ 9732787422 │
│ 6408438016 │ 3763590161 │
│ 3304726322 │ 3420452799 │
│ 9331675844 │ 8452961952 │
│ 1319632629 │ 3731179148 │
│ 8728474104 │ 3926567295 │
│ 5895467059 │ 2316228232 │
│ 6043907526 │ 4631453869 │
│ 6194603097 │ 4622965933 │
│ 3364941483 │ 2849552119 │
│ 3489736907 │ 8257060348 │
│ 7442185118 │ 6179102902 │
└────────────┴────────────┘
(23 rows)
select tmp.retiredid, tmpa.keptid from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.keptid 
left outer join tmp_merge tmpa on tmp.retiredid=tmpa.retiredid
where s.stateid=51 and s.activeflag is true;

select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true) sub on keptid=s.statestudentidentifier;
│   keptid   │ retiredid  │
├────────────┼────────────┤
│ 2849552119 │ 3364941483 │
│ 8218537945 │ 9359582271 │
│ 2076605053 │ 9125859129 │
│ 8755938965 │ 1385545453 │
│ 3253289583 │ 8195302114 │
└────────────┴────────────┘
(5 rows)
select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 and s.activeflag is true) sub on retiredid=s.statestudentidentifier;
│   keptid   │ retiredid  │
├────────────┼────────────┤
│ 3731179148 │ 1319632629 │
│ 1882102967 │ 5529823599 │
│ 3420452799 │ 3304726322 │
└────────────┴────────────┘
(3 rows)
select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select distinct keptid,retiredid from studentstests st 
  inner join student s on s.id=st.studentid
  inner join (select s.statestudentidentifier,tmp.retiredid,tmpa.keptid  from student s
inner join tmp_merge tmp on s.statestudentidentifier=tmp.retiredid 
left outer join tmp_merge tmpa on tmp.keptid=tmpa.keptid
where s.stateid=51 ) sub on keptid=s.statestudentidentifier) sub on retiredid=s.statestudentidentifier
where st.status=86;
┌────────┬───────────┐
│ keptid │ retiredid │
├────────┼───────────┤
└────────┴───────────┘
(0 rows)
select stu.id as studentid,stu.activeflag as studentflag, en.id as enrollmentid,en.currentschoolyear, st.id as studentstestid, st.enrollmentid, st.studentid 
from student stu
left outer join  enrollment en on en.studentid = stu.id
left outer join studentstests st on st.enrollmentid = en.id
where stu.statestudentidentifier ='3304726322';
*/
BEGIN;

update student 
set activeflag =false,
    modifieddate=now(),
    modifieduser =12	
where  statestudentidentifier in(
                                '8195302114',
								'9125859129',
								'2339297362',
								'1385545453',
								'9359582271',
								'7315738282',
								'6090642193',
								'6799232829',
								'9162964631',
								'3600123017',
								'8172172672',
								'6408438016',
								'9331675844',
								'8728474104',
								'5895467059',
								'6043907526',
								'6194603097',
								'3364941483',
								'3489736907',
								'7442185118');
								
update student 
set activeflag =false,
    modifieddate=now(),
    modifieduser =12	
where 	statestudentidentifier in ('3731179148','1882102967','3420452799');


update student 
set activeflag =false,
    statestudentidentifier ='3731179148',
    modifieddate=now(),
    modifieduser =12	
where id = 345346;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 345346, 12, now(), 'MERGE', '1319632629',  '3731179148' );	

update  student
set   	statestudentidentifier ='3731179148',
        modifieddate=now(),
        modifieduser =12	
where 	id = 704512;


INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 704512, 12, now(), 'MERGE', '1319632629',  '3731179148' );	

  
update student 
set    statestudentidentifier ='1882102967',
       modifieddate=now(),
       modifieduser =12	
where id = 755229;
  
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 755229, 12, now(), 'MERGE', '5529823599',  '1882102967' );

  
update student 
set activeflag =false,
    statestudentidentifier ='3420452799',
    modifieddate=now(),
    modifieduser =12	
where id = 218721;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 218721, 12, now(), 'MERGE', '3304726322',  '3420452799' );	
  
update student 
set activeflag =false,
    statestudentidentifier ='3420452799',
    modifieddate=now(),
    modifieduser =12	
where id = 1118941;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 1118941, 12, now(), 'MERGE', '3304726322', '3420452799' );
  
COMMIT;


