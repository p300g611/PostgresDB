

 --list of the states and count for each state
	select 
	      (select organizationname from organization_parent(org.id) where organizationtypeid=2 limit 1)  "StateName",
	      (select organizationname from organization_parent(org.id) where organizationtypeid=2 limit 1)  "StateID",
	      count(*)
	       from  organization org
		     where organizationtypeid=7 and activeflag is true 			        
	  group by (select organizationname from organization_parent(org.id) where organizationtypeid=2 limit 1),
		   (select organizationname from organization_parent(org.id) where organizationtypeid=2 limit 1)
		   order by 1;


BEGIN;
--////////////More dynamic functionality////////////////////////////

-- Find the  rows for every table and insert into temp table 
drop table if exists tmp_org_allstates;
select 
    org.organizationname    "School Name",
    org.displayidentifier   "School Number",
    (select organizationname from organization_parent(org.id) where organizationtypeid=5 limit 1)  "District Name",
    (select displayidentifier from organization_parent(org.id) where organizationtypeid=5 limit 1)  "District Number",
    (select organizationname from organization_parent(org.id) where organizationtypeid=2 limit 1) state
       into temp table  tmp_org_allstates
       from  organization org
             where organizationtypeid=7 and activeflag is true ;
                
-- Dynamically create the files list of the files need to generate(should be in one line) 
select distinct '\COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='''||state||''' order by 1,3) To ''/home/p300g611/'||state||'.csv'' DELIMITER ''|'' CSV HEADER;'  from tmp_org_allstates order by 1;


-- Run every script online at a time 
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Alaska' order by 1,3) To '/home/p300g611/Alaska.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='AMP QC State' order by 1,3) To '/home/p300g611/AMP QC State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='ARMM' order by 1,3) To '/home/p300g611/ARMM.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='ARMM QC State' order by 1,3) To '/home/p300g611/ARMM QC State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='ATEA' order by 1,3) To '/home/p300g611/ATEA.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='ATEA QC State' order by 1,3) To '/home/p300g611/ATEA QC State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='BIE-Choctaw' order by 1,3) To '/home/p300g611/BIE-Choctaw.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='BIE-Miccosukee' order by 1,3) To '/home/p300g611/BIE-Miccosukee.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Colorado-cPass' order by 1,3) To '/home/p300g611/Colorado-cPass.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Colorado' order by 1,3) To '/home/p300g611/Colorado.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='cPass QC State' order by 1,3) To '/home/p300g611/cPass QC State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Delaware' order by 1,3) To '/home/p300g611/Delaware.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Demo State' order by 1,3) To '/home/p300g611/Demo State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='DLM QC EOY State' order by 1,3) To '/home/p300g611/DLM QC EOY State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='DLM QC IM State ' order by 1,3) To '/home/p300g611/DLM QC IM State .csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='DLM QC State' order by 1,3) To '/home/p300g611/DLM QC State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='DLM QC YE State' order by 1,3) To '/home/p300g611/DLM QC YE State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Illinois' order by 1,3) To '/home/p300g611/Illinois.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Iowa' order by 1,3) To '/home/p300g611/Iowa.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Kansas' order by 1,3) To '/home/p300g611/Kansas.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='KAP QC State' order by 1,3) To '/home/p300g611/KAP QC State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Mississippi-cPass' order by 1,3) To '/home/p300g611/Mississippi-cPass.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Mississippi' order by 1,3) To '/home/p300g611/Mississippi.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Missouri' order by 1,3) To '/home/p300g611/Missouri.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='New Hampshire' order by 1,3) To '/home/p300g611/New Hampshire.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='New Jersey' order by 1,3) To '/home/p300g611/New Jersey.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='New York' order by 1,3) To '/home/p300g611/New York.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='North Carolina' order by 1,3) To '/home/p300g611/North Carolina.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='North Dakota' order by 1,3) To '/home/p300g611/North Dakota.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Oklahoma' order by 1,3) To '/home/p300g611/Oklahoma.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Pennsylvania' order by 1,3) To '/home/p300g611/Pennsylvania.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Playground QC State' order by 1,3) To '/home/p300g611/Playground QC State.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Training Program' order by 1,3) To '/home/p300g611/Training Program.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Utah' order by 1,3) To '/home/p300g611/Utah.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Vermont' order by 1,3) To '/home/p300g611/Vermont.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Virginia' order by 1,3) To '/home/p300g611/Virginia.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='West Virginia' order by 1,3) To '/home/p300g611/West Virginia.csv' DELIMITER '|' CSV HEADER;
 \COPY (select "School Name","School Number","District Name","District Number" from tmp_org_allstates  where state='Wisconsin' order by 1,3) To '/home/p300g611/Wisconsin.csv' DELIMITER '|' CSV HEADER;

-- drop temp table 
drop table if exists tmp_org_allstates;

 ROLLBACK;
 