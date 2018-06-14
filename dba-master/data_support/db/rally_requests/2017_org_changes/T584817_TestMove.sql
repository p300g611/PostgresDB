/*
SELECT distinct enr.id enrid, enr.activeflag, enr.rosterid enrrosterid,ts.id testsessionid, ts.rosterid tsrosterid,
ts.activeflag testsessionflag, iti.id itiid, iti.rosterid itirosterid


FROM enrollment en
inner join student stu on stu.id=en.studentid and stu.activeflag is true
inner join organization org on org.id =stu.stateid
inner join enrollmentsrosters enr on enr.enrollmentid=en.id
inner join  roster r on r.id =enr.rosterid and r.activeflag is true
inner join testsession ts on ts.rosterid=r.id and ts.activeflag is true
inner join ititestsessionhistory iti on iti.studentid=stu.id and ts.id =iti.testsessionid
inner join contentarea ca on ca.id =r.statesubjectareaid
where stu.id =700501 
--and ts.rosterid =857519 
--and ca.abbreviatedname ='ELA'
and en.currentschoolyear =2017 
and en.activeflag is true and iti.activeflag is true;
*/

BEGIN;
/*
--studentid:439147

update enrollmentsrosters 
set activeflag =false,
    modifieddate =now(),
	modifieduser =12
where id in (14606698,14606697);

--ELA
update testsession 
set rosterid = 1071799,
    modifieddate= now(),
		modifieduser =12
where id =3937169;

update ititestsessionhistory
set rosterid = 1071799,
    modifieddate= now(),
	modifieduser =12
where id= 666928;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 439147, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "3937169", "rosterid": 1075325}')::JSON,  ('{"Reason": "As Ticket584817, updated rosterid:1071799"}')::JSON);
--M

update testsession 
set rosterid = 1071798,
    modifieddate= now(),
		modifieduser =12
where id =3937138;

update ititestsessionhistory
set rosterid = 1071798,
    modifieddate= now(),
	modifieduser =12
where id= 666911;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 439147, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "3937138", "rosterid": 1075326}')::JSON,  ('{"Reason": "As Ticket584817, updated rosterid:1071798"}')::JSON);


--studentid:860588
update enrollmentsrosters 
set activeflag =false,
    modifieddate =now(),
	modifieduser =12
where id in (14603792,14603793);

--ELA

update testsession 
set rosterid = 1074047,
    modifieddate= now(),
	modifieduser =12
where id =3817810;

update ititestsessionhistory
set rosterid = 1074047,
    modifieddate= now(),
	modifieduser =12
where id= 541787;

--M
update testsession 
set rosterid = 1074048,
    modifieddate= now(),
		modifieduser =12
where id =3817811;


update ititestsessionhistory
set rosterid = 1074048,
    modifieddate= now(),
	modifieduser =12
where id= 541785;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
select 'DATA_SUPPORT', 'STUDENT', 860588, 12, now(), 'REST_TS_ROSTERID', '{"TestSessionIds": "3817810,3817811", "rosterid": "1074043,1074045"}'::JSON,  '{"Reason": "As Ticket584817, updated rosterid:1074047,1074048"}'::JSON;

--studnetid:857519,
update enrollmentsrosters 
set activeflag =false,
    modifieddate =now(),
	modifieduser =12
where id =14690478;

--M
update testsession 
set rosterid = 1080673,
    modifieddate= now(),
		modifieduser =12
where id IN (3846381,3846380,3846379,3846378);

update ititestsessionhistory
set rosterid = 1080673,
    modifieddate= now(),
	modifieduser =12
where id IN (582282,582281,582280,582279);

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
select 'DATA_SUPPORT', 'STUDENT', 857519, 12, now(), 'REST_TS_ROSTERID', '{"TestSessionIds": "3846381,3846380,3846379,3846378", "rosterid": "1080672"}'::JSON,  '{"Reason": "As Ticket584817, updated rosterid:1080673"}'::JSON;


--studentid:518705

update enrollmentsrosters 
set activeflag =false,
    modifieddate =now(),
	modifieduser =12
where id =14838334;

update testsession 
set rosterid = 1096833,
    modifieddate= now(),
		modifieduser =12
where id in (3909979,3902742,3902739);

update ititestsessionhistory
set rosterid = 1096833,
    modifieddate= now(),
	modifieduser =12
where id in(645403,639150,639148);

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
select 'DATA_SUPPORT', 'STUDENT', 518705, 12, now(), 'REST_TS_ROSTERID', '{"TestSessionIds": "3909979,3902742,3902739", "rosterid": "1086189"}'::JSON,  '{"Reason": "As Ticket584817, updated rosterid:1096833"}'::JSON;

--studentid:863995
update enrollmentsrosters 
set activeflag =false,
    modifieddate =now(),
	modifieduser =12
where id =14593991;

update testsession 
set rosterid = 1070646,
    modifieddate= now(),
		modifieduser =12
where id =3846987;

update ititestsessionhistory
set rosterid = 1070646,
    modifieddate= now(),
	modifieduser =12
where id =582822;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
select 'DATA_SUPPORT', 'STUDENT', 863995, 12, now(), 'REST_TS_ROSTERID', '{"TestSessionIds": "3846987", "rosterid": "1070670"}'::JSON,  '{"Reason": "As Ticket584817, updated rosterid:1070646"}'::JSON;
*/
--studentid:1206468
update enrollmentsrosters 
set activeflag =false,
    modifieddate =now(),
	modifieduser =12
where id =14604552;

update testsession 
set rosterid = 1074514,
    modifieddate= now(),
		modifieduser =12
where id in(3947004,3947013,3947009,3947005,3947008,3947011);

update ititestsessionhistory
set rosterid = 1074514,
    modifieddate= now(),
	modifieduser =12
where id in (674566,674575,674571,674567,674570,674573);

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
select 'DATA_SUPPORT', 'STUDENT', 1206468, 12, now(), 'REST_TS_ROSTERID', '{"TestSessionIds": "3947004,3947013,3947009,3947005,3947008,3947011", "rosterid": "1074516"}'::JSON,  '{"Reason": "As Ticket584817, updated rosterid:1074514"}'::JSON;

COMMIT;

