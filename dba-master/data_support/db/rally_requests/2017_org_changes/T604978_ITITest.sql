begin;
select distinct stu.statestudentidentifier ssid,stu.legalfirstname,stu.legallastname,
st.id studenttestid,ts.name testsessionname, t.id testid, t.testname,en.currentschoolyear,
c.categorycode as status

INTO TEMP tmp_iti

from student stu
inner join enrollment en on en.studentid=stu.id
left outer join studentstests st on st.enrollmentid=en.id
left outer join testsession ts on ts.id =st.testsessionid
left outer join test t on st.testid =t.id
left outer join category c on c.id =st.status

where stu.activeflag is true and stateid is not null and t.testname ilike '%ITI%' and st.activeflag is true and
 statestudentidentifier in 
('3501048351',
'1793749264',
'3109157721',
'9104195442',
'9407769577',
'1894147944',
'4217590016',
'5026743552',
'6812448427',
'3343544272',
'4144900916',
'1751949036',
'2334119075',
'1415837937',
'6760867602',
'6705083948',
'8030311397',
'8195398448',
'9034936929',
'1026883946',
'9919709875',
'7247840528',
'8463816886',
'4281391622',
'1189803',
'1193622',
'1194489',
'1197682',
'1211140',
'1225512',
'1231081',
'1240142',
'1244445',
'1247364',
'1264863',
'1020402857',
'1022806688') 
order by stu.statestudentidentifier;
\copy (select * from tmp_iti) to 'T604978_ITI.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

ROLLBACK;
