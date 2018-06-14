BEGIN;

select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='MO' order by schoolname;
\copy (select * from extractorg) to 'T343101_OrgMO.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;