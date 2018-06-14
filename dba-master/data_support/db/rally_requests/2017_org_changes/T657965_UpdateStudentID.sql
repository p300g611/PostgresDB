BEGIN;
update student 
set   statestudentidentifier='120053528',
      modifieddate = now(),
	  modifieduser=12
where id = 1310925;


INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 1310925, 12, now(), 'MERGE', '120052528',  '120053528' );
  
update student 
set   activeflag =false,
      modifieddate = now(),
	  modifieduser=12
where id in (675188,812455);

COMMIT;

 