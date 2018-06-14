--dlm script
drop table if exists tmp_epqa;
select distinct 
  s.id "Studentid"
 ,s.statestudentidentifier "State_Student_Identifier"
 ,s.legalfirstname  "Student_Legal_First_Name"
 ,s.legalmiddlename  "Student_Legal_Middle_Name"
 ,s.legallastname  "Student_Legal_Last_Name"      
 ,s.generationcode   "Generation_Code   "
 ,to_char(s.dateofbirth  ,'mm/dd/yyyy') "Date_of_Birth"
, gc.name "Current_Grade_Level"
--,e.currentgradelevel       enrollmentgradeid
-- ,tc.gradecourseid          testgradeid
-- ,tc.gradebandid            testgradebandid
-- ,e.id enrollmentid
 ,exitwithdrawaltype as "Exit Code"
 ,sec.description "Exit Code Description"
 ,to_char(exitwithdrawaldate, 'mm/dd/yyyy') "Exit Date"
 ,ca.name	"Subject"
 ,ot.statedisplayidentifier statename
-- ,st.status studentsteststatus
  into temp tmp_epqa
 from studentstests st 
inner join enrollment e on st.studentid=e.studentid  and e.currentschoolyear=2018
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join student s on s.id=e.studentid and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
left outer join studentexitcodes sec on sec.code=e.exitwithdrawaltype
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true and sap.assessmentprogramid=3
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join contentarea ca on ca.id=tc.contentareaid
inner join test t on st.testid=t.id and t.activeflag is true
inner join operationaltestwindowstate opws on opws.operationaltestwindowid=ts.operationaltestwindowid
where (e.exitwithdrawaltype<>0 or exitwithdrawaldate is not null ) and st.status in (86,494,679,681)
ts.schoolyear=2018 and ts.source in ('BATCHAUTO', 'FIXBATCH', 'MABATCH') 
--and  ts.operationaltestwindowid in (10268,10286,10295,10270,10284,10293,10272,10274,10276,10291,10278,10282,10280,10288,10259,10262,10264,10266,10305,10290)  --we need to uncomment ***WRANING**
and  ts.operationaltestwindowid in (10262,10264, 10267, 10270, 10271, 10273, 10276, 10278, 10201)  --we need to uncomment ***WRANING**
and (e.exitwithdrawaltype<>0 or exitwithdrawaldate is not null );

 \copy (select * from tmp_epqa where statename='AK') to 'dlm_exited_spring_students_AK.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='CO') to 'dlm_exited_spring_students_CO.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='DE') to 'dlm_exited_spring_students_DE.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='IA') to 'dlm_exited_spring_students_IA.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='IL') to 'dlm_exited_spring_students_IL.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='KS') to 'dlm_exited_spring_students_KS.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='MD') to 'dlm_exited_spring_students_MD.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='MO') to 'dlm_exited_spring_students_MO.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='ND') to 'dlm_exited_spring_students_ND.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='NH') to 'dlm_exited_spring_students_NH.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='NJ') to 'dlm_exited_spring_students_NJ.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='NY') to 'dlm_exited_spring_students_NY.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='OK') to 'dlm_exited_spring_students_OK.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='RI') to 'dlm_exited_spring_students_RI.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='UT') to 'dlm_exited_spring_students_UT.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='WI') to 'dlm_exited_spring_students_WI.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='WV') to 'dlm_exited_spring_students_WV.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='BIE-Miccosukee') to 'dlm_exited_spring_students_BIEMiccosukee.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

 