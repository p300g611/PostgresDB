BEGIN;


select schoolname   "School Name",
       schooldisplayidentifier "School Number",
	   districtname   "District Name",
	   districtdisplayidentifier  "District Number"
  into temp extractorg
	from organizationtreedetail where statedisplayidentifier ='RI' order by schoolname;
\copy (select * from extractorg) to 'T159239_OrgRI.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;

sh /srv/extracts/helpdesk/automation/organizationreportdetails_prod.sh