select distinct stu.statestudentidentifier as ssid,
       stu.legalfirstname,
       stu.legallastname,
       stu.createddate as studentcreatedate,
       stu.modifieddate as studentmodifieddate,
       en.id as enrollmentid,
       en.currentschoolyear,
       gc.abbreviatedname as currentgrade,
       en.createddate as enrollmentcreatedate,
       en.modifieddate as enrollmentmodifieddate,
       st.startdatetime,
       st.enddatetime,
       ca.categorycode as status,
       ts.name as testname,
       ct.abbreviatedname as contentarea,
       asp.abbreviatedname as assessmentprogram,
	   otg.schoolname,
	   otg.districtname,
	   otg.statename
       
       
from student stu
left outer join enrollment en on stu.id = en.studentid
left outer join organizationtreedetail otg on otg.schoolid = en.attendanceschoolid
left outer join studentstests st on st.enrollmentid = en.id and st.studentid= stu.id
left outer join testsession ts on st.testsessionid = ts.id
left outer join testcollection tc on tc.id =st.testcollectionid
left outer join category ca on ca.id =st.status
left outer join gradecourse gc on gc.id = en.currentgradelevel
left outer join contentarea ct on ct.id = tc.contentareaid
left outer join studentassessmentprogram sts on sts.studentid = stu.id
left outer join assessmentprogram asp on asp.id = sts.assessmentprogramid
where stu.statestudentidentifier in ('7051458434','7020467849') 
order by stu.statestudentidentifier,en.currentschoolyear;