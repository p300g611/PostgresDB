BEGIN;

--State ID - 1021639974 Local ID - 18000006

update student 
set    activeflag =false,
       modifieddate =now(),
	   modifieduser=12
where id =868680; 
     
update student 
set    statestudentidentifier ='1021639974',
       modifieddate =now(),
	   modifieduser=12
where id =1258866; 

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 1258866, 12, now(), 'MERGE', '18000006',  '1021639974' );	
  
  
-- State ID - 1021639966   Local ID - 19000005

update student 
set    activeflag =false,
       modifieddate =now(),
	   modifieduser=12
where id =1136335; 
     
update student 
set    statestudentidentifier ='1021639966',
       modifieddate =now(),
	   modifieduser=12
where id =1258859; 

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 1258859, 12, now(), 'MERGE', '19000005',  '1021639966' );	
  
  
--State ID - 1020161612   Local ID - 18000003
update student 
set    activeflag =false,
       modifieddate =now(),
	   modifieduser=12
where id =868679; 
     
update student 
set    statestudentidentifier ='1020161612',
       modifieddate =now(),
	   modifieduser=12
where id =1258867; 

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
  values('DATA_SUPPORT', 'STUDENT', 1258867, 12, now(), 'MERGE', '18000003',  '1020161612' );	
  
 
 
COMMIT;