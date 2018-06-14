BEGIN;
create temp table tmp ( "State"	text,
			"District"	text,
			"School"	text,
			"School Identifier"	text,
			"Grade"	text,
			"Grouping 1"	text,
			"Grouping 2"	text,
			"Roster Name"	text,
			"Educator Identifier"	text,
			"Educator Last Name"	text,
			"Educator First Name"	text,
			"Student Last Name"	text,
			"Student First Name"	text,
			"Student Middle Name"	text,
			"State Student Identifier"	text,
			"Local Student Identifier"	text,
			"Subject"	text,
			"Test Session Name"	text,
			"Test Collection Name"	text,
			"Test Status"	text,
			"Special Circumstance"	text,
			"Special Circumstance Status"	text,
			"Last Reactivated Date Time"	text,
			"Stage"	text,
			"Part 1 Status"	text,
			"Part 1 Start DateTime"	text,
			"Part 1 End DateTime"	text,
			"Part 1 Ticket Sections"	text,
			"Part 1 Total Items"	text,
			"Part 1 Omitted Items"	text,
			"Part 2 Status"	text,
			"Part 2 Start DateTime"	text,
			"Part 2 End DateTime"	text,
			"Part 2 Ticket Sections"	text,
			"Part 2 Total Items"	text,
			"Part 2 Omitted Items"	text,
			"Part 3 Status"	text,
			"Part 3 Start DateTime"	text,
			"Part 3 End DateTime"	text,
			"Part 3 Ticket Sections"	text,
			"Part 3 Total Items"	text,
			"Part 3 Omitted Items"	text,
			"Part 4 Status"	text,
			"Part 4 Start DateTime"	text,
			"Part 4 End DateTime"	text,
			"Part 4 Ticket Sections"	text,
			"Part 4 Total Items"	text,
			"Part 4 Omitted Items"	text);

\COPY tmp FROM 'KITE_KS.csv' DELIMITER ',' CSV HEADER;
select count(*) from tmp;


  select t.* ,
      case when ea.id is not null then (select organizationname from organization ayp join enrollment e on e.aypschoolid=ayp.id and e.id=ea.id)
           when ef.id is not null then (select organizationname from organization ayp join enrollment e on e.aypschoolid=ayp.id and e.id=ef.id)
           else t."School" end "AypSchool",
      case when ea.id is not null then (select displayidentifier from organization ayp join enrollment e on e.aypschoolid=ayp.id and e.id=ea.id)
           when ef.id is not null then (select displayidentifier from organization ayp join enrollment e on e.aypschoolid=ayp.id and e.id=ef.id)
           else t."School Identifier" end "AypSchool Identifier"
    into temp tmp_ayp from tmp t
  left outer join student s on s.statestudentidentifier=t."State Student Identifier" and s.stateid=51 and s.activeflag is true
  left outer join  (select e.studentid,o.schooldisplayidentifier,max(e.id) id from enrollment e 
                         inner join organizationtreedetail o on e.attendanceschoolid=o.schoolid 
                         where e.activeflag is true and o.stateid=51
                         group by e.studentid,o.schooldisplayidentifier) ea
                             on ea.schooldisplayidentifier=t."School Identifier" and s.id=ea.studentid
  left outer join  (select e.studentid,o.schooldisplayidentifier,max(e.id) id from enrollment e 
                         inner join organizationtreedetail o on e.attendanceschoolid=o.schoolid
                         where  o.stateid=51
                         group by e.studentid,o.schooldisplayidentifier) ef
                             on ef.schooldisplayidentifier=t."School Identifier" and s.id=ef.studentid;                           

--validation
select count(*) from tmp_ayp
where "AypSchool" is null or "AypSchool Identifier" is null;
select count(*) from tmp_ayp
where "AypSchool"<>"School";


--\COPY (select * from tmp_ayp) to 'KITE_KS_AYP.csv' DELIMITER ',' CSV HEADER 
\COPY (select * from tmp_ayp ) to 'KITE_KS_AYP.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 
--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
drop table if exists tmp;
drop table if exists tmp_ayp;

rollback;


  
	
