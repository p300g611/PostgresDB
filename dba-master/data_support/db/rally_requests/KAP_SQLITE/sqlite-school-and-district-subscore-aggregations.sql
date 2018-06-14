select * from (
	select otd.districtname as "District"
	     , otd.schoolname as "School"
	     , gc.abbreviatedname as "Grade"
	     , ca.abbreviatedname as "Content Area"
	     , rms.studentcount as "Number of Students"
	     , rms.subscoredefinitionname as "Subscore Definition Name"
	     , rms.rating as "Rating"
	from reportsmedianscore rms
	join organizationtreedetail otd on rms.organizationid = otd.schoolid
	join contentarea ca on rms.contentareaid = ca.id
	join gradecourse gc on rms.gradeid = gc.id
	where rms.schoolyear = 2016
	and ca.abbreviatedname in ('ELA', 'M')
	and rms.rating is not null
	union
	select otd.districtname as "District"
	     , null as "School"
	     , gc.abbreviatedname as "Grade"
	     , ca.abbreviatedname as "Content Area"
	     , rms.studentcount as "Number of Students"
	     , rms.subscoredefinitionname as "Subscore Definition Name"
	     , rms.rating as "Rating"
	from reportsmedianscore rms
	join organizationtreedetail otd on rms.organizationid = otd.districtid
	join contentarea ca on rms.contentareaid = ca.id
	join gradecourse gc on rms.gradeid = gc.id
	where rms.schoolyear = 2016
	and ca.abbreviatedname in ('ELA', 'M')
	and rms.rating is not null
) as school_and_district_subscores
order by "Content Area"
       , "District"
       , "Grade"
       , "School"
       , "Subscore Definition Name";