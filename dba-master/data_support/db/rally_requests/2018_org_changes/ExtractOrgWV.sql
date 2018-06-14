BEGIN;

select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='WV' order by schoolname;
\copy (select * from extractorg) to 'Extract_OrgWV.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;