1025179781
98048

1010431804
102829

1013941853
73242

1026603501
100297

1025258088
97506

1020476303
87774

1021735639
90434

1022099043
97572

1021705845
88686

1027465862
101567

1016472439
81017

1016866887
93911

1020480084
87402

1018778918
91845
--
select distinct stud.statestudentidentifier ssid, stud.id studentid, stud.legalfirstname,stud.legallastname,gr.abbreviatedname grade,
en.id as enrollmentid,en.activeflag,ort.schoolid,ort.schooldisplayidentifier,ort.schoolname,ort.districtname,orgtd.statename
from student stud
left outer join  enrollment en on en.studentid = stud.id
left outer join organizationtreedetail ort on ort.schoolid = en.attendanceschoolid
left outer join organizationtreedetail orgtd on orgtd.stateid = stud.stateid
left outer join gradecourse gr on gr.id =en.currentgradelevel
--where stud.id =	255518 and currentschoolyear =2018;
where stud.statestudentidentifier in ('1025179781')and currentschoolyear =2018;






select distinct s.id sid, s.statestudentidentifier ssid
--,s.legalfirstname, s.legallastname
,en.id enid
--,en.activeflag eflag
,st.id stid
,st.status st_status,st.activeflag stfalg
,ts.id tsid
 ,ts.rosterid,ts.name
 ,t.id testid
 ,sv.id svid
,ca.abbreviatedname sub
,tt.id ttid
from enrollment en 
join student s on s.id=en.studentid
left outer join  gradecourse  eg on eg.id=en.currentgradelevel
left outer join studentstests st on st.enrollmentid =en.id 
left outer join test  t on t.id =st.testid							  
left outer join testsession ts on ts.id =st.testsessionid
left outer join studentstestsections  sts on sts.studentstestid =st.id
left outer join testsection tt on tt.id=sts.testsectionid
left outer join testcollection tc on tc.id=st.testcollectionid
left outer join contentarea ca on ca.id=tc.contentareaid
left outer join studentsresponses sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
left outer join survey sv on sv.studentid = s.id
where en.currentschoolyear=2018and s.id=1469522 and ca.abbreviatedname='M'
and s.statestudentidentifier in ('98048')
and st.id in (22968770,21409660,21448013,21449154,22314873,22317805,21394941)
order by ca.abbreviatedname,ts.name;

select distinct e.studentid,e.id enrollmentid, e.attendanceschoolid,e.activeflag e_flag,er.rosterid,er.id erid,er.activeflag er_active,er.modifieddate, statesubjectareaid,teacherid 
from enrollment e
left outer join enrollmentsrosters er on er.enrollmentid=e.id 
left outer  join roster r on r.id=er.rosterid
where  e.currentschoolyear=2018 and e.studentid in (969360,669152)
order by statesubjectareaid,er.activeflag;

select * from student where statestudentidentifier in ('1010431804','102829');
---SSID:1025179781 , old ssid:98048

begin;
update student 
set  statestudentidentifier='1025179781',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id =1469522;
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3382169;
	 
	 
--SSID:1010431804 , old ssid:102829 --------------------------------------
update student 
set  statestudentidentifier='1010431804',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id =1470637;
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396526;
	 
update studentstests 
set    enrollmentid = 3396996,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='For ticket #339510'
where studentid =1470637 and enrollmentid =3396526
and id in (22968770,21409660,21448013,21449154,22314873,22317805,21394941);

update testsession
set   name ='DLM-PalazzoloVivianna-969360-FT YE ELA RI.11-12.3 DP'
      rosterid=
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =6969504;



	 
	 


--SSID:1026603501, old ssid:100297-------------------------------------------------







--SSID:1013941853, old ssid:73242

update student 
set  statestudentidentifier='1013941853',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470638,533192);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396527;




--SSID:1025258088, old ssid:97506

update student 
set  statestudentidentifier='1025258088',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470642);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396531;
	 
----SSID:1020476303, old ssid:87774
update student 
set  statestudentidentifier='1020476303',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470643);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396533;
	 
	 
----SSID:1021735639, old ssid:90434
update student 
set  statestudentidentifier='1021735639',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470644);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396534;

----SSID:1022099043, old ssid:97572
update student 
set  statestudentidentifier='1022099043',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470645);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396535;

----SSID:1021705845, old ssid:88686
update student 
set  statestudentidentifier='1021705845',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470646);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396536;



----SSID:1027465862, old ssid:101567
update student 
set  statestudentidentifier='1027465862',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470640);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396529;

--SSID:1016472439 ,old ssid:81017
update student 
set  statestudentidentifier='1016472439',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470635);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396524;
	 
--SSID:1016866887 ,old ssid:93911
update student 
set  statestudentidentifier='1016866887',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470636);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396525;

--SSID:1020480084 ,old ssid:87402
update student 
set  statestudentidentifier='1020480084',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470647);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396537;
	 
--SSID:1018778918 ,old ssid:91845
update student 
set  statestudentidentifier='1018778918',
     activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id in (1470648);
	 
 	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #339510'
	 where id =3396538;


commit;





select id,statestudentidentifier  from student where statestudentidentifier in ('1026603501','100297');

select id,teststatus,contentareaname,count(*) from masterpull_item 
where id in (1470639,1242026)
group by id,teststatus,contentareaname;


1025179781  --new ela, math and sci and olds just math 
98048
│   id    │ statestudentidentifier │
├─────────┼────────────────────────┤
│ 1097454 │ 1025179781             │
│ 1469522 │ 98048                  │
└─────────┴────────────────────────
1097454|complete|ELA|37
1097454|complete|M|34
1097454|complete|Sci|32
1097454|unused|Sci|3
1469522|complete|M|34

1010431804 -- old id math completed and new ids ela, Sci completed
102829
│   id    │ statestudentidentifier │
├─────────┼────────────────────────┤
│  969360 │ 1010431804             │
│ 1470637 │ 102829                 │
└─────────┴────────────────────────
969360|complete|M|38
969360|complete|Sci|23
969360|unused|Sci|3
1470637|complete|ELA|37

1013941853    --no completed tests
73242
   id    │ statestudentidentifier │
├─────────┼────────────────────────┤
│ 1097443 │ 1013941853             │
│  533192 │ 1013941853             │
│ 1470638 │ 73242                  │
└─────────┴────────────────────────┘
1097443|complete|ELA|37
1097443|complete|M|37
1097443|complete|SS|1
1097443|complete|Sci|36

1026603501   -- old id ela, Sci completed and new ids  math completed
100297
   id    │ statestudentidentifier │
├─────────┼────────────────────────┤
│ 1470639 │ 100297                 │
│ 1242026 │ 1026603501             │
└─────────┴────────────────────────┘
1242026|complete|M|38
1470639|complete|ELA|41
1470639|complete|Sci|42

1025258088  -- no tests with old id 
97506

1020476303 -- no tests with old id 
87774

1021735639  -- no tests with old id 
90434

1022099043  -- no tests with old id 
97572

1021705845  -- no tests with old id 
88686

1027465862  -- no tests with old id 
101567

1016472439  -- no tests with old id 
81017

1016866887  -- no tests with old id 
93911

1020480084  -- no tests with old id 
87402

1018778918   -- no tests with old id 
91845









