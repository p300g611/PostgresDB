--studentID:4655626801. ayp:5790, attendance:5790, attendance DB id:1509

--inactive school
update enrollment 
set  activeflag = false, 
modifieduser = 12, modifieddate = now(), exitwithdrawaltype = -55,  
exitwithdrawaldate = now(), notes = 'inactivated according to US18864'
where id  = 2382235;


--active school
update enrollment 
set activeflag = true,modifieduser = 12, modifieddate = now(), exitwithdrawaltype = 0, 
 exitwithdrawaldate = null, notes = 'Reactivated according to US18864'
where id =  2330460;


--ELA STAGE 2
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2532165, modifieduser = 12, modifieddate = now()
      where id = 13122808;


--Math stage 2
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2791683, modifieduser = 12, modifieddate = now()
      where id = 13122810;	 


--Sci stage 3
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2273003, modifieduser = 12, modifieddate = now()
      where id = 13228690;	
	  
	  
--Sci stage 3
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2273003, modifieduser = 12, modifieddate = now()
      where id = 10879548;	

--Sci stage 2
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2273005, modifieduser = 12, modifieddate = now()
     where id = 13228689;
	  
--Sci stage 2
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2273005, modifieduser = 12, modifieddate = now()
      where id = 10879550;
	  
--Sci stage 1
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2273004, modifieduser = 12, modifieddate = now()
      where id = 10879549;

--Math stage 1
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2260121, modifieduser = 12, modifieddate = now()
      where id = 10084413;	  
	  
	  
--ELA STAGE 1 
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2266254, modifieduser = 12, modifieddate = now()
      where id = 10436531;		  
	  
--ELA performance 
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2192018, modifieduser = 12, modifieddate = now()
      where id = 9039165;	  
	  
--Math performance
UPDATE studentstests
set enrollmentid = 2330460,testsessionid = 2192009, modifieduser = 12, modifieddate = now()
      where id = 9031259;	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  