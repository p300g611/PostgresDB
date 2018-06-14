select distinct stu.statestudentidentifier ssid, ort.schooldisplayidentifier schoolid, ort.schoolname schoolname,
ort.districtdisplayidentifier districtid, ort.districtname districtname,aart.firstname fristname,
aart.surname lastname,c.abbreviatedname subject, enr.createddate 

into temp table tmp_extract_roster
select distinct stu.statestudentidentifier
from student stu
inner join enrollment en on en.studentid=stu.id and en.activeflag is true
inner join enrollmentsrosters enr on enr.enrollmentid =en.id and enr.activeflag is true
INNER JOIN organizationtreedetail ort on ort.schoolid =en.attendanceschoolid
inner join roster r on enr.rosterid =r.id and r.activeflag is true
inner join aartuser aart on aart.id =r.teacherid and aart.activeflag is true
left outer join contentarea c on c.id = r.statesubjectareaid and c.activeflag is true
where en.currentschoolyear =2017 and 
stu.statestudentidentifier in ('8361191278',
				'8578423210',
				'3501048351',
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
order by aart.firstname,aart.surname;
\copy (select * from tmp_extract_roster) to 'T530842_extract.csv' DELIMITER ','CSV HEADER;
