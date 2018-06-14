BEGIN;

drop table if exists extractorg;
select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='MD' order by schoolname;
\copy (select * from extractorg) to 'T253957_OrgMD.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;