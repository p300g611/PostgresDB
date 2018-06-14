/*
Interim Predictive tests (KAP Summative, Interim Tests, Prediction Purpose). List any test with Status Complete and >0 
items not answered. For each test, please include:
Test ID
Testsession ID
Student ID
Grade
Subject
School
District
Count of items not answered 
*/
     create temp table tmp_orgyear (orgid bigint ,orgyear int);
     insert into tmp_orgyear
     select schoolid orgid,2018 orgyear from organizationtreedetail 
	 where coalesce(organization_school_year(stateid),extract(year from now()))=2018 
	 and stateid not in (select id from organization where  organizationtypeid=2 
	                     and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
	                                              ,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
	                                              ,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland','Service Desk QC State'));

select 
t.id         			"TestID"
,ts.id        			"TestsessionID"
,st.studentid  			"StudentID"
,s.statestudentidentifier       "SSID"
,gc.abbreviatedname     	"Grade"
,ca.abbreviatedname     	"Subject"
,ort.schoolid           	"schoolid"
,ort.schoolname         	"SchoolName"
,ort.districtid         	"Districtid"
,ort.districtname         	"DistrictName"
,count(sres1.taskvariantid)     "Noofnotanswered"
FROM studentstests st
inner join testsession ts on ts.id =st.testsessionid
inner join test t on t.id=st.testid
inner JOIN testspecstatementofpurpose tstop on t.testspecificationid=tstop.testspecificationid
inner JOIN category ct on ct.id=tstop.statementofpurposeid 
inner JOIN enrollment e ON st.enrollmentid = e.id
inner join student s on s.id=e.studentid
inner JOIN gradecourse gc on gc.id = e.currentgradelevel
inner JOIN tmp_orgyear tmp on e.attendanceschoolid=tmp.orgid and e.currentschoolyear=tmp.orgyear and e.activeflag is true
inner JOIN organizationtreedetail ort on ort.schoolid=tmp.orgid
inner JOIN testcollectionstests tct ON st.testid = tct.testid
inner JOIN testcollection tc ON tc.id = tct.testcollectionid
inner JOIN contentarea ca on ca.id =tc.contentareaid
inner JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
inner JOIN assessment a ON atc.assessmentid = a.id
inner JOIN testingprogram tp ON a.testingprogramid = tp.id
inner JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
inner JOIN studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
inner join taskvariant tv on tv.id=tstv.taskvariantid
left outer JOIN studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tv.id
WHERE  tp.programname ='Interim' and st.status =86 
and ap.id=12 and (ct.categorycode='INSTRCT' or ct.categorycode='PRDCTN') and (sres1.response is null and sres1.foilid is null)
group by t.id,ts.id,st.studentid,gc.abbreviatedname,ca.abbreviatedname
,ort.schoolname,ort.districtid,schoolid,districtname,s.statestudentidentifier;






	