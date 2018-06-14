-- KELPA issue 

select distinct td.testdevelopmentid,td.testspecificationid
,ts.contentframeworkid testspecification_contentframeworkid,tv.taskvariantid,cfd.contentframeworkid task_contentframeworkid
,gc.name task_gradecourse, gb.name task_gradeband
,tgc.name testspecification_gradecourse, tgb.name testspecification_gradeband
into temp tmp_record
from cb.testdevelopment td
inner join cb.testspecification ts on td.testspecificationid = ts.testspecificationid and ts.inuse=true
inner join cb.testdevelopmenttestsection tdts on tdts.testdevelopmentid = td.testdevelopmentid and tdts.inuse=true
inner join cb.testdevelopmentsectiontask tdst on tdst.testdevelopmenttestsectionid = tdts.testdevelopmenttestsectionid and tdst.inuse=true
inner join cb.taskvariant tv on tv.taskvariantid = tdst.taskvariantid and tv.inuse=true
inner join organization_ o on o.organizationid=tv.organizationid
inner join cb.task t on tv.taskid=t.taskid and o.organizationid=t.organizationid
inner join cb.taskcontentframeworkdetails tcfd on tcfd.taskid = tv.taskid
inner join cb.contentframeworkdetail cfd on cfd.contentframeworkdetailid = tcfd.contentframeworkdetailid and cfd.inuse=true
inner join cb.testcollection tc on tc.testcollectionid=td.testcollectionid
left outer join cb.gradecourse gc on t.gradecourseid=gc.gradecourseid and o.organizationid=gc.organizationid and gc.inuse is true 
left outer join cb.gradecourse tgc on ts.gradecourseid=tgc.gradecourseid and o.organizationid=ts.organizationid and tgc.inuse is true 
left outer join cb.systemrecord gb on t.gradebandid=gb.id 
left outer join cb.systemrecord tgb on ts.gradebandid=tgb.id 
where td.inuse=true and cfd.contentframeworkid<>ts.contentframeworkid and tc.name ilike '%2018%'
and td.organizationid=94761 
order by td.testdevelopmentid;

\copy (select * from tmp_record) to 'kelpa_contentframework.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-----


--K and grade 1 
select taskid,gradebandid,gradecourseid from cb.task where taskid in (select taskid from cb.taskvariant where taskvariantid in (64695,64696,64697,64698));

update cb.task set gradebandid=595,gradecourseid=null where taskid in (select taskid from cb.taskvariant where taskvariantid in (64695,64696,64697,64698));


select taskid,gradebandid,gradecourseid from cb.task where taskid in (select taskid from cb.taskvariant where taskvariantid in (64690,64691,64692,64693,64694));

update cb.task set gradebandid=594,gradecourseid=null where taskid in (select taskid from cb.taskvariant where taskvariantid in (64690,64691,64692,64693,64694));


--Validation in EP 2018 kelpa tests

drop table if exists tmp_tmp_max;
select max(tv.id), tv.externalid--,t.id testid, t.externalid testcbid
into temp tmp_tmp_max     
FROM test t
JOIN testsection as ts ON (t.id = ts.testid)
JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id
LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
LEFT JOIN cognitivetaxonomy ct ON tv.cognitivetaxonomyid = ct.id
LEFT JOIN cognitivetaxonomydimension ctd on  tv.cognitivetaxonomydimensionid = ctd.id
LEFT JOIN tasklayoutformat tlf ON tv.tasklayoutformatid = tlf.id
LEFT JOIN tasksubtype tst ON tv.tasksubtypeid = tst.id
LEFT JOIN taskvariantessentialelementlinkage tveel ON (tveel.taskvariantid = tv.id)
LEFT JOIN category tvcat ON tveel.essentialelementlinkageid = tvcat.id
JOIN testcollectionstests tct ON t.id = tct.testid
JOIN testcollection tc ON tc.id = tct.testcollectionid
JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
JOIN assessment a ON atc.assessmentid = a.id
JOIN testingprogram tp ON a.testingprogramid = tp.id
JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
JOIN contentframework cf ON (cfd.contentframeworkid = cf.id AND cf.assessmentprogramid = ap.id)
WHERE ap.id=47 
and t.externalid in (20150,
20151,
20152,
20157,
20170,
20246,
20247,
20248,
20249,
20250,
20251,
20252,
20256,
20257,
20258,
20259,
20260,
20261,
20320,
20321,
20322,
20323,
20324,
20325)
group by tv.externalid;--,t.id , t.externalid;


drop table if exists tmp_tmp_max2;
select max(tv.id), tv.externalid 
into temp tmp_tmp_max2  from taskvariant tv
where tv.externalid in ( select externalid from tmp_tmp_max )
group by tv.externalid;


select distinct t.externalid testcbid,tv.externalid itemexternalid ,tv.id itemid
FROM test t
JOIN testsection as ts ON (t.id = ts.testid)
JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
where tv.id in (select distinct tmp.max from tmp_tmp_max2 tmp 
inner join tmp_tmp_max tmp2 on tmp.externalid=tmp2.externalid
where tmp.max<>tmp2.max)  and t.externalid in (20150,
20151,
20152,
20157,
20170,
20246,
20247,
20248,
20249,
20250,
20251,
20252,
20256,
20257,
20258,
20259,
20260,
20261,
20320,
20321,
20322,
20323,
20324,
20325)
order by t.externalid;



/*

select max(tv.id), tv.externalid--,t.id testid, t.externalid testcbid
FROM test t
JOIN testsection as ts ON (t.id = ts.testid)
JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
LEFT JOIN cognitivetaxonomy ct ON tv.cognitivetaxonomyid = ct.id
LEFT JOIN cognitivetaxonomydimension ctd on  tv.cognitivetaxonomydimensionid = ctd.id
JOIN testcollectionstests tct ON t.id = tct.testid
JOIN testcollection tc ON tc.id = tct.testcollectionid
JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
JOIN assessment a ON atc.assessmentid = a.id
JOIN testingprogram tp ON a.testingprogramid = tp.id
JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
JOIN contentframework cf ON (cfd.contentframeworkid = cf.id AND cf.assessmentprogramid = ap.id)
WHERE ap.id=47 and tv.id =62442
group by tv.externalid;--,t.id , t.externalid;

select id,externalid,createdate from taskvariant  where externalid=62442 order by id desc;


*/




