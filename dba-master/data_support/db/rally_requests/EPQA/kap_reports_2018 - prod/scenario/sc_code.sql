
drop table if exists tmp_no_response;
with no_response_cnt as (
select st.studentid, st.id studentstestsid,tstv.taskvariantid,gc.id gradeid,tc.contentareaid,tc.stageid
from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
inner join studentspecialcircumstance ssp on ssp.studenttestid=st.id and ssp.activeflag is true
inner join testcollection tc on tc.id =st.testcollectionid and tc.activeflag is true 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid--duplicate
where st.activeflag is true and ts.operationaltestwindowid in (10261,10258)  and ts.schoolyear=2018  and st.status =86
and ts.source='BATCHAUTO' 
)
select tmp.studentid, tmp.studentstestsid,stageid,contentareaid
,count( distinct case when sr.score is not null  and exld.id is null then  sr.taskvariantid end ) no_incl_answer
,count( distinct case when sr.score is not null  then sr.taskvariantid end) no_answer
into temp tmp_no_response
from no_response_cnt  tmp
left outer join studentsresponses sr on sr.studentid=tmp.studentid and sr.studentstestsid =tmp.studentstestsid and sr.taskvariantid=tmp.taskvariantid and sr.activeflag is true
left outer join (select distinct tv.id, gc.id gradeid,subjectid from taskvariant tv 
                join excludeditems exld on exld.taskvariantid =tv.externalid
                join gradecourse gc on gc.id=exld.gradeid
                where exld.schoolyear=2018 and exld.assessmentprogramid=12) exld on exld.id=sr.taskvariantid AND exld.gradeid=tmp.gradeid and exld.subjectid=tmp.contentareaid
group by tmp.studentid, tmp.studentstestsid,stageid,contentareaid;

create index inx_sr_studentid on tmp_no_response (studentid,studentstestsid);


select studentid,contentareaid,count(distinct stageid) 
into temp tmp_sc_std
 from tmp_no_response
where no_incl_answer>=5
group by studentid,contentareaid 
having count(distinct stageid)>1;

drop table if exists tmp_scode;
select distinct 
 s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,cas.name                                 "Subject"
,st.id as stid, st.studentid,sc.specialcircumstancetype, ca.categoryname as sc_statusname,'SC-'||sc.ksdecode ksdecode,
(case  when sc.ksdecode in ('08','28','34','36','37') and ca.id =549 then 'Yes'
       when sc.ksdecode in ('08','28','34','36','37') and ca.id in (551,548)then 'No'
       else null END) as Approved	   
into temp tmp_scode
from studentstests st
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join contentarea cas on cas.id=tc.contentareaid
inner join studentspecialcircumstance ssp on ssp.studenttestid=st.id and ssp.activeflag is true
inner join category ca on ca.id =ssp.status and ca.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join student s on st.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid  and e.studentid=st.studentid
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
inner join specialcircumstance sc on sc.id=ssp.specialcircumstanceid and sc.activeflag is true
inner join statespecialcircumstance ssc on ssc.specialcircumstanceid=sc.id  and ssc.activeflag is true
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ca.categorytypeid=79 and e.activeflag is true and e.currentschoolyear=2018
and ts.operationaltestwindowid  in (10261,10258)
and exists (select 1 from tmp_sc_std tmp where tmp.studentid=st.studentid and  tmp.contentareaid=tc.contentareaid);
--\copy (select * from tmp_scode) to 'kap_sc_codes.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-01') to 'kap_sc_codes_SC_01.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-04') to 'kap_sc_codes_SC_04.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-05') to 'kap_sc_codes_SC_05.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-07') to 'kap_sc_codes_SC_07.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-08') to 'kap_sc_codes_SC_08.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-16') to 'kap_sc_codes_SC_16.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-20') to 'kap_sc_codes_SC_20.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-24') to 'kap_sc_codes_SC_24.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-25') to 'kap_sc_codes_SC_25.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-26') to 'kap_sc_codes_SC_26.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-27') to 'kap_sc_codes_SC_27.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-28') to 'kap_sc_codes_SC_28.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-31') to 'kap_sc_codes_SC_31.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-32') to 'kap_sc_codes_SC_32.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-34') to 'kap_sc_codes_SC_34.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-36') to 'kap_sc_codes_SC_36.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-37') to 'kap_sc_codes_SC_37.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-41') to 'kap_sc_codes_SC_41.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from tmp_scode where ksdecode='SC-98') to 'kap_sc_codes_SC_98.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);







