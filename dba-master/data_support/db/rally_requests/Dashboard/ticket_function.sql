
--save copy of copy of call records from CMS and name 'callline.csv'
DROP TABLE IF EXISTS tmp_callline;
create temp table tmp_callline(call_id int,segment int,row_date date,row_time time,segstart time,segstop time,duration int,
                              calling_party char(30),dialed_number bigint,dispivector int,disposition varchar(10),disposition_time int,
			      dispsplit int,ans_logid int,talk_time int,hold_time int,acw_time int,transout char(1),
                              conf char(1),assist char(1),acd  int);
\copy tmp_callline from 'callline.csv' DELIMITER ',' CSV HEADER;

--save yesterday's information from osticket. 
truncate table dashboardatsosticketdaily;
\copy dashboardatsosticketdaily from 'osticket.csv' DELIMITER ',' CSV HEADER;



CREATE OR REPLACE FUNCTION public.fnc_dashboardatsticket()
  RETURNS character varying AS
$BODY$
	DECLARE 
		val_today timestamp with time zone;
		
	BEGIN
     	        val_today:=now();

  RAISE NOTICE 'Processing dashboardatscalllinearchive and insert today''s data to  dashboardatscalllinedaily:%',clock_timestamp();
  IF EXISTS (SELECT 1 FROM information_schema.tables where table_name='dashboardatscalllinedaily')
 THEN
    IF NOT EXISTS (SELECT 1 FROM dashboardatscalllinearchive WHERE createddate::date=now()::date limit 1)
    THEN
    INSERT INTO dashboardatscalllinearchive (call_id,segment,row_date,row_time,segstart,segstop,duration,
                              calling_party ,dialed_number ,dispivector,disposition ,disposition_time ,
			      dispsplit ,ans_logid,talk_time ,hold_time ,acw_time ,transout,
                              conf ,assist ,acd,hold_talk )
                      select  call_id,segment,row_date,row_time,segstart,segstop,duration,
                              calling_party ,dialed_number ,dispivector,disposition ,disposition_time ,
			      dispsplit ,ans_logid,talk_time ,hold_time ,acw_time ,transout,
                              conf ,assist,acd,talk_time+hold_time
                              from tmp_callline; 
       END IF;
   END IF;
  IF EXISTS (SELECT 1 FROM information_schema.tables where table_name ='dashboardatscalllinedaily') 
  THEN 
     delete from  dashboardatscalllinedaily;
     INSERT INTO dashboardatscalllinedaily (call_id,segment,row_date,row_time,segstart,segstop,duration,
                              calling_party ,dialed_number ,dispivector,disposition ,disposition_time ,
			      dispsplit ,ans_logid,talk_time ,hold_time ,acw_time ,transout,
                              conf,assist ,acd,hold_talk)
                      select  call_id,segment,row_date,row_time,segstart,segstop,duration,
	                      calling_party ,dialed_number ,dispivector,disposition ,disposition_time ,
	      		      dispsplit ,ans_logid,talk_time ,hold_time ,acw_time ,transout,
	                      conf,assist,acd,talk_time+hold_time
                              from tmp_callline
                              WHERE dispivector IN (34, 283, 284, 285, 288, 289);
   END IF;
   
   RAISE NOTICE 'Processing dashboardatstenticketsachive and insert today''s data  to dashboardatstenticketsdaily:%',clock_timestamp();
 
   IF EXISTS  (SELECT 1 FROM information_schema.tables where table_name ='dashboardatstenticketsachive')
   THEN
      IF NOT EXISTS (SELECT 1 FROM dashboardatstenticketsachive WHERE createddate::date=now()::date limit 1)
      THEN 
      INSERT INTO dashboardatstenticketsachive( ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
                             source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned,nine_minute_flag ,program ,
                             state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file)
                     select  ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
                             source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned,nine_minute_flag ,program ,
                            state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file
                            from dashboardatsosticketdaily;
     END IF;
   END IF;
   
   IF EXISTS (SELECT 1 FROM information_schema.tables where table_name='dashboardatstenticketsdaily')
   THEN 
       delete from  dashboardatstenticketsdaily;
       INSERT INTO dashboardatstenticketsdaily( ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
                            source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned,nine_minute_flag ,program ,
                            state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file)
                     select ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
                             source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned,nine_minute_flag ,program ,
                            state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file
                            from dashboardatsosticketdaily
                            where date::date=now()::date-interval '24 hour' and nine_minute_flag='Yes';
    END IF;
    
    RAISE NOTICE 'Processing dashboardatsosticketachive and today''s date dashboardatsosticketdaily:%',clock_timestamp();

    IF EXISTS (SELECT 1 FROM information_schema.tables where table_name ='dashboardatsosticketdaily')
    THEN
       IF NOT EXISTS (SELECT 1 FROM dashboardatsosticketachive where createddate::date=now()::date limit 1) 
       THEN
       INSERT INTO dashboardatsosticketachive( ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
			source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned ,nine_Minute_Flag ,program ,
			state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file,
			include ,include_open,days_to_update ,age_since_created ,age_since_updated ,created_date ,in_current_year ,
			include_pending ,include_open_current_year ,include_pending_current_year ,include_current_year ,last_30 ,
			last_30_include ,last_30_pending_include ,last_30_open_include ,last_7 ,last_7_include ,
			last_7_pending_include ,last_7_open_include)
	       select   ticket_number ,date,subject,from_user ,from_email,priority,department,help_topic,
			source,current_status,last_updated ,due_date,overdue,answered ,assigned_to,agent_assigned ,team_assigned ,nine_Minute_Flag ,program ,
			state ,district,school ,defect,policy ,resolution ,user_file ,roster_file ,enrollment_file ,tec_file,
			include ,include_open,days_to_update ,age_since_created ,age_since_updated ,created_date ,in_current_year ,
			include_pending ,include_open_current_year ,include_pending_current_year ,include_current_year ,last_30 ,
			last_30_include ,last_30_pending_include ,last_30_open_include ,last_7 ,last_7_include ,
			last_7_pending_include ,last_7_open_include
			from dashboardatsosticketdaily;
	   END IF;
    END IF;


        RETURN 'SUCCESS';  END;
	$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnc_dashboardatsticket()
  OWNER TO aartdw;
GRANT EXECUTE ON FUNCTION public.fnc_dashboardatsticket() TO public;
GRANT EXECUTE ON FUNCTION public.fnc_dashboardatsticket() TO aartdw;