--Returns information on students with multiple active enrollments in the same school year, any grade level
--
select  * from (
select  distinct 
        s.id studentid
       ,s.legallastname
       ,s.legalfirstname
       ,s.stateid
       , (select o.organizationname
          from   organization o
          where  o.id = s.stateid) residencestate
       ,e.currentschoolyear
       ,(select array_to_string(array_agg(name), ',')  as gradelevel 
         from (select e1.studentid
                    , e1.currentschoolyear
                    , array_to_string(array_agg(case when(e1.currentgradelevel is null) 
                                                     then 'NULL' 
                                                     else g1.name end), ',') as name
               from enrollment e1 
               left join gradecourse g1 on (e1.currentgradelevel = g1.id)
               where e1.activeflag = true
               group by e1.studentid
                      , e1.currentschoolyear
                      , g1.name) as a
         where s.id = a.studentid
         and   a.currentschoolyear = e.currentschoolyear) enrolledgradelevels
       ,(select array_to_string(array_agg(organizationname), ',')  as schools 
         from (select e2.studentid
                    , e2.currentschoolyear
                    , array_to_string(array_agg(o2.organizationname), ',') as organizationname 
               from organization o2, enrollment e2 
               where e2.attendanceschoolid = o2.id
               and   e2.activeflag = true
               group by e2.studentid
                      , e2.currentschoolyear
                      , o2.organizationname) as a
         where s.id = a.studentid
         and   a.currentschoolyear = e.currentschoolyear) attendanceschools
from   student s
     , enrollment e  
where  s.id = e.studentid
and    e.currentschoolyear = e.currentschoolyear
and    e.currentschoolyear = '2016'
and    s.stateid = 51 --Kansas
order by s.stateid
        ,s.id
        ,e.currentschoolyear
) as a
where enrolledgradelevels like '%,%'
;
