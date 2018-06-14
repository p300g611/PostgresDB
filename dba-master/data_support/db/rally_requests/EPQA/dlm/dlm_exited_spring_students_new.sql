drop table if exists tmp_dlm_exited_students;
select distinct 
  s.id "Studentid"
 ,s.statestudentidentifier "State_Student_Identifier"
 ,ot.statedisplayidentifier "State"
 ,s.legalfirstname  "Student_Legal_First_Name"
 ,s.legalmiddlename  "Student_Legal_Middle_Name"
 ,s.legallastname  "Student_Legal_Last_Name"      
 ,s.generationcode   "Generation_Code"
 ,to_char(s.dateofbirth  ,'mm/dd/yyyy') "Date_of_Birth"
, gc.name "Current_Grade_Level"
 ,exitwithdrawaltype as "Exit Code"
 ,sec.description "Exit Code Description"
 ,to_char(exitwithdrawaldate, 'mm/dd/yyyy') "Exit Date"
 ,ca.name "Subject"
 ,(
   select case when count(ie.id) > 0 then 1 else 0 end
   from enrollment ie
   join studentassessmentprogram isap
     on ie.studentid = isap.studentid
     and isap.assessmentprogramid = 3
     and isap.activeflag is true
   where ie.activeflag is true
   and ie.currentschoolyear = e.currentschoolyear
   and ie.studentid = s.id
 ) as "Current_Enrollment_Status"

into temp tmp_dlm_exited_students

from student s
join studentassessmentprogram sap on s.id = sap.studentid
join assessmentprogram ap on sap.assessmentprogramid = ap.id
join enrollment e on s.id = e.studentid
join organizationtreedetail ot on e.attendanceschoolid = ot.schoolid
join gradecourse gc on e.currentgradelevel = gc.id
left join studentexitcodes sec on e.exitwithdrawaltype = sec.code
left join studentstests st on s.id = st.studentid
left join testsession ts
  on st.testsessionid = ts.id
  and e.currentschoolyear = ts.schoolyear
  --and ts.source in ('BATCHAUTO', 'FIXBATCH', 'MABATCH')
  and ts.operationaltestwindowid in (
    10271,10295,10296,10291,10283,10264,10242,10266,10243,10278,10286,10285,10265,10277,10281,10282,10267,10287,10272,10288,10273,10235,10270,10244,
    10276,10279,10237,10262,10289,10284,10259,10294,10275,10260,10280,10292,10274,10293,10269,10268,10263,10305
  )
left join testcollection tc on st.testcollectionid = tc.id
left join contentarea ca on tc.contentareaid = ca.id
where e.currentschoolyear = 2018
and ap.abbreviatedname = 'DLM'
and (e.exitwithdrawaltype != 0 or exitwithdrawaldate is not null)
;

\copy (select * from tmp_dlm_exited_students where "State"='AK') to 'dlm_exited_spring_students_AK.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='CO') to 'dlm_exited_spring_students_CO.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='DE') to 'dlm_exited_spring_students_DE.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='IA') to 'dlm_exited_spring_students_IA.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='IL') to 'dlm_exited_spring_students_IL.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='KS') to 'dlm_exited_spring_students_KS.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='MD') to 'dlm_exited_spring_students_MD.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='MO') to 'dlm_exited_spring_students_MO.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='ND') to 'dlm_exited_spring_students_ND.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='NH') to 'dlm_exited_spring_students_NH.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='NJ') to 'dlm_exited_spring_students_NJ.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='NY') to 'dlm_exited_spring_students_NY.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='OK') to 'dlm_exited_spring_students_OK.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='RI') to 'dlm_exited_spring_students_RI.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='UT') to 'dlm_exited_spring_students_UT.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='WI') to 'dlm_exited_spring_students_WI.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='WV') to 'dlm_exited_spring_students_WV.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)
\copy (select * from tmp_dlm_exited_students where "State"='BIE-Miccosukee') to 'dlm_exited_spring_students_BIEMiccosukee.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)

