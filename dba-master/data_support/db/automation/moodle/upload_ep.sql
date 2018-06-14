DROP TABLE IF EXISTS  tmp_user_training_raw ;
DROP TABLE IF EXISTS  tmp_user_training ;
CREATE TEMPORARY TABLE tmp_user_training_raw(   
                                        LastName                      text ,
                                        FirstName                     text ,
                                        Email                         text , 
                                        idnumber                      text ,
                                        --state                         text ,
                                        DistrictName                  text ,
                                        --DistrictID                    text ,
                                        SchoolName                    text ,
                                        --SchoolID                      text ,
                                        RTComplete                    text , 
                                        RTCompleteDate                text ); 


\COPY tmp_user_training_raw FROM '/srv/extracts/helpdesk/moodle/upload_ep/user_training.csv' DELIMITER ',' CSV HEADER ;   
--\COPY tmp_user_training_raw FROM 'user_training.csv' DELIMITER ',' CSV HEADER ;   

SELECT                                  ROW_NUMBER() over()+1 as  row_num,
                                        cast('' as text)          error_msg,
                                        trim(LastName)            LastName,
                                        trim(FirstName)           FirstName,
                                        trim(Email)               Email, 
                                        trim(idnumber)            idnumber,
                                        --trim(state)               state,
                                        trim(DistrictName)        DistrictName,
                                        --trim(DistrictID)          DistrictID,
                                        trim(SchoolName)          SchoolName,
                                        --trim(SchoolID)            SchoolID,
                                        trim(RTComplete)          RTComplete, 
                                        trim(RTCompleteDate)      RTCompleteDate
                                 INTO TEMP tmp_user_training FROM tmp_user_training_raw;

DO
$BODY$
DECLARE
	 now_date timestamp with time zone; 
	 tmp_table record ;
	 record_cnt integer;
	 err_msg TEXT;
	 ceteSysAdminUserId bigint;
	 aartuser_id bigint;
	 RTCompleteDate_cdt timestamp with time zone;
	 school_year integer; 
BEGIN
	 now_date :=now();
	 record_cnt:=1;
	 school_year:=2018;
	 SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin' and activeflag is true);

FOR tmp_table IN (SELECT idnumber,case when cast(upper(COALESCE(RTComplete,'N')) as char(1)) = 'Y' then 'Y' else 'N' end RTComplete,RTCompleteDate,row_num,error_msg FROM tmp_user_training)
  LOOP   
        record_cnt:=record_cnt+1;
	RAISE NOTICE 'processing row(%)>> idnumber:%,RTComplete:%,RTCompleteDate:%'
	                                 ,record_cnt,tmp_table.idnumber,tmp_table.RTComplete,tmp_table.RTCompleteDate ;
    BEGIN
        RTCompleteDate_cdt:=(tmp_table.RTCompleteDate::timestamp without time zone AT TIME ZONE 'CST6CDT');
        SELECT INTO aartuser_id (SELECT id FROM aartuser WHERE id=tmp_table.idnumber::bigint);
        IF (tmp_table.RTCompleteDate is null or tmp_table.RTComplete<>'Y'  or aartuser_id is null) 
          THEN
           err_msg = '<error> incomplete row on RTCompleteDate:'||cast(coalesce(tmp_table.RTCompleteDate,'NULL') as text) || ' or RTComplete:'||COALESCE(tmp_table.RTComplete,'NULL') ||' or idnumber:'||COALESCE(tmp_table.idnumber,'NULL')||' or idnumber(DB):'||COALESCE(aartuser_id,0);
           RAISE NOTICE 'Error message is %',err_msg;	
           UPDATE tmp_user_training
           SET error_msg=err_msg
           WHERE row_num=tmp_table.row_num;
	  ELSE	
	   RAISE NOTICE 'Insert row processing';
	   err_msg = '';
             IF((select count(*) from userpdtrainingdetail  
                                  where userid =aartuser_id
                                    and coalesce(trainingcompletiondate,'01/01/1900')=coalesce(RTCompleteDate_cdt,'01/01/1900') 
                                    --and currentschoolyear=school_year
                                    and case when trainingcompleted is true then 'Y'
                                             else 'N' end =tmp_table.RTComplete)>0)                                                                    
             THEN 
                RAISE NOTICE 'record exists';
             ELSE     
                select case when st.stateid is not null then  coalesce(organization_school_year(st.stateid),extract(year from now()))
                            when uo.aartuserid is not null then coalesce(organization_school_year(uo.organizationid),extract(year from now())) 
                            else  extract(year from now()) end into school_year
                             from aartuser a
                              left outer join usersorganizations uo on a.id=uo.aartuserid
                              left outer join (select o.id, case when o.organizationtypeid=(select id from organizationtype where typecode ='ST') then o.id 
	                                         else (select id from organization_parent(o.id) where organizationtypeid=(select id from organizationtype where typecode ='ST') limit 1) 
	                                         end stateid
                                                  from organization o where o.activeflag is true) st on stateid is not null and st.id=uo.organizationid
                             where a.id=aartuser_id limit 1 ;
                                                                                                       
	       INSERT INTO userpdtrainingdetail(
                userid, trainingcompleted, trainingcompletiondate, currentschoolyear, 
                createduser, createddate, modifieduser, modifieddate)
               SELECT  aartuser_id,'true', RTCompleteDate_cdt,2018, 
                      ceteSysAdminUserId, now_date, ceteSysAdminUserId, now_date;   
                      RAISE NOTICE 'row inserted into userpdtrainingdetail';                    
	     END IF;
        END IF;
	EXCEPTION WHEN others THEN
           RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;
           UPDATE tmp_user_training
           SET error_msg='<ERROR> on row :' ||cast(record_cnt as text)||','||SQLERRM||'/'|| SQLSTATE
           WHERE row_num=tmp_table.row_num;           
        END;                                                 
 END LOOP; 
END;
$BODY$;
\COPY (select * from tmp_user_training where error_msg ilike '%<error>%' ) to '/srv/extracts/helpdesk/moodle/upload_ep/user_training_error.csv' DELIMITER ',' CSV HEADER ;
--\COPY (select * from tmp_user_training where error_msg ilike '%<error>%' ) to 'user_training_error.csv' DELIMITER ',' CSV HEADER ;
DROP TABLE IF EXISTS  tmp_user_training;
DROP TABLE IF EXISTS  tmp_user_training_raw;
