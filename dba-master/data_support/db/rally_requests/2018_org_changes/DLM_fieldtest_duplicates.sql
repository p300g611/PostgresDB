-- validation for one student 
/*
select distinct st.id stid,testname,st.status,tc.contentareaid,st.id ,ts.source,tl.id,tl.testletname tl,tl.externalid
from studentstests st 
inner join test t on t.id=st.testid
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
JOIN testsection as tss ON (t.id = tss.testid)
JOIN testsectionstaskvariants AS tstv ON (tss.id = tstv.testsectionid)
join testlet as tl ON (tstv.testletid = tl.id)
where studentid =436221 
and ts.source <>'ITI'
and st.activeflag is true and ts. activeflag is true 
order by tc.contentareaid,tl.externalid,testname;


-- FIND the duplicate list 
with dups as (
select count(distinct ts.source),tl.externalid,st.studentid,tc.contentareaid,o.displayidentifier state
from studentstests st 
inner join student s on s.id=st.studentid
inner join organization o on o.id=s.stateid
inner join test t on t.id=st.testid
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
JOIN testsection as tss ON (t.id = tss.testid)
JOIN testsectionstaskvariants AS tstv ON (tss.id = tstv.testsectionid)
join testlet as tl ON (tstv.testletid = tl.id)
join operationaltestwindow opw on opw.id=ts.operationaltestwindowid and assessmentprogramid =3
where ts.source in ('BATCHAUTO','MABATCH')
and tc.contentareaid in (3,440,441)
--and testname not like '%R-%'
and st.activeflag is true and ts. activeflag is true 
group by tl.externalid,st.studentid,tc.contentareaid,o.displayidentifier
having count(distinct ts.source )>1 )
select state,contentareaid,count(studentid) from dups
group by state,contentareaid;

*/

--validation
-- FIND the duplicate individual students
Drop table if exists tmp_dups;
select count(distinct ts.source),tl.externalid,st.studentid,tc.contentareaid,o.displayidentifier state
into temp tmp_dups
from studentstests st 
inner join student s on s.id=st.studentid
inner join organization o on o.id=s.stateid
inner join test t on t.id=st.testid
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
JOIN testsection as tss ON (t.id = tss.testid)
JOIN testsectionstaskvariants AS tstv ON (tss.id = tstv.testsectionid)
join testlet as tl ON (tstv.testletid = tl.id)
join operationaltestwindow opw on opw.id=ts.operationaltestwindowid and assessmentprogramid =3
where ts.source in ('BATCHAUTO','MABATCH')
and tc.contentareaid in (3,440,441)
--and testname not like '%R-%'
and st.activeflag is true and ts. activeflag is true 
group by tl.externalid,st.studentid,tc.contentareaid,o.displayidentifier
having count(distinct ts.source )>1;


--Generate report to send DLM
Drop table if exists tmp_ft_dlm_report;
select distinct tl.id testletid,tl.externalid testletexternalid,tl.testletname,testname,st.studentid,tc.contentareaid,o.displayidentifier state,ts.source
,st.id studenttestid,ts.id testsessionid,c.categoryname
into temp tmp_ft_dlm_report
from studentstests st 
inner join student s on s.id=st.studentid
inner join organization o on o.id=s.stateid
inner join test t on t.id=st.testid
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
inner join category c on c.id=st.status
JOIN testsection as tss ON (t.id = tss.testid)
JOIN testsectionstaskvariants AS tstv ON (tss.id = tstv.testsectionid)
join testlet as tl ON (tstv.testletid = tl.id)
join operationaltestwindow opw on opw.id=ts.operationaltestwindowid and assessmentprogramid =3
inner join tmp_dups dup on dup.studentid=st.studentid and dup.externalid=tl.externalid and dup.contentareaid=tc.contentareaid 
where ts.source in ('BATCHAUTO','MABATCH')
and tc.contentareaid in (3,440,441)
--and testname not like '%R-%'
and st.activeflag is true and ts. activeflag is true
order by state,st.studentid,tc.contentareaid,tl.externalid,ts.source;

--Find duplicates for ech subject
select contentareaid,count(studentid) from tmp_dups group by contentareaid;
select contentareaid,count(distinct studentid) from tmp_dups group by contentareaid;

--Makesure above counts matched
select contentareaid,count(studentid) from tmp_ft_dlm_report group by contentareaid;
select contentareaid,count(distinct studentid) from tmp_ft_dlm_report group by contentareaid;


\copy (select * from tmp_ft_dlm_report) to 'DLM_Field_Test_Assignment_duplicates04302018.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



BEGIN;

UPDATE studentsresponses SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE studentstestsid IN (SELECT studenttestid from tmp_ft_dlm_report where source='MABATCH') and activeflag = true;

UPDATE studentstestsections SET activeflag = false,  modifieduser = 174744, modifieddate = now()
      WHERE studentstestid IN (SELECT studenttestid from tmp_ft_dlm_report where source='MABATCH') and activeflag = true;

UPDATE studentstests SET manualupdatereason ='FieldTestDuplicated DE17234', activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (SELECT studenttestid from tmp_ft_dlm_report where source='MABATCH') and activeflag = true;
                 
UPDATE testsession SET activeflag = false, modifieduser = 174744, modifieddate = now()
     WHERE id IN (select  testsessionid from tmp_ft_dlm_report where source='MABATCH') and activeflag = true;


COMMIT;  

