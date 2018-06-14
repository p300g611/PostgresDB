/*
--EP

select tsv.externalid,tvfl.foilid foilid, tvfl.responseorder, tvfl.responsescore,mut.scoringdependency,mut.partorder
from taskvariant tsv
inner join taskvariantsfoils tvfl on tsv.id =tvfl.taskvariantid 
inner join foil fol on fol.id =tvfl.foilid
left outer join multiparttaskvariant mut on mut.id=fol.multiparttaskvariantid
where tsv.id = 448794;


select * from multiparttaskvariant where multiparttaskvariantid=448794
--SQLite
select * from taskvariant where externalid=61374 order by 1 desc ;



SELECT
tvf.taskvariantid, tvf.foilid, tvf.responseorder,
tvf.correctresponse, tvf.responsescore, tvf.responsename,
f.foiltext
FROM test t
JOIN testsection as ts ON (t.id = ts.testid)
JOIN testsectionstaskvariants AS tstv
ON (ts.id = tstv.testsectionid)
JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
JOIN taskvariantsfoils AS tvf ON (tv.id = tvf.taskvariantid)
JOIN foil as f on (tvf.foilid = f.id)
JOIN testcollectionstests tct ON t.id = tct.testid
JOIN testcollection tc ON tc.id = tct.testcollectionid
JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
JOIN assessment a ON atc.assessmentid = a.id
JOIN testingprogram tp ON a.testingprogramid = tp.id
JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
where ap.id=12 and tvf.taskvariantid=448794

398701


SELECT DISTINCT
tv.id, tv.externalid, tv.taskname, tv.variantname,
tt.code as tasktypecode, tst.code as tasksubtypecode,
ft.name as frameworktype, ca.abbreviatedname,
cfd.contentcode, tvcfd.isprimary,
ct.name, ctd.name, tlf.formatname, tvcat.categoryname, nodecode
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
LEFT JOIN cognitivetaxonomydimension ctd on	tv.cognitivetaxonomydimensionid = ctd.id
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
WHERE ap.id=12 and tv.id = 448794

---------------------------------------------------------------------
SELECT  
tvf.taskvariantid, tvf.foilid, tvf.responseorder,
tvf.correctresponse, tvf.responsescore, tvf.responsename,f.foiltext
select count(*)
FROM test t
JOIN testsection as ts ON (t.id = ts.testid)
JOIN testsectionstaskvariants AS tstv 	ON (ts.id = tstv.testsectionid)
JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
JOIN taskvariantsfoils AS tvf ON (tv.id = tvf.taskvariantid)
JOIN foil as f on (tvf.foilid = f.id)
JOIN testcollectionstests tct ON t.id = tct.testid
JOIN testcollection tc ON tc.id = tct.testcollectionid
JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
JOIN assessment a ON atc.assessmentid = a.id
JOIN testingprogram tp ON a.testingprogramid = tp.id
JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
-- left outer join multiparttaskvariant mut on mut.id=f.multiparttaskvariantid
WHERE ap.id=12


select  partorder,count(*) from multiparttaskvariant 
group by partorder;

	SELECT
			tvf.taskvariantid, tvf.foilid, tvf.responseorder,
			tvf.correctresponse, tvf.responsescore, tvf.responsename,
			 f.foiltext,mtv.partorder

        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
			JOIN testsectionstaskvariants AS tstv
				ON (ts.id = tstv.testsectionid)
			JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
			JOIN taskvariantsfoils AS tvf ON (tv.id = tvf.taskvariantid)
			JOIN foil as f on (tvf.foilid = f.id)

            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            LEFT OUTER JOIN multiparttaskvariant mtv ON mtv.id = f.multiparttaskvariantid
        WHERE ap.id=12
*/
-------------------------------------------------
-- updated script :
SELECT
tvf.taskvariantid,tv.externalid, tvf.foilid, tvf.responseorder,
tvf.correctresponse, tvf.responsescore, tvf.responsename,
f.foiltext,mtv.scoringdependency,mtv.partorder
into temp tmp_taskvariantsfoils
FROM test t
JOIN testsection as ts ON (t.id = ts.testid)
JOIN testsectionstaskvariants AS tstv 
ON (ts.id = tstv.testsectionid)
JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
JOIN taskvariantsfoils AS tvf ON (tv.id = tvf.taskvariantid)
JOIN foil as f on (tvf.foilid = f.id)
JOIN testcollectionstests tct ON t.id = tct.testid
JOIN testcollection tc ON tc.id = tct.testcollectionid
JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
JOIN assessment a ON atc.assessmentid = a.id
JOIN testingprogram tp ON a.testingprogramid = tp.id
JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id
LEFT OUTER JOIN multiparttaskvariant mtv ON mtv.id = f.multiparttaskvariantid
WHERE ap.id=12 and tt.code='MP';

\copy (select * from tmp_taskvariantsfoils) to 'kapsqlite_taskvariantsfoils_mp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);      

 