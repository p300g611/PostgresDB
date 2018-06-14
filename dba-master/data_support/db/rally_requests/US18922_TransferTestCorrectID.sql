

BEGIN;

--StudentID:221266653,9459782674. The student completed testa under both ID. All the tests needs to be merged under 221266653 whick is the correct ID

--inactive studentID:9459782674
update  student
    set activeflag = false,
        modifieddate = now(),
	    modifieduser = 12
    where id = 1294465;
	
--inactive enrollment studentID:9459782674
update enrollment
    set activeflag = false,
	    modifieddate = now(),
	    modifieduser = 12,
		notes = 'As per us18922 inactived'
	where id = 2326600;
	
--update enrollmentsrosters
update enrollmentsrosters
   set enrollmentid = 2379422,
        modifieddate = now(),
	    modifieduser = 12
	 where id = 14310867;
	 
--transfer test to correct studentstests.
update studentstests
     set  enrollmentid = 2379422,
          studentid=1317705,	 
	      modifieddate = now(),
	      modifieduser = 12
     where id in (14218342,14198723,14192333,14173362,14166434,14130486,13747695)
	      and studentid=1294465;
		  
--transfer test to correct studentstests.
update studentsresponses
     set  studentid=1317705,	 
	      modifieddate = now(),
	      modifieduser = 12
     where studentstestsid in (14218342,14198723,14192333,14173362,14166434,14130486,13747695)
	      and studentid=1294465;		  
 
 
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 1317705, 12, now(), 'REST_TS_ENROLLMENTID', ('{"Studentstests": "14218342,14198723,14192333,14173362,14166434,14130486,13747695", "enrollmentid": 2326600}')::JSON,  ('{"Reason": "As per US18922, updated rosterid:2379422"}')::JSON);

COMMIT;