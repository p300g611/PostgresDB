
drop table tmp_ssid;
create temporary table tmp_ssid(stid bigint, out_time text );
\copy tmp_ssid from 'tmp_ssid.csv'DELIMITER ',' CSV HEADER;

BEGIN;

UPDATE studentstests st
set    startdatetime =tmp.out_time::timestamp,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	   manualupdatereason='for ticket#738436'
	   from tmp_ssid tmp 
	  where tmp.stid= st.id and st.startdatetime is null;
	 
commit;



