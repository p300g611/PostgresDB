--begin;
DO
$BODY$
DECLARE
       now_date timestamp with time zone; 
       aart_userid integer;
       row_count integer;
       userstory text;
BEGIN
     now_date :=now();
     aart_userid :=(SELECT id FROM aartuser WHERE username = 'cetesysadmin');
     row_count:=0;
     userstory:='US18991'; --please add user story number 

    --student 4793972620   
    WITH updaterows AS (update enrollment 
			      set activeflag = false,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 Inactivated'
                              where id = 2370800 and activeflag = true
					RETURNING 1 )
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;  

  WITH updaterows AS (update enrollmentsrosters 
			      set enrollmentid = 2326959,
				  modifieddate = now_date,
				  modifieduser =aart_userid
                              where enrollmentid = 2370800 and rosterid=1035630
							 RETURNING 1 )
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;  

     WITH updaterows AS (update studentstests 
			      set enrollmentid = 2326959,
			          studentid=1294822,
				  modifieddate = now_date,
				  modifieduser =aart_userid
                              where enrollmentid = 2370800 and studentid=1314019
							 RETURNING 1 )
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;  

        INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1294822,aart_userid, now_date, 'REST_STEST', ('{"enrollmentid": "2326959", "studentid": "1294822"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated enrollmentid:2370800"}')::JSON);


  --student 4824036760
  WITH updated_rows AS (  update student
			    set activeflag=false,
			    statestudentidentifier ='4824036760_old',
				modifieddate=now_date
				,modifieduser=aart_userid
		           where  statestudentidentifier ='4824036760' and id=1295274 
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;
	
    WITH updated_rows AS (  update student
			    set 
			    statestudentidentifier ='4824036760',
				modifieddate=now_date
				,modifieduser=aart_userid
		           where  statestudentidentifier ='223480765' and id=1319466 
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated:%', row_count;
	

     WITH updaterows AS (update enrollment 
			      set activeflag = false,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 Inactivated'
                              where id = 2382509 and activeflag = true
					RETURNING 1 )
 select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;
    					
   WITH updaterows AS (update enrollment 
			      set studentid = 1319466,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 updated studentid 1319466 from 1295274'
                              where id = 2327415 and studentid = 1295274	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;
    
 WITH updaterows AS (update enrollmentsrosters 
			      set enrollmentid = 2327415,
				  modifieddate = now_date,
				  modifieduser =aart_userid
                              where enrollmentid = 2382509 
					RETURNING 1 )
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count; 

   --student  8150250486
WITH updaterows AS (update enrollment 
			      set aypschoolid = 72944,
			      aypschoolidentifier='310100010064',
			      residencedistrictidentifier='310100010000',
			      attendanceschoolid=72944,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 updated school  310100010064 from 307500011094'
                              where id = 2381570 	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;
     
    --student  8482729034--verified
WITH updaterows AS (update enrollment 
			      set aypschoolid = 77346,
			      aypschoolidentifier='580104030005',
			      residencedistrictidentifier='580104030000',
			      attendanceschoolid=77346,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 updated school  580104030005 from 030601060001'
                              where id = 2387706 	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count; 

WITH updaterows AS (update student 
			      set activeflag = false,
				  modifieddate = now_date,
				  modifieduser =aart_userid
                              where id = 1308376 	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;     
     
   --student  7191833895--verified
WITH updaterows AS (update enrollment 
			      set aypschoolid = 74183,
			      aypschoolidentifier='331400010777',
			      residencedistrictidentifier='331400010000',
			      attendanceschoolid=74183,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 updated school  331400010777 from 800000064752'
                              where id = 2381570 	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;
     
    --student  3794723110
WITH updaterows AS (update enrollment 
			      set aypschoolid = 73228,
			      aypschoolidentifier='310200999592',
			      residencedistrictidentifier='000000000008',
			      attendanceschoolid=73228,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 updated school  310200999592 from 471101997806'
                              where id = 2392925 	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count; 
   --student  7560859673
WITH updaterows AS (update enrollment 
			      set aypschoolid = 75038,
			      aypschoolidentifier='333200011403',
			      residencedistrictidentifier='333200010000',
			      attendanceschoolid=75038,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 updated school  333200011403 from 310200999413'
                              where id = 2381128 	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count;
     
    --student  4259046332
WITH updaterows AS (update enrollment 
			      set aypschoolid = 75536,
			      aypschoolidentifier='343000010112',
			      residencedistrictidentifier='343000010000',
			      attendanceschoolid=75536,
				  modifieddate = now_date,
				  modifieduser =aart_userid,
				  notes='As per US18991 updated school  343000010112 from 320800010100'
                              where id = 2395272 	
					RETURNING 1 )					
    select count(*) from updaterows into row_count;
    RAISE NOTICE 'Total Numbe of rows of updated on enrollment:%',row_count; 

    
            
END;
$BODY$;