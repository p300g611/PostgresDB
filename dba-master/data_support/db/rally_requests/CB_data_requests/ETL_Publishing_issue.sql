--duplicates

select externalid,count(id) from testcollection where activeflag is true and externalid is not null group by externalid having count(*)>1;
select externalid,count(id) from testcollection where activeflag is true and externalid is not null group by externalid having count(*)>1;


SELECT tc.id testcollectionid,tc.externalid,count(tp.id) cnt FROM testpanel tp 
JOIN testpanelstage tps ON tp.id = tps.testpanelid 
JOIN testpanelstagetestcollection tpstc ON tpstc.testpanelstageid = tps.id 
JOIN testcollection tc ON tc.externalid = tpstc.externaltestcollectionid 
WHERE tp.activeflag is true and tps.activeflag is true and tpstc.activeflag is true --and tc.activeflag is true
group by tc.id,tc.externalid having count(tp.id)>1;


with dups as (
SELECT tc.id testcollectionid,count(tp.id) cnt FROM testpanel tp 
JOIN testpanelstage tps ON tp.id = tps.testpanelid 
JOIN testpanelstagetestcollection tpstc ON tpstc.testpanelstageid = tps.id 
JOIN testcollection tc ON tc.externalid = tpstc.externaltestcollectionid 
WHERE tp.activeflag is true and tps.activeflag is true and tpstc.activeflag is true 
group by tc.id having count(tp.id)>1)
select
tc.id testcollectionid,
tc.name testcollectionname,
tc.externalid   testcollectionexternalid,
tp.id testpanelid,
tp.externalid testpanelexternalid,
tp.panelname testpanel,
tps.id  testpanelstageid,
tps.externalid testpanelstageexternalid,
tpstc.id testpanelstagetestcollectionid,
tpstc.externalid testpanelstagetestcollectionexternalid
  FROM testpanel tp 
JOIN testpanelstage tps ON tp.id = tps.testpanelid 
JOIN testpanelstagetestcollection tpstc ON tpstc.testpanelstageid = tps.id 
JOIN testcollection tc ON tc.externalid = tpstc.externaltestcollectionid 
WHERE tp.activeflag is true and tps.activeflag is true and tpstc.activeflag is true
and tc.id in (select testcollectionid from dups)
order by tc.externalid, tc.id desc;


/*
****Note****--Not tested commented code manually verified executed below script
drop table if exists tmp_dups;
with dups as (select externalid,count(id) from testcollection group by externalid having count(*)>1)
select id, externalid,row_number() over(partition by externalid order by id desc ) row_num,id id_new
into temp tmp_dups
 from testcollection
where externalid in (select externalid from dups);

update tmp_dups tmp
set id_new=idmax.id
from (select id,externalid from tmp_dups where row_num=1) idmax 
where idmax.externalid=tmp.externalid and tmp.row_num>1;

select * from tmp_dups where row_num=2;
select * from tmp_dups order by externalid,id desc;

select * from testpanelstagetestcollection where externaltestcollectionid in (select externalid from tmp_dups);

--update 

select count(*) from testcollectionstests 
where testcollectionid in (select id from tmp_dups where row_num=2);


select * from operationaltestwindowstestcollections opwtc
inner join tmp_dups tmp on tmp.id=opwtc.testcollectionid
where row_num>2;


select * from testpanelstagetestcollection  
where testcollectionid in (select id from tmp_dups where row_num>1);

update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id in (73, 69, 88);


select * from operationaltestwindowstestcollections  
where testcollectionid in (select id from tmp_dups where row_num>1);

begin;

delete from operationaltestwindowstestcollections  
where testcollectionid in (select id from tmp_dups where row_num>1);


update testcollectionstests tmp
set testcollectionid=dup.id_new 
from tmp_dups dup where tmp.testcollectionid=dup.id and dup.row_num>1

select * from testcollection
where id in (select id from tmp_dups dup where dup.row_num>1);

update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id in (73, 69, 88) and activeflag = true;
*/

begin;
delete from operationaltestwindowstestcollections 
where testcollectionid in (4792,4855,4858,4969,9095,9592,10277,10275);

update testcollectionstests set testcollectionid=4791 where testcollectionid=4792;
update testcollectionstests set testcollectionid=4854 where testcollectionid=4855;
update testcollectionstests set testcollectionid=4857 where testcollectionid=4858;
update testcollectionstests set testcollectionid=4968 where testcollectionid=4969;
update testcollectionstests set testcollectionid=9096 where testcollectionid=9095;
update testcollectionstests set testcollectionid=9594 where testcollectionid=9592;
update testcollectionstests set testcollectionid=10278 where testcollectionid=10277;
update testcollectionstests set testcollectionid=10276 where testcollectionid=10275;
update testcollection set activeflag = false, modifieddate = now() where id in(4792,4855,4858,4969,9095,9592,10277,10275);
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id in (73, 88);

update testpanelstagetestcollection  set activeflag = false where testpanelstageid= 83 and externaltestcollectionid=6077;
update testpanelstage set activeflag = false where id=83;
update testpanel set activeflag = false where id=28;

commit;

--prod
select * 
into temp tc_activeinactive from testcollectionstests where testcollectionid in(4791,4854 ,4857 ,4968 ,9095 ,9592 ,10277,10275,43117,43121,43124,43128,43130,43133,43151,43296
,4792,4855,4858,4969,9096,9594,10278,10276,43119,43122,43125,43129,43131,43134,43152,43297);
\copy (select * from tc_activeinactive) to 'tc_activeinactive.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

update testcollectionstests set testcollectionid=4791 where testcollectionid=4792;
update testcollectionstests set testcollectionid=4854 where testcollectionid=4855;
update testcollectionstests set testcollectionid=4857 where testcollectionid=4858;
update testcollectionstests set testcollectionid=4968 where testcollectionid=4969;
update testcollectionstests set testcollectionid=9095 where testcollectionid=9096;
update testcollectionstests set testcollectionid=9592 where testcollectionid=9594;
update testcollectionstests set testcollectionid=10277 where testcollectionid=10278;
update testcollectionstests set testcollectionid=10275 where testcollectionid=10276;
update testcollectionstests set testcollectionid=43117 where testcollectionid=43119;
update testcollectionstests set testcollectionid=43121 where testcollectionid=43122;
update testcollectionstests set testcollectionid=43124 where testcollectionid=43125;
update testcollectionstests set testcollectionid=43128 where testcollectionid=43129;
update testcollectionstests set testcollectionid=43130 where testcollectionid=43131;
update testcollectionstests set testcollectionid=43133 where testcollectionid=43134;
update testcollectionstests set testcollectionid=43151 where testcollectionid=43152;
update testcollectionstests set testcollectionid=43296 where testcollectionid=43297;

update operationaltestwindowstestcollections set activeflag = false, modifieddate = now()
 where testcollectionid in(4792,4855,4858,4969,9096,9594,10278,10276,43119,43122,43125,43129,43131,43134,43152,43297);

update testcollection set activeflag = false, modifieddate = now()
 where id in(4792,4855,4858,4969,9096,9594,10278,10276,43119,43122,43125,43129,43131,43134,43152,43297);
 
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 59 and externaltestcollectionid=6065;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 60 and externaltestcollectionid=6066;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 72 and externaltestcollectionid=6067;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 71 and externaltestcollectionid=6068;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 99 and externaltestcollectionid=6069;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 68 and externaltestcollectionid=6069;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 100 and externaltestcollectionid=6070;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 67 and externaltestcollectionid=6070;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 103 and externaltestcollectionid=6071;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 77 and externaltestcollectionid=6071;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 104 and externaltestcollectionid=6072;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 78 and externaltestcollectionid=6072;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 107 and externaltestcollectionid=6073;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 82 and externaltestcollectionid=6073;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 108 and externaltestcollectionid=6074;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 81 and externaltestcollectionid=6074;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 111 and externaltestcollectionid=6075;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 79 and externaltestcollectionid=6075;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 112 and externaltestcollectionid=6076;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 80 and externaltestcollectionid=6076;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 87 and externaltestcollectionid=6077;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 85 and externaltestcollectionid=6077;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 88 and externaltestcollectionid=6078;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 86 and externaltestcollectionid=6078;


--validation30 12/20/2017

update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 111 and externaltestcollectionid=6075;
update testpanelstagetestcollection set activeflag = false, modifieddate = now() where id = 112 and externaltestcollectionid=6076;
