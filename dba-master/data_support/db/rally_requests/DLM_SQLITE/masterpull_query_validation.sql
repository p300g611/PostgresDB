-- 1.Number of completed test sessions within each state has not decreased since last pull 
-- 2.Number of students with complete test sessions within each state has not decreased since last pull 
-- 3.Every student with complete test sessions has first contact information 
-- 4.No duplicate rosters for a student within each content area 
-- 5.All test sessions (complete, in progress, and unused) all have complete educator information (first name, last name, id), school and district information (names and ids) 
-- 6.No in progress test sessions (when using the am database) 
-- 7.All items have linkage level information (i.e., essentialelementlinkage is not NA for any assigned items)


select state,contentareaname,count(distinct id) from masterpull_item
group by state,contentareaname
order by state;

select state,count(distinct testsectionid)  from masterpull_item
where teststatus='complete'
group by state;

select state,count(distinct id)  from masterpull_item
where teststatus='complete'
group by state;

select count(*) from masterpull_item where educatorkiteid is null;

select teststatus,count(*) from studentstests group by teststatus;

select count(*) from studentstests where teststatus='inprogress';

select state,st.id studentstestid,s.id studentid,st.createddate from studentstests st 
inner join student s on s.id=st.studentid where teststatus='inprogress';

select contentareaname,essentialelementlinkage,count(*) 
from masterpull_item 
 --where contentareaname in ('ELA','M','Sci','SS')
group by contentareaname,essentialelementlinkage;


