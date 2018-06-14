BEGIN;

select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='CO' order by schoolname;
\copy (select * from extractorg) to 'Extract_OrgCO.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;