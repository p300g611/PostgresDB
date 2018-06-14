select distinct 
       tv.externalid "ExternalItemid" ,
       case when tc.pooltype='SINGLEEE'  then  'Integrated' 
            when tc.pooltype='MULTIEEOFC'  then 'Year end'
            when tc.pooltype='MULTIEEOFG'  then 'Year end'
            when ts.source='ITI'  then 'Integrated' 
            when ts.source='MANUAL' and tc.name ilike '%Offline%' then 'Year end'
            when ts.source='FIXBATCH' and  tc.pooltype is null then tc.name
            else tc.pooltype end "Model",
        case when g.id is not null then g.name 
         else gb.name end "Grade" 
         into temp tmp_item_information
  FROM studentstests st
 JOIN test t ON st.testid = t.id
 inner join student s on s.id=st.studentid
 inner join organization o on o.id=s.stateid
 JOIN studentstestsections sts ON sts.studentstestid = st.id
 JOIN testcollectionstests tct ON st.testid = tct.testid
 JOIN testcollection tc ON tc.id = tct.testcollectionid
 JOIN contentarea ca ON ca.id = tc.contentareaid
 JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
 JOIN assessment a ON atc.assessmentid = a.id
 JOIN testingprogram tp ON a.testingprogramid = tp.id
 JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
 JOIN testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id
 JOIN testsection tsec ON sts.testsectionid = tsec.id
 JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
 JOIN taskvariant tv ON tv.id = tstv.taskvariantid 
 JOIN category stcat ON stcat.id = st.status
 left outer join gradecourse AS g ON (tc.gradecourseid = g.id)
 LEFT Outer JOIN gradeband AS gb ON (tc.gradebandid = gb.id)
 WHERE ap.id=3 AND ts.schoolyear=2017 AND st.activeflag=case when stcat.categorycode='exitclearunenrolled-complete' then st.activeflag else 't' end
 and o.organizationname NOT IN ('flatland', 'DLM QC State', 'AMP QC State', 'KAP QC State', 'Playground QC State', 'Flatland',
                                    'DLM QC YE State', 'DLM QC IM State', 'DLM QC IM State ', 'DLM QC EOY State')
 and ts.source not in ('RESEARCHSURVEY');
\copy (select * from tmp_item_information order by 3,2,1) to 'tmp_item_information.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);






