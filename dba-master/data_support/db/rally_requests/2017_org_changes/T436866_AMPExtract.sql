BEGIN;

with oneass as
(select aat.id, count(assessmentprogramid) 
from aartuser aat
inner join  userassessmentprogram ussm on ussm.aartuserid = aat.id 
where aat.activeflag is true and ussm.activeflag is true
group by aat.id
having count(assessmentprogramid)=1

)

select distinct 
aart.firstname  FirstName,
aart.surname    LastName,
aart.email      EmailAddress,
org.organizationname as organizationname,
(CASE WHEN orgt.typecode = 'DT' THEN 
		(select distinct districtdisplayidentifier from organizationtreedetail where districtid=org.id) 
        ELSE 
		(select districtdisplayidentifier from organizationtreedetail where schoolid=org.id) END) as districtdisplayidentifier,
g.groupcode  UserRole

into tmp_amp
from aartuser aart 
inner join oneass on oneass.id =aart.id
inner join usersorganizations usg on usg.aartuserid =aart.id and usg.activeflag is true
inner join organization org on org.id = usg.organizationid and org.activeflag is true
inner join organizationtype orgt on orgt.id =org.organizationtypeid
inner join userorganizationsgroups usgg on usgg.userorganizationid = usg.id and usgg.activeflag is true
inner join groups g on g.id = usgg.groupid
inner join userassessmentprogram usa on usa.aartuserid =aart.id and usa.activeflag is true
inner join assessmentprogram assp on assp.id = usa.assessmentprogramid 
where aart.activeflag is true and  assp.abbreviatedname ='AMP' 
and org.id in (select schoolid  from organizationtreedetail where stateid=35999
                 union select districtid from organizationtreedetail where stateid=35999
                 union select stateid from organizationtreedetail where stateid=35999) 
order by aart.firstname,aart.surname 


\copy (select * from tmp_amp) to 'AMP_AK_Extract.csv' DELIMITER ',' CSV HEADER;

ROLLBACK;


--count of any active users that have DLM on their account for Alaska
	 
select count(*) from aartuser aart
inner join usersorganizations usg on usg.aartuserid =aart.id and usg.activeflag is true
inner join organization org on org.id = usg.organizationid and org.activeflag is true
inner join userassessmentprogram usap on usap.aartuserid = aart.id and usap.activeflag is true
inner join assessmentprogram assp on assp.id = usap.assessmentprogramid 
where aart.activeflag is true and assp.abbreviatedname ='DLM' 
and org.id in (select schoolid  from organizationtreedetail where stateid=35999
                 union select districtid from organizationtreedetail where stateid=35999
                 union select stateid from organizationtreedetail where stateid=35999); 


