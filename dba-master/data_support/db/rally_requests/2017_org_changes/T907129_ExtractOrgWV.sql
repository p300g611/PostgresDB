BEGIN;

drop table if exists tmp_extractorg;
select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp tmp_extractorg
	from organizationtreedetail where statedisplayidentifier ='WV' order by schoolname;
\copy (select * from tmp_extractorg) to 'T907129_OrgWV.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;