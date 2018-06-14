/*
-- Student scale score 
-- 2018 Student Scale Scores CPASS ArchConst May
-- 2018 Student Scale Scores CPASS BMA May
-- 2018 Student Scale Scores CPASS GKS May
-- 2018 Student Scale Scores CPASS MFG May
-- 2018 Student Scale Scores CPASS AGFNR May

drop table if exists tmp_cpass_ss;
create temp table tmp_cpass_ss(
"School_Year"	text,
"Assessment_Program"	text,
"Testing_Program"	text,
"Subject"	text,
"Grade"	text,
"Test_Type"	text,
"Report_Cycle"	text,
"State_Student_Identifier"	text,
"State"	text,
"District_Identifier"	text,
"School_Identifier"	text,
"Scale_Score"	text,
"Standard_Error"	text,
"Level_Number"	text,
"Completed_Flag"	text);

\COPY tmp_cpass_ss FROM '2018 Student Scale Scores CPASS AGFNR May.csv' DELIMITER ',' CSV HEADER ; 

update tmp_cpass_ss tmp
set "State_Student_Identifier" =sub.id
from (select distinct s.statestudentidentifier,s.id,displayidentifier from student s 
inner join enrollment e on s.id=e.studentid 
inner join organization o on e.attendanceschoolid=o.id 
where s.stateid=51) sub where trim(LEADING '0' FROM tmp."School_Identifier")=trim(LEADING '0' FROM sub.displayidentifier) and tmp."State_Student_Identifier" =sub.statestudentidentifier;

\copy (select "School_Year","Assessment_Program","Testing_Program","Subject","Grade","Test_Type","Report_Cycle","State_Student_Identifier","State","District_Identifier","School_Identifier","Scale_Score","Standard_Error","Level_Number","Completed_Flag" from tmp_cpass_ss) to '2018 Student Scale Scores CPASS AGFNR May_id.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

*/
-- select distinct s.statestudentidentifier,s.id,displayidentifier 
-- into temp tmp_cpass from student s 
-- inner join enrollment e on s.id=e.studentid 
-- inner join organization o on e.attendanceschoolid=o.id 
-- where s.stateid=51;
-- 
-- \copy (select * from tmp_cpass) to 'ks_ssid.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--  Students Percent Correct
-- 2018 Student Percent Correct by Assessment Topics CPASS ArchConst May
-- 2018 Student Percent Correct by Assessment Topics CPASS BMA May
-- 2018 Student Percent Correct by Assessment Topics CPASS GKS May
-- 2018 Student Percent Correct by Assessment Topics CPASS MFG May
-- 2018 Student Percent Correct by Assessment Topics CPASS AGFNR May

drop table if exists tmp_cpass_pc;
create temp table tmp_cpass_pc(
"School_Year" TEXt,
"Testing_Program" TEXT,
"Subject" TEXT,
"Grade" TEXT,
"Test_Type" TEXT,
"Report_Cycle" TEXT,
"State_Student_Identifier" TEXT,
"State" TEXT,"District_Identifier" TEXT,
"School_Identifier" TEXT,
"Topic_Code" TEXT,
"Percent_Correct" TEXT);

\COPY tmp_cpass_pc FROM '2018 Students Percent Correct by Assessment Topics CPASS AGFNR May.csv' DELIMITER ',' CSV HEADER ; 

update tmp_cpass_pc tmp
set "State_Student_Identifier" =sub.id
from (select distinct s.statestudentidentifier,s.id,displayidentifier from student s 
inner join enrollment e on s.id=e.studentid 
inner join organization o on e.attendanceschoolid=o.id 
where s.stateid=51) sub where trim(LEADING '0' FROM tmp."School_Identifier")=trim(LEADING '0' FROM sub.displayidentifier) and tmp."State_Student_Identifier" =sub.statestudentidentifier;

\copy (select "School_Year","Testing_Program","Subject","Grade","Test_Type","Report_Cycle","State_Student_Identifier","State","District_Identifier","School_Identifier","Topic_Code","Percent_Correct" from tmp_cpass_pc) to '2018 Students Percent Correct by Assessment Topics CPASS AGFNR May_id.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

