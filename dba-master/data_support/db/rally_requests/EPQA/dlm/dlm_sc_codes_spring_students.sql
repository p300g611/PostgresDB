--Other than Kansas 51
drop table if exists tmp_ee_lookups;
create temp table tmp_ee_lookups(ee text, dlm_ee text);
\COPY tmp_ee_lookups FROM 'ee_lookups.csv' DELIMITER ',' CSV HEADER ;

--Other than Kansas
drop table if exists tmp_epqa;
select distinct 
  s.id studentid
 ,s.statestudentidentifier 
 ,s.legalfirstname         
 ,s.legalmiddlename        
 ,s.legallastname          
 ,s.generationcode        
 ,to_char(s.dateofbirth  ,'mm/dd/yyyy') dateofbirth
-- ,e.id enrollmentid
-- ,e.currentgradelevel       enrollmentgradeid
-- ,tc.gradecourseid          testgradeid
-- ,tc.gradebandid            testgradebandid
,ca.name Assessment
 ,sc.specialcircumstancetype
 ,sc.cedscode
 ,cfd.contentcode ee -- dlm mapping table 
 ,case when cfd.contentcode is not null and dlm.dlm_ee is not null then dlm.dlm_ee else 'ee' end  dlm_ee  
 ,ot.statedisplayidentifier statename
  into temp tmp_epqa
from studentstests st 
inner join enrollment e on st.enrollmentid=e.id and st.studentid=e.studentid  and e.currentschoolyear=2018  --may be uncomment st.enrollmentid=e.id and
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join student s on s.id=e.studentid and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true and sap.assessmentprogramid=3
inner join studentspecialcircumstance stsc ON st.id = stsc.studenttestid
inner JOIN specialcircumstance sc ON stsc.specialcircumstanceid = sc.id
inner join testsession ts on st.testsessionid=ts.id
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join contentarea ca on ca.id=tc.contentareaid
inner join test t on st.testid=t.id and t.activeflag is true 
inner jOIN testsection as tss ON (t.id = tss.testid)
inner JOIN testsectionstaskvariants AS tstv ON (tss.id = tstv.testsectionid)
inner JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
inner JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
left JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
left join tmp_ee_lookups dlm on trim(dlm.ee)=trim(cfd.contentcode)
where ts.schoolyear=2018 and s.stateid<>51
and ts.source in ('BATCHAUTO', 'FIXBATCH', 'MABATCH') -- we need to confirm on this 
--and  ts.operationaltestwindowid in (10268,10286,10295,10270,10284,10293,10272,10274,10276,10291,10278,10282,10280,10288,10259,10264,10266,10305,10290)  --we need to uncomment ***WRANING**
;

 \copy (select * from tmp_epqa where statename='AK') to 'dlm_sc_code_spring_students_AK.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='CO') to 'dlm_sc_code_spring_students_CO.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='DE') to 'dlm_sc_code_spring_students_DE.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='IA') to 'dlm_sc_code_spring_students_IA.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='IL') to 'dlm_sc_code_spring_students_IL.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='KS') to 'dlm_sc_code_spring_students_KS.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='MD') to 'dlm_sc_code_spring_students_MD.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='MO') to 'dlm_sc_code_spring_students_MO.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='ND') to 'dlm_sc_code_spring_students_ND.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='NH') to 'dlm_sc_code_spring_students_NH.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='NJ') to 'dlm_sc_code_spring_students_NJ.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='NY') to 'dlm_sc_code_spring_students_NY.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='OK') to 'dlm_sc_code_spring_students_OK.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='RI') to 'dlm_sc_code_spring_students_RI.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='UT') to 'dlm_sc_code_spring_students_UT.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='WI') to 'dlm_sc_code_spring_students_WI.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='WV') to 'dlm_sc_code_spring_students_WV.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 \copy (select * from tmp_epqa where statename='BIE-Miccosukee') to 'dlm_sc_code_spring_students_BIEMiccosukee.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--For Kansas
drop table if exists tmp_epqa;
select  
  s.id studentid
 ,s.statestudentidentifier 
 ,s.legalfirstname         
 ,s.legalmiddlename        
 ,s.legallastname          
 ,s.generationcode        
 ,to_char(s.dateofbirth  ,'mm/dd/yyyy') dateofbirth
 --,e.id enrollmentid
 --,e.currentgradelevel       enrollmentgradeid
 --,tc.gradecourseid          testgradeid
 --,tc.gradebandid            testgradebandid
,ca.name Assessment
 ,sc.specialcircumstancetype
 ,sc.cedscode
 ,'SC-'||sc.ksdecode KSDECODE
 ,row_number() over(partition by st.studentid,tc.contentareaid order by case when sc.ksdecode='08' then '1900-12-31'::timestamp with time zone  
  when sc.ksdecode='39' then '1901-12-31'::timestamp with time zone else  stsc.createdate end) hierarchy   
  into temp tmp_epqa
from studentstests st 
inner join enrollment e on st.enrollmentid=e.id and st.studentid=e.studentid  and e.currentschoolyear=2018 
inner join student s on s.id=e.studentid and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true and sap.assessmentprogramid=3
inner join studentspecialcircumstance stsc ON st.id = stsc.studenttestid
inner join category c on c.id=stsc.status and c.categorycode in ('SAVED','APPROVED')
inner JOIN specialcircumstance sc ON stsc.specialcircumstanceid = sc.id and sc.activeflag is true 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join test t on st.testid=t.id and t.activeflag is true
inner join contentarea ca on ca.id=tc.contentareaid
where ts.schoolyear=2018 and s.stateid=51
and ts.source in ('BATCHAUTO', 'MANUAL','FIXBATCH')-- we need to confirm on this 
--and  ts.operationaltestwindowid in (10262)  --we need to uncomment ***WRANING**
;

\copy (select * from tmp_epqa where hierarchy=1) to 'dlm_sc_code_spring_students_KS.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);