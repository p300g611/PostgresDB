pnp.studentid
pnp.attributecontainer
pnp.attributename
 

rawtoscalescores.schoolyear
rawtoscalescores.assessmentprogramid
rawtoscalescores.subjectid
rawtoscalescores.gradeid
rawtoscalescores.testid1
rawtoscalescores.testid2
rawtoscalescores.scalescore
rawtoscalescores.standarderror
 

student.statestudentidentifier
student.grade
student.gender
student.id
student.firstlanguage
student.esolparticipationcode
 

studentsresponses.studentstestsid
studentsresponses.score
studentsresponses.responsetext
 

studentstests.id
studentstests.studentid
studentstests.programname
studentstests.testid
 

taskvariantsfoils.foilsorder
taskvariantsfoils.correctresponse
 

taskvariant.id
taskvariant.externalid
taskvariant.contentareaname
taskvariant.taskname
taskvariant.tasktypecode
 

test.id
test.contentareaname
test.gradecourse
test.testname
test.externalid
test.testinternalname
 

testsection.id
testsection.testid
 

testsectionstaskvariants.testsectionid
testsectionstaskvariants.taskvariantid

--pnp
SELECT
                s.id,
                spiav.id,
                piac.attributecontainer,
                pia.attributename,
                spiav.selectedvalue
            FROM student s
                JOIN enrollment e
                    ON (e.studentid = s.id and e.activeflag = true)
                --JOIN studentassessmentprogram sap ON sap.studentid = s.id
                --JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
                LEFT JOIN studentprofileitemattributevalue spiav
                    ON s.id = spiav.studentid
                LEFT JOIN profileitemattributenameattributecontainer pianc
                    ON spiav.profileitemattributenameattributecontainerid =
                        pianc.id
                LEFT JOIN profileitemattribute pia
                    ON pianc.attributenameid = pia.id
                LEFT JOIN profileitemattributecontainer piac
                    ON pianc.attributecontainerid = piac.id
            limit 10;

--rawtoscalescore  information from tabe (name is different in prod: rawtoscalescores)



--student
            SELECT
                s.id, s.activeflag, e.id, s.legalfirstname,
                s.legalmiddlename, s.legallastname,
		s.generationcode, s.statestudentidentifier, e.localstudentidentifier, s.username,
		e.currentschoolyear, s.firstlanguage,
                cast( case when length(cast (EXTRACT(YEAR from s.dateofbirth) as varchar(4))) < 4 then
                          case when EXTRACT(YEAR from s.dateofbirth) between 1 and 16 then s.dateofbirth+INTERVAL '2000 year'
                               when EXTRACT(YEAR from s.dateofbirth) between 90 and 99 then s.dateofbirth+INTERVAL '1900 year'
                               when EXTRACT(YEAR from s.dateofbirth) between 900 and  999 then s.dateofbirth+INTERVAL '1000 year'
                               when EXTRACT(YEAR from s.dateofbirth) between 201 and  209 then s.dateofbirth+INTERVAL '1800 year'
                               else s.dateofbirth end
                else s.dateofbirth end as date) as dateofbirth,
                case when s.gender = 1 then 'Male'
                    when s.gender = 0 then 'Female'
                else '' end,
                s.comprehensiverace, s.hispanicethnicity,
                s.primarydisabilitycode, gc.name, e.attendanceschoolid,

                o.organizationname, o.displayidentifier, o.organizationtypeid,
                po.organizationname, po.displayidentifier, po.organizationtypeid,
                gpo.organizationname, gpo.displayidentifier, gpo.organizationtypeid,
                gpo1.organizationname, gpo1.displayidentifier, gpo1.organizationtypeid,
                gpo2.organizationname, gpo2.displayidentifier, gpo2.organizationtypeid,
                gpo3.organizationname, gpo3.displayidentifier, gpo3.organizationtypeid,
                gpo4.organizationname, gpo4.displayidentifier, gpo4.organizationtypeid,

                e.schoolentrydate, e.districtentrydate,
                e.stateentrydate, --aypco.displayidentifier,
                o.displayidentifier, s.esolparticipationcode,
                ccomm.categorydescription as "Comm band ",
                cela.categorydescription as "Ela band ",
                cmath.categorydescription as "Math band ",
                cfela.categorydescription as "Final ELA",
                cfmath.categorydescription as "Final math",
                e.activeflag, e.exitwithdrawaldate, e.exitwithdrawaltype

            FROM student s
            JOIN enrollment e ON (s.id = e.studentid)
            JOIN gradecourse gc ON gc.id = e.currentgradelevel

            --JOIN organization aypco ON e.aypschoolid = aypco.id
            JOIN organization o ON e.attendanceschoolid = o.id

            JOIN organizationrelation por ON o.id = por.organizationid
            JOIN organization po ON por.parentorganizationid = po.id

            LEFT JOIN organizationrelation gpor ON po.id = gpor.organizationid
            LEFT JOIN organization gpo ON gpor.parentorganizationid = gpo.id

            lEFT JOIN organizationrelation gpor1 ON gpo.id = gpor1.organizationid
            LEFT JOIN organization gpo1 ON gpor1.parentorganizationid = gpo1.id

            LEFT JOIN organizationrelation gpor2 ON gpo1.id = gpor2.organizationid
            LEFT JOIN organization gpo2 ON gpor2.parentorganizationid = gpo2.id

            LEFT JOIN organizationrelation gpor3 ON gpo2.id = gpor3.organizationid
            LEFT JOIN organization gpo3 ON gpor3.parentorganizationid = gpo3.id

            LEFT JOIN organizationrelation gpor4 ON gpo3.id = gpor4.organizationid
            LEFT JOIN organization gpo4 ON gpor4.parentorganizationid = gpo4.id

            LEFT JOIN category ccomm ON s.commbandid = ccomm.id
            LEFT JOIN category cela ON s.elabandid = cela.id
            LEFT JOIN category cmath ON s.mathbandid = cmath.id
            LEFT JOIN category cfela ON s.finalelabandid = cfela.id
            LEFT JOIN category cfmath ON s.finalmathbandid = cfmath.id

			--JOIN studentassessmentprogram sap ON sap.studentid = s.id
			--JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
			limit 10;
\copy (select * from tmp_student) to 'student.csv' DELIMITER ',' CSV HEADER;
		
--studentsresponses
SELECT st.id, sts.id, tstv.taskvariantid, sres1.foilid,
   regexp_replace(f.foiltext, E'[\\n\\r]+', ' ', 'g' ),
    sres1.response, sres1.score, stst.sortorder,tvf.responseorder as responseorder,
    sres1.createddate,sres1.modifieddate
  	FROM studentstests st
     	JOIN enrollment AS e ON st.enrollmentid = e.id
    	JOIN testcollectionstests tct ON st.testid = tct.testid
        JOIN testcollection tc ON tc.id = tct.testcollectionid
        JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
        JOIN assessment a ON atc.assessmentid = a.id
        JOIN testingprogram tp ON a.testingprogramid = tp.id
        JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
        JOIN studentstestsections sts ON sts.studentstestid = st.id
        JOIN testsection tsec ON sts.testsectionid = tsec.id
        JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
        JOIN studentsresponses sres1 ON
              st.id = sres1.studentstestsid and
              sres1.taskvariantid=tstv.taskvariantid
        LEFT JOIN studentstestsectionstasks stst ON
              stst.studentstestsectionsid=sts.id and
              stst.taskid=tstv.taskvariantid
        LEFT JOIN foil f ON sres1.foilid = f.id
        LEFT JOIN taskvariantsfoils tvf ON sres1.foilid = tvf.foilid
        LEFT JOIN taskvariant tv ON tv.id = tvf.taskvariantid
         WHERE ap.id = %s AND e.currentschoolyear=%s %s AND sres1.activeflag='t'
			
\copy (select * from tmp_studentsresponses) to 'studentsresponses.csv' DELIMITER ',' CSV HEADER;			
--studentstests
SELECT
                st.id, st.studentid, st.enrollmentid, st.testid as testid,
                sts.id as studentstestssectionsid,
                sts.testsectionid as testsectionid,
                stcat.categorycode as teststatus,
                stscat.categorycode as testsectionstatus,
		        st.createddate, st.startdatetime, st.enddatetime,
		        r.teacherid as educatorid, fband.categorydescription as finalband, tp.programname as programname,
                CASE
                    WHEN ts.source = 'QUESTARPROCESS' THEN true
                    WHEN ts.createduser = 105101 THEN true
                    ELSE false
                END as paperpencil,
                ts.rosterid as rosterid,ca.abbreviatedname as contentareaname,--st.interimtheta as interimtheta,
                sc.id as specialcircumstanceid,
        		sc.specialcircumstancetype,
        		sc.cedscode as  specialcircumstancecedscode--,
                --sc.activeflag as specialcircumstanceactive,
                --st. totalrawscore                
            FROM studentstests st
            JOIN test t ON st.testid = t.id
            JOIN studentstestsections sts ON sts.studentstestid = st.id
            JOIN testcollectionstests tct ON st.testid = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN contentarea ca ON ca.id = tc.contentareaid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            JOIN testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id
            JOIN category stscat ON stscat.id = sts.statusid
            JOIN category stcat ON stcat.id = st.status
            LEFT JOIN category fband ON st.finalbandid = fband.id
            LEFT JOIN roster r ON ts.rosterid = r.id
            LEFT JOIN enrollment e ON st.enrollmentid = e.id
            LEFT JOIN studentspecialcircumstance stsc ON (st.id = stsc.studenttestid)
	        LEFT JOIN specialcircumstance sc ON (stsc.specialcircumstanceid = sc.id) AND e.currentschoolyear=%s
            WHERE ap.id=%s %s AND e.currentschoolyear=%s AND st.activeflag='t';
\copy (select * from tmp_studentstests) to 'studentstests.csv' DELIMITER ',' CSV HEADER;


--taskvariantsfoils
SELECT
			tvf.taskvariantid, tvf.foilid, tvf.responseorder,
			tvf.correctresponse, tvf.responsescore, tvf.responsename,
			 f.foiltext
into temp table tmp_taskvariantsfoils	
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
        WHERE ap.id=%s	
\copy (select * from tmp_taskvariantsfoils) to 'taskvariantsfoils.csv' DELIMITER ',' CSV HEADER;
--taskvariant
SELECT
            tv.id, tv.externalid, tv.taskname, tv.variantname,
	    tt.code as tasktypecode, tst.code as tasksubtypecode,
	    ft.name as frameworktype, ca.abbreviatedname,
            cfd.contentcode, tvcfd.isprimary,
            ct.name, ctd.name, tlf.formatname, --tvcat.categoryname, 
            nodecode

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
            --LEFT JOIN taskvariantessentialelementlinkage tveel ON (tveel.taskvariantid = tv.id)
            --LEFT JOIN category tvcat ON tveel.essentialelementlinkageid = tvcat.id
            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
	    JOIN contentframework cf ON (cfd.contentframeworkid = cf.id AND cf.assessmentprogramid = ap.id)
        WHERE ap.id=%s		
		
\copy (select * from tmp_taskvariant) to 'taskvariant.csv' DELIMITER ',' CSV HEADER;		
--test
 SELECT
            t.id, t.externalid, t.testname, t.testinternalname,
            t.createdate, c.categoryname,
			g.name, gb.name, ca.name, t.avglinkagelevel, t.qccomplete,t.testspecificationid,
			ts.externalid,ts.specificationname,ts.phase,ts.contentpool,ts.minimumnumberofees,
			af.accessibilityflagcodes--,acf.filename
	            
			FROM test t
			JOIN category as c ON (t.status = c.id)
			JOIN contentarea as ca ON (t.contentareaid = ca.id)
            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
			LEFT JOIN gradecourse AS g ON (tc.gradecourseid = g.id)
			LEFT JOIN gradeband AS gb ON (tc.gradebandid = gb.id)
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            LEFT JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            LEFT JOIN testspecification ts ON t.testspecificationid = ts.id
            LEFT JOIN (select testid,array_to_string(array_agg(accessibilityflagcode), ',') accessibilityflagcodes from testaccessibilityflag GROUP BY testid) af ON af.testid = t.id
            LEFT JOIN contentgroup cg on cg.testid = t.id
            --LEFT JOIN brailleaccommodation bac on bac.contentgroupid = cg.id
            --LEFT JOIN accessibilityfile acf on acf.id = bac.accessibilityfileid AND bac.brailleabbreviation = 'UCB'
	;
            WHERE ap.id=%s
\copy (select * from tmp_test) to 'test.csv' DELIMITER ',' CSV HEADER;
--testsection
			SELECT
            ts.id, ts.externalid, ts.testid, ts.testsectionname,
			ts.createdate, ts.numberoftestitems, sva.filename
			
		
        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
			LEFT JOIN testsectionresource tsr ON ts.id = tsr.testsectionid
			LEFT JOIN stimulusvariant sv ON tsr.stimulusvariantid = sv.id
			LEFT JOIN stimulusvariantattachment sva on sv.id = sva.stimulusvariantid
        WHERE ap.id=%s
		
		
--testsectionstaskvariants
SELECT
			tstv.testsectionid, tstv.taskvariantid,
			tstv.externaltestsectionid, tstv.externaltaskid,
			tstv.taskvariantposition, tstv.testletid, tstv.sortorder,
			tstv.groupnumber
				
        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
			JOIN testsectionstaskvariants AS tstv
				ON (ts.id = tstv.testsectionid)

            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
        WHERE ap.id=%s	
\copy (select * from tmp_testsectionstaskvariants) to 'testsectionstaskvariants.csv' DELIMITER ',' CSV HEADER;			