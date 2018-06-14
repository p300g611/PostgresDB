  BEGIN;
 --Sci
 --statestudentID: 2439853801
	    update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10722144 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10727841 and activeflag is false;
				
--statestudentID: 2602085944

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id in(10870935,10870936)and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id in(10720112,10720116) and activeflag is false;
				
--statestudentID:2939623163	

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10726541 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10728184 and activeflag is false;

--statestudentID: 4492459464	

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10727250 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10727853 and activeflag is false;			
				
--statestudentID:4709142742	

        update  studentstests
	        set activeflag = false,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10860970,10860965) and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10693741,10693746) and activeflag is false;
				
		update studentstests
            set enrollmentid = 	2052551, testsessionid = 2267465,	
			    modifieddate = now(),
		        modifieduser =aart_userid
				where id = 10860967;
				
		

         INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
         VALUES('DATA_SUPPORT', 'STUDENT', 605790, 12, now(), 'REST_ST_ENROLLMENTID', ('{"STUDNETTESTID": "10860967", "enrollmentid": "2364910"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated enrollmentid:2052551"}')::JSON);

--statestudentID: 4769659202

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10694383 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10699271 and activeflag is false;
				
--statestudentID:5329121183

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id in(13950975,10727194,10727191) and activeflag is true;
				
				
--statestudentID: 5330849594

		update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10724104 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10728033 and activeflag is false;	

--statestudentID:5405808776				
        				
        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10727618 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10718742 and activeflag is false;
				
--statestudentID:5935239035	

        update  studentstests
	        set activeflag = false,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10701152,10701156,10701153) and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10699013,10699017,10699010) and activeflag is false;		

--statestudentID:6078978837		

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10694629 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10699281 and activeflag is false;		
				
--statestudentID:6899831325		

        update  studentstests
	        set activeflag = false,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10722181,10722185,10722189) and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10727864,10727868,10727872) and activeflag is false;	
				
--statestudentID:7406898142

        update  studentstests
	        set activeflag = false,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10847893,10847897,10847895) and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =aart_userid
				where id in (10691981,10691984,10691977) and activeflag is false;	

--statestudentID:8874171951			

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10727373 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10728219 and activeflag is false;	
				
--SS
--statestudentID:4709142742
		 
		update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10667606 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10549134 and activeflag is false;

--statestudentID:5329121183				

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10570710 and activeflag is true;
				
--statestudentID:5405808776		

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10571027 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10564911 and activeflag is false;	
				
				
--statestudentID: 6899831325	

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10567239 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10571395 and activeflag is false;	

--statestudentID: 7154343826

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10578785 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10562823 and activeflag is false;	

--statestudentID:7406898142		

        update  studentstests
		    set activeflag = false,
				modifieddate = now(),
				modifieduser =12
				where id = 10658594 and activeflag is true;
				
		
	    update  studentstests
	        set activeflag = true,
	            modifieddate = now(),
		        modifieduser =12
				where id = 10547840 and activeflag is false;	
COMMIT;				