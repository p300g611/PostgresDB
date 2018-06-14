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
     userstory:='DE13447'; --please add user story number
      
--STUDENT:1302794
    WITH updated_rows AS (  update testsession
			    set rosterid=1059248
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1302794)
		                      and rosterid = 1058000
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1302794:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1302794, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3053469,3132547,3153202,3156091", "rosterid": "1058000"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1059248"}')::JSON);

--STUDENT:1302793
    WITH updated_rows AS (  update testsession
			    set rosterid=1059250
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1302793)
		                      and rosterid = 1029609
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1302793:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1302793, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3226109,3226111,3226112,3226110,3202382,3156228,3131970,3086494,3073785,3053661", "rosterid": "1029609"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1059250"}')::JSON);
--STUDENT:1302790
    WITH updated_rows AS (  update testsession
			    set rosterid=1059246
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1302790)
		                      and rosterid = 1029614
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1302790:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1302790, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3218183,3218187,3218181,3218185,3202371,3157319,3136136,3084848,3066459,3053633", "rosterid": "1029614"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1059246"}')::JSON);
--STUDENT:1302792
    WITH updated_rows AS (  update testsession
			    set rosterid=1059246
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1302792)
		                      and rosterid = 1029614
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1302792:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1302792, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3212974,3212972,3212973,3214450,3204120,3159219,3156217,3151771,3131960,3053651", "rosterid": "1029614"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1059246"}')::JSON);
--STUDENT:1302791
    WITH updated_rows AS (  update testsession
			    set rosterid=1059246
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1302791)
		                      and rosterid = 1029614
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1302791:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1302791, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3203856,3203855,3206749,3203854,3183818,3156208,3151761,3131951,3071269,3053642", "rosterid": "1029614"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1059246"}')::JSON);
--STUDENT:1315136
    WITH updated_rows AS (  update testsession
			    set rosterid=1060286
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1315136)
		                      and rosterid = 1054601
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1315136:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1315136, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3121687,3124655,3121685,3121686,3117945,3107441,3105476,3101211,3095950,3055068", "rosterid": "1054601"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1060286"}')::JSON);
--STUDENT:1315136
    WITH updated_rows AS (  update testsession
			    set rosterid=1060287
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1315136)
		                      and rosterid = 1054602
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1315136:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1315136, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3102922,3100741,3096557,3054399", "rosterid": "1054602"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1060287"}')::JSON);

--STUDENT:1302794
    WITH updated_rows AS (  update testsession
			    set rosterid=1059246
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1302794)
		                      and rosterid = 1029614
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1302794:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1302794, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3220057,3220058,3220056,3220059,3213381,3202389,3186559,3156238,3131977,3053672", "rosterid": "1029614"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1059246"}')::JSON);

--STUDENT:1302793
    WITH updated_rows AS (  update testsession
			    set rosterid=1059249
				,modifieddate=now_date
				,modifieduser=aart_userid
				--select id from testsession
		           where id in (select testsessionid from student s
						    inner join enrollment e on e.studentid=s.id
						    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
						    where s.id=1302793)
		                      and rosterid = 1029608
		            RETURNING 1
		          ) SELECT COUNT(*) FROM updated_rows INTO row_count;
	RAISE NOTICE 'Total Number of rows updated for studentid_1302793:%', row_count;
	
        RAISE NOTICE 'Insert record into domainaudithistory';
	INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        VALUES('DATA_SUPPORT', 'STUDENT', 1302793, aart_userid, now_date, 'REST_TS_ROSTERID', ('{"TestSessionIds": "3132538,3084691,3073594,3053460", "rosterid": "1029608"}')::JSON,  ('{"Reason": "As per:'||userstory||',updated rosterid:1059249"}')::JSON);
END;
$BODY$; 		