BEGIN;
--statedisplayidentifier in (ND,NJ,NY,VT)
select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='ND' order by schoolname;
\copy (select * from extractorg) to 'T442729_OrgND.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;

