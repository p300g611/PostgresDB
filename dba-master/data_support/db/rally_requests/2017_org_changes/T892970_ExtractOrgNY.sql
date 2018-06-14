BEGIN;


select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='NY' order by schoolname;
\copy (select * from extractorg) to 'T892970_OrgNY.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;