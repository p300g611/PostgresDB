BEGIN;


select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='OK' order by schoolname;
\copy (select * from extractorg) to 'T159239_OrgOK.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;