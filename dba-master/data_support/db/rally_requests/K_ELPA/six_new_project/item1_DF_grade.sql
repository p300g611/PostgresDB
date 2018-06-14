create temp table tmp_orgyear (orgid bigint ,orgyear int);
insert into tmp_orgyear
select schoolid orgid,2017 orgyear from organizationtreedetail 
where coalesce(organization_school_year(stateid),extract(year from now()))=2017 
and stateid not in (select id from organization where  organizationtypeid=2 
and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland'));

SELECT    distinct stu.legalfirstname          firstname
                  ,stu.legallastname           lastname
                  ,stu.id                      studnetid
	              ,ort.schoolname              schoolname
	              ,ort.districtname            districtname
	              ,gc.abbreviatedname          gradeband
	              ,tgc.abbreviatedname         testgrade
			    --,st.id                       studentstestid
     
FROM studentstests st
JOIN student stu ON stu.id = st.studentid and stu.activeflag is true 
JOIN enrollment en ON en.id = st.enrollmentid and en.activeflag is true 
join organizationtreedetail ort on ort.schoolid=en.attendanceschoolid
JOIN tmp_orgyear tmp on tmp.orgid=ort.schoolid 
join gradecourse gc on gc.id =en.currentgradelevel
JOIN testcollection tc ON tc.id = st.testcollectionid and tc.activeflag is true
jOIN testsession ts ON ts.id = st.testsessionid and ts.activeflag is true 
JOIN test t on t.id =st.testid  and t.activeflag is true
left outer join   gradecourse tgc on tgc.id =t.gradecourseid
where  st.activeflag is true and ts.operationaltestwindowid = 10171 and gc.abbreviatedname<>tgc.abbreviatedname
order by stu.id, gc.abbreviatedname