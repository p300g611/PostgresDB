drop table if exists tmp_sts;
SELECT s.id as studentid, st.id studentstestsid, st.testid, sts.id studentstestsectionsid
into temp tmp_sts
--select count(distinct st.id)
FROM student s
JOIN studentstests st on s.id = st.studentid
join studentstestsections sts on sts.studentstestid=st.id
JOIN test t on st.testid = t.id
WHERE s.statestudentidentifier ilike 'kelpa%'
AND t.id = 89614 and st.activeflag is true and sts.activeflag is true and st.status<>86;

begin;
INSERT INTO studentsresponses(
            studentid, testid, testsectionid, studentstestsid, studentstestsectionsid, 
            taskvariantid, foilid, response, createddate, modifieddate, score, 
            createduser, modifieduser, activeflag, questarrequestid, originalscore, 
            questarresponsetext, attempts, readableresponse)
select tmp.studentid, 89614 testid, sr.testsectionid, tmp.studentstestsid, tmp.studentstestsectionsid, 
            sr.taskvariantid, sr.foilid, sr.response,now() createddate,now() modifieddate, score, 
            174744 createduser, 174744 modifieduser, activeflag, questarrequestid, originalscore, 
            questarresponsetext, attempts, readableresponse
             from studentsresponses sr
             cross join tmp_sts tmp
             where sr.studentstestsid =20061005;

 update studentstests set status=86,modifieduser = 174744, modifieddate=now()
  where id in (select studentstestsid from  tmp_sts);

 update studentstestsections set statusid=127,modifieduser = 174744, modifieddate=now()
  where id in (select studentstestsectionsid from  tmp_sts);

select count(distinct studentstestsid) from (select distinct sr.studentstestsid,sr.taskvariantid FROM student s
JOIN studentstests st on s.id = st.studentid
join studentstestsections sts on sts.studentstestid=st.id
JOIN test t on st.testid = t.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id 
WHERE s.statestudentidentifier ilike 'kelpa%'
AND t.id = 89614 and st.activeflag is true and sts.activeflag is true and st.status=86 and sts.statusid=127)a;

commit;