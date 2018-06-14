/*
DO
$BODY$
DECLARE
       now_date timestamp with time zone; 
       aart_userid integer;
       row_count integer;
       tmp_state record;
       sql_script text;
BEGIN
   
for tmp_state in ( select distinct displayidentifier from organization where organizationtypeid=2
and displayidentifier in (  'BIE-Choctaw','BIE-Miccosukee','CO','IA','IL','KS'
                           ,'MO','NC','ND','NH','NJ','NY','OK','UT','VT','WI'
                           ,'WV','AK') order by 1)
loop
--raise info '%',tmp_state.displayidentifier ;
sql_script:='\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='''||tmp_state.displayidentifier||''' order by 2,1) TO ''tmp_org_'||tmp_state.displayidentifier||'.csv'' DELIMITER '','' CSV HEADER;';
raise info '%',sql_script;
--sql_script
end loop;
    
END;
$BODY$; 
*/
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='AK' order by 2,1) TO 'tmp_org_AK.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='BIE-Choctaw' order by 2,1) TO 'tmp_org_BIE-Choctaw.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='BIE-Miccosukee' order by 2,1) TO 'tmp_org_BIE-Miccosukee.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='CO' order by 2,1) TO 'tmp_org_CO.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='IA' order by 2,1) TO 'tmp_org_IA.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='IL' order by 2,1) TO 'tmp_org_IL.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='KS' order by 2,1) TO 'tmp_org_KS.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='MO' order by 2,1) TO 'tmp_org_MO.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='NC' order by 2,1) TO 'tmp_org_NC.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='ND' order by 2,1) TO 'tmp_org_ND.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='NH' order by 2,1) TO 'tmp_org_NH.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='NJ' order by 2,1) TO 'tmp_org_NJ.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='NY' order by 2,1) TO 'tmp_org_NY.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='OK' order by 2,1) TO 'tmp_org_OK.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='UT' order by 2,1) TO 'tmp_org_UT.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='VT' order by 2,1) TO 'tmp_org_VT.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='WI' order by 2,1) TO 'tmp_org_WI.csv' DELIMITER ',' CSV HEADER;
\copy (select schoolname,schooldisplayidentifier,districtname,districtdisplayidentifier from organizationtreedetail where statedisplayidentifier='WV' order by 2,1) TO 'tmp_org_WV.csv' DELIMITER ',' CSV HEADER;
