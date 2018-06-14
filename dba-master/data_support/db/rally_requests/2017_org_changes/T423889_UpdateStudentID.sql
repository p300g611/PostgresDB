BEGIN;

update student 
set   activeflag =false,
      modifieddate = now(),
	  modifieduser=12
where id = 1096778 ;


update student 
set   statestudentidentifier='1019293152',
      modifieddate = now(),
	  modifieduser=12
where id = 1323270;


INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 1323270, 12, now(), 'MERGE', '22161',  '1019293152' );
  
COMMIT;