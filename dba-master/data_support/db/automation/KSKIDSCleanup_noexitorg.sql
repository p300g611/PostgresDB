drop table if exists  tmp_KSKIDSCleanup ;
create temporary table tmp_KSKIDSCleanup(   
                                        statestudent_identifier             text ,
                                        ayp_sch_displayidentifier           text ,
                                        att_sch_displayidentifier           text ,
                                        exit_att_sch_displayidentifier      text 
                                       );
\COPY tmp_KSKIDSCleanup FROM '/CETE_GENERAL/Technology/helpdesk/datasupport/unprocessed/tmp_KSKIDSCleanup.csv' DELIMITER ',' CSV HEADER ;   
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 tmp_table record ;
 tmp_enrollmentid record ;
 record_cnt integer;
 err_msg TEXT;
BEGIN
now_date :=now();
record_cnt:=1;
FOR tmp_table IN (SELECT trim(statestudent_identifier)   statestudent_identifier,
                         trim(ayp_sch_displayidentifier) ayp_sch_displayidentifier,
                         trim(att_sch_displayidentifier) att_sch_displayidentifier,
                         trim(exit_att_sch_displayidentifier) exit_att_sch_displayidentifier
                        FROM tmp_KSKIDSCleanup)
 LOOP   
        record_cnt:=record_cnt+1;
	RAISE NOTICE 'processing row(%)>> Student_State_ID:% , ayp_sch_displayidentifier: %, att_sch_displayidentifier: %'
	                ,record_cnt,tmp_table.statestudent_identifier,tmp_table.ayp_sch_displayidentifier,tmp_table.att_sch_displayidentifier;
        BEGIN
          FOR tmp_enrollmentid in (select e.id,e.studentid
					from enrollment e 
					inner join student s on e.studentid = s.id
					inner join organization o on e.attendanceschoolid = o.id
					inner join organization ayp on e.aypschoolid = ayp.id
					where o.id in (select id from organization_children((select id from organization where displayidentifier = 'KS')))
					and s.stateid = (select id from organization where displayidentifier = 'KS')
					and lower(s.statestudentidentifier) = lower(tmp_table.statestudent_identifier)
					and lower(o.displayidentifier) = lower(tmp_table.att_sch_displayidentifier)					
					and lower(ayp.displayidentifier) =lower(tmp_table.ayp_sch_displayidentifier)
			           )		
                       LOOP 
					update enrollment
						set activeflag = true,
						exitwithdrawaldate = null,
						exitwithdrawaltype = null,
						modifieddate = now_date,
						modifieduser = (select id from aartuser where username = 'cetesysadmin'),
						notes = 'Activated enrollment on '||now_date::text
					where activeflag = false
						and id = tmp_enrollmentid.id
						and studentid=tmp_enrollmentid.studentid;
				RAISE NOTICE 'Activate enrollmentid:% ,for studentid:% ',tmp_enrollmentid.id,tmp_enrollmentid.studentid;
	               END LOOP; 
	EXCEPTION WHEN others THEN
           RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;
        END;                                                 
 END LOOP;			    
	    		   
END;
$BODY$;
drop table if exists  tmp_KSKIDSCleanup ;